{%- macro caps_2(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 4, 1), '0'))::varchar(1) as record_id
, trim(nullif(substring(content, 5, 1), '0'))::varchar(1) as market_code
, trim(nullif(substring(content, 6, 1), '0'))::varchar(1) as blotter_code
, trim(nullif(substring(content, 7, 1), '0'))::varchar(1) as security_type
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as stock_symbol
, trim(nullif(substring(content, 17, 40), '0000000000000000000000000000000000000000'))::varchar(40) as security_description
, to_number(nullif(nullif(trim(substring(content, 57, 9)), '000000000'), '')) / power(10, 04)::number as cents_per_share
, {{target.database}}.{{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 66, 7)), '0000000'), '')) / power(10, 02)::number as discount_percent
, trim(nullif(substring(content, 73, 2), '00'))::varchar(2) as paycode
, trim(nullif(substring(content, 75, 9), '000000000'))::varchar(9) as master_client_mnemonic
, trim(nullif(substring(content, 84, 1), '0'))::varchar(1) as institutionalretail_indicator
, trim(nullif(substring(content, 85, 3), '000'))::varchar(3) as state_code
, trim(nullif(substring(content, 88, 3), '000'))::varchar(3) as commission_indicator
, trim(nullif(substring(content, 91, 9), '000000000'))::varchar(9) as firm_trading_account
, try_to_date(nullif(substring(content, 100, 8), '00000000'), 'YYYYMMDD')::date as posted_date
, try_to_date(nullif(substring(content, 108, 8), '00000000'), 'YYYYMMDD')::date as settlement_date
-- , trim(nullif(substring(content, 116, 17), '00000000000000000'))::varchar(17) as not_used
, trim(nullif(substring(content, 133, 1), '0'))::varchar(1) as recycle_indicator
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 4, 1) = '2'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
