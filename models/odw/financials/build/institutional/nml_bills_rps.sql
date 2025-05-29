-- obtains clients from rps template to filter salesforce accounts,
-- 'salesforce_compass_accounts' mart model not used, rps uses plans, not accounts (estate items)
with sf1_clients_cte as (
    select
        id                    as acct_id
        , name                as acct_name
        , owner_id            as owner_id
        , partner_firm_c      as partner_firm_id
        , mariner_location_c  as mariner_location_c
        , unique_identifier_c as unique_identifier_c
        , lead_source_c       as lead_source_c
        , key_tags_c          as key_tags_c
        , effective_at::date  as effective_date
        , case when max(effective_at) over (partition by id) = effective_at
                then 1 else
                0
        end                   as is_head
        , case when max(effective_at) over (partition by id , effective_at) = effective_at
                then 1 else
                0
        end                   as is_head_per_day
    from {{ ref('salesforce_compass__base_account') }}
    where true
        and is_deleted = 0
        and _fivetran_deleted = 0
        and is_latest = 1
        and effective_at::date >= '2024-01-01'
        and id in (select distinct aa.client_salesforce_id from {{ ref('rps__stg_bills') }} as aa)
)

-- obtains the salesforce advisor at the datetime of the invoice
, sf2_clients_cte as (
    select
        a.*
        , u.employee_number
        , l.finance_code_c
        , p.name as partner_firm_name
    from sf1_clients_cte as a
    left join {{ ref('salesforce_compass__base_user') }} as u
        on a.owner_id = u.id
    left join {{ ref('salesforce_compass__base_mh_location_c') }} as l
        on a.mariner_location_c = l.id
        and l.is_head = 1
    left join {{ ref('salesforce_compass__base_account') }} as p
        on a.partner_firm_id = p.id
        -- filters account object to partner firm
        and p.record_type_id = '012C0000000iuA9IAI'-- partner firms
        and p.is_head = 1
)

