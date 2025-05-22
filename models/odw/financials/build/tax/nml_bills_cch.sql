-- obtains the category name from the line item table; this maps to `revenue_type` as a concatenated string
with line_item_cte as (
    select
        w.invoiceident
        , listagg(distinct s.categoryname , '; ') over (partition by w.invoiceident) as categoryname
        , row_number() over (
            partition by w.invoiceident
            order by w.transactiondate
        )                                                                            as rn
    from {{ ref('cch_dau__stg_uvw_wipar02clientident') }} as w
    left join {{ ref('cch_dau__stg_servicecode') }} as s
        on w.servicecodeident = s.servicecodeident
        and s.is_head = 1
    where true
        and w.is_head = 1
)

-- used to evaluate the location in xcm. compares to the location in the cch invoice table. defers to xcm.
, xcm_locations_cte as (
    select
        account_number
        , location_name
        , period_end_date
        , row_number() over (
            partition by account_number
            order by account_number asc , period_end_date desc
        ) as rn
    from {{ ref('xcm__stg_task_detail') }}
    where true
        and status_type = 'Completed'-- business rule to only evaluate completed tasks
    qualify rn = 1
)

-- ensures that the location is the most recent one in the source system. this is used to evaluate the location in cch.
, locations_cte as (
    select *
    from {{ ref('locations') }}
    where true
    qualify row_number() over (
            partition by accounting_id
            order by accounting_id asc , end_date desc nulls first
        ) = 1
)

-- applies distinct business logic to the client office name, converting to the new office name.
, cch_client_office_custom_cte as (
    select
        c.clientident
        , c.clientofficename
        , case
            when c.clientofficename = 'Madison' and left(c.clientid , 2) = '06' then 'Manasquan'
            when c.clientofficename = 'Madison' and left(c.clientsubid , 2) = '06' then 'Manasquan'
            when c.clientofficename = 'Madison' and left(c.clientid , 2) = '13' then 'Chatham'
            when c.clientofficename = 'Madison' and left(c.clientsubid , 2) = '13' then 'Chatham'
            when c.clientofficename = 'Sioux Falls' and left(c.clientid , 5) = '20ZTC' then 'Speciality Tax'
            when c.clientofficename = 'Sioux Falls' and left(c.clientsubid , 5) = '20ZTC' then 'Speciality Tax'
            when c.clientofficename = 'Sioux Falls' and left(c.clientid , 5) = '20STS' then 'Cost Seg'
            when c.clientofficename = 'Sioux Falls' and left(c.clientsubid , 5) = '20STS' then 'Cost Seg'
            when c.clientofficename = 'New Albany' and right(c.clientid , 6) = '.kleeh' then 'New Albany'
            when c.clientofficename = 'New Albany' and right(c.clientsubid , 6) = '.kleeh' then 'New Albany'
            when c.clientofficename = 'New Albany' then 'Louisville'
            else c.clientofficename
        end as clientofficenamecustom
    from {{ ref('cch_dau__stg_client') }} as c
    where true
        and c.is_head = 1
)

