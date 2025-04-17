select
    -- [pms attributes]
    b.system_name::text(200)                                                          as system_name
    , b.system_instance::text(200)                                                    as system_instance
    , b.system_key::text(200)                                                         as system_key
    , b.firm_source::text(200)                                                        as firm_source

    -- [location]
    , coalesce(acc.household_location_code , acc2.household_location_code)::text(200) as client_location_code

    -- [invoice]
    , b.billing_id::text(200)                                                         as invoice_number_source
    , null::timestamp_ntz                                                             as invoice_created_at
    , b.billing_date::date                                                            as invoice_date
    , null::text(200)                                                                 as billing_statement_id_source
    , null::text(200)                                                                 as billing_statement_id_crm
    , null::text(200)                                                                 as invoice_status
    , 0::int                                                                          as is_intra_period_invoice
    , a.account_number::text(200)                                                     as account_number
    , a.account_number_formatted::text(200)                                           as account_number_formatted
    , b.billing_bill_to_account_number::text(200)                                     as billing_account_number
    , b.entity_id::text(200)                                                          as account_id_pms
    , a.top_level_owner::text(200)                                                    as registrant_name
    , b.name::text(200)                                                               as account_name
    , coalesce(acc.registration_type , acc2.registration_type)::text(200)             as type_of_account
    , a.top_level_owner_entity_id::text(200)                                          as client_id_pms
    , coalesce(acc.aum_classification , acc2.aum_classification)::text(200)           as aum_classification_status
    , coalesce(acc.investment_strategy , acc2.investment_strategy)::text(200)         as model_investment_strategy
    -- confirm this matches FA Master
    , coalesce(acc.custodian_key , acc2.custodian_key)::text(200)                     as custodian
    , null::text(200)                                                                 as billing_custodian
    , null::text(200)                                                                 as partner_firm
    , null::text(200)                                                                 as partner_firm_original

    -- [advisor]
    , null::varchar(200)                                                              as advisor_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::varchar(200)                                                as advisor_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::text(200)                                                  as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , acc2.client_manager::varchar(200)                                               as advisor_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::varchar(200)                                              as associate_id_primary
    , 'W-2'::varchar(200)                                                             as advisor_type

    -- [assets and fees]
    -- fee type requires null handling, deteremines revenue category
    , lower(coalesce(trim(b.billing_fee_type) , 'management fee'))::text(200)         as fee_type
    , coalesce(acc.fee_schedule , acc2.fee_schedule)::text(200)                       as fee_schedule_source
    , null::text(200)                                                                 as fee_schedule_type
    , null::text(200)                                                                 as fee_schedule
    , b.billing_date::date                                                            as assets_as_of_date
    , b.billing_date::date                                                            as fee_calculation_date
    , case
        when b.billing_assets_billed_on = 0 or b.billing_fee_value = 0 then null
        else b.billing_fee_value / b.billing_assets_billed_on::decimal(20 , 5)
    end::decimal(29 , 8)                                                              as effective_fee_rate
    , coalesce(b.value , acc.account_value)::decimal(20 , 5)                          as total_account_value
    , b.billing_assets_billed_on::decimal(20 , 5)                                     as billable_value
    , (b.value - b.billing_assets_billed_on)::decimal(20 , 5)                         as fee_excluded_assets
    , b.billing_gross_fee::decimal(20 , 5)                                            as client_fee_gross
    , 0::decimal(20 , 5)                                                              as client_fee_rebates
    , 0::decimal(20 , 5)                                                              as client_net_contribution_fee
    , b.billing_prorated_fee::decimal(20 , 5)                                         as client_adjustments_fee
    , 0::decimal(20 , 5)                                                              as client_write_off_fee
    , b.billing_fee_value::decimal(20 , 5)                                            as client_fee_net
    , null::decimal(20 , 2)                                                           as referral_fee
    , null::date                                                                      as collection_date
    , null::boolean                                                                   as third_party_calculation

    -- [billing terms and payment]
    , case
        when b.billing_schedule_timing ilike '%advance%' then 'Advance'
        when b.billing_schedule_timing ilike '%arrears%' then 'Arrears'
        else 'Advance'
    end::text(200)                                                                    as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , lower(coalesce(b.billing_schedule_interval , 'monthly'))::text(200)             as billing_frequency
    , a.billing_payment_method::text(200)                                             as billing_method

    , case
        when fee_type ilike '%management fee%'
            then 'EOM Balance'
    end::text(200)                                                                    as bill_on_balance_type
    , null::text(200)                                                                 as payment_terms
    , null::number(20 , 5)                                                            as payment_method_fee

    -- [accounting]
    , 'REV'::text(200)                                                                as account_class
    , null::text(200)                                                                 as coa_segment_1_legal_entity_id
    , '1197'::text(200)                                                               as coa_segment_3_accounting_id
    , null::text(200)                                                                 as coa_segment_4_team_id
    , case
        when coalesce(acc.household_lead_source , acc2.household_lead_source) ilike '%RPP%'
            then '40000'
        when coalesce(acc.household_lead_source , acc2.household_lead_source) ilike '%Solicitor%'
            then '40002'
        else
            '40001'
    end::text(200)                                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::text(200)                                                  as revenue_category
    , 'Wealth Mgmt Fees'::text(200)                                                   as revenue_type

    -- [crm]
    , coalesce(acc.system_name , acc2.system_name)::text(200)                         as system_name_crm
    , coalesce(acc.system_instance , acc2.system_instance)::text(200)                 as system_instance_crm
    , coalesce(acc.system_key , acc2.system_key)::text(200)                           as system_key_crm
    , coalesce(acc.id , acc2.id)::text(200)                                           as account_id_crm
    , coalesce(acc.client_id , acc2.client_id)::text(200)                             as client_id_crm
    , coalesce(acc.client_id , acc2.client_id)::text(200)                             as client_id_original_crm
    , coalesce(acc.unique_identifier , acc2.unique_identifier)::text(200)             as client_id_unique_compass
    , coalesce(acc.household_name , acc2.household_name)::text(200)                   as client_name
    , coalesce(acc.household_name , acc2.household_name)::text(200)                   as client_name_original_crm
    , coalesce(acc.household_lead_source , acc2.household_lead_source)::text(200)     as client_lead_source
    , coalesce(acc.key_tags , acc2.key_tags)::text(5000)                              as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text(200)                                                            as transaction_type
    , 'Line'::text(200)                                                               as transaction_line_type
    , 1::int                                                                          as transaction_line_quantity
    , 'USD'::text(200)                                                                as currency_code
    , 'User'::text(200)                                                               as currency_conversion_type
    , b.billing_fee_value::number(20 , 5)                                             as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, set excluded to empty string
    , ''::text(200)                                                                   as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                          as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , concat(b.billing_id , '-' , b.account_number)::varchar(200)                     as _trans_key
    , b._created_at::timestamp_ntz(9)                                                 as _source_loaded_at
    , b._source_file::varchar(200)                                                    as _source_file
    , null::varchar(200)                                                              as _box_file_id
    -- [extra field]
    , object_construct_keep_null(
        'join_pms_add_base_accts_is_head' , iff(a.account_number is not null , 1 , 0)
        , 'join_crm_sf_eff_date' , iff(acc.account_number is not null , 1 , 0)
        , 'join_crm_sf_is_head' , iff(acc2.account_number is not null , 1 , 0)
    )::variant                                                                        as _extra_fields
from {{ ref('addepar_corbenic_history__int_bills') }} as b
left join {{ ref('addepar_corbenic_history__base_accounts') }} as a
    on b.account_number = a.account_number
    and a.is_head = 1
-- joins crm data on invoice date, if available
left join {{ ref('salesforce_compass_accounts') }} as acc
    on a.account_number = acc.account_number
    and b._created_at::date = acc.effective_date
-- otherwise, joins to the current snapshot (is_head = 1)
left join {{ ref('salesforce_compass_accounts') }} as acc2
    on a.account_number = acc.account_number
    and acc2.is_head = 1
where true
    and b.is_head = 1
    and b.billing_date::date >= '2024-10-01'
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
