{%- macro envestnet_account_fee_schedule_fee_rate(src) -%}
select
    'envestnet'                                                   as system_name
    , {{ "'" ~ src ~ "'" }}                                       as system_instance
    , concat(system_name , '__' , system_instance)                as system_key
    , {{ envestnet_instance_map(src) }}                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)          as record_type
    , nullif(split_part(content , '|' , 2), '')::int              as fee_schedule_id
    , nullif(split_part(content , '|' , 3), '')::int              as fee_component_type
    , nullif(split_part(content , '|' , 4), '')::int              as filter_type
    , nullif(split_part(content , '|' , 5), '')::int              as start_range
    , nullif(split_part(content , '|' , 6), '')::decimal(18 , 4)  as rate_percent
    , nullif(split_part(content , '|' , 7), '')::decimal(18 , 2)  as rate_dollars
    , nullif(split_part(content , '|' , 8), '')::int              as fee_filter_id
    , nullif(split_part(content , '|' , 9), '')::decimal(18 , 4)  as min_fee_percent
    , nullif(split_part(content , '|' , 10), '')::decimal(18 , 2) as min_fee_dollars
    , nullif(split_part(content , '|' , 11), '')::decimal(18 , 4) as max_fee_percent
    , nullif(split_part(content , '|' , 12), '')::decimal(18 , 2) as max_fee_dollars
    , nullif(split_part(content , '|' , 13), '')::decimal(18 , 4) as soft_min_percent
    , effective_date                                              as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'accountfeeschedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                 as _created_at
    , _source_file                                                as _source_file
from {{ source('envestnet_' + src, 'accountfeeschedule') }}
where split_part(content , '|' , 1) = 'D'
{%- endmacro -%}
