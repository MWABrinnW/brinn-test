{%- macro potl_a_aggregated_total_position_quantity_holdings(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 1), '0'))::varchar(1) as portfolio_account_type
, trim(nullif(substring(content, 22, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 31, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 35, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 38, 1), '0'))::varchar(1) as not_used_2
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 39, 3), '000'))
  else trim(nullif(substring(content, 39, 4), '0000'))
  end::varchar(4) as investment_professional_ip_number
, try_to_date(nullif(substring(content, 43, 8), '00000000'), 'YYYYMMDD')::date as process_date
, trim(nullif(substring(content, 51, 1), '0'))::varchar(1) as reconciliation_break_indicator
, iff(substring(content, 70, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 52, 18)), '000000000000000000'), '')) / power(10, 05)::number as aggregated_total_position_trade_date_quantity
, trim(nullif(substring(content, 70, 1), '0'))::varchar(1) as aggregated_total_position_trade_date_quantity_sign
, iff(substring(content, 89, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 71, 18)), '000000000000000000'), '')) / power(10, 09)::number as current_total_cost_on_position_level
, trim(nullif(substring(content, 89, 1), '0'))::varchar(1) as current_total_cost_sign
, trim(nullif(substring(content, 90, 16), '0000000000000000'))::varchar(16) as security_symbol
, trim(nullif(substring(content, 106, 1), '0'))::varchar(1) as security_type_code
, trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as security_modifier_code
, trim(nullif(substring(content, 108, 1), '0'))::varchar(1) as security_calculation_code
-- , trim(nullif(substring(content, 109, 7), '0000000'))::varchar(7) as not_used_4
, trim(nullif(substring(content, 116, 6), '000000'))::varchar(6) as option_root
, try_to_date(nullif(substring(content, 122, 6), '000000'), 'YYMMDD')::date as option_expiration_date
, trim(nullif(substring(content, 128, 1), '0'))::varchar(1) as callput_indicator
, to_number(nullif(nullif(trim(substring(content, 129, 8)), '00000000'), '')) / power(10, 03)::number as strike_price
, iff(substring(content, 155, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 137, 18)), '000000000000000000'), '')) / power(10, 02)::number as average_noncovered_subtotal
, trim(nullif(substring(content, 155, 1), '0'))::varchar(1) as average_noncovered_subtotal_sign
, iff(substring(content, 174, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 156, 18)), '000000000000000000'), '')) / power(10, 02)::number as average_covered_subtotal
, trim(nullif(substring(content, 174, 1), '0'))::varchar(1) as average_covered_subtotal_sign
, trim(nullif(substring(content, 175, 2), '00'))::varchar(2) as cusip_level_default_disposition_method_from_disposition
-- , trim(nullif(substring(content, 177, 306), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(306) as not_used_5
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
and substring(content, 3, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
