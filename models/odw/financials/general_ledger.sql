{{ config(
  enabled=false
) }}

select
    revenue_month_end_date                           as effective_date_of_transaction
    , 'snowflake'                                    as journal_source
    , system_key                                     as journal_category
    , coa_segment_1_legal_entity_id                  as coa_segment_1_legal_entity_id
    , coa_segment_2_product_id                       as coa_segment_2_product_id
    , coa_segment_3_accounting_id                    as coa_segment_3_accounting_id
    , coa_segment_4_team_id                          as coa_segment_4_team_id
    , coa_segment_5_natural_account_id
        as coa_segment_5_natural_account_id
    , coa_segment_6_initiative_id                    as coa_segment_6_initiative_id
    , coa_segment_7_intercompany_id                  as coa_segment_7_intercompany_id
    , coa_segment_8_future_id                        as coa_segment_8_future_id
    , sum(client_fee_net_allocation)::number(18 , 2) as entered_debit_amount
    , null::number(18 , 2)                           as entered_credit_amount
    , null::number(18 , 2)                           as converted_debit_amount
    , null::number(18 , 2)                           as converted_credit_amount
from {{ ref('int_general_ledger') }}
group by all
order by
    effective_date_of_transaction desc
    , journal_source asc
    , journal_category asc
    , coa_segment_1_legal_entity_id asc
    , coa_segment_2_product_id asc
    , coa_segment_3_accounting_id asc
    , coa_segment_4_team_id asc
    , coa_segment_5_natural_account_id asc
    , coa_segment_6_initiative_id asc
    , coa_segment_7_intercompany_id asc
    , coa_segment_8_future_id asc
