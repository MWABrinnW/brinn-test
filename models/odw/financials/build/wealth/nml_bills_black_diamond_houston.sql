select
    ---[pms attributes]
    bb.system_name::varchar(200)                                                 as system_name
    , bb.system_instance::varchar(200)                                           as system_instance
    , bb.system_key::varchar(200)                                                as system_key

    --[location]
    , null::varchar(200)                                                         as client_location_code--[TODO] discuss with gavin

    -- [financial dates]
    , bb.as_of_date::timestamp_ntz                                               as invoice_created_at
    , bb.as_of_date::date                                                        as invoice_date
    , bb.period_end_date::date                                                   as revenue_period_end_date

    --[invoice]
    , null::varchar(200)                                                         as invoice_number_source
    , null::varchar(200)                                                         as billing_statement_id_source
    , null::varchar(200)                                                         as billing_statement_id_crm
    , null::varchar(200)                                                         as invoice_status
    , 0::int                                                                     as is_intra_period_invoice
    , replace(bb.account_number , '-' , '')::varchar(200)                        as account_number
    , bb.account_number::varchar(200)                                            as account_number_formatted
    , replace(bb.billing_account_number , '-' , '')::varchar(200)                as billing_account_number
    , bb.external_id::varchar(200)                                               as account_id_pms
    , bb.account_long_name::varchar(200)                                         as registrant_name
    , bb.account_name::varchar(200)                                              as account_name
    , coalesce(
        acc.registration_type
        , acc2.registration_type
    )::varchar(200)                                                              as type_of_account
    , ba.id::varchar(200)                                                        as client_id_pms
    , coalesce(
        acc.aum_classification
        , acc2.aum_classification
    )::varchar(200
    )                                                                            as aum_classification_status
    , coalesce(acc.investment_strategy , acc2.investment_strategy)::varchar(200) as model_investment_strategy
    , coalesce(acc.custodian_key , acc2.custodian_key)::varchar(200)             as custodian
    , coalesce(
        bb.billing_account_custodian , bb.custodian
    )::varchar(200)                                                              as billing_custodian
    , null::varchar(200)                                                         as partner_firm
    , null::varchar(200)                                                         as partner_firm_original

    -- [advisor]
    , coalesce(acc.client_manager , acc2.client_manager)::varchar(200)           as client_manager_source
    , coalesce(acc.client_manager , acc2.client_manager)::varchar(200)           as client_manager_original_crm
    , coalesce(acc.client_manager , acc2.client_manager)::varchar(200)           as client_manager_primary
    , 'W-2'::varchar(200)                                                        as client_manager_type
    , coalesce(
        acc.employee_number
        , acc2.employee_number
    )::varchar(200
    )                                                                            as associate_id

    -- [assets and fees]
    , 'Quarterly Fee'::varchar(200)                                              as fee_type
    , fs.name::varchar(200)                                                      as fee_schedule_source
    , bb.fee_schedule_name::varchar(200)                                         as fee_schedule_type
    , null::varchar(200)                                                         as fee_schedule
    , bb.as_of_date::date                                                        as assets_as_of_date
    , bb.as_of_date::date                                                        as fee_calculation_date
    , bb.rate_percentage * 100::decimal(20 , 5)                                  as effective_fee_rate
    , coalesce(bb.account_value , acc.account_value)::decimal(20 , 5)            as total_account_value
    , bb.billed_value::decimal(20 , 5)                                           as billable_value
    , (bb.account_value - bb.billed_value)::decimal(20 , 5)                      as fee_excluded_assets
    , case
        when bb.fee_or_rebate_amount > 0
            then
                bb.fee_or_rebate_amount
        else 0::decimal(20 , 5)
    end                                                                          as client_fee_gross
    , case
        when bb.fee_or_rebate_amount < 0
            then
                bb.fee_or_rebate_amount
        else 0
    end::decimal(20 , 5)                                                         as client_fee_rebates
    , null::decimal(20 , 5)                                                      as client_net_contribution_fee
    , null::decimal(20 , 5)                                                      as client_adjustments_fee
    , null::decimal(20 , 5)                                                      as client_write_off_fee
    , bb.fee_or_rebate_amount::decimal(20 , 5)                                   as client_fee_net
    , null::date                                                                 as collection_date
    , null::boolean                                                              as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::varchar(200)                                                    as billing_style
    , 'Quarterly'::varchar(200)                                                  as billing_frequency_source
    , 'Direct'::varchar(200)                                                     as billing_method
    , null::varchar(200)                                                         as bill_on_balance_type
    , null::varchar(200)                                                         as payment_terms
    , null::varchar(200)                                                         as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                        as account_class
    , '110'::varchar(200)                                                        as coa_segment_1_legal_entity_id
    , null::varchar(200)                                                         as coa_segment_3_accounting_id
    , case
        when coalesce(
                acc.household_lead_source
                , acc2.household_lead_source
            ) ilike '%RPP%'
            then
                '40000'
        when coalesce(
                acc.household_lead_source
                , acc2.household_lead_source
            ) ilike '%Solicitor%'
            then
                '40002'
        else
            '40001'
    end::varchar(200)                                                            as coa_segment_5_natural_account_id
    , 'Wealth Mgmt Fees'::varchar(200)                                           as revenue_type

    -- [crm]
    , 'salesforce'::varchar(200)                                                 as system_name_crm
    , 'compass'::varchar(200)                                                    as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::varchar(200)         as system_key_crm
    , coalesce(
        acc.id
        , acc2.id
    )::varchar(200)                                                              as account_id_crm
    , coalesce(
        acc.client_id
        , acc2.client_id
    )::varchar(200
    )                                                                            as client_id_crm
    , coalesce(
        acc.client_id
        , acc2.client_id
    )::varchar(200
    )                                                                            as client_id_original_crm
    , coalesce(

        acc.unique_identifier
        , acc2.unique_identifier

    )::varchar(200)                                                              as client_id_unique_compass
    , coalesce(

        acc.household_name
        , acc2.household_name
    )::varchar(200)                                                              as client_name
    , coalesce(
        acc.household_name
        , acc2.household_name
    )::varchar(200)                                                              as client_name_original_crm
    , coalesce(

        acc.household_lead_source
        , acc2.household_lead_source

    )::varchar(200)                                                              as client_lead_source
    , coalesce(

        acc.key_tags
        , acc2.key_tags

    )::varchar(5009)                                                             as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::varchar(200)                                                    as transaction_type
    , 'Line'::varchar(200)                                                       as transaction_line_type
    , 1::int                                                                     as transaction_line_quantity
    , 'USD'::varchar(200)                                                        as currency_code
    , 'User'::varchar(200)                                                       as currency_conversion_type
    , bb.fee_or_rebate_amount::number(20 , 5)                                    as unit_selling_price

    -- [exclusion]
    -- no records are being excluded, default to 0
    , 0::int                                                                     as is_excluded
    , null::varchar(200)                                                         as excluded_reason

    -- [referential]
    , trim(replace(bb.account_number , '-' , '')) || '-' || bb._id::varchar(200) as _trans_key
    , bb._created_at::timestamp_ntz(9)                                           as _created_at
    , bb._box_file_name::varchar(200)                                            as _source_file
    , bb._box_file_id::varchar(200)                                              as _box_file_id

    -- [extra fields]
    , null::variant                                                              as _extra_fields

from {{ ref('black_diamond_houston_history__base_bills') }} as bb
left join {{ ref('black_diamond_houston_history__base_accounts') }} as ba
    on bb.billing_account_number = ba.account_number
    and ba.is_head = 1
-- joins crm data on invoice date, if available
left join {{ ref('int_salesforce_compass_accounts') }} as acc
    on trim(replace(ba.account_number , '-' , '')) = trim(replace(acc.account_number_formatted , '-' , ''))
    and bb.as_of_date = acc.effective_date
    and acc.is_latest = 1
-- otherwise, joins to the current snapshot (is_head = 1)
left join {{ ref('int_salesforce_compass_accounts') }} as acc2
    on trim(replace(ba.account_number , '-' , '')) = trim(replace(acc.account_number_formatted , '-' , ''))
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
