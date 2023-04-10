{%- macro mfds_a(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_id
, nullif(nullif(trim(substring(content, 4, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 10, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 19, 4), '0000'))::varchar(4) as fund_family_code
, trim(nullif(substring(content, 23, 6), '000000'))::varchar(6) as security_symbol
-- , trim(nullif(substring(content, 29, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 30, 1), '0'))::varchar(1) as dividend_reinvest_indicator
, trim(nullif(substring(content, 31, 1), '0'))::varchar(1) as capital_gain_reinvest_indicator
-- , trim(nullif(substring(content, 32, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 33, 1), '0'))::varchar(1) as fundserv_indicator
, trim(nullif(substring(content, 34, 1), '0'))::varchar(1) as grandfather_indicator
, trim(nullif(substring(content, 35, 1), '0'))::varchar(1) as loadnoload_indicator
, trim(nullif(substring(content, 36, 1), '0'))::varchar(1) as networking_indicator
, trim(nullif(substring(content, 37, 1), '0'))::varchar(1) as no_transaction_fee_eligibility_indicator
, trim(nullif(substring(content, 38, 1), '0'))::varchar(1) as short_settlement_eligibility_indicator
, trim(nullif(substring(content, 39, 1), '0'))::varchar(1) as systematic_reinvestment_system_eligibility_indicator
, trim(nullif(substring(content, 40, 1), '0'))::varchar(1) as dividend_frequency
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as closed_to_buys_indicator
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as closed_to_sells_indicator
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as new_investment_closed_indicator
, trim(nullif(substring(content, 44, 2), '00'))::varchar(2) as settle_purchase_days
, trim(nullif(substring(content, 46, 2), '00'))::varchar(2) as settle_redemption_days
, trim(nullif(substring(content, 48, 2), '00'))::varchar(2) as settle_purchase_days_2
, trim(nullif(substring(content, 50, 2), '00'))::varchar(2) as settle_redemption_days_2
, try_to_time(nullif(substring(content, 52, 4), '0000'), 'HH24MISSFF6')::time as exchange_cutoff_time
, try_to_time(nullif(substring(content, 56, 4), '0000'), 'HH24MISSFF6')::time as purchase_cutoff_time
, try_to_time(nullif(substring(content, 60, 4), '0000'), 'HH24MISSFF6')::time as redemption_cutoff_time
, iff(substring(content, 81, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 64, 17)), '00000000000000000'), '')) / power(10, 08)::number as last_price
, trim(nullif(substring(content, 81, 1), '0'))::varchar(1) as last_price_sign
, try_to_date(nullif(substring(content, 82, 8), '00000000'), 'YYYYMMDD')::date as last_price_date
, trim(nullif(substring(content, 90, 26), '00000000000000000000000000'))::varchar(26) as fund_family_name
, trim(nullif(substring(content, 116, 1), '0'))::varchar(1) as share_class
, trim(nullif(substring(content, 117, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_1
, trim(nullif(substring(content, 137, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_2
, trim(nullif(substring(content, 157, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_3
, trim(nullif(substring(content, 177, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_4
, trim(nullif(substring(content, 197, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_5
, trim(nullif(substring(content, 217, 20), '00000000000000000000'))::varchar(20) as mutual_fund_description_line_6
, trim(nullif(substring(content, 237, 1), '0'))::varchar(1) as exchange_eligible_indicator
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as trade_status
, trim(nullif(substring(content, 239, 20), '00000000000000000000'))::varchar(20) as customer_comments
, trim(nullif(substring(content, 259, 1), '0'))::varchar(1) as offshore_indicator
, trim(nullif(substring(content, 260, 1), '0'))::varchar(1) as offshore_processing_indicator
, trim(nullif(substring(content, 261, 1), '0'))::varchar(1) as dealer_agreement_required_for_load_trades
, trim(nullif(substring(content, 262, 1), '0'))::varchar(1) as dealer_agreement_required_for_noload_trades
, trim(nullif(substring(content, 263, 1), '0'))::varchar(1) as dealer_agreement_required_for_load_transfers
, trim(nullif(substring(content, 264, 1), '0'))::varchar(1) as dealer_agreement_required_for_noload_transfers
, trim(nullif(substring(content, 265, 1), '0'))::varchar(1) as asof_indicator
, nullif(nullif(trim(substring(content, 266, 3)), '000'), '')::int as asof_days
, trim(nullif(substring(content, 269, 1), '0'))::varchar(1) as post_settle_cancel_indicator
, nullif(nullif(trim(substring(content, 270, 3)), '000'), '')::int as post_settle_cancel_days
, to_number(nullif(nullif(trim(substring(content, 273, 11)), '00000000000'), '')) / power(10, 02)::number as post_settle_maximum_dollar_amount
, to_number(nullif(nullif(trim(substring(content, 284, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_initial_purchase_amount
, to_number(nullif(nullif(trim(substring(content, 302, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_subsequent_purchase_amount
, to_number(nullif(nullif(trim(substring(content, 320, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_initial_purchase_amount
, to_number(nullif(nullif(trim(substring(content, 338, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_subsequent_purchase_amount
, trim(nullif(substring(content, 356, 1), '0'))::varchar(1) as for_pershing_internal_use
, trim(nullif(substring(content, 357, 1), '0'))::varchar(1) as omnibus_indicator
, trim(nullif(substring(content, 358, 1), '0'))::varchar(1) as tender_indicator
, trim(nullif(substring(content, 359, 1), '0'))::varchar(1) as fundvest_200_eligible
, trim(nullif(substring(content, 360, 1), '0'))::varchar(1) as surcharge
, trim(nullif(substring(content, 361, 3), '000'))::varchar(3) as currency
, trim(nullif(substring(content, 364, 1), '0'))::varchar(1) as retirement_plan_network_rpn_eligible_indicator
, trim(nullif(substring(content, 365, 1), '0'))::varchar(1) as trading_restricted_by_booking_entities
, trim(nullif(substring(content, 366, 1), '0'))::varchar(1) as bny_mellon
, trim(nullif(substring(content, 367, 1), '0'))::varchar(1) as pershing_llc_pllc
, trim(nullif(substring(content, 368, 1), '0'))::varchar(1) as pershing_australia_psal
, trim(nullif(substring(content, 369, 1), '0'))::varchar(1) as pershing_canada_pscl
, trim(nullif(substring(content, 370, 1), '0'))::varchar(1) as pershing_london_psll
, trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as reserved_for_future_booking_entity
, trim(nullif(substring(content, 372, 1), '0'))::varchar(1) as reserved_for_future_booking_entity_2
, trim(nullif(substring(content, 373, 1), '0'))::varchar(1) as reserved_for_future_booking_entity_3
, trim(nullif(substring(content, 374, 1), '0'))::varchar(1) as reserved_for_future_booking_entity_4
, trim(nullif(substring(content, 375, 1), '0'))::varchar(1) as reserved_for_future_booking_entity_5
-- , trim(nullif(substring(content, 376, 10), '0000000000'))::varchar(10) as reserved
, trim(nullif(substring(content, 386, 10), '0000000000'))::varchar(10) as fund_share_class
, trim(nullif(substring(content, 396, 1), '0'))::varchar(1) as b1_indicator
-- , trim(nullif(substring(content, 397, 103), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(103) as not_used_3
, trim(nullif(substring(content, 500, 1), '0'))::varchar(1) as literally_x
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
