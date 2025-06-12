select
    system_name::text                             as system_name
    , null::text                                  as system_instance
    , case
        -- Quickly did the ones we know the mapping for.
        -- Would need some investigation to determine the rest.
        when system_name ilike 'addepar'
            then 'addepar__corbenic'
        when system_name ilike 'axys'
            then 'axys__granite'
        when system_name ilike 'envestnet'
            then 'envestnet__manasquan'
        when system_name ilike 'portfoliocenter'
            then 'portfoliocenter__tcea'
        when system_name ilike 'sei'
            then 'sei__manasquan'
    end::text                                     as system_key
    -- If this is null then the row access policy won't work as intended.
    , null::text                                  as firm_source
    , location_code::text                         as location_code
    , location_name::text(300)                    as office_name
    , null::text                                  as client_location_code
    , null::text                                  as client_office_name
    , null::timestamp_ntz(9)                      as invoice_created_at
    , invoice_date::date                          as invoice_date
    , null::date                                  as revenue_period_end_date
    , revenue_quarter::date                       as revenue_quarter_end_date
    , null::text                                  as invoice_number_source
    , null::text                                  as billing_statement_id_source
    , null::text                                  as billing_statement_id_crm
    , null::text                                  as invoice_status
    , null::number(38 , 0)                        as is_intra_period_invoice
    , financial_account_number_clean::text        as account_number
    , financial_account_number::text              as account_number_formatted
    , billing_account_number::text                as billing_account_number
    , null::text                                  as account_id_pms
    , null::text                                  as registrant_name
    , financial_account_name::text                as account_name
    , type_of_account::text                       as type_of_account
    , null::text                                  as client_id_pms
    , aum_classification_status::text             as aum_classification_status
    , model_investment_strategy::text             as model_investment_strategy
    , null::text                                  as model_grouping_assignment
    , custodian::text                             as custodian
    , null::text                                  as billing_custodian
    , null::text                                  as partner_firm
    , null::text                                  as partner_firm_original
    , client_manager::text                        as advisor_source
    , null::text                                  as advisor_original
    , null::text                                  as associate_id_original
    , null::text                                  as advisor_primary
    , null::text                                  as associate_id_primary
    , null::text                                  as advisor_type
    , null::text                                  as advisor
    , null::text                                  as associate_id
    , fee_type::text                              as fee_type
    , fee_schedule::text                          as fee_schedule_source
    , null::text                                  as fee_schedule_type
    , null::text                                  as fee_schedule
    , null::date                                  as assets_as_of_date
    , null::date                                  as fee_calculation_date
    , null::number(20 , 5)                        as effective_fee_rate
    , null::number(20 , 5)                        as total_account_value
    , billable_value::number(20 , 5)              as billable_value
    , fee_excluded_assets::number(20 , 5)         as fee_excluded_assets
    , client_fee_gross::number(20 , 5)            as client_fee_gross
    , client_fee_rebates::number(20 , 5)          as client_fee_rebates
    , client_net_contribution_fee::number(20 , 5) as client_net_contribution_fee
    , client_adjustments_fee::number(20 , 5)      as client_adjustments_fee
    , client_write_off_fee::number(20 , 5)        as client_write_off_fee
    , client_fee_net::number(20 , 5)              as client_fee_net
    , null::decimal(20 , 2)                       as referral_fee
    , null::date                                  as collection_date
    , null::boolean                               as third_party_calculation
    , billing_style::text                         as billing_style
    , null::text                                  as billing_frequency
    , null::text                                  as billing_method
    , null::text                                  as bill_on_balance_type
    , null::text                                  as payment_terms
    , null::number(18 , 2)                        as payment_method_fee
    , null::text                                  as account_class
    , null::boolean                               as recurring_revenue
    , null::boolean                               as impacted_by_financial_markets
    , null::text                                  as coa_segment_1_legal_entity_id
    , null::text                                  as coa_segment_2_product_id
    , coa_segment_3_accounting_id::text           as coa_segment_3_accounting_id
    , null::text                                  as coa_segment_4_team_id
    , null::text                                  as coa_segment_5_natural_account_id
    , null::text                                  as coa_segment_6_initiative_id
    , null::text                                  as coa_segment_7_intercompany_id
    , null::text                                  as coa_segment_8_future_id
    , null::text(16777216)                        as coa_account_number
    , revenue_category::text                      as revenue_category
    , null::text                                  as revenue_type
    , null::text                                  as system_name_crm
    , null::text                                  as system_instance_crm
    , null::text                                  as system_key_crm
    , null::text                                  as account_id_crm
    , null::text                                  as client_id_crm
    , null::text                                  as client_id_original_crm
    , null::text                                  as client_id_unique_compass
    , client_name::text                           as client_name
    , null::text                                  as client_name_original_crm
    , null::text                                  as client_lead_source
    , null::text(5000)                            as client_key_tags_crm
    , null::text                                  as transaction_type
    , null::text                                  as transaction_line_type
    , null::number(20 , 5)                        as transaction_line_quantity
    , null::text                                  as currency_code
    , null::text                                  as currency_conversion_type
    , null::number(20 , 5)                        as unit_selling_price
    , ''::text                                    as excluded_reasons
    , 0::number(38 , 0)                           as is_excluded
    , null::text                                  as _invoice_key
    , null::timestamp_ntz(9)                      as _source_loaded_at
    , null::text                                  as _source_file
    , null::text                                  as _box_file_id
    , null::variant                               as _extra_fields
    , null::timestamp_ntz(9)                      as _created_at
    , 1::int                                      as is_legacy
from {{ source('reporting_raw', 'revenue_legacy_history') }}
