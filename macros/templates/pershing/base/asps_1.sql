{%- macro asps_1(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator_value
, trim(nullif(substring(content, 2, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 11, 3), '000'))::varchar(3) as investment_professional_ip_of_record
, trim(nullif(substring(content, 14, 13), '0000000000000'))::varchar(13) as subscription_products_reference_number
, trim(nullif(substring(content, 27, 15), '000000000000000'))::varchar(15) as contract_number
, trim(nullif(substring(content, 42, 2), '00'))::varchar(2) as subscription_status
, trim(nullif(substring(content, 44, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 53, 1), '0'))::varchar(1) as product_type
, to_number(nullif(nullif(trim(substring(content, 54, 15)), '000000000000000'), '')) / power(10, 06)::number as share_quantity
, to_number(nullif(nullif(trim(substring(content, 69, 15)), '000000000000000'), '')) / power(10, 02)::number as share_price
, to_number(nullif(nullif(trim(substring(content, 84, 15)), '000000000000000'), '')) / power(10, 02)::number as contract_value
, nullif(nullif(trim(substring(content, 99, 2)), '00'), '')::int as number_of_underlying_funds
, trim(nullif(substring(content, 101, 8), '00000000'))::varchar(8) as product_code
-- , trim(nullif(substring(content, 109, 24), '000000000000000000000000'))::varchar(24) as not_used
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = '1'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
