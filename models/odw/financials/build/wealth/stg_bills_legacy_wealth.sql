select
    system_name::varchar(200)                      as system_name
    , null::varchar(200)                           as system_instance
    , null::varchar(200)                           as system_key
    , location_code::varchar(200)                  as location_code
    , location_name::varchar(300)                  as office_name
    , null::varchar(200)                           as client_location_code
    , null::varchar(200)                           as client_office_name
    , null::timestamp_ntz(9)                       as invoice_created_at
    , invoice_date::date                           as invoice_date
    , null::date                                   as revenue_period_end_date
    , revenue_quarter::date                        as revenue_quarter_end_date
    , null::varchar(200)                           as invoice_number_source
    , null::varchar(200)                           as billing_statement_id_source
    , null::varchar(200)                           as billing_statement_id_crm
    , null::varchar(600)                           as invoice_status
    , null::number(38 , 0)                         as is_intra_period_invoice
    , financial_account_number_clean::varchar(200) as account_number
    , financial_account_number::varchar(200)       as account_number_formatted
    , billing_account_number::varchar(200)         as billing_account_number
    , null::varchar(200)                           as account_id_pms
    , null::varchar(200)                           as registrant_name
    , financial_account_name::varchar(200)         as account_name
    , type_of_account::varchar(200)                as type_of_account
    , null::varchar(200)                           as client_id_pms
    , aum_classification_status::varchar(200)      as aum_classification_status
    , model_investment_strategy::varchar(200)      as model_investment_strategy
    , custodian::varchar(200)                      as custodian
    , null::varchar(200)                           as billing_custodian
    , null::varchar(200)                           as partner_firm
    , null::varchar(200)                           as partner_firm_original
    , client_manager::varchar(200)                 as client_manager_source
    , null::varchar(200)                           as client_manager_original
    , null::varchar(200)                           as associate_id_original
    , null::varchar(200)                           as client_manager_primary
    , null::varchar(200)                           as associate_id_primary
    , null::varchar(200)                           as client_manager_type
    , null::varchar(200)                           as client_manager
    , null::varchar(200)                           as associate_id
    , fee_type::varchar(600)                       as fee_type
    , fee_schedule::varchar(600)                   as fee_schedule_source
    , null::varchar(600)                           as fee_schedule_type
    , null::varchar(600)                           as fee_schedule
    , null::date                                   as assets_as_of_date
    , null::date                                   as fee_calculation_date
    , null::number(20 , 5)                         as effective_fee_rate
    , null::number(20 , 5)                         as total_account_value
    , billable_value::number(20 , 5)               as billable_value
    , fee_excluded_assets::number(20 , 5)          as fee_excluded_assets
    , client_fee_gross::number(20 , 5)             as client_fee_gross
    , client_fee_rebates::number(20 , 5)           as client_fee_rebates
    , client_net_contribution_fee::number(20 , 5)  as client_net_contribution_fee
    , client_adjustments_fee::number(20 , 5)       as client_adjustments_fee
    , client_write_off_fee::number(20 , 5)         as client_write_off_fee
    , client_fee_net::number(20 , 5)               as client_fee_net
    , null::date                                   as collection_date
    , null::boolean                                as third_party_calculation
    , billing_style::varchar(600)                  as billing_style
    , null::varchar(600)                           as billing_frequency
    , null::varchar(600)                           as billing_method
    , null::varchar(600)                           as bill_on_balance_type
    , null::varchar(600)                           as payment_terms
    , null::varchar(16777216)                      as payment_method_fee
    , null::varchar(200)                           as account_class
    , null::boolean                                as recurring_revenue
    , null::boolean                                as impacted_by_financial_markets
    , null::varchar(200)                           as coa_segment_1_legal_entity_id
    , null::varchar(200)                           as coa_segment_2_product_id
    , coa_segment_3_accounting_id::varchar(200)    as coa_segment_3_accounting_id
    , null::varchar(200)                           as coa_segment_4_team_id
    , null::varchar(200)                           as coa_segment_5_natural_account_id
    , null::varchar(200)                           as coa_segment_6_initiative_id
    , null::varchar(200)                           as coa_segment_7_intercompany_id
    , null::varchar(200)                           as coa_segment_8_future_id
    , null::varchar(16777216)                      as coa_account_number
    , revenue_category::varchar(600)               as revenue_category
    , null::varchar(600)                           as revenue_type
    , null::varchar(200)                           as system_name_crm
    , null::varchar(200)                           as system_instance_crm
    , null::varchar(200)                           as system_key_crm
    , null::varchar(200)                           as account_id_crm
    , null::varchar(200)                           as client_id_crm
    , null::varchar(200)                           as client_id_original_crm
    , null::varchar(200)                           as client_id_unique_compass
    , client_name::varchar(200)                    as client_name
    , null::varchar(200)                           as client_name_original_crm
    , null::varchar(600)                           as client_lead_source
    , null::varchar(5000)                          as client_key_tags_crm
    , null::varchar(600)                           as transaction_type
    , null::varchar(600)                           as transaction_line_type
    , null::number(20 , 5)                         as transaction_line_quantity
    , null::varchar(200)                           as currency_code
    , null::varchar(200)                           as currency_conversion_type
    , null::number(20 , 5)                         as unit_selling_price
    , ''::varchar(600)                             as excluded_reasons
    , 0::number(38 , 0)                            as is_excluded
    , null::varchar(200)                           as _invoice_key
    , null::timestamp_ntz(9)                       as _source_loaded_at
    , null::varchar(200)                           as _source_file
    , null::varchar(200)                           as _box_file_id
    , null::variant                                as _extra_fields
    , null::timestamp_ntz(9)                       as _created_at
from {{ source('reporting_raw', 'revenue_legacy_history') }}
