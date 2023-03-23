{%- macro asps_3(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator_value
, trim(nullif(substring(content, 2, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 11, 3), '000'))::varchar(3) as investment_professional_ip_of_record
, trim(nullif(substring(content, 14, 13), '0000000000000'))::varchar(13) as subscription_products_reference_number
, trim(nullif(substring(content, 27, 13), '0000000000000'))::varchar(13) as investment_code
, trim(nullif(substring(content, 40, 30), '000000000000000000000000000000'))::varchar(30) as underlying_fund_description
, to_number(nullif(nullif(trim(substring(content, 70, 15)), '000000000000000'), '')) / power(10, 06)::number as units_held
, to_number(nullif(nullif(trim(substring(content, 85, 15)), '000000000000000'), '')) / power(10, 06)::number as unit_price
, to_number(nullif(nullif(trim(substring(content, 100, 6)), '000000'), '')) / power(10, 03)::number as guaranteed_rate
, try_to_date(nullif(substring(content, 106, 8), '00000000'), 'MMDDYYYY')::date as maturity_date
, to_number(nullif(nullif(trim(substring(content, 114, 6)), '000000'), '')) / power(10, 03)::number as investment_percentage
-- , trim(nullif(substring(content, 120, 13), '0000000000000'))::varchar(13) as not_used
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = '3'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