-- returns the latest location row
, locations_cte as (
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

, associates_rev_coding_latest_cte as (
    select
        effective_date        as effective_date
        , seg_3               as location_accounting_id
        , associate_id_oracle as associate_id_oracle
        , assoc_name_hc       as associate_full_name
        -- accounts for rare instances that an client manager has two records for the same period, differerent state values for tax requirements
        , row_number() over (
            partition by associate_id_adp , associate_id_oracle , start_date , end_date
            order by _id
        )                     as rn
    from {{ ref('bld_associate_revenue_coding') }}
    where is_latest = 1
    qualify rn = 1
)

-- [system attributes]
select
    r.system_name::text                                                                         as system_name
    , r.system_instance::text                                                                   as system_instance
    , r.system_key::text                                                                        as system_key
    , 'inst'::text                                                                              as firm_source

    -- [location]
    , coalesce(
        l1.location_code
        , l2.location_code
        , case
            when lower(r.location) = 'rps'
                then
                    '301'
        end
    )::text                                                                                     as location_code
    , case
        when lower(r.location) = 'rps'
            then
                (
                    select aa.office_name from {{ ref('locations_active') }} as aa
                    where aa.location_code = '301'
                )
        else
            coalesce(l1.office_name , l2.office_name)::text
    end                                                                                         as office_name
    , case
        when lower(r.location) = 'rps'
            then
                '301'
        else
            l2.location_code
    end::text
        as client_location_code
    , case
        when lower(r.location) = 'rps'
            then
                (
                    select aa.office_name from {{ ref('locations_active') }} as aa
                    where aa.location_code = '301'
                )
        else
            l2.office_name
    end::text                                                                                   as client_office_name

    -- [financial dates]
    , r.invoice_date::datetime                                                                  as invoice_created_at
    , r.invoice_date::date                                                                      as invoice_date
    , r.revenue_quarter_end_date::date                                                          as revenue_period_end_date
    , r.revenue_quarter_end_date::date                                                          as revenue_quarter_end_date

    -- [invoice]
    , null::text                                                                                as invoice_number_source
    , null::text                                                                                as billing_statement_id_source
    , iff(
        r.client_payment is null , 'outstanding' , 'paid'
    )::text                                                                                     as invoice_status
    , 0::int                                                                                    as is_intra_period_invoice
    , r.account_number::text                                                                    as account_number
    , r.account_number_formatted::text                                                          as account_number_formatted
    , r.account_number::text                                                                    as billing_account_number
    , null::text                                                                                as account_id_pms
    , coalesce(z1.acct_name , z2.acct_name)::text                                               as registrant_name
    , r.client_name::text                                                                       as account_name
    , null::text                                                                                as type_of_account
    , r.client_salesforce_id::text                                                              as client_id_pms
    , null::text                                                                                as aum_classification_status
    , r.record_keeper::text                                                                     as custodian
    , r.record_keeper::text                                                                     as billing_custodian
    , coalesce(z1.partner_firm_name , z2.partner_firm_name)::text                               as partner_firm_original
    , coalesce(z1.partner_firm_name , z2.partner_firm_name)::text                               as partner_firm

    -- [advisor]
    , r.client_manager_new::text                                                                as advisor_source
    , r.client_manager::text                                                                    as advisor_original
    , coalesce(c.associate_full_name , r.client_manager_new , r.client_manager)::text           as advisor_primary
    , coalesce(c.associate_id_oracle , coalesce(z1.employee_number , z2.employee_number))::text as associate_id_primary
    , 'W-2'::text                                                                               as advisor_type
    , coalesce(c.associate_full_name , r.client_manager_new , r.client_manager)::text           as advisor
    , coalesce(
        c.associate_id_oracle , coalesce(z1.employee_number , z2.employee_number)
    )::text                                                                                     as associate_id

    -- [assets and fees]
    , r.comment::text                                                                           as fee_type
    , null::text                                                                                as fee_schedule_source
    , r.invoice_date::date                                                                      as assets_as_of_date
    , r.invoice_date::date                                                                      as fee_calculation_date
    , null::number(18 , 2)                                                                      as total_account_value
    , null::number(18 , 2)                                                                      as billable_value
    , r.amount::number(18 , 2)                                                                  as client_fee_gross
    , null::number(18 , 2)                                                                      as client_adjustments_fee
    , r.amount::number(18 , 2)                                                                  as client_fee_net
    , r.client_payment::date                                                                    as collection_date

    -- [billing terms and payment]
    , initcap(r.billing_style)::text                                                            as billing_style
    , initcap(r.billing_frequency)::text                                                        as billing_frequency
    , initcap(r.billing_source)::text                                                           as billing_method

    -- [accounting]
    , 'rev'::text                                                                               as account_class
    , 1::boolean                                                                                as recurring_revenue
    , 0::boolean                                                                                as impacted_by_financial_markets
    , '110'::text                                                                               as coa_segment_1_legal_entity_id
    , '000'::text                                                                               as coa_segment_2_product_id
    , coalesce(
        l1.accounting_id , l2.accounting_id , '3301'
    )::text                                                                                     as coa_segment_3_accounting_id
    , '0000'::text                                                                              as coa_segment_4_team_id
    , '43001'::text
        as coa_segment_5_natural_account_id
    , '000'::text                                                                               as coa_segment_6_initiative_id
    , '000'::text                                                                               as coa_segment_7_intercompany_id
    , '000'::text                                                                               as coa_segment_8_future_id
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
    )::text                                                                                     as coa_account_number
    , '401k'::text                                                                              as revenue_category
    , '401k'::text                                                                              as revenue_type

    -- [crm]
    , 'salesforce'::text                                                                        as system_name_crm
    , 'compass'::text                                                                           as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text                                as system_key_crm
    , null::text                                                                                as account_id_crm
    , r.client_salesforce_id::text                                                              as client_id_crm
    , r.client_salesforce_id::text                                                              as client_id_original_crm
    , coalesce(z1.unique_identifier_c , z2.unique_identifier_c)::text                           as client_id_unique_compass
    , coalesce(z1.acct_name , z2.acct_name)::text                                               as client_name
    , coalesce(z1.acct_name , z2.acct_name)::text                                               as client_name_original_crm
    , coalesce(z1.lead_source_c , z2.lead_source_c)::text                                       as client_lead_source
    , coalesce(z1.key_tags_c , z2.key_tags_c)::text                                             as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text                                                                           as transaction_type
    , 'Line'::text                                                                              as transaction_line_type
    , 1::int                                                                                    as transaction_line_quantity
    , 'USD'::text                                                                               as currency_code
    , 'User'::text                                                                              as currency_conversion_type
    , r.amount::number(18 , 2)                                                                  as unit_selling_price

    -- [exclusions]
    -- no records are being excluded, default to 0
    , ''::text                                                                                  as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                                    as is_excluded

    -- [referential]
    , r.account_number || '_' || r.invoice_date::text                                           as _invoice_key
    , r._created_at::datetime                                                                   as _source_loaded_at
    , r._box_file_name::text                                                                    as _source_file
    , r._box_file_id::text                                                                      as _box_file_id
    , null::variant                                                                             as _extra_fields
    , r._created_at::datetime                                                                   as _created_at

from {{ ref('rps__stg_bills') }} as r
left join sf2_clients_cte as z1
    on r.client_salesforce_id = z1.acct_id
    and r.invoice_date = z1.effective_date
    and z1.is_head_per_day = 1
left join sf2_clients_cte as z2
    on r.client_salesforce_id = z2.acct_id
    and z2.is_head = 1
left join associates_rev_coding_latest_cte as c
    on coalesce(z1.employee_number , z2.employee_number) = c.associate_id_oracle
    and r.revenue_quarter_end_date = c.effective_date
left join locations_cte as l1
    on c.location_accounting_id = l1.accounting_id
left join locations_cte as l2
    on coalesce(z1.finance_code_c , z2.finance_code_c) = l2.location_code