select
    i.system_name::text                                                                                      as system_name
    , i.system_instance::text                                                                                as system_instance
    , i.system_key::text                                                                                     as system_key
    -- row access policy applied in yaml file
    , 'mwa'::text(200)                                                                                       as firm_source
    , loc.location_code::text                                                                                as location_code
    , loc.office_name::text                                                                                  as office_name
    , loc.location_code::text
        as client_location_code
    , loc.office_name::text                                                                                  as client_office_name
    , i.invoicedatetime::datetime                                                                            as invoice_created_at
    , i.invoicedatetime::date                                                                                as invoice_date
    , last_day(i.invoicedatetime , 'month')::date
        as revenue_period_end_date
    , last_day(i.invoicedatetime , 'quarter')::date
        as revenue_quarter_end_date
    , i.invoicenumber::text                                                                                  as invoice_number_source--not uniqiue in source
    , i.invoiceident::text                                                                                   as billing_statement_id_source--is unique in source
    , i.invoicestatusname::text                                                                              as invoice_status
    , 0::int
        as is_mid_cycle_invoice
    , c.clientidsubid::text                                                                                  as client_id_pms
    , 'W-2'::text
        as advisor_manager_type
    , 'Tax Prep Fee'::text                                                                                   as fee_type
    , (i.stdwipamount + i.adjustmentamount + i.progressbilledamount + i.progressapplyamount)::number(18 , 2) as client_fee_net-- ties to invoiced amt on sys generated AR report
    , (i.taxamount + i.progresstaxamount - i.taxappamount - i.progresstaxappamount)::number(18 , 2)          as sales_tax-- ties to invoiced amt on sys generated AR report
    , 0::boolean
        as third_party_calculation
    , 'One-Time'                                                                                             as billing_frequency
    , 'Arrears'                                                                                              as billing_style
    , 'tax'                                                                                                  as account_class
    , 0::boolean
        as impacted_by_financial_markets
    , case
        when t2.coa_segment_3_accounting_id = '6609' then '190'
        else '110'
    end::text
        as coa_segment_1_legal_entity_id
    , case
        when t2.coa_segment_3_accounting_id = '6609' then '260'
        else '100'
    end::text
        as coa_segment_2_product_id
    , coalesce(t2.coa_segment_3_accounting_id , t.coa_segment_3_accounting_id)
        as coa_segment_3_accounting_id
    , '0000'::text
        as coa_segment_4_team_id
    , '42001'::text
        as coa_segment_5_natural_account_id
    , '000'::text
        as coa_segment_6_initiative_id
    , '000'::text
        as coa_segment_7_intercompany_id
    , '000'::text
        as coa_segment_8_future_id
    , concat_ws(
        '-'
        , coa_segment_1_legal_entity_id
        , coa_segment_2_product_id
        , coalesce(t2.coa_segment_3_accounting_id , t.coa_segment_3_accounting_id)
        , coa_segment_4_team_id
        , coa_segment_5_natural_account_id
        , coa_segment_6_initiative_id
        , coa_segment_7_intercompany_id
        , coa_segment_8_future_id
    )                                                                                                        as coa_account_number
    , case
        when coalesce(t2.coa_segment_3_accounting_id , t.coa_segment_3_accounting_id) in ('6633' , '6634') then 'Speciality Tax'
        else 'Core Tax'
    end::text                                                                                                as revenue_category
    , w.categoryname::text                                                                                   as revenue_type
    , 'xcm'::text                                                                                            as system_name_crm
    , 'xcm'::text
        as system_instance_crm
    , 'xcm'::text                                                                                            as system_key_crm
    , c.clientidsubid::text                                                                                  as client_id_crm
    , c.clientsortname::text                                                                                 as client_name
    , 'Invoice'::text                                                                                        as transaction_type
    , 'Line'
        as transaction_line_type
    , 1::int
        as transaction_line_quantity
    , 'USD'::text                                                                                            as currency_code
    , 'User'::text
        as currency_conversion_type
    , client_fee_net::number(18 , 2)                                                                         as unit_selling_price
    , case
        when i.reverseddatetime > '1900-01-01 00:00:00.000' then 1
        else 0
    end::int                                                                                                 as is_reversed
    , case
        when i.reverseddatetime > '1900-01-01 00:00:00.000' then date(i.reverseddatetime)
    end::date                                                                                                as reversed_date
    , case
        when i.invoicestatusname != 'Final'
            then
                1
        else
            0
    end                                                                                                      as is_excluded
    , case
        when i.invoicestatusname != 'Final'
            then
                'invoice not final'
    end                                                                                                      as excluded_reasons--as excluded_reasons
    , concat(i.invoiceident , '-' , i.invoicenumber)                                                         as _invoice_key
    , i._created_at::datetime                                                                                as _created_at
    , null::text                                                                                             as _source_file
    , null::text                                                                                             as _box_file_id
    , 0::int                                                                                                 as is_legacy

    , object_construct_keep_null(
        'cch_client_office_name' , c.clientofficename
        , 'cch_client_office_name_custom' , c2.clientofficenamecustom
        , 'xcm_location_name' , x.location_name
        , 'reporting_client_office_name' , coalesce(x.location_name , c2.clientofficenamecustom)
        , 'cch_coa_segment_3_accounting_id' , t.coa_segment_3_accounting_id
        , 'xcm_coa_segment_3_accounting_id' , t2.coa_segment_3_accounting_id
    )::variant                                                                                               as _extra_fields

from
    {{ ref('cch_dau__stg_invoice') }} as i
left join {{ ref('cch_dau__stg_client') }} as c
    on i.clientident = c.clientident
    and c.is_head = 1
left join cch_client_office_custom_cte as c2
    on c.clientident = c2.clientident
left join line_item_cte as w
    on i.invoiceident = w.invoiceident
    and w.rn = 1
left join {{ ref('aux__stg_tax_location_mappings') }} as t
    on lower(c2.clientofficenamecustom) = t.tax_office_name
    and t.system_name = 'cch axcess'
    and t.rn = 1
left join xcm_locations_cte as x
    on c.clientid = x.account_number
left join {{ ref('aux__stg_tax_location_mappings') }} as t2
    on lower(x.location_name) = t2.tax_office_name
    and t2.system_name = 'xcm'
    and t2.rn = 1
left join locations_cte as loc
    on coalesce(t2.coa_segment_3_accounting_id , t.coa_segment_3_accounting_id) = loc.accounting_id
where true
    and i.is_head = 1
