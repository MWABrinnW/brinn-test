select
    -- [pms attributes]
    b.system_name::varchar(200)                                                          as system_name
    , b.system_instance::varchar(200)                                                    as system_instance
    , b.system_key::varchar(200)                                                         as system_key

    -- [location]
    , coalesce(acc.household_location_code , acc2.household_location_code)::varchar(200) as client_location_code

    -- [invoice]
    , b.billing_id::varchar(200)                                                         as invoice_number_source
    , null::timestamp_ntz                                                                as invoice_created_at
    , b.billing_date::date                                                               as invoice_date
    , null::varchar(200)                                                                 as billing_statement_id_source
    , null::varchar(200)                                                                 as billing_statement_id_crm
    , null::varchar(200)                                                                 as invoice_status
    , 0::int                                                                             as is_intra_period_invoice
    , a.account_number::varchar(200)                                                     as account_number
    , a.account_number_formatted::varchar(200)                                           as account_number_formatted
    , b.billing_bill_to_account_number::varchar(200)                                     as billing_account_number
    , b.entity_id::varchar(200)                                                          as account_id_pms
    , a.top_level_owner::varchar(200)                                                    as registrant_name
    , b.name::varchar(200)                                                               as account_name
    , coalesce(acc.registration_type , acc2.registration_type)::varchar(200)             as type_of_account
    , a.top_level_owner_entity_id::varchar(200)                                          as client_id_pms
    , coalesce(acc.aum_classification , acc2.aum_classification)::varchar(200)           as aum_classification_status
    , coalesce(acc.investment_strategy , acc2.investment_strategy)::varchar(200)         as model_investment_strategy
    -- confirm this matches FA Master
    , coalesce(acc.custodian_key , acc2.custodian_key)::varchar(200)                     as custodian
    , null::varchar(200)                                                                 as billing_custodian
    , null::varchar(200)                                                                 as partner_firm
    , null::varchar(200)                                                                 as partner_firm_original

    -- [advisor]
    , b.cwm_lead_advisor::varchar(200)                                                   as client_manager_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::varchar(200)                                                   as client_manager_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::varchar(200)                                                  as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , acc2.client_manager::varchar(200)                                                  as client_manager_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::varchar(200)                                                 as associate_id_primary
    , 'W-2'::varchar(200)                                                                as client_manager_type

    -- [assets and fees]
    -- fee type requires null handling, deteremines revenue category
    , lower(coalesce(trim(b.billing_fee_type) , 'management fee'))::varchar(200)         as fee_type
    , fs.name::varchar(200)                                                              as fee_schedule_source
    , null::varchar(200)                                                                 as fee_schedule_type
    , null::varchar(200)                                                                 as fee_schedule
    , b.billing_date::date                                                               as assets_as_of_date
    , b.billing_date::date                                                               as fee_calculation_date
    , case
        when b.billing_assets_billed_on = 0 or b.billing_fee_value = 0 then null
        else b.billing_fee_value / b.billing_assets_billed_on::decimal(20 , 5)
    end::decimal(29 , 8)                                                                 as effective_fee_rate
    , coalesce(b.value , acc.account_value)::decimal(20 , 5)                             as total_account_value
    , b.billing_assets_billed_on::decimal(20 , 5)                                        as billable_value
    , (b.value - b.billing_assets_billed_on)::decimal(20 , 5)                            as fee_excluded_assets
    , b.billing_gross_fee::decimal(20 , 5)                                               as client_fee_gross
    , 0::decimal(20 , 5)                                                                 as client_fee_rebates
    , 0::decimal(20 , 5)                                                                 as client_net_contribution_fee
    , b.billing_prorated_fee::decimal(20 , 5)                                            as client_adjustments_fee
    , 0::decimal(20 , 5)                                                                 as client_write_off_fee
    , b.billing_fee_value::decimal(20 , 5)                                               as client_fee_net
    , null::decimal(20 , 2)                                                              as referral_fee
    , null::date                                                                         as collection_date
    , null::boolean                                                                      as third_party_calculation

    -- [billing terms and payment]
    , case
        when b.billing_schedule_timing ilike '%advance%' then 'Advance'
        when b.billing_schedule_timing ilike '%arrears%' then 'Arrears'
        else 'Advance'
    end::varchar(200)                                                                    as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , lower(coalesce(b.billing_schedule_interval , 'monthly'))::varchar(200)             as billing_frequency
    , a.billing_payment_method::varchar(200)                                             as billing_method

    , case
        when fee_type ilike '%management fee%'
            then 'EOM Balance'
    end::varchar(200)                                                                    as bill_on_balance_type
    , null::varchar(200)                                                                 as payment_terms
    , null::number(20 , 5)                                                               as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                                as account_class
    , null::varchar(200)                                                                 as coa_segment_1_legal_entity_id
    , '1197'::varchar(200)                                                               as coa_segment_3_accounting_id
    , null::varchar(200)                                                                 as coa_segment_4_team_id
    , case
        when coalesce(acc.household_lead_source , acc2.household_lead_source) ilike '%RPP%'
            then '40000'
        when coalesce(acc.household_lead_source , acc2.household_lead_source) ilike '%Solicitor%'
            then '40002'
        else
            '40001'
    end::varchar(200)                                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::varchar(200)                                                  as revenue_category
    , 'Wealth Mgmt Fees'::varchar(200)                                                   as revenue_type

    -- [crm]
    , coalesce(acc.system_name , acc2.system_name)::varchar(200)                         as system_name_crm
    , coalesce(acc.system_instance , acc2.system_instance)::varchar(200)                 as system_instance_crm
    , coalesce(acc.system_key , acc2.system_key)::varchar(200)                           as system_key_crm
    , coalesce(acc.id , acc2.id)::varchar(200)                                           as account_id_crm
    , coalesce(acc.client_id , acc2.client_id)::varchar(200)                             as client_id_crm
    , coalesce(acc.client_id , acc2.client_id)::varchar(200)                             as client_id_original_crm
    , coalesce(acc.unique_identifier , acc2.unique_identifier)::varchar(200)             as client_id_unique_compass
    , coalesce(acc.household_name , acc2.household_name)::varchar(200)                   as client_name
    , coalesce(acc.household_name , acc2.household_name)::varchar(200)                   as client_name_original_crm
    , coalesce(acc.household_lead_source , acc2.household_lead_source)::varchar(200)     as client_lead_source
    , coalesce(acc.key_tags , acc2.key_tags)::varchar(5000)                              as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::varchar(200)                                                            as transaction_type
    , 'Line'::varchar(200)                                                               as transaction_line_type
    , 1::int                                                                             as transaction_line_quantity
    , 'USD'::varchar(200)                                                                as currency_code
    , 'User'::varchar(200)                                                               as currency_conversion_type
    , b.billing_fee_value::number(20 , 5)                                                as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, set excluded to empty string
    , ''::varchar(200)                                                                   as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                             as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , concat(b.billing_id , '-' , b.holding_account_number)::varchar(200)                as _trans_key
    , b._created_at::timestamp_ntz(9)                                                    as _source_loaded_at
    , b._source_file::varchar(200)                                                       as _source_file
    , null::varchar(200)                                                                 as _box_file_id

    -- These are fields that are likely specific to this source
    -- and are intended to help with one off investigations or
    -- special analysis.
    , null::object                                                                       as _extra_fields
from
    {{ ref('addepar_corbenic_history__base_bills') }} as b
left join {{ ref('addepar_corbenic_history__base_accounts') }} as a
    on b.holding_account_number = a.account_number
-- joins crm data on invoice date, if available
left join {{ ref('salesforce_compass_accounts') }} as acc
    on trim(replace(a.account_number , '-' , '')) = trim(replace(acc.account_number_formatted , '-' , ''))
    and b._created_at::date = acc.effective_date
-- otherwise, joins to the current snapshot (is_head = 1)
left join {{ ref('salesforce_compass_accounts') }} as acc2
    on trim(replace(a.account_number , '-' , '')) = trim(replace(acc2.account_number_formatted , '-' , ''))
    and acc2.is_head = 1
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on
    coalesce(acc.effective_at::date , acc2.effective_at::date) = fs.effective_at::date
    and coalesce(acc.fee_schedule , acc2.fee_schedule) = fs.id
    and fs.is_latest = 1
where true
    and b.is_head = 1
    and b.billing_date::date >= '2024-10-01'
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
