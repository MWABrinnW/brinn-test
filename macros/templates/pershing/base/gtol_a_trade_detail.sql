{%- macro gtol_a_trade_detail(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
-- , trim(nullif(substring(content, 22, 1), '0'))::varchar(1) as reserved
, trim(nullif(substring(content, 23, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 26, 3), '000'))::varchar(3) as reserved_2
-- , trim(nullif(substring(content, 29, 14), '00000000000000'))::varchar(14) as not_used
, trim(nullif(substring(content, 43, 20), '00000000000000000000'))::varchar(20) as pershing_internal_order_reference_number
, trim(nullif(substring(content, 63, 20), '00000000000000000000'))::varchar(20) as pershing_internal_trade_reference_number
, nullif(nullif(trim(substring(content, 83, 4)), '0000'), '')::int as pershing_internal_version
, trim(nullif(substring(content, 87, 20), '00000000000000000000'))::varchar(20) as introducing_brokerdealer_ibd_trade_id
, trim(nullif(substring(content, 107, 20), '00000000000000000000'))::varchar(20) as unique_order_id
, trim(nullif(substring(content, 127, 20), '00000000000000000000'))::varchar(20) as allocation_block_id
, trim(nullif(substring(content, 147, 20), '00000000000000000000'))::varchar(20) as external_reference_number
, trim(nullif(substring(content, 167, 20), '00000000000000000000'))::varchar(20) as block_trade_id
, trim(nullif(substring(content, 187, 6), '000000'))::varchar(6) as p
, trim(nullif(substring(content, 193, 6), '000000'))::varchar(6) as trade_area_id
, try_to_date(nullif(substring(content, 199, 8), '00000000'), 'YYYYMMDD')::date as trade_date
, try_to_time(nullif(substring(content, 207, 6), '000000'), 'HH24MISSFF6')::time as execution_time
, try_to_date(nullif(substring(content, 213, 8), '00000000'), 'YYYYMMDD')::date as settlement_date
, try_to_date(nullif(substring(content, 221, 8), '00000000'), 'YYYYMMDD')::date as process_date
-- , trim(nullif(substring(content, 229, 16), '0000000000000000'))::varchar(16) as not_used_2
-- , trim(nullif(substring(content, 245, 3), '000'))::varchar(3) as not_used_3
, trim(nullif(substring(content, 248, 1), '0'))::varchar(1) as buysell_code
, trim(nullif(substring(content, 249, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 258, 7), '0000000'))::varchar(7) as reserved_3
, trim(nullif(substring(content, 265, 1), '0'))::varchar(1) as international_security_identifier_type
, trim(nullif(substring(content, 266, 12), '000000000000'))::varchar(12) as international_security_identifier_as_entered_on
, trim(nullif(substring(content, 278, 16), '0000000000000000'))::varchar(16) as security_symbol
, iff(substring(content, 312, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 294, 18)), '000000000000000000'), '')) / power(10, 05)::number as order_quantity
, trim(nullif(substring(content, 312, 1), '0'))::varchar(1) as order_quantity_sign
, nullif(nullif(trim(substring(content, 313, 9)), '000000000'), '')::int as pricing_group_quantity
, trim(nullif(substring(content, 322, 1), '0'))::varchar(1) as market_code
-- , trim(nullif(substring(content, 323, 15), '000000000000000'))::varchar(15) as not_used_4
, trim(nullif(substring(content, 338, 4), '0000'))::varchar(4) as market_mnemonic_code
, trim(nullif(substring(content, 342, 1), '0'))::varchar(1) as blotter_code
-- , trim(nullif(substring(content, 343, 3), '000'))::varchar(3) as reserved_4
, trim(nullif(substring(content, 346, 4), '0000'))::varchar(4) as settlement_location_code
, trim(nullif(substring(content, 350, 4), '0000'))::varchar(4) as counter_party_client
, trim(nullif(substring(content, 354, 1), '0'))::varchar(1) as cancel_code
, trim(nullif(substring(content, 355, 1), '0'))::varchar(1) as correction_code
, trim(nullif(substring(content, 356, 1), '0'))::varchar(1) as openclose_indicator_for_options
, trim(nullif(substring(content, 357, 1), '0'))::varchar(1) as type_of_order
, trim(nullif(substring(content, 358, 1), '0'))::varchar(1) as discretion_exercised
, trim(nullif(substring(content, 359, 1), '0'))::varchar(1) as solicited_indicator
, trim(nullif(substring(content, 360, 1), '0'))::varchar(1) as fx_forward
, trim(nullif(substring(content, 361, 8), '00000000'))::varchar(8) as user_id_of_person_who_entered_the_order
, trim(nullif(substring(content, 369, 1), '0'))::varchar(1) as source_of_input
, trim(nullif(substring(content, 370, 1), '0'))::varchar(1) as no_transaction_fee_ntf_for_exchange_traded_funds
, trim(nullif(substring(content, 371, 8), '00000000'))::varchar(8) as order_terminal_id
, nullif(nullif(trim(substring(content, 379, 5)), '00000'), '')::int as order_sequence_number
, trim(nullif(substring(content, 384, 1), '0'))::varchar(1) as capacity_code
, trim(nullif(substring(content, 385, 1), '0'))::varchar(1) as account_type_indicator_for_blue_sheet_reporting
, trim(nullif(substring(content, 386, 1), '0'))::varchar(1) as riskless_principal_indicator
, trim(nullif(substring(content, 387, 1), '0'))::varchar(1) as tracetreasury_whenissued_indicator
, trim(nullif(substring(content, 388, 1), '0'))::varchar(1) as short_trade
, trim(nullif(substring(content, 389, 1), '0'))::varchar(1) as syndicate_indicator
, trim(nullif(substring(content, 390, 1), '0'))::varchar(1) as odd_lot_code
, trim(nullif(substring(content, 391, 1), '0'))::varchar(1) as mutual_fund_values
, trim(nullif(substring(content, 392, 1), '0'))::varchar(1) as spreadstraddle_indicator
, trim(nullif(substring(content, 393, 5), '00000'))::varchar(5) as batch_code
, trim(nullif(substring(content, 398, 8), '00000000'))::varchar(8) as investment_manager_code
, trim(nullif(substring(content, 406, 1), '0'))::varchar(1) as dollar_roll_indicator
, trim(nullif(substring(content, 407, 1), '0'))::varchar(1) as hedged_transaction_indicator
-- , trim(nullif(substring(content, 408, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 410, 10), '0000000000'))::varchar(10) as offset_account
-- , trim(nullif(substring(content, 420, 7), '0000000'))::varchar(7) as not_used_6
, trim(nullif(substring(content, 427, 4), '0000'))::varchar(4) as executing_broker
, trim(nullif(substring(content, 431, 4), '0000'))::varchar(4) as major_brokerage_badge_number
, trim(nullif(substring(content, 435, 4), '0000'))::varchar(4) as contra_broker
, trim(nullif(substring(content, 439, 4), '0000'))::varchar(4) as minor_brokerage_badge_number
, trim(nullif(substring(content, 443, 3), '000'))::varchar(3) as trader_initials
, trim(nullif(substring(content, 446, 1), '0'))::varchar(1) as step_instep_out_indicator
, trim(nullif(substring(content, 447, 2), '00'))::varchar(2) as execution_terminal
-- , trim(nullif(substring(content, 449, 6), '000000'))::varchar(6) as not_used_7
, nullif(nullif(trim(substring(content, 455, 5)), '00000'), '')::int as execution_sequence_number
-- , trim(nullif(substring(content, 460, 6), '000000'))::varchar(6) as not_used_8
, trim(nullif(substring(content, 466, 1), '0'))::varchar(1) as prime_broker_indicator
, trim(nullif(substring(content, 467, 3), '000'))::varchar(3) as country_of_citizenship
, trim(nullif(substring(content, 470, 3), '000'))::varchar(3) as countrystate_of_residence
, trim(nullif(substring(content, 473, 1), '0'))::varchar(1) as withholding_codetax_exempt_indicator
, trim(nullif(substring(content, 474, 3), '000'))::varchar(3) as base_currency
, to_number(nullif(nullif(trim(substring(content, 477, 18)), '000000000000000000'), '')) / power(10, 09)::number as base_currency_exchange_rate
, trim(nullif(substring(content, 495, 1), '0'))::varchar(1) as base_currency_multiplydivide_code
-- , trim(nullif(substring(content, 496, 10), '0000000000'))::varchar(10) as not_used_9
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 506, 3), '000'))
  else trim(nullif(substring(content, 506, 4), '0000'))
  end::varchar(4) as primary_execution_investment_professional
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 510, 3), '000'))
  else trim(nullif(substring(content, 510, 4), '0000'))
  end::varchar(4) as investment_professional_2_override
