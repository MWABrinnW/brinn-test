{%- macro caps_1(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
, trim(nullif(substring(content, 4, 1), '0'))::varchar(1) as record_id
, try_to_date(nullif(substring(content, 5, 8), '00000000'), 'YYYYMMDD')::date as trade_date
, trim(nullif(substring(content, 13, 6), '000000'))::varchar(6) as trade_reference_number
, trim(nullif(substring(content, 19, 3), '000'))::varchar(3) as pershing_office_number
, trim(nullif(substring(content, 22, 10), '0000000000'))::varchar(10) as account_number
, trim(nullif(substring(content, 32, 32), '00000000000000000000000000000000'))::varchar(32) as account_name
, trim(nullif(substring(content, 64, 1), '0'))::varchar(1) as buysell_indicator
, trim(nullif(substring(content, 65, 1), '0'))::varchar(1) as cancel_indicator
, trim(nullif(substring(content, 66, 3), '000'))::varchar(3) as caps_source
, signed_to_numeric(nullif(nullif(trim(substring(content, 69, 13)), '0000000000000'), '')) / power(10, 04)::number as trade_quantity
, signed_to_numeric(nullif(nullif(trim(substring(content, 82, 13)), '0000000000000'), '')) / power(10, 07)::number as price
, trim(nullif(substring(content, 95, 4), '0000'))::varchar(4) as product_code
, trim(nullif(substring(content, 99, 9), '000000000'))::varchar(9) as cusip_number_of_security_traded
, trim(nullif(substring(content, 108, 10), '0000000000'))::varchar(10) as account_short_name
, trim(nullif(substring(content, 118, 1), '0'))::varchar(1) as order_type
, signed_to_numeric(nullif(nullif(trim(substring(content, 119, 13)), '0000000000000'), '')) / power(10, 02)::number as miscellaneous_fee
-- , trim(nullif(substring(content, 132, 2), '00'))::varchar(2) as not_used
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 4, 1) = '1'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
