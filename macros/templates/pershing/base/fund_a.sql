{%- macro fund_a(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 17, 3), '000'))::varchar(3) as investment_professional_ip_number
, trim(nullif(substring(content, 20, 4), '0000'))::varchar(4) as fund_mnemonic
, trim(nullif(substring(content, 24, 15), '000000000000000'))::varchar(15) as account_number_at_fund
, trim(nullif(substring(content, 39, 8), '00000000'))::varchar(8) as fund_manager
, try_to_date(nullif(substring(content, 47, 8), '00000000'), 'YYYYMMDD')::date as last_sweep_date
, nullif(nullif(trim(substring(content, 55, 8)), '00000000'), '')::int as last_update_date
, signed_to_numeric(nullif(nullif(trim(substring(content, 63, 13)), '0000000000000'), '')) / power(10, 03)::number as principal
, signed_to_numeric(nullif(nullif(trim(substring(content, 76, 11)), '00000000000'), '')) / power(10, 02)::number as accrued_dividend
, trim(nullif(substring(content, 87, 5), '00000'))::varchar(5) as group_number
-- , trim(nullif(substring(content, 92, 3), '000'))::varchar(3) as not_used
, trim(nullif(substring(content, 95, 1), '0'))::varchar(1) as omnibus_account_indicator
, trim(nullif(substring(content, 96, 1), '0'))::varchar(1) as sweep_account_indicator
, trim(nullif(substring(content, 97, 1), '0'))::varchar(1) as margin_debit_auto_sweep_indicator
, trim(nullif(substring(content, 98, 19), '0000000000000000000'))::varchar(19) as for_pershing_internal_use_only
, trim(nullif(substring(content, 117, 9), '000000000'))::varchar(9) as cusip
, nullif(nullif(trim(substring(content, 126, 2)), '00'), '')::int as pricing_group
, trim(nullif(substring(content, 128, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as reserved
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'A'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
