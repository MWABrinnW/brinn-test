{%- macro envestnet_products_fee_rate(src) -%}
select
    'envestnet'                                      as system_name
    , {{ "'" ~ src ~ "'" }}                                             as system_instance
    , concat(system_name , '__' , system_instance)   as system_key
    , {{ envestnet_instance_map(src) }}                                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::int             as fee_rate_schedule_id
    , nullif(split_part(content , '|' , 2), '')::int             as start_range
    , nullif(split_part(content , '|' , 3), '')::decimal(18 , 4) as rate_percentage
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'products')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                    as _created_at
    , _source_file                                   as _source_file
from {{ source('envestnet_' + src, 'products') }}
where split_part(content , '|' , 1) = 'C'
{%- endmacro -%}
