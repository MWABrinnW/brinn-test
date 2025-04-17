select
    -- [pms attributes]
    bb.system_name::text(200)                                                         as system_name
    , bb.system_instance::text(200)                                                   as system_instance
    , bb.system_key::text(200)                                                        as system_key
    , bb.firm_source::text(200)                                                       as firm_source

    -- [location]
    , coalesce(acc.household_location_code , acc2.household_location_code)::text(200) as client_location_code

    -- [invoice]
    , bb.transaction_identifier::text(200)                                            as invoice_number_source
    , bb.fee_effective_date::timestamp_ntz                                            as invoice_created_at
    , bb.fee_effective_date::date                                                     as invoice_date
    , bb.transaction_identifier::text(200)                                            as billing_statement_id_source
    , null::text(200)                                                                 as billing_statement_id_crm
    , null::text(200)                                                                 as invoice_status
    , 0::int                                                                          as is_intra_period_invoice
    , replace(bb.account_number , '-' , '')::text(200)                                as account_number
    , bb.account_number::text(200)                                                    as account_number_formatted
    , replace(bb.account_number , '-' , '')::text(200)                                as billing_account_number
    , null::text(200)                                                                 as account_id_pms
    , bb.account_display_name::text(200)                                              as registrant_name
    , bb.account_display_name::text(200)                                              as account_name
    , coalesce(
        acc.registration_type
        , acc2.registration_type
    )::text(200)                                                                      as type_of_account
    , null::text(200)                                                                 as client_id_pms
    , coalesce(
        acc.aum_classification
        , acc2.aum_classification
    )::text(200
    )                                                                                 as aum_classification_status
    , coalesce(acc.investment_strategy , acc2.investment_strategy)::text(200)         as model_investment_strategy
    , coalesce(acc.custodian_key , acc2.custodian_key , 'SEI')::text(200)             as custodian
    , coalesce(
        acc.custodian_key , acc2.custodian_key , 'SEI'
    )::text(200)                                                                      as billing_custodian
    , null::text(200)                                                                 as partner_firm
    , null::text(200)                                                                 as partner_firm_original

    -- [advisor]
    , null::text(200)                                                                 as advisor_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::text(200)                                                   as advisor_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::text(200)                                                  as associate_id_original
    -- Current client manager (from compass account object, is_head)
    , acc2.client_manager::text(200)                                                  as advisor_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::text(200)                                                 as associate_id_primary
    , 'W-2'::text(200)                                                                as advisor_type


    -- [assets and fees]
    , bb.fee_type_description::text(200)                                              as fee_type
    , coalesce(acc.fee_schedule , acc2.fee_schedule)::text                            as fee_schedule_source
    , null::text(200)                                                                 as fee_schedule_type
    , null::text(200)                                                                 as fee_schedule
    , bb.fee_effective_date::date                                                     as assets_as_of_date
    , bb.fee_effective_date::date                                                     as fee_calculation_date
    , null::decimal(29 , 8)                                                           as effective_fee_rate
    , acc.account_value::decimal(20 , 5)                                              as total_account_value
    , acc.account_value::decimal(20 , 5)                                              as billable_value
    , null::decimal(20 , 5)                                                           as fee_excluded_assets
    , bb.fees_collected::decimal(20 , 5)                                              as client_fee_gross
    , null::decimal(20 , 5)                                                           as client_fee_rebates
    , null::decimal(20 , 5)                                                           as client_net_contribution_fee
    , null::decimal(20 , 5)                                                           as client_adjustments_fee
    , null::decimal(20 , 5)                                                           as client_write_off_fee
    , bb.fees_collected::decimal(20 , 5)                                              as client_fee_net
    , null::decimal(20 , 2)                                                           as referral_fee

    , null::date                                                                      as collection_date
    , null::boolean                                                                   as third_party_calculation

    -- [billing terms and payment]
    , 'Arrears'::text(200)                                                            as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Quarterly'::text(200)                                                          as billing_frequency
    , 'Direct'::text(200)                                                             as billing_method
    , null::text(200)                                                                 as bill_on_balance_type
    , null::text(200)                                                                 as payment_terms
    , null::decimal(20 , 5)                                                           as payment_method_fee

    -- [accounting]
    , 'REV'::text(200)                                                                as account_class
    , '110'::text(200)                                                                as coa_segment_1_legal_entity_id
    , null::text(200)                                                                 as coa_segment_3_accounting_id
    , null::text(200)                                                                 as coa_segment_4_team_id
    , case
        when acc.household_lead_source in ('Referral Partner - SAN' , 'Referral Partner - WAS')
            then
                '40000'
        when acc.household_lead_source ilike '%solicitor%'
            then
                '40002'
        else
            '40001'
    end::text(200)                                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::text(200)                                                  as revenue_category
    , 'Wealth Mgmt Fees'::text(200)                                                   as revenue_type

    -- [crm]
    , 'salesforce'::text(200)                                                         as system_name_crm
    , 'compass'::text(200)                                                            as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text(200)                 as system_key_crm
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
    , bb.fees_collected::number(20 , 5)                                               as unit_selling_price

    -- [exclusion]
    -- no records are being excluded, default to 0
    , ''::text(200)                                                                   as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                          as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , bb.transaction_identifier::text(200)                                            as _trans_key
    , bb._created_at::timestamp_ntz(9)                                                as _source_loaded_at
    , bb._box_file_name::text(200)                                                    as _source_file
    , bb._box_file_id::text(200)                                                      as _box_file_id

    -- [extra fields]
    , object_construct_keep_null(
        'join_sf1_eff_date' , iff(acc.account_number is not null , 1 , 0)
        , 'join_sf2_is_head' , iff(acc2.account_number is not null , 1 , 0)
    )::variant                                                                        as _extra_fields
from {{ ref('sei_manasquan__base_bills') }} as bb
-- joins crm data on invoice date, if available
left join {{ ref('salesforce_compass_accounts') }} as acc
    on trim(replace(bb.account_number , '-' , '')) = trim(replace(acc.account_number_formatted , '-' , ''))
    and bb.fee_effective_date = acc.effective_date
-- otherwise, joins to the current snapshot (is_head = 1)
left join {{ ref('salesforce_compass_accounts') }} as acc2
    on bb.account_number = acc2.account_number_formatted
    and acc2.is_head = 1
where true
    and bb.is_head = 1
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
