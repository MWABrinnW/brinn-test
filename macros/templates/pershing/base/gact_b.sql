{%- macro gact_b(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 22, 3), '000'))::varchar(3) as security_currency_of_issuance
, trim(nullif(substring(content, 25, 3), '000'))::varchar(3) as trade_currency_code
, trim(nullif(substring(content, 28, 3), '000'))::varchar(3) as settlement_currency_code
, to_number(nullif(nullif(trim(substring(content, 31, 18)), '000000000000000000'), '')) / power(10, 09)::number as settlementusd_currency_fx_rate
, trim(nullif(substring(content, 49, 1), '0'))::varchar(1) as settlementusd_multiplydivide_code
, to_number(nullif(nullif(trim(substring(content, 50, 18)), '000000000000000000'), '')) / power(10, 09)::number as cross_currency_fx_rate
, trim(nullif(substring(content, 68, 1), '0'))::varchar(1) as currency_multiplydivide_code
, iff(substring(content, 87, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 69, 18)), '000000000000000000'), '')) / power(10, 02)::number as accrued_interest_in_settlement_currency
, trim(nullif(substring(content, 87, 1), '0'))::varchar(1) as accrued_interest_in_settlement_currency_sign
, trim(nullif(substring(content, 88, 12), '000000000000'))::varchar(12) as market_code
, trim(nullif(substring(content, 100, 20), '00000000000000000000'))::varchar(20) as internal_reference_for_gloss
, trim(nullif(substring(content, 120, 2), '00'))::varchar(2) as introducing_broker_dealer_ibd_version
, iff(substring(content, 140, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 122, 18)), '000000000000000000'), '')) / power(10, 02)::number as net_amount_in_settlement_currency
, trim(nullif(substring(content, 140, 1), '0'))::varchar(1) as net_amount_in_settlement_currency_sign
, iff(substring(content, 159, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 141, 18)), '000000000000000000'), '')) / power(10, 02)::number as principal_amount_in_settlement_currency
, trim(nullif(substring(content, 159, 1), '0'))::varchar(1) as principal_amount_in_settlement_currency_sign
, iff(substring(content, 178, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 160, 18)), '000000000000000000'), '')) / power(10, 02)::number as interest_in_settlement_currency
, trim(nullif(substring(content, 178, 1), '0'))::varchar(1) as interest_in_settlement_currency_sign
, iff(substring(content, 197, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 179, 18)), '000000000000000000'), '')) / power(10, 02)::number as commission_in_settlement_currency
, trim(nullif(substring(content, 197, 1), '0'))::varchar(1) as commission_in_settlement_currency_sign
, iff(substring(content, 216, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 198, 18)), '000000000000000000'), '')) / power(10, 02)::number as tax_in_settlement_currency
, trim(nullif(substring(content, 216, 1), '0'))::varchar(1) as tax_in_settlement_currency_sign
, iff(substring(content, 235, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 217, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_fee_in_settlement_currency
, trim(nullif(substring(content, 235, 1), '0'))::varchar(1) as transaction_fee_in_settlement_currency_sign
, iff(substring(content, 254, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 236, 18)), '000000000000000000'), '')) / power(10, 02)::number as miscellaneous_fee_in_settlement_currency
, trim(nullif(substring(content, 254, 1), '0'))::varchar(1) as miscellaneous_fee_in_settlement_currency_sign
, iff(substring(content, 273, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 255, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_fee_in_settlement_currency
, trim(nullif(substring(content, 273, 1), '0'))::varchar(1) as other_fee_in_settle_currency_sign
, iff(substring(content, 292, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 274, 18)), '000000000000000000'), '')) / power(10, 02)::number as sales_credit_in_settlement_currency
, trim(nullif(substring(content, 292, 1), '0'))::varchar(1) as sales_credit_in_settlement_currency_sign
, iff(substring(content, 311, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 293, 18)), '000000000000000000'), '')) / power(10, 02)::number as settlement_fee_in_settlement_currency
, trim(nullif(substring(content, 311, 1), '0'))::varchar(1) as settlement_fee_in_settlement_currency_sign
, iff(substring(content, 330, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 312, 18)), '000000000000000000'), '')) / power(10, 02)::number as service_charge_in_settlement_currency
, trim(nullif(substring(content, 330, 1), '0'))::varchar(1) as service_charge_in_settlement_currency_sign
, iff(substring(content, 349, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 331, 18)), '000000000000000000'), '')) / power(10, 02)::number as markupmarkdown_in_settlement_currency
, trim(nullif(substring(content, 349, 1), '0'))::varchar(1) as markupmarkdown_in_settlement_currency_sign
, trim(nullif(substring(content, 350, 4), '0000'))::varchar(4) as global_exchange
, nullif(nullif(trim(substring(content, 354, 2)), '00'), '')::int as number_of_description_lines
, nullif(nullif(trim(substring(content, 356, 2)), '00'), '')::int as last_description_line
, trim(nullif(substring(content, 358, 20), '00000000000000000000'))::varchar(20) as description_line_1
, trim(nullif(substring(content, 378, 20), '00000000000000000000'))::varchar(20) as description_line_2
, trim(nullif(substring(content, 398, 20), '00000000000000000000'))::varchar(20) as description_line_3
, trim(nullif(substring(content, 418, 20), '00000000000000000000'))::varchar(20) as description_line_4
, trim(nullif(substring(content, 438, 20), '00000000000000000000'))::varchar(20) as description_line_5
, trim(nullif(substring(content, 458, 20), '00000000000000000000'))::varchar(20) as description_line_6
, trim(nullif(substring(content, 478, 20), '00000000000000000000'))::varchar(20) as description_line_7
, trim(nullif(substring(content, 498, 20), '00000000000000000000'))::varchar(20) as description_line_8
, trim(nullif(substring(content, 518, 20), '00000000000000000000'))::varchar(20) as description_line_9
, trim(nullif(substring(content, 538, 20), '00000000000000000000'))::varchar(20) as description_line_10
, trim(nullif(substring(content, 558, 20), '00000000000000000000'))::varchar(20) as description_line_11
, trim(nullif(substring(content, 578, 20), '00000000000000000000'))::varchar(20) as description_line_12
, trim(nullif(substring(content, 598, 1), '0'))::varchar(1) as securitycurrency_indicator
, trim(nullif(substring(content, 599, 4), '0000'))::varchar(4) as market_mnemonic_code
, to_number(nullif(nullif(trim(substring(content, 603, 18)), '000000000000000000'), '')) / power(10, 09)::number as currency_of_issuance__usd_currency_fx_rate
, trim(nullif(substring(content, 621, 1), '0'))::varchar(1) as currency_of_issuance__usd_multiplydivide_code
, trim(nullif(substring(content, 622, 1), '0'))::varchar(1) as alternate_security_id_type_1
, trim(nullif(substring(content, 623, 12), '000000000000'))::varchar(12) as alternate_security_id_1
, trim(nullif(substring(content, 635, 1), '0'))::varchar(1) as reserved_for_alternate_security_id_type_2
, trim(nullif(substring(content, 636, 12), '000000000000'))::varchar(12) as reserved_for_alternate_security_id_2
, trim(nullif(substring(content, 648, 16), '0000000000000000'))::varchar(16) as international_nondollar_symbol
, trim(nullif(substring(content, 664, 2), '00'))::varchar(2) as confirmation_code_one
, trim(nullif(substring(content, 666, 2), '00'))::varchar(2) as confirmation_code_two
, trim(nullif(substring(content, 668, 2), '00'))::varchar(2) as confirmation_code_three
, trim(nullif(substring(content, 670, 2), '00'))::varchar(2) as confirmation_code_four
, to_number(nullif(nullif(trim(substring(content, 672, 18)), '000000000000000000'), '')) / power(10, 09)::number as prevailing_market_price_pmp
, iff(substring(content, 708, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 690, 18)), '000000000000000000'), '')) / power(10, 02)::number as total_amount_of_mark_updown
, trim(nullif(substring(content, 708, 1), '0'))::varchar(1) as total_amount_of_mark_updown_sign
, to_number(nullif(nullif(trim(substring(content, 709, 9)), '000000000'), '')) / power(10, 05)::number as pmp_percent
-- , trim(nullif(substring(content, 718, 32), '00000000000000000000000000000000'))::varchar(32) as not_used
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
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
