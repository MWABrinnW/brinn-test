{{ config(
  enabled=false
) }}


select
-- [system attributes]
    sw.system_name::varchar(200)                        as system_name
    , sw.system_instance::varchar(200)                  as system_instance
    , sw.system_key::varchar(200)                       as system_key

    -- [location]
    , sw.location_code                                  as location_code
    , sw.office_name                                    as office_name
    , sw.location_code::varchar(200)                    as client_location_code
    , sw.office_name::varchar(200)                      as client_office_name

    -- [financial dates]
    , sw.invoice_created_at::datetime                   as invoice_created_at
    , sw.invoice_date::date                             as invoice_date
    , sw.revenue_month_start_date::date                 as revenue_month_start_date
    , sw.revenue_month_end_date::date                   as revenue_month_end_date
    , sw.days_in_month                                  as days_in_month
    , sw.revenue_quarter_end_date::date                 as revenue_quarter_end_date
    , sw.days_in_quarter                                as days_in_quarter

    -- [invoice]
    , sw.invoice_number_source::varchar(200)            as invoice_number_source
    , sw.billing_statement_id_source::varchar(200)      as billing_statement_id_source
    , sw.billing_statement_id_crm::varchar(200)         as billing_statement_id_crm
    , sw.invoice_status::varchar(200)                   as invoice_status
    , sw.is_intra_period_invoice                        as is_intra_period_invoice
    , sw.account_number::varchar(200)                   as account_number
    , sw.account_number_formatted::varchar(200)         as account_number_formatted
    , sw.billing_account_number::varchar(200)           as billing_account_number
    , sw.account_id_pms::varchar(200)                   as account_id_pms
    , sw.registrant_name::varchar(200)                  as registrant_name
    , sw.account_name::varchar(200)                     as account_name
    , sw.type_of_account::varchar(200)                  as type_of_account
    , sw.client_id_pms::varchar(200)                    as client_id_pms
    , sw.aum_classification_status::varchar(200)        as aum_classification_status
    , sw.model_investment_strategy::varchar(200)        as model_investment_strategy
    , sw.custodian::varchar(200)                        as custodian
    , sw.billing_custodian::varchar(200)                as billing_custodian
    , sw.partner_firm::varchar(200)                     as partner_firm
    , sw.partner_firm_original                          as partner_firm_original

    -- [advisor]
    , sw.client_manager_source::varchar(200)            as client_manager_source
    , sw.client_manager_original_crm::varchar(200)      as client_manager_original_crm
    , sw.client_manager_primary::varchar(200)           as client_manager_primary
    , sw.client_manager_type::varchar(200)              as client_manager_type
    , sw.associate_id::varchar(200)                     as associate_id

    -- [assets and fees]
    , sw.fee_type::varchar(200)                         as fee_type
    , sw.fee_schedule_source::varchar(200)              as fee_schedule_source
    , sw.fee_schedule_type::varchar(200)                as fee_schedule_type
    , sw.fee_schedule::varchar(200)                     as fee_schedule
    , sw.assets_as_of_date::date                        as assets_as_of_date
    , sw.fee_calculation_date::date                     as fee_calculation_date
    , sw.effective_fee_rate                             as effective_fee_rate
    , sw.total_account_value::number(20 , 5)            as total_account_value
    , sw.billable_value::number(20 , 5)                 as billable_value
    , sw.fee_excluded_assets::number(20 , 5)            as fee_excluded_assets
    , sw.client_fee_gross::number(20 , 5)               as client_fee_gross
    , sw.client_fee_rebates::number(20 , 5)             as client_fee_rebates
    , sw.client_net_contribution_fee::number(20 , 5)    as client_net_contribution_fee
    , sw.client_adjustments_fee::number(20 , 5)         as client_adjustments_fee
    , sw.client_write_off_fee::number(20 , 5)           as client_write_off_fee
    , sw.client_fee_net::number(20 , 5)                 as client_fee_net
    , sw.collection_date::date                          as collection_date
    , sw.client_fee_net_allocation::number(18 , 2)      as client_fee_net_allocation
    , sw.third_party_calculation::boolean               as third_party_calculation

    -- [billing terms and payment]
    , sw.billing_style::varchar(200)                    as billing_style
    , sw.billing_frequency::varchar(200)                as billing_frequency
    , sw.billing_method::varchar(200)                   as billing_method
    , sw.bill_on_balance_type                           as bill_on_balance_type
    , sw.payment_terms::varchar(200)                    as payment_terms
    , sw.payment_method_fee::number(20 , 5)             as payment_method_fee

    -- [accounting]
    , sw.account_class::varchar(200)                    as account_class
    , sw.recurring_revenue::boolean                     as recurring_revenue
    , sw.impacted_by_financial_markets::boolean         as impacted_by_financial_markets
    , sw.coa_segment_1_legal_entity_id::varchar(200)    as coa_segment_1_legal_entity_id
    , sw.coa_segment_2_product_id::varchar(200)         as coa_segment_2_product_id
    , sw.coa_segment_3_accounting_id::varchar(200)      as coa_segment_3_accounting_id
    , sw.coa_segment_4_team_id::varchar(200)            as coa_segment_4_team_id
    , sw.coa_segment_5_natural_account_id::varchar(200) as coa_segment_5_natural_account_id
    , sw.coa_segment_6_initiative_id::varchar(200)      as coa_segment_6_initiative_id
    , sw.coa_segment_7_intercompany_id::varchar(200)    as coa_segment_7_intercompany_id
    , sw.coa_segment_8_future_id::varchar(200)          as coa_segment_8_future_id
    , sw.coa_account_number::varchar(200)               as coa_account_number
    , sw.revenue_category::varchar(200)                 as revenue_category
    , sw.revenue_type::varchar(200)                     as revenue_type

    -- [crm]
    , sw.system_name_crm::varchar(200)                  as system_name_crm
    , sw.system_instance_crm::varchar(200)              as system_instance_crm
    , sw.system_key_crm::varchar(200)                   as system_key_crm
    , sw.account_id_crm::varchar(200)                   as account_id_crm
    , sw.client_id_crm::varchar(200)                    as client_id_crm
    , sw.client_id_original_crm::varchar(200)
        as client_id_original_crm
    , sw.client_id_unique_compass::varchar(200)
        as client_id_unique_compass
    , sw.client_name::varchar(200)                      as client_name
    , sw.client_name_original_crm::varchar(200)
        as client_name_original_crm
    , sw.client_lead_source::varchar(200)               as client_lead_source
    , sw.client_key_tags_crm::varchar(200)              as client_key_tags_crm

    -- [transactions]
    , sw.transaction_type::varchar                      as transaction_type
    , sw.transaction_line_type::varchar(200)            as transaction_line_type
    , sw.transaction_line_quantity::number(20 , 5)      as transaction_line_quantity
    , sw.currency_code::varchar(200)                    as currency_code
    , sw.currency_conversion_type::varchar(200)         as currency_conversion_type
    , sw.unit_selling_price::number(20 , 5)             as unit_selling_price

    -- [exclusion]
    , sw.is_excluded::int                               as is_excluded
    , sw.excluded_reason::varchar(200)                  as excluded_reason

    -- [referential]
    , sw._invoice_key::varchar(200)                     as _invoice_key
    , sw._created_at::datetime                          as _created_at
    , sw._source_file::varchar(200)                     as _source_file
    , sw._box_file_id::varchar(200)                     as _box_file_id
    , sw._extra_fields::variant                         as _extra_fields

from
    {{ ref('int_subledger_01_allocations') }} as sw
order by
    sw.system_key asc , sw._invoice_key asc , sw.revenue_month_end_date desc
