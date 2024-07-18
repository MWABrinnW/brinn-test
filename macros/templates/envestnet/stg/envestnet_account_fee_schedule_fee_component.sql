{%- macro envestnet_account_fee_schedule_fee_component(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)         as record_type
    , nullif(split_part(content , '|' , 2), '')::int             as fee_schedule_id
    , nullif(split_part(content , '|' , 3), '')::int             as fee_component_type
    , nullif(split_part(content , '|' , 4), '')::int             as is_derived_component
    , nullif(split_part(content , '|' , 5), '')::decimal(18 , 2) as fee_minimum
    , nullif(split_part(content , '|' , 6), '')::decimal(18 , 2) as fee_maximum
    , nullif(split_part(content , '|' , 7), '')::int             as is_linear
    , nullif(split_part(content , '|' , 8), '')::int             as is_household
    , nullif(split_part(content , '|' , 9), '')::int             as asset_calculation_method
    , nullif(split_part(content , '|' , 10), '')::int            as aum_fee_schedule_id
    , nullif(split_part(content , '|' , 11), '')::int            as aum_method
    , nullif(split_part(content , '|' , 12), '')::varchar(256)   as aum_rule
    , nullif(split_part(content , '|' , 13), '')::int            as fee_paid_by
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'accountfeeschedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src , 'accountfeeschedule') }}
where split_part(content , '|' , 1) = 'B'
{%- endmacro -%}
