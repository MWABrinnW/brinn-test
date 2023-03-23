{%- macro asps_2(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator_value
, trim(nullif(substring(content, 2, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 11, 3), '000'))::varchar(3) as investment_professional_ip_of_record
, trim(nullif(substring(content, 14, 13), '0000000000000'))::varchar(13) as subscription_products_reference_number
, trim(nullif(substring(content, 27, 106), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(106) as product_description
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = '2'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
