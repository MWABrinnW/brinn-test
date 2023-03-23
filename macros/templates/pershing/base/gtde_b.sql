{%- macro gtde_b(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
-- , trim(nullif(substring(content, 22, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 23, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 26, 17), '00000000000000000'))::varchar(17) as not_used_2
, iff(substring(content, 61, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 43, 18)), '000000000000000000'), '')) / power(10, 05)::number as quantity
, trim(nullif(substring(content, 61, 1), '0'))::varchar(1) as quantity_sign
, to_number(nullif(nullif(trim(substring(content, 62, 18)), '000000000000000000'), '')) / power(10, 09)::number as price
, trim(nullif(substring(content, 80, 3), '000'))::varchar(3) as trade_currency
, trim(nullif(substring(content, 83, 1), '0'))::varchar(1) as basis_price_indicator
, iff(substring(content, 101, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 84, 17)), '00000000000000000'), '')) / power(10, 09)::number as yield
, trim(nullif(substring(content, 101, 1), '0'))::varchar(1) as yield_sign
, iff(substring(content, 119, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 102, 17)), '00000000000000000'), '')) / power(10, 09)::number as yield_to_worst
, trim(nullif(substring(content, 119, 1), '0'))::varchar(1) as yield_to_worst_sign
, trim(nullif(substring(content, 120, 2), '00'))::varchar(2) as yield_to_worst_code
, iff(substring(content, 140, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 122, 18)), '000000000000000000'), '')) / power(10, 02)::number as pershing_charge
, trim(nullif(substring(content, 140, 1), '0'))::varchar(1) as pershing_charge_sign
, iff(substring(content, 159, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 141, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_fee_sec_fee
, trim(nullif(substring(content, 159, 1), '0'))::varchar(1) as transaction_fee_sign
, iff(substring(content, 178, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 160, 18)), '000000000000000000'), '')) / power(10, 02)::number as rebate_amount
, trim(nullif(substring(content, 178, 1), '0'))::varchar(1) as rebate_amount_sign
, iff(substring(content, 197, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 179, 18)), '000000000000000000'), '')) / power(10, 02)::number as net_amount
, trim(nullif(substring(content, 197, 1), '0'))::varchar(1) as net_amount_sign
, trim(nullif(substring(content, 198, 3), '000'))::varchar(3) as settlement_currency
, to_number(nullif(nullif(trim(substring(content, 201, 18)), '000000000000000000'), '')) / power(10, 09)::number as settlement_currency_exchange_rate
, trim(nullif(substring(content, 219, 1), '0'))::varchar(1) as settlement_currency_multiplydivide_code
, iff(substring(content, 238, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 220, 18)), '000000000000000000'), '')) / power(10, 05)::number as accrued_interest_fixed_income_products_only
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as accrued_interest_sign
, iff(substring(content, 257, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 239, 18)), '000000000000000000'), '')) / power(10, 02)::number as service_charge_for_ibd
, trim(nullif(substring(content, 257, 1), '0'))::varchar(1) as service_charge_sign
, iff(substring(content, 276, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 258, 18)), '000000000000000000'), '')) / power(10, 02)::number as postage_sometimes_referred_to_as_confirm_fee
, trim(nullif(substring(content, 276, 1), '0'))::varchar(1) as postage_sign
, trim(nullif(substring(content, 277, 1), '0'))::varchar(1) as commissionsales_credit_type
, iff(substring(content, 296, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 278, 18)), '000000000000000000'), '')) / power(10, 02)::number as commission
, trim(nullif(substring(content, 296, 1), '0'))::varchar(1) as commission_sign
, to_number(nullif(nullif(trim(substring(content, 297, 7)), '0000000'), '')) / power(10, 04)::number as commission_percent_discount
-- , trim(nullif(substring(content, 304, 11), '00000000000'))::varchar(11) as not_used_3
, iff(substring(content, 333, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 315, 18)), '000000000000000000'), '')) / power(10, 02)::number as sales_credit
, trim(nullif(substring(content, 333, 1), '0'))::varchar(1) as sales_credit_sign
, iff(substring(content, 352, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 334, 18)), '000000000000000000'), '')) / power(10, 02)::number as contingent_deferred_sales_charge_cdsc
, trim(nullif(substring(content, 352, 1), '0'))::varchar(1) as cdsc_sign
, iff(substring(content, 371, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 353, 18)), '000000000000000000'), '')) / power(10, 02)::number as base_commission_this_is_what_the_commission_would_be_without_any
, trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as base_commission_sign
, iff(substring(content, 390, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 372, 18)), '000000000000000000'), '')) / power(10, 02)::number as equity_mark_upmark_down
, trim(nullif(substring(content, 390, 1), '0'))::varchar(1) as equity_mark_upmark_down_sign
, iff(substring(content, 409, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 391, 18)), '000000000000000000'), '')) / power(10, 02)::number as principal
, trim(nullif(substring(content, 409, 1), '0'))::varchar(1) as principal_sign
, iff(substring(content, 428, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 410, 18)), '000000000000000000'), '')) / power(10, 02)::number as execution_charge
, trim(nullif(substring(content, 428, 1), '0'))::varchar(1) as execution_charge_sign
, trim(nullif(substring(content, 429, 1), '0'))::varchar(1) as execution_only_indicator
, iff(substring(content, 448, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 430, 18)), '000000000000000000'), '')) / power(10, 02)::number as settlement_fee__customer_clearance_charge
, trim(nullif(substring(content, 448, 1), '0'))::varchar(1) as settlement_fee_sign
, trim(nullif(substring(content, 449, 1), '0'))::varchar(1) as clearance_only_indicator
, iff(substring(content, 468, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 450, 18)), '000000000000000000'), '')) / power(10, 02)::number as foreign_receivedeliver_charge
, trim(nullif(substring(content, 468, 1), '0'))::varchar(1) as fgn_receivedeliver_charge_sign
, iff(substring(content, 487, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 469, 18)), '000000000000000000'), '')) / power(10, 02)::number as ntf_redemption_fee
, trim(nullif(substring(content, 487, 1), '0'))::varchar(1) as ntf_redemption_fee_sign
, iff(substring(content, 506, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 488, 18)), '000000000000000000'), '')) / power(10, 02)::number as ntf_redemption_addon_fee
, trim(nullif(substring(content, 506, 1), '0'))::varchar(1) as ntf_redemption_addon_sign
, iff(substring(content, 525, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 507, 18)), '000000000000000000'), '')) / power(10, 02)::number as mutual_fund_exchange_fee
, trim(nullif(substring(content, 525, 1), '0'))::varchar(1) as mf_exchange_fee_sign
, iff(substring(content, 544, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 526, 18)), '000000000000000000'), '')) / power(10, 02)::number as srs_fund_exchange_fee
, trim(nullif(substring(content, 544, 1), '0'))::varchar(1) as srs_fund_exchange_fee_sign
, iff(substring(content, 563, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 545, 18)), '000000000000000000'), '')) / power(10, 02)::number as handling_fee
, trim(nullif(substring(content, 563, 1), '0'))::varchar(1) as handling_fee_sign
, iff(substring(content, 582, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 564, 18)), '000000000000000000'), '')) / power(10, 02)::number as stamp_duty
, trim(nullif(substring(content, 582, 1), '0'))::varchar(1) as stamp_duty_sign
, iff(substring(content, 601, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 583, 18)), '000000000000000000'), '')) / power(10, 02)::number as prime_broker_fee
, trim(nullif(substring(content, 601, 1), '0'))::varchar(1) as prime_broker_fee_sign
, trim(nullif(substring(content, 602, 20), '00000000000000000000'))::varchar(20) as ibd_miscellaneous_charge_label
, iff(substring(content, 640, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 622, 18)), '000000000000000000'), '')) / power(10, 02)::number as ibd_miscellaneous_charge
, trim(nullif(substring(content, 640, 1), '0'))::varchar(1) as ibd_miscellaneous_charge_sign
, trim(nullif(substring(content, 641, 20), '00000000000000000000'))::varchar(20) as streetside_miscellaneous_charge_label
, to_number(nullif(nullif(trim(substring(content, 661, 18)), '000000000000000000'), '')) / power(10, 02)::number as streetside_miscellaneous_charge
, trim(nullif(substring(content, 679, 1), '0'))::varchar(1) as streetside_misc
, to_number(nullif(nullif(trim(substring(content, 680, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_levy
, trim(nullif(substring(content, 641, 20), '00000000000000000000'))::varchar(20) as streetside_miscellaneous_charge_label_2
, to_number(nullif(nullif(trim(substring(content, 661, 18)), '000000000000000000'), '')) / power(10, 02)::number as streetside_miscellaneous_charge_2
, trim(nullif(substring(content, 679, 1), '0'))::varchar(1) as streetside_misc_2
, iff(substring(content, 698, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 680, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_levy_2
, trim(nullif(substring(content, 698, 1), '0'))::varchar(1) as transaction_levy_sign
, iff(substring(content, 717, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 699, 18)), '000000000000000000'), '')) / power(10, 02)::number as transfer_stamp_fee
, trim(nullif(substring(content, 717, 1), '0'))::varchar(1) as transfer_stamp_fee_sign
, iff(substring(content, 736, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 718, 18)), '000000000000000000'), '')) / power(10, 02)::number as transfer_tax
, trim(nullif(substring(content, 736, 1), '0'))::varchar(1) as transfer_tax_sign
, iff(substring(content, 755, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 737, 18)), '000000000000000000'), '')) / power(10, 02)::number as customer_confirm_fee
, trim(nullif(substring(content, 755, 1), '0'))::varchar(1) as customer_confirm_fee_sign
, iff(substring(content, 774, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 756, 18)), '000000000000000000'), '')) / power(10, 02)::number as ibd_confirm_fee
, trim(nullif(substring(content, 774, 1), '0'))::varchar(1) as ibd_confirm_fee_sign
, iff(substring(content, 793, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 775, 18)), '000000000000000000'), '')) / power(10, 02)::number as foreign_financial_transaction_tax_was_value_added_tax
, trim(nullif(substring(content, 793, 1), '0'))::varchar(1) as foreign_financial_transaction_tax_sign
, to_number(nullif(nullif(trim(substring(content, 794, 18)), '000000000000000000'), '')) / power(10, 09)::number as reported_price
-- , trim(nullif(substring(content, 812, 4), '0000'))::varchar(4) as not_used_4
, trim(nullif(substring(content, 816, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_one
, trim(nullif(substring(content, 836, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_two
, trim(nullif(substring(content, 856, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_three
, trim(nullif(substring(content, 876, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_four
, trim(nullif(substring(content, 896, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_five
, trim(nullif(substring(content, 916, 20), '00000000000000000000'))::varchar(20) as additional_trailer_line_six
, trim(nullif(substring(content, 936, 20), '00000000000000000000'))::varchar(20) as freeform_lot_information_1
, trim(nullif(substring(content, 956, 20), '00000000000000000000'))::varchar(20) as freeform_lot_information_2
, trim(nullif(substring(content, 976, 20), '00000000000000000000'))::varchar(20) as freeform_lot_information_3
, iff(substring(content, 1014, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 996, 18)), '000000000000000000'), '')) / power(10, 02)::number as transaction_sec_fee_less_option_regulatory_fee
, trim(nullif(substring(content, 1014, 1), '0'))::varchar(1) as transaction_sec_fee_less_option_regulatory_fee_sign
, iff(substring(content, 1033, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 1015, 18)), '000000000000000000'), '')) / power(10, 02)::number as option_regulatory_fee
, trim(nullif(substring(content, 1033, 1), '0'))::varchar(1) as option_regulatory_fee_sign
, trim(nullif(substring(content, 1034, 1), '0'))::varchar(1) as alternate_security_id
, trim(nullif(substring(content, 1035, 12), '000000000000'))::varchar(12) as alternate_security_id_2
, trim(nullif(substring(content, 1047, 1), '0'))::varchar(1) as reserved_for_alternate_security_id
, trim(nullif(substring(content, 1048, 12), '000000000000'))::varchar(12) as reserved_for_alternate_security_id_2
, iff(substring(content, 1078, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 1060, 18)), '000000000000000000'), '')) / power(10, 02)::number as net_amount_in_usde
, trim(nullif(substring(content, 1078, 1), '0'))::varchar(1) as net_amount_in_usde_sign
, to_number(nullif(nullif(trim(substring(content, 1079, 18)), '000000000000000000'), '')) / power(10, 02)::number as international_foreign_trading_fee
, trim(nullif(substring(content, 1097, 1), '0'))::varchar(1) as intl
, trim(nullif(substring(content, 1098, 1), '0'))::varchar(1) as alternative_trading_system_ats_indicator
, trim(nullif(substring(content, 1099, 4), '0000'))::varchar(4) as alt
-- , trim(nullif(substring(content, 1103, 122), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(122) as not_used_5
, nullif(nullif(trim(substring(content, 1225, 4)), '0000'), '')::int as pershing_internal_version_number
, trim(nullif(substring(content, 1229, 20), '00000000000000000000'))::varchar(20) as pershing_internal_trade_reference_number
, trim(nullif(substring(content, 1249, 1), '0'))::varchar(1) as pershing_internal_use
, trim(nullif(substring(content, 1250, 1), '0'))::varchar(1) as literally_x
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
