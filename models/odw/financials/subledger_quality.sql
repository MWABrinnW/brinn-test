{{ config(
  enabled=false
) }}

{% set columns = ['SYSTEM_KEY','INVOICE_NUMBER_SOURCE'] %}
{{ describe_billing_model(model=ref('subledger'), where_clause=none, date_partition='revenue_month_end_date', exclude_columns=columns) }}
