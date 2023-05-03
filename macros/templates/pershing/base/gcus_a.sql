{%- macro gcus_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 31, 3), '000'))::varchar(3) as portfolio_currency
-- , trim(nullif(substring(content, 34, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 35, 9), '000000000'))::varchar(9) as underlying_cusip_number
, trim(nullif(substring(content, 44, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 46, 2), '00'))::varchar(2) as not_used_2
, trim(nullif(substring(content, 48, 3), '000'))::varchar(3) as investment_professional_ip_of_record_number
, trim(nullif(substring(content, 51, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 54, 1), '0'))::varchar(1) as currencysecurity_indicator
, trim(nullif(substring(content, 55, 3), '000'))::varchar(3) as issue_currency
, try_to_date(nullif(substring(content, 58, 8), '00000000'), 'YYYYMMDD')::date as date_stamptrade_date
, try_to_date(nullif(substring(content, 66, 8), '00000000'), 'YYYYMMDD')::date as date_stampsettlement_date
, iff(substring(content, 92, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 74, 18)), '000000000000000000'), '')) / power(10, 05)::number as trade_date_quantity
, trim(nullif(substring(content, 92, 1), '0'))::varchar(1) as trade_date_quantity_sign
, iff(substring(content, 111, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 93, 18)), '000000000000000000'), '')) / power(10, 05)::number as settlement_date_quantity
, trim(nullif(substring(content, 111, 1), '0'))::varchar(1) as settlement_date_quantity_sign
, iff(substring(content, 130, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 112, 18)), '000000000000000000'), '')) / power(10, 05)::number as seg_quantity_memo
, trim(nullif(substring(content, 130, 1), '0'))::varchar(1) as seg_quantity_sign
, iff(substring(content, 149, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 131, 18)), '000000000000000000'), '')) / power(10, 05)::number as safekeeping_quantity_memo
, trim(nullif(substring(content, 149, 1), '0'))::varchar(1) as safekeeping_quantity_sign
, iff(substring(content, 168, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 150, 18)), '000000000000000000'), '')) / power(10, 05)::number as transfer_quantity_memo
, trim(nullif(substring(content, 168, 1), '0'))::varchar(1) as transfer_quantity_sign
, iff(substring(content, 187, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 169, 18)), '000000000000000000'), '')) / power(10, 05)::number as pending_transfer_quantity
, trim(nullif(substring(content, 187, 1), '0'))::varchar(1) as pending_transfer_quantity_sign
, iff(substring(content, 206, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 188, 18)), '000000000000000000'), '')) / power(10, 05)::number as legal_transfer_quantity
, trim(nullif(substring(content, 206, 1), '0'))::varchar(1) as legal_transfer_quantity_sign
, iff(substring(content, 225, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 207, 18)), '000000000000000000'), '')) / power(10, 05)::number as tendered_reorg_quantity_memo
, trim(nullif(substring(content, 225, 1), '0'))::varchar(1) as tendered_quantity_sign
, iff(substring(content, 244, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 226, 18)), '000000000000000000'), '')) / power(10, 05)::number as pending_papers_memo
, trim(nullif(substring(content, 244, 1), '0'))::varchar(1) as pending_papers_sign
, iff(substring(content, 263, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 245, 18)), '000000000000000000'), '')) / power(10, 05)::number as short_against_the_box_quantity_memo
, trim(nullif(substring(content, 263, 1), '0'))::varchar(1) as short_against_the_box_quantity_sign
, iff(substring(content, 282, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 264, 18)), '000000000000000000'), '')) / power(10, 05)::number as networked_quantity_memo
, trim(nullif(substring(content, 282, 1), '0'))::varchar(1) as networked_quantity_sign
, iff(substring(content, 301, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 283, 18)), '000000000000000000'), '')) / power(10, 05)::number as pending_split_quantity_memo
, trim(nullif(substring(content, 301, 1), '0'))::varchar(1) as pending_split_quantity_sign
, iff(substring(content, 320, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 302, 18)), '000000000000000000'), '')) / power(10, 05)::number as quantity_covering_options_or_covered_quantity
, trim(nullif(substring(content, 320, 1), '0'))::varchar(1) as quantity_covering_options_or_covered_quantity_sign
, iff(substring(content, 339, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 321, 18)), '000000000000000000'), '')) / power(10, 05)::number as trade_date_quantity_bought
, trim(nullif(substring(content, 339, 1), '0'))::varchar(1) as trade_date_quantity_bought_sign
, iff(substring(content, 358, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 340, 18)), '000000000000000000'), '')) / power(10, 05)::number as trade_date_quantity_sold
, trim(nullif(substring(content, 358, 1), '0'))::varchar(1) as trade_date_quantity_sold_sign
, iff(substring(content, 377, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 359, 18)), '000000000000000000'), '')) / power(10, 02)::number as fed_reg_t_requirement
, trim(nullif(substring(content, 377, 1), '0'))::varchar(1) as fed_requirement_sign
, iff(substring(content, 396, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 378, 18)), '000000000000000000'), '')) / power(10, 02)::number as house_pershing_margin_requirement
, trim(nullif(substring(content, 396, 1), '0'))::varchar(1) as house_margin_requirement_sign
, iff(substring(content, 415, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 397, 18)), '000000000000000000'), '')) / power(10, 02)::number as exchange_nyse_requirement
, trim(nullif(substring(content, 415, 1), '0'))::varchar(1) as exchange_requirement_sign
, iff(substring(content, 434, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 416, 18)), '000000000000000000'), '')) / power(10, 02)::number as equity_requirement
, trim(nullif(substring(content, 434, 1), '0'))::varchar(1) as equity_requirement_sign
, trim(nullif(substring(content, 435, 9), '000000000'))::varchar(9) as security_symbol
, trim(nullif(substring(content, 444, 1), '0'))::varchar(1) as security_type
, trim(nullif(substring(content, 445, 1), '0'))::varchar(1) as security_modifier
, trim(nullif(substring(content, 446, 1), '0'))::varchar(1) as security_calculation
, trim(nullif(substring(content, 447, 3), '000'))::varchar(3) as minor_product_code
, trim(nullif(substring(content, 450, 1), '0'))::varchar(1) as network_eligibility_indicator
, iff(substring(content, 469, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 451, 18)), '000000000000000000'), '')) / power(10, 09)::number as strike_price
, trim(nullif(substring(content, 469, 1), '0'))::varchar(1) as strike_price_sign
, try_to_date(nullif(substring(content, 470, 8), '00000000'), 'YYYYMMDD')::date as expirationmaturity_date
, to_number(nullif(nullif(trim(substring(content, 478, 18)), '000000000000000000'), '')) / power(10, 05)::number as contract_size
, to_number(nullif(nullif(trim(substring(content, 496, 18)), '000000000000000000'), '')) / power(10, 09)::number as conversion_ratio
, trim(nullif(substring(content, 514, 10), '0000000000'))::varchar(10) as account_short_name
, trim(nullif(substring(content, 524, 3), '000'))::varchar(3) as state_code
, trim(nullif(substring(content, 527, 3), '000'))::varchar(3) as country_code_2
, trim(nullif(substring(content, 530, 4), '0000'))::varchar(4) as for_pershing_internal_use
, nullif(nullif(trim(substring(content, 534, 4)), '0000'), '')::int as number_of_security_description_lines
, trim(nullif(substring(content, 538, 20), '00000000000000000000'))::varchar(20) as security_description_line_1
, trim(nullif(substring(content, 558, 20), '00000000000000000000'))::varchar(20) as security_description_line_2
, trim(nullif(substring(content, 578, 20), '00000000000000000000'))::varchar(20) as security_description_line_3
, trim(nullif(substring(content, 598, 20), '00000000000000000000'))::varchar(20) as security_description_line_4
, trim(nullif(substring(content, 618, 20), '00000000000000000000'))::varchar(20) as security_description_line_5
, trim(nullif(substring(content, 638, 20), '00000000000000000000'))::varchar(20) as security_description_line_6
, trim(nullif(substring(content, 658, 1), '0'))::varchar(1) as dividend_option
, trim(nullif(substring(content, 659, 1), '0'))::varchar(1) as long_term_capital_gains_option
, trim(nullif(substring(content, 660, 1), '0'))::varchar(1) as short_term_capital_gains_option
, trim(nullif(substring(content, 661, 1), '0'))::varchar(1) as firm_trading_indicator
, trim(nullif(substring(content, 662, 3), '000'))::varchar(3) as position_currency
, iff(substring(content, 683, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 665, 18)), '000000000000000000'), '')) / power(10, 03)::number as trade_date_liquidating_value
, trim(nullif(substring(content, 683, 1), '0'))::varchar(1) as trade_date_liquidating_value_sign
, iff(substring(content, 694, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 684, 10)), '0000000000'), '')) / power(10, 08)::number as pool_factor
, trim(nullif(substring(content, 694, 1), '0'))::varchar(1) as pool_factor_sign
, iff(substring(content, 713, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 695, 18)), '000000000000000000'), '')) / power(10, 10)::number as exchange_rate
, trim(nullif(substring(content, 713, 1), '0'))::varchar(1) as exchange_rate_sign
, iff(substring(content, 732, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 714, 18)), '000000000000000000'), '')) / power(10, 03)::number as settlement_date_liquidating_value
, trim(nullif(substring(content, 732, 1), '0'))::varchar(1) as settlement_date_liquidating_value_sign
, trim(nullif(substring(content, 733, 3), '000'))::varchar(3) as for_internal_pershing_use_display_currency
, trim(nullif(substring(content, 736, 1), '0'))::varchar(1) as alternate_security_id_type
, trim(nullif(substring(content, 737, 12), '000000000000'))::varchar(12) as alternate_security_id
, trim(nullif(substring(content, 749, 1), '0'))::varchar(1) as for_pershing_internal_use_only
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
