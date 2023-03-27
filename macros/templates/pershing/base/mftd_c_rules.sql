{%- macro mftd_c_rules(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 10, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 20, 9), '000000000'))::varchar(9) as cusip_number
, nullif(nullif(trim(substring(content, 29, 2)), '00'), '')::int as rule_number
, trim(nullif(substring(content, 31, 80), '00000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(80) as rule_message
, iff(substring(content, 129, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 111, 18)), '000000000000000000'), '')) / power(10, 09)::number as loiroa_calculated_amount
, trim(nullif(substring(content, 129, 1), '0'))::varchar(1) as loiroa_calculated_amount_sign
, iff(substring(content, 148, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 130, 18)), '000000000000000000'), '')) / power(10, 09)::number as loiroa_manually_entered_amount
, trim(nullif(substring(content, 148, 1), '0'))::varchar(1) as loiroa_manually_entered_amount_sign
, trim(nullif(substring(content, 149, 1), '0'))::varchar(1) as dividend_reinvestment_indicator
, trim(nullif(substring(content, 150, 1), '0'))::varchar(1) as capital_gain_indicator
, trim(nullif(substring(content, 151, 1), '0'))::varchar(1) as delivery_instructions
, trim(nullif(substring(content, 152, 20), '00000000000000000000'))::varchar(20) as fund_account_number
, trim(nullif(substring(content, 172, 14), '00000000000000'))::varchar(14) as last_action_indicator
, trim(nullif(substring(content, 186, 4), '0000'))::varchar(4) as fee_waiver_indicator
, trim(nullif(substring(content, 190, 9), '000000000'))::varchar(9) as error_account_number
-- , trim(nullif(substring(content, 199, 1), '0'))::varchar(1) as reserved
-- , trim(nullif(substring(content, 200, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as not_used
, trim(nullif(substring(content, 250, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'C'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
