{%- macro ptld_a(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_transfer_type
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as pershing_account_number
, trim(nullif(substring(content, 21, 1), '0'))::varchar(1) as portfolio_account_type
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 31, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 35, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 38, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 39, 3), '000'))::varchar(3) as investment_professional_ip_number
-- , trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as not_used_3
, try_to_date(nullif(substring(content, 43, 8), '00000000'), 'YYYYMMDD')::date as effective_date_of_the_transaction
, trim(nullif(substring(content, 51, 12), '000000000000'))::varchar(12) as record_id_of_the_closing_transaction
, try_to_date(nullif(substring(content, 63, 8), '00000000'), 'YYYYMMDD')::date as date_of_the_gainloss
, try_to_date(nullif(substring(content, 71, 8), '00000000'), 'YYYYMMDD')::date as settlement_date
, trim(nullif(substring(content, 79, 5), '00000'))::varchar(5) as transaction_code_2
, trim(nullif(substring(content, 84, 2), '00'))::varchar(2) as disposition_method_at_time_of_disposal
-- , trim(nullif(substring(content, 86, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 87, 1), '0'))::varchar(1) as coverednoncovered
-- , trim(nullif(substring(content, 88, 1), '0'))::varchar(1) as not_used_5
, iff(substring(content, 107, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 89, 18)), '000000000000000000'), '')) / power(10, 05)::number as share_quantity
, trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as share_quantity_sign
, iff(substring(content, 126, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 108, 18)), '000000000000000000'), '')) / power(10, 02)::number as realized_gainloss
, trim(nullif(substring(content, 126, 1), '0'))::varchar(1) as realized_gainloss_sign
, iff(substring(content, 145, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 127, 18)), '000000000000000000'), '')) / power(10, 02)::number as proceeds_of_the_closing_transaction
, trim(nullif(substring(content, 145, 1), '0'))::varchar(1) as proceeds_of_the_closing_transaction_sign
, to_number(nullif(nullif(trim(substring(content, 146, 18)), '000000000000000000'), '')) / power(10, 09)::number as price
, iff(substring(content, 182, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 164, 18)), '000000000000000000'), '')) / power(10, 02)::number as commission
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as commission_sign
-- , trim(nullif(substring(content, 183, 76), '0000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(76) as not_used_6
, iff(substring(content, 277, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 259, 18)), '000000000000000000'), '')) / power(10, 02)::number as premium_paid_for_options
, trim(nullif(substring(content, 277, 1), '0'))::varchar(1) as premium_paid_for_options_sign
, iff(substring(content, 296, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 278, 18)), '000000000000000000'), '')) / power(10, 09)::number as buysell_interest
, trim(nullif(substring(content, 296, 1), '0'))::varchar(1) as buysell_interest_sign
-- , trim(nullif(substring(content, 297, 19), '0000000000000000000'))::varchar(19) as not_used_7
, try_to_date(nullif(substring(content, 316, 8), '00000000'), 'YYYYMMDD')::date as trade_date_of_the_closing_transaction
-- , trim(nullif(substring(content, 324, 12), '000000000000'))::varchar(12) as not_used_8
, try_to_date(nullif(substring(content, 336, 8), '00000000'), 'YYYYMMDD')::date as trade_date_of_the_original_transaction
, trim(nullif(substring(content, 344, 12), '000000000000'))::varchar(12) as record_id
, trim(nullif(substring(content, 356, 15), '000000000000000'))::varchar(15) as security_description_line_one
, trim(nullif(substring(content, 371, 15), '000000000000000'))::varchar(15) as security_description_line_two
, trim(nullif(substring(content, 386, 1), '0'))::varchar(1) as callput_indicator
, try_to_date(nullif(substring(content, 387, 8), '00000000'), 'YYYYMMDD')::date as expiration_date
, nullif(nullif(trim(substring(content, 395, 4)), '0000'), '')::int as contract_size
, to_number(nullif(nullif(trim(substring(content, 399, 18)), '000000000000000000'), '')) / power(10, 09)::number as strike_price
, iff(substring(content, 435, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 417, 18)), '000000000000000000'), '')) / power(10, 05)::number as original_quantity
, trim(nullif(substring(content, 435, 1), '0'))::varchar(1) as original_quantity_sign
, iff(substring(content, 454, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 436, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_total_cost
, trim(nullif(substring(content, 454, 1), '0'))::varchar(1) as original_total_cost_sign
, nullif(nullif(trim(substring(content, 455, 5)), '00000'), '')::int as contra_firm_number
, trim(nullif(substring(content, 460, 30), '000000000000000000000000000000'))::varchar(30) as matching_external_reference
, to_number(nullif(nullif(trim(substring(content, 490, 18)), '000000000000000000'), '')) / power(10, 02)::number as average_unit_cost
, iff(substring(content, 526, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 508, 18)), '000000000000000000'), '')) / power(10, 02)::number as disallowance
, trim(nullif(substring(content, 526, 1), '0'))::varchar(1) as disallowance_sign
, iff(substring(content, 545, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 527, 18)), '000000000000000000'), '')) / power(10, 02)::number as current_cost
, trim(nullif(substring(content, 545, 1), '0'))::varchar(1) as current_cost_sign
, try_to_date(nullif(substring(content, 546, 8), '00000000'), 'YYYYMMDD')::date as adjusted_trade_date
, try_to_date(nullif(substring(content, 554, 8), '00000000'), 'YYYYMMDD')::date as date_of_death
, try_to_date(nullif(substring(content, 562, 8), '00000000'), 'YYYYMMDD')::date as date_of_gift
, iff(substring(content, 588, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 570, 18)), '000000000000000000'), '')) / power(10, 02)::number as gift_fair_market_value_fmv
, trim(nullif(substring(content, 588, 1), '0'))::varchar(1) as gift_fair_market_value_sign
, iff(substring(content, 607, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 589, 18)), '000000000000000000'), '')) / power(10, 02)::number as original_prorated_cost
, trim(nullif(substring(content, 607, 1), '0'))::varchar(1) as original_prorated_cost_sign
, iff(substring(content, 626, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 608, 18)), '000000000000000000'), '')) / power(10, 02)::number as return_of_capital_adjustment_amount
, trim(nullif(substring(content, 626, 1), '0'))::varchar(1) as return_of_capital_adjustment_amount_sign
, trim(nullif(substring(content, 627, 5), '00000'))::varchar(5) as closing_transaction_source_code
, trim(nullif(substring(content, 632, 2), '00'))::varchar(2) as bond_election_method
, to_number(nullif(nullif(trim(substring(content, 634, 18)), '000000000000000000'), '')) / power(10, 02)::number as reportable_income_amount
, to_number(nullif(nullif(trim(substring(content, 652, 18)), '000000000000000000'), '')) / power(10, 02)::number as yeartodate_reportable_income_adjustment_amount
, trim(nullif(substring(content, 670, 1), '0'))::varchar(1) as yeartodate_reportable_income_adjustment_amount_2
, to_number(nullif(nullif(trim(substring(content, 671, 18)), '000000000000000000'), '')) / power(10, 02)::number as acquisition_premium_amount
, to_number(nullif(nullif(trim(substring(content, 689, 18)), '000000000000000000'), '')) / power(10, 02)::number as accrued_original_issue_discount_oid_amount
, trim(nullif(substring(content, 707, 4), '0000'))::varchar(4) as booking_entity
, trim(nullif(substring(content, 711, 4), '0000'))::varchar(4) as booking_entity_business_code
-- , trim(nullif(substring(content, 715, 18), '000000000000000000'))::varchar(18) as not_used_9
, trim(nullif(substring(content, 733, 9), '000000000'))::varchar(9) as reserved_for_introducing_firm
, try_to_date(nullif(substring(content, 742, 8), '00000000'), 'YYYYMMDD')::date as date_of_data
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
