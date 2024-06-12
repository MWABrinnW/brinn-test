{{ config(
  enabled=false
) }}


{%- set source_models = 
 
    ['int_subledger_02_typing'] -%}

{% for model in source_models -%}
    select
        system_key
        , invoice_number_source
        , billing_style
        , billing_frequency
        , invoice_created_at
        , invoice_date
        , is_mid_cycle_invoice
        , revenue_month_end_date
        , days_in_month
        , client_fee_net
        , client_fee_net_allocation
        , fee_type
        , client_lead_source
        , coa_segment_1_legal_entity_id
        , coa_segment_2_product_id
        , coa_segment_3_accounting_id
        , coa_segment_4_team_id
        , coa_segment_5_natural_account_id
        , coa_segment_6_initiative_id
        , coa_segment_7_intercompany_id
        , coa_segment_8_future_id
        , is_excluded
        , excluded_reason
        , _invoice_key
    from {{ ref(model) }}
    {%- if not loop.last %} union all {% endif -%}
{% endfor %}
