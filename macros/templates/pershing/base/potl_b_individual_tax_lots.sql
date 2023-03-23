{%- macro potl_b_individual_tax_lots(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as pershing_account_number
, trim(nullif(substring(content, 21, 1), '0'))::varchar(1) as portfolio_account_type
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 31, 4), '0000'))::varchar(4) as reserved_for_future_use
, trim(nullif(substring(content, 35, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 38, 1), '0'))::varchar(1) as reserved_for_future_use_2
, trim(nullif(substring(content, 39, 3), '000'))::varchar(3) as investment_professional_ip_number
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as reserved_for_future_use_3
, try_to_date(nullif(substring(content, 43, 8), '00000000'), 'YYYYMMDD')::date as process_date
, trim(nullif(substring(content, 51, 12), '000000000000'))::varchar(12) as record_id
, try_to_date(nullif(substring(content, 63, 8), '00000000'), 'YYYYMMDD')::date as trade_date
, try_to_date(nullif(substring(content, 71, 8), '00000000'), 'YYYYMMDD')::date as settlement_date
, iff(substring(content, 97, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 79, 18)), '000000000000000000'), '')) / power(10, 05)::number as quantity
, trim(nullif(substring(content, 97, 1), '0'))::varchar(1) as quantity_sign
, iff(substring(content, 116, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 98, 18)), '000000000000000000'), '')) / power(10, 09)::number as current_total_cost_on_lot_level
, trim(nullif(substring(content, 116, 1), '0'))::varchar(1) as current_cost_on_lot_level_sign
-- , trim(nullif(substring(content, 117, 19), '0000000000000000000'))::varchar(19) as not_used
, iff(substring(content, 154, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 136, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_adjusted_cost
, trim(nullif(substring(content, 154, 1), '0'))::varchar(1) as original_adjusted_cost_sign
, iff(substring(content, 173, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 155, 18)), '000000000000000000'), '')) / power(10, 09)::number as bond_rate
, trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as bond_rate_sign
, try_to_date(nullif(substring(content, 174, 8), '00000000'), 'YYYYMMDD')::date as adjusted_trade_date
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as missing_cost_basis_code
, iff(substring(content, 201, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 183, 18)), '000000000000000000'), '')) / power(10, 02)::number as commissionsales_credit
, trim(nullif(substring(content, 201, 1), '0'))::varchar(1) as commissionsales_credit_sign
, iff(substring(content, 220, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 202, 18)), '000000000000000000'), '')) / power(10, 02)::number as fees
, trim(nullif(substring(content, 220, 1), '0'))::varchar(1) as fees_sign
, trim(nullif(substring(content, 221, 1), '0'))::varchar(1) as lot_status
, trim(nullif(substring(content, 222, 1), '0'))::varchar(1) as coverednoncovered
, trim(nullif(substring(content, 223, 5), '00000'))::varchar(5) as contra_firm_number
, trim(nullif(substring(content, 228, 30), '000000000000000000000000000000'))::varchar(30) as matching_external_reference
, to_number(nullif(nullif(trim(substring(content, 258, 18)), '000000000000000000'), '')) / power(10, 02)::number as average_unit_cost
, try_to_date(nullif(substring(content, 276, 8), '00000000'), 'YYYYMMDD')::date as date_of_death
, try_to_date(nullif(substring(content, 284, 8), '00000000'), 'YYYYMMDD')::date as date_of_gift
, iff(substring(content, 310, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 292, 18)), '000000000000000000'), '')) / power(10, 02)::number as gift_fair_market_value_fmv
, trim(nullif(substring(content, 310, 1), '0'))::varchar(1) as gift_fair_market_value_sign
, iff(substring(content, 329, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 311, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_cost
, trim(nullif(substring(content, 329, 1), '0'))::varchar(1) as original_cost_sign
, trim(nullif(substring(content, 330, 5), '00000'))::varchar(5) as portfolio_transaction_code
, iff(substring(content, 353, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 335, 18)), '000000000000000000'), '')) / power(10, 05)::number as original_quantity
, trim(nullif(substring(content, 353, 1), '0'))::varchar(1) as original_quantity_sign
, to_number(nullif(nullif(trim(substring(content, 354, 18)), '000000000000000000'), '')) / power(10, 07)::number as expanded_average_unit_cost
, trim(nullif(substring(content, 372, 2), '00'))::varchar(2) as bond_election_method
, to_number(nullif(nullif(trim(substring(content, 374, 18)), '000000000000000000'), '')) / power(10, 02)::number as deferred_income
, iff(substring(content, 410, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 392, 18)), '000000000000000000'), '')) / power(10, 02)::number as yeartodate_reportable_income_adjustment
, trim(nullif(substring(content, 410, 1), '0'))::varchar(1) as yeartodate_reportable_income_adjustment_sign
, to_number(nullif(nullif(trim(substring(content, 411, 18)), '000000000000000000'), '')) / power(10, 02)::number as unused_amortization
, to_number(nullif(nullif(trim(substring(content, 429, 18)), '000000000000000000'), '')) / power(10, 02)::number as acquisition_premium_amount
, to_number(nullif(nullif(trim(substring(content, 447, 18)), '000000000000000000'), '')) / power(10, 02)::number as accrued_original_issue_discount_oid_amount
, trim(nullif(substring(content, 465, 4), '0000'))::varchar(4) as booking_entity
, trim(nullif(substring(content, 469, 4), '0000'))::varchar(4) as booking_entity_business_code
-- , trim(nullif(substring(content, 473, 10), '0000000000'))::varchar(10) as not_used_2
, trim(nullif(substring(content, 483, 9), '000000000'))::varchar(9) as reserved_for_introducing_firm
, try_to_date(nullif(substring(content, 492, 8), '00000000'), 'YYYYMMDD')::date as date_of_data
, trim(nullif(substring(content, 500, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'B'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