, to_number(nullif(nullif(trim(substring(content, 514, 18)), '000000000000000000'), '')) / power(10, 09)::number as investment_professional_2_percentage
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 532, 3), '000'))
  else trim(nullif(substring(content, 532, 4), '0000'))
  end::varchar(4) as investment_professional_3_override
, to_number(nullif(nullif(trim(substring(content, 536, 18)), '000000000000000000'), '')) / power(10, 09)::number as investment_professional_3_percentage
-- , trim(nullif(substring(content, 554, 5), '00000'))::varchar(5) as not_used_13
, trim(nullif(substring(content, 559, 1), '0'))::varchar(1) as security_type_code
, trim(nullif(substring(content, 560, 1), '0'))::varchar(1) as security_modifier_code
, trim(nullif(substring(content, 561, 1), '0'))::varchar(1) as security_calculation_code
, trim(nullif(substring(content, 562, 3), '000'))::varchar(3) as minor_product_code
, trim(nullif(substring(content, 565, 8), '00000000'))::varchar(8) as asset_type
, trim(nullif(substring(content, 573, 8), '00000000'))::varchar(8) as asset_subtype
, trim(nullif(substring(content, 581, 8), '00000000'))::varchar(8) as asset_subsubtype
-- , trim(nullif(substring(content, 589, 2), '00'))::varchar(2) as not_used_14
, trim(nullif(substring(content, 591, 4), '0000'))::varchar(4) as international_exchange_code
, trim(nullif(substring(content, 595, 9), '000000000'))::varchar(9) as underlying_cusip
-- , trim(nullif(substring(content, 604, 7), '0000000'))::varchar(7) as not_used_15
, to_number(nullif(nullif(trim(substring(content, 611, 18)), '000000000000000000'), '')) / power(10, 09)::number as strike_price
, to_number(nullif(nullif(trim(substring(content, 629, 15)), '000000000000000'), '')) / power(10, 12)::number as pool_factor
, trim(nullif(substring(content, 644, 1), '0'))::varchar(1) as nonus_security_indicator
, trim(nullif(substring(content, 645, 1), '0'))::varchar(1) as continuous_net_settlement_cns_eligibility
, trim(nullif(substring(content, 646, 1), '0'))::varchar(1) as depository_trust_company_dtc_eligibilty
, trim(nullif(substring(content, 647, 1), '0'))::varchar(1) as buyin_trade_execution_indicator
, try_to_date(nullif(substring(content, 648, 8), '00000000'), 'YYYYMMDD')::date as exdividend_date
, try_to_date(nullif(substring(content, 656, 8), '00000000'), 'YYYYMMDD')::date as record_date
, nullif(nullif(trim(substring(content, 664, 2)), '00'), '')::int as number_of_description_lines
, trim(nullif(substring(content, 666, 20), '00000000000000000000'))::varchar(20) as description_line_1
, trim(nullif(substring(content, 686, 20), '00000000000000000000'))::varchar(20) as description_line_2
, trim(nullif(substring(content, 706, 20), '00000000000000000000'))::varchar(20) as description_line_3
, trim(nullif(substring(content, 726, 20), '00000000000000000000'))::varchar(20) as description_line_4
, trim(nullif(substring(content, 746, 20), '00000000000000000000'))::varchar(20) as description_line_5
, trim(nullif(substring(content, 766, 20), '00000000000000000000'))::varchar(20) as description_line_6
, trim(nullif(substring(content, 786, 1), '0'))::varchar(1) as legend_code_1
-- , trim(nullif(substring(content, 787, 1), '0'))::varchar(1) as not_used_16
, trim(nullif(substring(content, 788, 1), '0'))::varchar(1) as legend_code_2
-- , trim(nullif(substring(content, 789, 7), '0000000'))::varchar(7) as not_used_17
, trim(nullif(substring(content, 796, 2), '00'))::varchar(2) as legend_code_one
, trim(nullif(substring(content, 798, 2), '00'))::varchar(2) as legend_code_two
, trim(nullif(substring(content, 800, 2), '00'))::varchar(2) as legend_code_three
, trim(nullif(substring(content, 802, 2), '00'))::varchar(2) as legend_code_four
, trim(nullif(substring(content, 804, 2), '00'))::varchar(2) as legend_code_five
, trim(nullif(substring(content, 806, 2), '00'))::varchar(2) as legend_code_six
-- , trim(nullif(substring(content, 808, 2), '00'))::varchar(2) as not_used_18
, trim(nullif(substring(content, 810, 20), '00000000000000000000'))::varchar(20) as trailer_line_one
, trim(nullif(substring(content, 830, 20), '00000000000000000000'))::varchar(20) as trailer_line_two
, trim(nullif(substring(content, 850, 20), '00000000000000000000'))::varchar(20) as trailer_line_three
, trim(nullif(substring(content, 870, 20), '00000000000000000000'))::varchar(20) as trailer_line_four
, trim(nullif(substring(content, 890, 20), '00000000000000000000'))::varchar(20) as trailer_line_five
, trim(nullif(substring(content, 910, 20), '00000000000000000000'))::varchar(20) as trailer_line_six
, trim(nullif(substring(content, 930, 20), '00000000000000000000'))::varchar(20) as trailer_line_seven
, trim(nullif(substring(content, 950, 20), '00000000000000000000'))::varchar(20) as trailer_line_eight
, trim(nullif(substring(content, 970, 20), '00000000000000000000'))::varchar(20) as trailer_line_nine
, trim(nullif(substring(content, 990, 7), '0000000'))::varchar(7) as mips_comment
, trim(nullif(substring(content, 997, 16), '0000000000000000'))::varchar(16) as mips_comment_2
, trim(nullif(substring(content, 1013, 1), '0'))::varchar(1) as source_of_initial_funds_purchase_indicator
, trim(nullif(substring(content, 1014, 1), '0'))::varchar(1) as source_of_funds
, trim(nullif(substring(content, 1015, 20), '00000000000000000000'))::varchar(20) as mips_comment_3
, trim(nullif(substring(content, 1035, 6), '000000'))::varchar(6) as option_root_id
, try_to_date(nullif(substring(content, 1041, 6), '000000'), 'YYMMDD')::date as expiration_date
, trim(nullif(substring(content, 1047, 1), '0'))::varchar(1) as callput_indicator
, to_number(nullif(nullif(trim(substring(content, 1048, 8)), '00000000'), '')) / power(10, 03)::number as strike_price_2
, trim(nullif(substring(content, 1056, 4), '0000'))::varchar(4) as mortgagebacked_securities_market_participant
, trim(nullif(substring(content, 1060, 1), '0'))::varchar(1) as bunched_trade_indicator
, trim(nullif(substring(content, 1061, 1), '0'))::varchar(1) as confirm_print_indicator
, trim(nullif(substring(content, 1062, 16), '0000000000000000'))::varchar(16) as international_nondollar_symbol
, trim(nullif(substring(content, 1078, 1), '0'))::varchar(1) as cmta_indicator
, trim(nullif(substring(content, 1079, 4), '0000'))::varchar(4) as cmta_broker_number
, trim(nullif(substring(content, 1083, 2), '00'))::varchar(2) as confirmation_code_one
, trim(nullif(substring(content, 1085, 2), '00'))::varchar(2) as confirmation_code_two
, trim(nullif(substring(content, 1087, 2), '00'))::varchar(2) as confirmation_code_three
, trim(nullif(substring(content, 1089, 2), '00'))::varchar(2) as confirmation_code_four
, to_number(nullif(nullif(trim(substring(content, 1091, 18)), '000000000000000000'), '')) / power(10, 09)::number as prevailing_market_price_pmp
, iff(substring(content, 1127, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 1109, 18)), '000000000000000000'), '')) / power(10, 02)::number as total_amount_of_mark_updown
, trim(nullif(substring(content, 1127, 1), '0'))::varchar(1) as total_amount_of_mark_updown_sign
, to_number(nullif(nullif(trim(substring(content, 1128, 9)), '000000000'), '')) / power(10, 05)::number as prevailing_market_price_percent
, try_to_time(nullif(substring(content, 1137, 12), '000000000000'), 'HH24MISSFF6')::time as expanded_execution_time
, trim(nullif(substring(content, 1149, 9), '000000000'))::varchar(9) as error_account_number
-- , trim(nullif(substring(content, 1158, 1), '0'))::varchar(1) as reserved_5
-- , trim(nullif(substring(content, 1159, 83), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(83) as not_used_19
, trim(nullif(substring(content, 1242, 8), '00000000'))::varchar(8) as for_pershing_internal_use_only
, trim(nullif(substring(content, 1250, 1), '0'))::varchar(1) as literally_x
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
