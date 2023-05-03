{%- macro capt_5(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 4, 1), '0'))::varchar(1) as record_id
, trim(nullif(substring(content, 5, 6), '000000'))::varchar(6) as option_root_id
, try_to_date(nullif(substring(content, 11, 6), '000000'), 'YYMMDD')::date as expiration_date
, trim(nullif(substring(content, 17, 1), '0'))::varchar(1) as callput_indicator
, signed_to_numeric(nullif(nullif(trim(substring(content, 18, 8)), '00000000'), '')) / power(10, 03)::number as strike_price
, trim(nullif(substring(content, 26, 32), '00000000000000000000000000000000'))::varchar(32) as master_client_name
, trim(nullif(substring(content, 58, 40), '0000000000000000000000000000000000000000'))::varchar(40) as for_pershing_internal_use_only
, trim(nullif(substring(content, 98, 20), '00000000000000000000'))::varchar(20) as pershing_internal_order_reference_number
-- , trim(nullif(substring(content, 118, 16), '0000000000000000'))::varchar(16) as not_used
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 4, 1) = '5'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
