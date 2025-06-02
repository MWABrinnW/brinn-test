{{
  config(
    alias = 'billing_independent_advisory' if target.name in ['prod', 'ci'] else None
    )
}}

select
    system_name::text                             as system_name
    , system_instance::text                       as system_instance
    , system_key::text                            as system_key
    -- row access policy applied in yaml file
    , firm_source::text                           as firm_source
    , location_code::text                         as location_code
    , office_name::text                           as office_name
    , client_location_code::text                  as client_location_code
    , client_office_name::text                    as client_office_name
    , invoice_created_at::timestamp_ntz(9)        as invoice_created_at
    , invoice_date::date                          as invoice_date
    , revenue_period_end_date::date               as revenue_period_end_date
    , revenue_quarter_end_date::date              as revenue_quarter_end_date
    , invoice_number_source::text                 as invoice_number_source
    , billing_statement_id_source::text           as billing_statement_id_source
    , billing_statement_id_crm::text              as billing_statement_id_crm
    , invoice_status::text                        as invoice_status
    , is_intra_period_invoice::int                as is_intra_period_invoice
    , account_number::text                        as account_number
    , account_number_formatted::text              as account_number_formatted
    , billing_account_number::text                as billing_account_number
    , account_id_pms::text                        as account_id_pms
    , registrant_name::text                       as registrant_name
    , account_name::text                          as account_name
    , type_of_account::text                       as type_of_account
    , client_id_pms::text                         as client_id_pms
    , aum_classification_status::text             as aum_classification_status
    , model_investment_strategy::text             as model_investment_strategy
    , model_grouping_assignment::text             as model_grouping_assignment
    , custodian::text                             as custodian
    , billing_custodian::text                     as billing_custodian
    , partner_firm::text                          as partner_firm
    , partner_firm_original::text                 as partner_firm_original
    , advisor_source::text                        as advisor_source
    , advisor_original::text                      as advisor_original
    , associate_id_original::text                 as associate_id_original
    , advisor_primary::text                       as advisor_primary
    , associate_id_primary::text                  as associate_id_primary
    , advisor_type::text                          as advisor_type
    , advisor::text                               as advisor
    , associate_id::text                          as associate_id
    , fee_type::text                              as fee_type
    , fee_schedule_source::text                   as fee_schedule_source
    , assets_as_of_date::date                     as assets_as_of_date
    , fee_calculation_date::date                  as fee_calculation_date
    , effective_fee_rate::number(20 , 5)          as effective_fee_rate
    , total_account_value::number(20 , 5)         as total_account_value
    , billable_value::number(20 , 5)              as billable_value
    , fee_excluded_assets::number(20 , 5)         as fee_excluded_assets
    , client_fee_gross::number(20 , 5)            as client_fee_gross
    , client_fee_rebates::number(20 , 5)          as client_fee_rebates
    , client_net_contribution_fee::number(20 , 5) as client_net_contribution_fee
    , client_adjustments_fee::number(20 , 5)      as client_adjustments_fee
    , client_write_off_fee::number(20 , 5)        as client_write_off_fee
    , client_fee_net::number(20 , 5)              as client_fee_net
    , referral_fee::number(20 , 5)                as referral_fee
    , collection_date::date                       as collection_date
    , third_party_calculation::boolean            as third_party_calculation
    , billing_style::text                         as billing_style
    , billing_frequency::text                     as billing_frequency
    , billing_method::text                        as billing_method
    , bill_on_balance_type::text                  as bill_on_balance_type
    , payment_terms::text                         as payment_terms
    , payment_method_fee::number(18 , 2)          as payment_method_fee
    , account_class::text                         as account_class
    , recurring_revenue::boolean                  as recurring_revenue
    , impacted_by_financial_markets::boolean      as impacted_by_financial_markets
    , coa_segment_1_legal_entity_id::text         as coa_segment_1_legal_entity_id
    , coa_segment_2_product_id::text              as coa_segment_2_product_id
    , coa_segment_3_accounting_id::text           as coa_segment_3_accounting_id
    , coa_segment_4_team_id::text                 as coa_segment_4_team_id
    , coa_segment_5_natural_account_id::text      as coa_segment_5_natural_account_id
    , coa_segment_6_initiative_id::text           as coa_segment_6_initiative_id
    , coa_segment_7_intercompany_id::text         as coa_segment_7_intercompany_id
    , coa_segment_8_future_id::text               as coa_segment_8_future_id
    , coa_account_number::text                    as coa_account_number
    , revenue_category::text                      as revenue_category
    , revenue_type::text                          as revenue_type
    , system_name_crm::text                       as system_name_crm
    , system_instance_crm::text                   as system_instance_crm
    , system_key_crm::text                        as system_key_crm
    , account_id_crm::text                        as account_id_crm
    , client_id_crm::text                         as client_id_crm
    , client_id_original_crm::text                as client_id_original_crm
    , client_id_unique_compass::text              as client_id_unique_compass
    , client_name::text                           as client_name
    , client_name_original_crm::text              as client_name_original_crm
    , client_lead_source::text                    as client_lead_source
    , client_key_tags_crm::text                   as client_key_tags_crm
    , transaction_type::text                      as transaction_type
    , transaction_line_type::text                 as transaction_line_type
    , transaction_line_quantity::number(20 , 5)   as transaction_line_quantity
    , currency_code::text                         as currency_code
    , currency_conversion_type::text              as currency_conversion_type
    , unit_selling_price::number(20 , 5)          as unit_selling_price
    , excluded_reasons::text                      as excluded_reasons
    , is_excluded::int                            as is_excluded
    , _invoice_key::text                          as _invoice_key
    , _source_loaded_at::timestamp_ntz(9)         as _source_loaded_at
    , _source_file::text                          as _source_file
    , _box_file_id::text                          as _box_file_id
    , _extra_fields::variant                      as _extra_fields
    , _created_at::timestamp_ntz(9)               as _created_at
    , 0::int                                      as is_legacy
from {{ ref('bld_billing_wealth') }}
where system_key in ('black_diamond__baystate' , 'black_diamond__mps')
    or (
        system_key = 'salesforce__compass' and (_extra_fields['is_cpg'] = 1)
    )
