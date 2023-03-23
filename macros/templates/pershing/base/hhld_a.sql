{%- macro hhld_a(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 15, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 16, 1), '0'))::varchar(1) as group_source_code
, trim(nullif(substring(content, 17, 32), '00000000000000000000000000000000'))::varchar(32) as group_id
, trim(nullif(substring(content, 49, 8), '00000000'))::varchar(8) as group_creator_user_id
, trim(nullif(substring(content, 57, 1), '0'))::varchar(1) as group_type_code
, trim(nullif(substring(content, 58, 3), '000'))::varchar(3) as group_access_type_code
, trim(nullif(substring(content, 61, 1), '0'))::varchar(1) as billing_group_indicator
, trim(nullif(substring(content, 62, 1), '0'))::varchar(1) as client_group_indicator
, try_to_date(nullif(substring(content, 63, 8), '00000000'), 'YYYYMMDD')::date as creation_date
, try_to_time(nullif(substring(content, 71, 6), '000000'), 'HH24MISSFF6')::time as creation_time
, trim(nullif(substring(content, 77, 15), '000000000000000'))::varchar(15) as creator_user_id
, nullif(nullif(trim(substring(content, 92, 8)), '00000000'), '')::int as update_date
, try_to_time(nullif(substring(content, 100, 6), '000000'), 'HH24MISSFF6')::time as update_time
, trim(nullif(substring(content, 106, 15), '000000000000000'))::varchar(15) as update_user_id
, trim(nullif(substring(content, 121, 32), '00000000000000000000000000000000'))::varchar(32) as group_name
, trim(nullif(substring(content, 153, 64), '0000000000000000000000000000000000000000000000000000000000000000'))::varchar(64) as for_pershing_internal_use_only
-- , trim(nullif(substring(content, 217, 100), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(100) as not_used_2
, trim(nullif(substring(content, 317, 3), '000'))::varchar(3) as investment_professional_ip_of_record
-- , trim(nullif(substring(content, 320, 1), '0'))::varchar(1) as not_used_3
, trim(nullif(substring(content, 321, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 330, 3), '000'))::varchar(3) as office_number
-- , trim(nullif(substring(content, 333, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 334, 1), '0'))::varchar(1) as primary_account_indicator
-- , trim(nullif(substring(content, 335, 4), '0000'))::varchar(4) as not_used_5
, try_to_date(nullif(substring(content, 339, 8), '00000000'), 'YYYYMMDD')::date as creation_date_2
, try_to_time(nullif(substring(content, 347, 6), '000000'), 'HH24MISSFF6')::time as creation_time_2
, trim(nullif(substring(content, 353, 15), '000000000000000'))::varchar(15) as creator_user_id_2
, trim(nullif(substring(content, 368, 1), '0'))::varchar(1) as delivery_frequency
, trim(nullif(substring(content, 369, 1), '0'))::varchar(1) as annual_statement
, trim(nullif(substring(content, 370, 1), '0'))::varchar(1) as tranche
, trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as trade_date_or_settlement_date
-- , trim(nullif(substring(content, 372, 128), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(128) as not_used_6
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
