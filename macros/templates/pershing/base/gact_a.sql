{%- macro gact_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 31, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 35, 9), '000000000'))::varchar(9) as underlying_cusip
-- , trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as not_used_2
, trim(nullif(substring(content, 48, 16), '0000000000000000'))::varchar(16) as security_symbol
, trim(nullif(substring(content, 64, 3), '000'))::varchar(3) as investment_professional_of_record
, trim(nullif(substring(content, 67, 3), '000'))::varchar(3) as executing_investment_professional
, trim(nullif(substring(content, 70, 1), '0'))::varchar(1) as transaction_type
, trim(nullif(substring(content, 71, 1), '0'))::varchar(1) as buysell_code
, trim(nullif(substring(content, 72, 1), '0'))::varchar(1) as openclose_indicator
, trim(nullif(substring(content, 73, 2), '00'))::varchar(2) as par_key_code
, trim(nullif(substring(content, 75, 3), '000'))::varchar(3) as source_code
, nullif(nullif(trim(substring(content, 78, 4)), '0000'), '')::int as maxx_key_code
, try_to_date(nullif(substring(content, 82, 8), '00000000'), 'YYYYMMDD')::date as process_date
, try_to_date(nullif(substring(content, 90, 8), '00000000'), 'YYYYMMDD')::date as trade_date
, try_to_date(nullif(substring(content, 98, 8), '00000000'), 'YYYYMMDD')::date as settlemententry_date
, nullif(nullif(trim(substring(content, 106, 7)), '0000000'), '')::int as for_pershing_internal_use_only
, trim(nullif(substring(content, 113, 2), '00'))::varchar(2) as source_of_input
, trim(nullif(substring(content, 115, 6), '000000'))::varchar(6) as reference_number
, trim(nullif(substring(content, 121, 5), '00000'))::varchar(5) as batch_code
, trim(nullif(substring(content, 126, 1), '0'))::varchar(1) as same_day_settlement
, trim(nullif(substring(content, 127, 10), '0000000000'))::varchar(10) as contra_account
, trim(nullif(substring(content, 137, 1), '0'))::varchar(1) as market_code
, trim(nullif(substring(content, 138, 1), '0'))::varchar(1) as blotter_code
, trim(nullif(substring(content, 139, 1), '0'))::varchar(1) as cancel_code
, trim(nullif(substring(content, 140, 1), '0'))::varchar(1) as correction_code
, trim(nullif(substring(content, 141, 1), '0'))::varchar(1) as marketlimit_indicator_trades_only
, trim(nullif(substring(content, 142, 1), '0'))::varchar(1) as legend_code_1
, trim(nullif(substring(content, 143, 1), '0'))::varchar(1) as legend_code_2
, trim(nullif(substring(content, 144, 2), '00'))::varchar(2) as for_pershing_internal_use_only_2
, iff(substring(content, 164, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 146, 18)), '000000000000000000'), '')) / power(10, 05)::number as quantity
, trim(nullif(substring(content, 164, 1), '0'))::varchar(1) as quantity_sign
, to_number(nullif(nullif(trim(substring(content, 165, 18)), '000000000000000000'), '')) / power(10, 09)::number as price_in_settlement_currency
-- , iff(substring(content, 188, 1) = '-', -1, 1) * trim(nullif(substring(content, 183, 5), '00000'))::varchar(5) as not_used_3
, trim(nullif(substring(content, 188, 1), '0'))::varchar(1) as price_in_settlement_currency_sign
, trim(nullif(substring(content, 189, 3), '000'))::varchar(3) as currency_indicator_for_price
, iff(substring(content, 210, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 192, 18)), '000000000000000000'), '')) / power(10, 03)::number as net_amount_of_transaction_in_usd_or_usde
, trim(nullif(substring(content, 210, 1), '0'))::varchar(1) as net_amount_in_usd_or_usde_sign
, iff(substring(content, 229, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 211, 18)), '000000000000000000'), '')) / power(10, 03)::number as principal_in_usd_or_usde
, trim(nullif(substring(content, 229, 1), '0'))::varchar(1) as principal_in_usd_or_usde_sign
, iff(substring(content, 248, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 230, 18)), '000000000000000000'), '')) / power(10, 02)::number as interest_in_usd_or_usde
, trim(nullif(substring(content, 248, 1), '0'))::varchar(1) as interest_in_usd_or_usde_sign
, iff(substring(content, 267, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 249, 18)), '000000000000000000'), '')) / power(10, 02)::number as commission_in_usd_or_usde
, trim(nullif(substring(content, 267, 1), '0'))::varchar(1) as commission_in_usd_or_usde_sign
, iff(substring(content, 286, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 268, 18)), '000000000000000000'), '')) / power(10, 02)::number as tax_in_usd_or_usde
, trim(nullif(substring(content, 286, 1), '0'))::varchar(1) as tax_in_usd_or_usde_sign
, iff(substring(content, 305, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 287, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_fee_in_usd_or_usde
, trim(nullif(substring(content, 305, 1), '0'))::varchar(1) as transaction_fee_in_usd_or_usde_sign
, iff(substring(content, 324, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 306, 18)), '000000000000000000'), '')) / power(10, 02)::number as misc_fee_in_usd_or_usde
, trim(nullif(substring(content, 324, 1), '0'))::varchar(1) as misc_fee_in_usd_or_usde_sign
, iff(substring(content, 343, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 325, 18)), '000000000000000000'), '')) / power(10, 02)::number as other_fee_in_usd_or_usde
, trim(nullif(substring(content, 343, 1), '0'))::varchar(1) as other_fee_in_usd_or_usde_sign
, iff(substring(content, 362, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 344, 18)), '000000000000000000'), '')) / power(10, 02)::number as tefra_withholding_amount_in_usd
, trim(nullif(substring(content, 362, 1), '0'))::varchar(1) as tefra_withholding_amount_in_usd_sign
, iff(substring(content, 381, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 363, 18)), '000000000000000000'), '')) / power(10, 02)::number as pershing_charge_in_usd
, trim(nullif(substring(content, 381, 1), '0'))::varchar(1) as pershing_charge_in_usd_sign
, iff(substring(content, 400, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 382, 18)), '000000000000000000'), '')) / power(10, 02)::number as brokerage_charge_in_usd
, trim(nullif(substring(content, 400, 1), '0'))::varchar(1) as brokerage_charge_in_usd_sign
, iff(substring(content, 419, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 401, 18)), '000000000000000000'), '')) / power(10, 02)::number as sales_credit_in_usd_or_usde
, trim(nullif(substring(content, 419, 1), '0'))::varchar(1) as sales_credit_in_usd_or_usde_sign
, iff(substring(content, 438, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 420, 18)), '000000000000000000'), '')) / power(10, 02)::number as settlement_fee_in_usd_or_usde
, trim(nullif(substring(content, 438, 1), '0'))::varchar(1) as settlement_fee_in_usd_or_usde_sign
, iff(substring(content, 457, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 439, 18)), '000000000000000000'), '')) / power(10, 02)::number as service_charge_in_usd_or_usde
, trim(nullif(substring(content, 457, 1), '0'))::varchar(1) as service_charge_in_usd_or_usde_sign
, iff(substring(content, 476, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 458, 18)), '000000000000000000'), '')) / power(10, 02)::number as markupmarkdown_amount_in_usd_or_usde
, trim(nullif(substring(content, 476, 1), '0'))::varchar(1) as markupdown_amount_in_usd_or_usde_sign
, trim(nullif(substring(content, 477, 1), '0'))::varchar(1) as for_internal_use_only
, try_to_date(nullif(substring(content, 478, 8), '00000000'), 'YYYYMMDD')::date as dividend_payable_date
, trim(nullif(substring(content, 486, 1), '0'))::varchar(1) as for_internal_use_only_2
, try_to_date(nullif(substring(content, 487, 8), '00000000'), 'YYYYMMDD')::date as dividend_record_date
, nullif(nullif(trim(substring(content, 495, 1)), '0'), '')::int as dividend_type
-- , trim(nullif(substring(content, 496, 1), '0'))::varchar(1) as not_used_4
, to_number(nullif(nullif(trim(substring(content, 497, 18)), '000000000000000000'), '')) / power(10, 05)::number as shares_of_record_quantity_for_dividends
, to_number(nullif(nullif(trim(substring(content, 515, 18)), '000000000000000000'), '')) / power(10, 05)::number as order_size_quantity
-- , trim(nullif(substring(content, 533, 1), '0'))::varchar(1) as not_used_5
, to_number(nullif(nullif(trim(substring(content, 534, 18)), '000000000000000000'), '')) / power(10, 09)::number as pool_factor
, trim(nullif(substring(content, 552, 10), '0000000000'))::varchar(10) as parsed_customer_account_number_associated_with_firm
, trim(nullif(substring(content, 562, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 565, 1), '0'))::varchar(1) as security_type_code
, trim(nullif(substring(content, 566, 1), '0'))::varchar(1) as security_modifier_code
, trim(nullif(substring(content, 567, 1), '0'))::varchar(1) as security_calculation_code
, trim(nullif(substring(content, 568, 3), '000'))::varchar(3) as minor_product_code
, trim(nullif(substring(content, 571, 1), '0'))::varchar(1) as foreign_product_indicator
, trim(nullif(substring(content, 572, 1), '0'))::varchar(1) as with_due_bill_indicator
, trim(nullif(substring(content, 573, 1), '0'))::varchar(1) as taxable_municipal_bond_indicator
, trim(nullif(substring(content, 574, 1), '0'))::varchar(1) as omnibus_indicator
, trim(nullif(substring(content, 575, 20), '00000000000000000000'))::varchar(20) as external_order_id
-- , trim(nullif(substring(content, 595, 3), '000'))::varchar(3) as not_used_6
, to_number(nullif(nullif(trim(substring(content, 598, 18)), '000000000000000000'), '')) / power(10, 02)::number as market_value_of_transaction
, trim(nullif(substring(content, 616, 3), '000'))::varchar(3) as ip_number_parsed_from_gmar_description_for_firm_account
, iff(substring(content, 637, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 619, 18)), '000000000000000000'), '')) / power(10, 09)::number as reported_price
, trim(nullif(substring(content, 637, 1), '0'))::varchar(1) as reported_price_sign
, to_number(nullif(nullif(trim(substring(content, 638, 18)), '000000000000000000'), '')) / power(10, 02)::number as previous_day_market_value_of_transaction
, to_number(nullif(nullif(trim(substring(content, 656, 18)), '000000000000000000'), '')) / power(10, 09)::number as price_in_usde
, trim(nullif(substring(content, 674, 6), '000000'))::varchar(6) as option_root_id
, try_to_date(nullif(substring(content, 680, 6), '000000'), 'YYMMDD')::date as expiration_date
, trim(nullif(substring(content, 686, 1), '0'))::varchar(1) as putcall_code
, to_number(nullif(nullif(trim(substring(content, 687, 8)), '00000000'), '')) / power(10, 03)::number as strike_price
, trim(nullif(substring(content, 695, 1), '0'))::varchar(1) as repo_identifier
, trim(nullif(substring(content, 696, 1), '0'))::varchar(1) as taxable
, trim(nullif(substring(content, 697, 1), '0'))::varchar(1) as qualified
-- , trim(nullif(substring(content, 698, 32), '00000000000000000000000000000000'))::varchar(32) as not_used_7
, trim(nullif(substring(content, 730, 12), '000000000000'))::varchar(12) as for_pershing_internal_use_only_3
-- , trim(nullif(substring(content, 742, 8), '00000000'))::varchar(8) as reserved
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
