{%- macro envestnet_products_fee_schedule(src) -%}
select
    'envestnet'                                      as system_name
    , {{ "'" ~ src ~ "'" }}                                             as system_instance
    , concat(system_name , '__' , system_instance)   as system_key
    , {{ envestnet_instance_map(src) }}                                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)         as record_type
    , nullif(split_part(content , '|' , 2), '')::int             as product_id
    , nullif(split_part(content , '|' , 3), '')::int             as fee_schedule_id
    , nullif(split_part(content , '|' , 4), '')::varchar(128)    as fee_schedule_name
    , nullif(split_part(content , '|' , 5), '')::int             as linear_fee_range_start
    , nullif(split_part(content , '|' , 6), '')::decimal(18 , 2) as fee_minimum
    , nullif(split_part(content , '|' , 7), '')::decimal(18 , 2) as fee_maximum
    , nullif(split_part(content , '|' , 8), '')::varchar(3)      as currency
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'products')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                    as _created_at
    , _source_file                                   as _source_file
from {{ source('envestnet_' + src, 'products') }}
where split_part(content , '|' , 1) = 'B'
{%- endmacro -%}
