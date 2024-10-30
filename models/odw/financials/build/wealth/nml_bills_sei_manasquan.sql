select
    -- [pms attributes]
    bb.system_name::varchar(200)                                                         as system_name
    , bb.system_instance::varchar(200)                                                   as system_instance
    , bb.system_key::varchar(200)                                                        as system_key

    -- [location]
    , coalesce(acc.household_location_code , acc2.household_location_code)::varchar(200) as client_location_code

    -- [invoice]
    , bb.transaction_identifier::varchar(200)                                            as invoice_number_source
    , bb.fee_effective_date::timestamp_ntz                                               as invoice_created_at
    , bb.fee_effective_date::date                                                        as invoice_date
    , bb.transaction_identifier::varchar(200)                                            as billing_statement_id_source
    , null::varchar(200)                                                                 as billing_statement_id_crm
    , null::varchar(200)                                                                 as invoice_status
    , 0::int                                                                             as is_intra_period_invoice
    , replace(bb.account_number , '-' , '')::varchar(200)                                as account_number
    , bb.account_number::varchar(200)                                                    as account_number_formatted
    , replace(bb.account_number , '-' , '')::varchar(200)                                as billing_account_number
    , null::varchar(200)                                                                 as account_id_pms
    , bb.account_display_name::varchar(200)                                              as registrant_name
    , bb.account_display_name::varchar(200)                                              as account_name
    , coalesce(
        acc.registration_type
        , acc2.registration_type
    )::varchar(200)                                                                      as type_of_account
    , null::varchar(200)                                                                 as client_id_pms
    , coalesce(
        acc.aum_classification
        , acc2.aum_classification
    )::varchar(200
    )                                                                                    as aum_classification_status
    , coalesce(acc.investment_strategy , acc2.investment_strategy)::varchar(200)         as model_investment_strategy
    , coalesce(acc.custodian_key , acc2.custodian_key , 'SEI')::varchar(200)             as custodian
    , coalesce(
        acc.custodian_key , acc2.custodian_key , 'SEI'
    )::varchar(200)                                                                      as billing_custodian
    , null::varchar(200)                                                                 as partner_firm
    , null::varchar(200)                                                                 as partner_firm_original

    -- [advisor]
    , null::varchar(200)                                                                 as client_manager_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::varchar(200)                                                   as client_manager_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::varchar(200)                                                  as associate_id_original
    -- Current client manager (from compass account object, is_head)
    , acc2.client_manager::varchar(200)                                                  as client_manager_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::varchar(200)                                                 as associate_id_primary
    , 'W-2'::varchar(200)                                                                as client_manager_type


    -- [assets and fees]
    , bb.fee_type_description::varchar(200)                                              as fee_type
    , fs.name::varchar(200)                                                              as fee_schedule_source
    , null::varchar(200)                                                                 as fee_schedule_type
    , null::varchar(200)                                                                 as fee_schedule
    , bb.fee_effective_date::date                                                        as assets_as_of_date
    , bb.fee_effective_date::date                                                        as fee_calculation_date
    , null::decimal(29 , 8)                                                              as effective_fee_rate
    , acc.account_value::decimal(20 , 5)                                                 as total_account_value
    , acc.account_value::decimal(20 , 5)                                                 as billable_value
    , null::decimal(20 , 5)                                                              as fee_excluded_assets
    , bb.fees_collected::decimal(20 , 5)                                                 as client_fee_gross
    , null::decimal(20 , 5)                                                              as client_fee_rebates
    , null::decimal(20 , 5)                                                              as client_net_contribution_fee
    , null::decimal(20 , 5)                                                              as client_adjustments_fee
    , null::decimal(20 , 5)                                                              as client_write_off_fee
    , bb.fees_collected::decimal(20 , 5)                                                 as client_fee_net
    , null::date                                                                         as collection_date
    , null::boolean                                                                      as third_party_calculation

    -- [billing terms and payment]
    , 'Arrears'::varchar(200)                                                            as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Quarterly'::varchar(200)                                                          as billing_frequency
    , 'Direct'::varchar(200)                                                             as billing_method
    , null::varchar(200)                                                                 as bill_on_balance_type
    , null::varchar(200)                                                                 as payment_terms
    , null::decimal(20 , 5)                                                              as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                                as account_class
    , '110'::varchar(200)                                                                as coa_segment_1_legal_entity_id
    , null::varchar(200)                                                                 as coa_segment_3_accounting_id
    , case
        when acc.household_lead_source in ('Referral Partner - SAN' , 'Referral Partner - WAS')
            then
                '40000'
        when acc.household_lead_source ilike '%solicitor%'
            then
                '40002'
        else
            '40001'
    end::varchar(200)                                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::varchar(200)                                                  as revenue_category
    , 'Wealth Mgmt Fees'::varchar(200)                                                   as revenue_type

    -- [crm]
    , 'salesforce'::varchar(200)                                                         as system_name_crm
    , 'compass'::varchar(200)                                                            as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::varchar(200)                 as system_key_crm
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
    , bb.fees_collected::number(20 , 5)                                                  as unit_selling_price

    -- [exclusion]
    -- no records are being excluded, default to 0
    , 0::int                                                                             as is_excluded
    , null::varchar(200)                                                                 as excluded_reason

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , bb.transaction_identifier::varchar(200)                                            as _trans_key
    , bb._created_at::timestamp_ntz(9)                                                   as _source_loaded_at
    , bb._box_file_name::varchar(200)                                                    as _source_file
    , bb._box_file_id::varchar(200)                                                      as _box_file_id

    -- [extra fields]
    , null::object                                                                       as _extra_fields


from {{ ref('sei_manasquan__base_bills') }} as bb
-- joins crm data on invoice date, if available
left join {{ ref('salesforce_compass_accounts') }} as acc
    on trim(replace(bb.account_number , '-' , '')) = trim(replace(acc.account_number_formatted , '-' , ''))
    and bb.fee_effective_date = acc.effective_date
    and acc.is_latest = 1
-- otherwise, joins to the current snapshot (is_head = 1)
left join {{ ref('salesforce_compass_accounts') }} as acc2
    on bb.account_number = acc2.account_number_formatted
    and acc2.is_head = 1
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on
    coalesce(
        acc.effective_at::date
        , acc2.effective_at::date
    )
    = fs.effective_at::date
    and coalesce(
        acc.fee_schedule
        , acc2.fee_schedule
    ) = fs.id
    and fs.is_latest = 1
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
