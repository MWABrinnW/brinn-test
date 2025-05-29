with location_cte as (
    select
        accounting_id
        , location_code
        , office_name
        , start_date
        , row_number() over (
            partition by accounting_id
            order by start_date desc
        ) as rn
    from {{ ref('locations') }}
    qualify rn = 1
)

, client_advisor_cte as (
    select
        ctm.client_id
        , listagg(ctm.user_id , ';')           as cb_user_id
        , listagg(ctm.user_display_name , ';') as cb_advisor_nm
        , listagg(urs.oracle_person_id , ';')  as cb_oracle_id
    from {{ ref('cambak__stg_clientteammembersdetails') }} as ctm
    left join {{ ref('cambak__stg_cbuser') }} as urs
        on ctm.user_id = urs.userid
    where (lower(ctm.role_details) like '%senior advisor%' or lower(ctm.role_details) like '%primary consultant%')
    group by ctm.client_id
)


select
    -- [helper]
    case when ipf.invoice_id is null then 'invoice'
        else 'plan'
    end::text                                              as invoice_level

    -- [system attributes]
    , 'cambak'::text                                       as system_name
    , 'andco'::text                                        as system_instance
    , concat('cambak' , '__' , 'andco')::text              as system_key
    , 'inst'::text                                         as firm_source

    -- [location]
    , case
        when pl3.picklist_string_value = 'Integration'
            and pl4.picklist_string_value = 'RPS'
            then '301'-- Legacy RPS
        when pl3.picklist_string_value = 'Acquisition'
            and pl4.picklist_string_value = 'Cardinal Investment Advisors'
            then 'L-10130'-- Cardinal
        else
            'L-10101'--AndCo

    end::text                                              as location_code
    , loc.office_name::text                                as office_name
    , case
        when pl3.picklist_string_value = 'Integration'
            and pl4.picklist_string_value = 'RPS'
            then '301'-- Legacy RPS
        when pl3.picklist_string_value = 'Acquisition'
            and pl4.picklist_string_value = 'Cardinal Investment Advisors'
            then 'L-10130'-- Cardinal
        else 'L-10101'--AndCo
    end::text                                              as client_location_code
    , loc.office_name::text                                as client_office_name

    -- [finanical dates]
    , inv.creation_date::datetime                          as invoice_created_at
    , inv.invoice_date::date                               as invoice_date
    , last_day(inv.calculation_date)::date                 as revenue_period_end_date
    , last_day(inv.calculation_date , 'quarter')::date     as revenue_quarter_end_date

    -- [invoice]
    , inv.invoice_number::text                             as invoice_number_source
    , inv.invoice_id::text                                 as billing_statement_id_source
    , null::text                                           as invoice_status
    , null::int                                            as is_intra_period_invoice
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_id::text , '; ')
                within group (
                    order by pln.plan_id::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_id::text
    end::text                                              as account_number
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_id::text , '; ')
                within group (
                    order by pln.plan_id::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_id::text
    end::text                                              as account_number_formatted
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_id::text , '; ')
                within group (
                    order by pln.plan_id::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_id::text
    end::text                                              as billing_account_number
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_id::text , '; ')
                within group (
                    order by pln.plan_id::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_id::text
    end::text                                              as account_id_pms
    , clt.legal_name::text                                 as registrant_name
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_name::text , '; ')
                within group (
                    order by pln.plan_name::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_name::text
    end::text                                              as account_name
    , pls_1.picklist_string_value::text                    as type_of_account
    , clt.client_id::text                                  as client_id_pms

    -- [advisory]
    , case
        when pln.discretion_level_id = 2561
            then 'AUM - Assets Under Management'
        else 'AUA - Assets Under Advisory'
    end::text                                              as aum_classification_status
    , null::text                                           as custodian
    , null::text                                           as billing_custodian
    , null::text                                           as partner_firm_original
    , null::text                                           as partner_firm

    -- [associate]
    , adv.cb_advisor_nm::text                              as advisor_source
    , null::text                                           as advisor_original
    , adv.cb_advisor_nm::text                              as advisor_primary
    , adv.cb_oracle_id::text                               as associate_id_primary
    , 'W-2'::text                                          as advisor_type
    , adv.cb_advisor_nm::text                              as advisor
    , adv.cb_oracle_id::text                               as associate_id

    -- [assets and fees]
    , bdx.billing_type_string::text                        as fee_type
    , null::text                                           as fee_schedule_source
    , inv.calculation_date::date                           as assets_as_of_date
    , inv.calculation_date::date                           as fee_calculation_date
    , a.account_value::number(18 , 2)                      as total_account_value
    , a.account_value::number(18 , 2)                      as billable_value
    , case
        when invoice_level = 'invoice'
            then inv.invoice_total
        when invoice_level = 'plan'
            then ipf.fee
    end::number(18 , 2)                                    as client_fee_gross
    , case
        when invoice_level = 'invoice'
            then 0
        when invoice_level = 'plan'
            then (ipf.fee - (coalesce(ipf.adjusted_fee , 0)))
    end::number(18 , 2)                                    as client_adjustments_fee
    , case
        when invoice_level = 'invoice'
            then inv.invoice_total
        when invoice_level = 'plan'
            then coalesce(ipf.adjusted_fee , ipf.fee)
    end::number(18 , 2)                                    as client_fee_net
    , null::date                                           as collection_date

    -- [billing terms and payment]
    , bdx.billing_timing_string                            as billing_style
    , bdx.billing_frequency_string                         as billing_frequency
    , null::text                                           as billing_method

    -- [accounting]
    , 'rev'::text                                          as account_class
    , case
        when bdx.billing_frequency_string in ('Quarterly')
            then 1
        else 0
    end::boolean                                           as recurring_revenue
    , null::boolean                                        as impacted_by_financial_markets
    , '270'::text                                          as coa_segment_1_legal_entity_id
    , '000'::text                                          as coa_segment_2_product_id
    , loc.accounting_id::text                              as coa_segment_3_accounting_id
    , '0000'::text                                         as coa_segment_4_team_id
    , '43003'::text                                        as coa_segment_5_natural_account_id
    , '300'::text                                          as coa_segment_6_initiative_id
    , '000'::text                                          as coa_segment_7_intercompany_id
    , '000'::text                                          as coa_segment_8_future_id
    , concat_ws(
        '-'
        , coa_segment_1_legal_entity_id
        , coa_segment_2_product_id
        , coa_segment_3_accounting_id
        , coa_segment_4_team_id
        , coa_segment_5_natural_account_id
        , coa_segment_6_initiative_id
        , coa_segment_7_intercompany_id
        , coa_segment_8_future_id
    )::text                                                as coa_account_number
    , '401k'::text                                         as revenue_category
    , '401k'::text                                         as revenue_type

    -- [crm]
    , 'cambak'::text                                       as system_name_crm
    , 'andco'::text                                        as system_instance_crm
    , 'cambak__andco'::text                                as system_key_crm
    , case
        when invoice_level = 'invoice'
            then (
                listagg(distinct pln.plan_id::text , '; ')
                within group (
                    order by pln.plan_id::text)
                    over (partition by inv.invoice_id::text)
            )
        when invoice_level = 'plan'
            then pln.plan_id::text
    end::text                                              as account_id_crm
    , clt.client_id::text                                  as client_id_crm
    , clt.client_id::text                                  as client_id_original_crm
    , null::text                                           as client_id_unique_compass
    , clt.client_name::text                                as client_name
    , clt.client_name::text                                as client_name_original_crm
    , null::text                                           as client_lead_source
    , null::text                                           as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text                                      as transaction_type
    , 'Line'::text                                         as transaction_line_type
    , 1::int                                               as transaction_line_quantity
    , 'USD'::text                                          as currency_code
    , 'User'::text                                         as currency_conversion_type
    , case
        when invoice_level = 'invoice'
            then inv.invoice_total
        when invoice_level = 'plan'
            then ipf.fee
    end::number(18 , 2)                                    as unit_selling_price

    -- [exclusions]
    -- no records are being excluded, default to 0
    , ''::text                                             as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                               as is_excluded

    -- [referential]
    , concat(inv.invoice_number , '_' , ipf.plan_id)::text as _invoice_key
    , null::datetime                                       as _source_loaded_at
    , null::text                                           as _source_file
    , null::text                                           as _box_file_id
    , object_construct_keep_null(
        'invoice level'
        , invoice_level
    ):variant                                              as _extra_fields
    , pln._created_at::datetime                            as _created_at
    , 0::int                                               as is_legacy
    , row_number() over (
        partition by clt.client_id , inv.invoice_id
        order by inv.invoice_date
    )::int                                                 as rn
from {{ ref('cambak__stg_cbinvoice') }} as inv
-- returns plan level fees, if available
left join {{ ref('cambak__stg_cbinvoicedplanfee') }} as ipf
    on inv.invoice_id = ipf.invoice_id
-- returns the "clint" billing definition to create the bridge to the client data object
left join {{ ref('cambak__stg_cbbillingdefinitionentitymap') }} as map1
    on inv.billing_definition_id = map1.billing_definition_id
    and map1.entity_typeid = 1400
-- returns the client
left join {{ ref('cambak__stg_cbclient') }} as clt
    on map1.entity_id = clt.client_id
    and map1.entity_typeid = 1400
-- returns the plans for each client, more explicitly on plan id, to prevent fanning
left join {{ ref('cambak__stg_cbplan') }} as pln
    on clt.client_id = pln.client_id
    and (
        case
            when ipf.plan_id is not null then ipf.plan_id = pln.plan_id
            else true
        end
    )
-- returns fair market value at calculation date
left join {{ ref('cambak__int_accounts') }} as a
    on pln.plan_id = a.account_number
    and inv.calculation_date = a.effective_date
-- returns the "plan" billing definition to create the bridge to the billing definition
left join {{ ref('cambak__stg_cbbillingdefinitionentitymap') }} as map2--plan
    on inv.billing_definition_id = map2.billing_definition_id
    and map2.entity_typeid = 3100
    and pln.plan_id = map2.entity_id
-- returns status of business; i.e., acquisition, integration - gwh added to rev model 20250507
left join datalake.cambak.stg_cbpickliststring as pl3
    on pln.source_type_id = pl3.picklist_string_id
    and pl3.picklist_id = 13010
-- returns the business unit/name - gwh added to rev model 20250507
left join datalake.cambak.stg_cbpickliststring as pl4
    on pln.source_subtype_id = pl4.picklist_string_id
    and pl4.picklist_id = 13020
-- returns location
left join location_cte as loc
    on
    (
        case
            when pl3.picklist_string_value = 'Integration' and pl4.picklist_string_value = 'RPS'
                then
                    '301'-- Legacy RPS
            when pl3.picklist_string_value = 'Acquisition' and pl4.picklist_string_value = 'Cardinal Investment Advisors'
                then
                    'L-10130'-- Cardinal
            else
                'L-10101'--AndCo
        end
    )
    = loc.location_code
left join {{ ref('cambak__stg_billingdefinitionex') }} as bdx
    on inv.billing_definition_id = bdx.billing_definition_id
left join {{ ref('cambak__stg_cbpickliststring') }} as pls_1
    on pln.plan_type_id = pls_1.picklist_string_id
    and pls_1.picklist_id = 1020
    -- returns the advisor
left join client_advisor_cte as adv
    on clt.client_id = adv.client_id
    -- returns location
where true
    and inv.invoice_date >= '2024-04-30'
order by client_id_crm asc , invoice_date desc , rn asc
