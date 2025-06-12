{%- set columns -%}
system_name
, system_instance
, system_key
, firm_source
, location_code
, office_name
, client_location_code
, client_office_name
, invoice_created_at
, invoice_date
, revenue_period_end_date
, revenue_quarter_end_date
, invoice_number_source
, billing_statement_id_source
, billing_statement_id_crm
, invoice_status
, is_intra_period_invoice
, account_number
, account_number_formatted
, billing_account_number
, account_id_pms
, registrant_name
, account_name
, type_of_account
, client_id_pms
, aum_classification_status
, model_investment_strategy
, model_grouping_assignment
, custodian
, billing_custodian
, partner_firm
, partner_firm_original
, advisor_source
, advisor_original
, associate_id_original
, advisor_primary
, associate_id_primary
, advisor_type
, advisor
, associate_id
, fee_type
, fee_schedule_source
, assets_as_of_date
, fee_calculation_date
, effective_fee_rate
, total_account_value
, billable_value
, fee_excluded_assets
, client_fee_gross
, client_fee_rebates
, client_net_contribution_fee
, client_adjustments_fee
, client_write_off_fee
, client_fee_net
, referral_fee
, collection_date
, third_party_calculation
, billing_style
, billing_frequency
, billing_method
, bill_on_balance_type
, payment_terms
, payment_method_fee
, account_class
, recurring_revenue
, impacted_by_financial_markets
, coa_segment_1_legal_entity_id
, coa_segment_2_product_id
, coa_segment_3_accounting_id
, coa_segment_4_team_id
, coa_segment_5_natural_account_id
, coa_segment_6_initiative_id
, coa_segment_7_intercompany_id
, coa_segment_8_future_id
, coa_account_number
, revenue_category
, revenue_type
, system_name_crm
, system_instance_crm
, system_key_crm
, account_id_crm
, client_id_crm
, client_id_original_crm
, client_id_unique_compass
, client_name
, client_name_original_crm
, client_lead_source
, client_key_tags_crm
, transaction_type
, transaction_line_type
, transaction_line_quantity
, currency_code
, currency_conversion_type
, unit_selling_price
, excluded_reasons
, is_excluded
, _invoice_key
, _source_loaded_at
, _source_file
, _box_file_id
, _extra_fields
, _created_at
{%- endset -%}

select
    {{ columns }}
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_black_diamond_baystate') }}

union all

select
    {{ columns }}
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_black_diamond_mps') }}

union all

select
    {{ columns }}
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_salesforce_compass') }}
where 1 = 1
    and _extra_fields['is_cpg']::int = 1

union all

select
    {{ columns }}
    , 0::int as is_legacy
from {{ ref('bld_billing_wealth_salesforce_compass_cpg') }}
where 1 = 1
    and _extra_fields['is_cpg']::int = 1

union all

select
    {{ columns }}
    , 1::int as is_legacy
from {{ ref('stg_bills_legacy_wealth') }}
where 1 = 1
    and (
        system_key in ('black_diamond__baystate' , 'black_diamond__mps')
        or (system_key = 'salesforce__compass' and (_extra_fields['is_cpg']::int = 1))
    )
