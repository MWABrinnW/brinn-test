{%- macro envestnet_account_fee_schedule_fee_filter(src) -%}
select
    'envestnet'                                                   as system_name
    , {{ "'" ~ src ~ "'" }}                                       as system_instance
    , concat(system_name , '__' , system_instance)                as system_key
    , {{ envestnet_instance_map(src) }}                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)          as record_type
    , nullif(split_part(content , '|' , 2), '')::int              as fee_schedule_id
    , nullif(split_part(content , '|' , 3), '')::int              as fee_component_type
    , nullif(split_part(content , '|' , 4), '')::int              as filter_type
    , nullif(split_part(content , '|' , 5), '')::varchar          as filter_value
    , nullif(split_part(content , '|' , 6), '')::char(1)          as is_exclusion_discount_custom_fee
    , nullif(split_part(content , '|' , 7), '')::date             as exclusion_end_date
    , nullif(split_part(content , '|' , 8), '')::char(1)          as advisor_cannot_edit
    , nullif(split_part(content , '|' , 9), '')::varchar(128)     as description
    , nullif(split_part(content , '|' , 10), '')::varchar(50)     as registration_type
    , nullif(split_part(content , '|' , 11), '')::decimal(18 , 4) as exclusion_factor
    , nullif(split_part(content , '|' , 12), '')::varchar(20)     as exclusion_factory_type
    , nullif(split_part(content , '|' , 13), '')::decimal(18 , 2) as cumulative_discount_cap
    , nullif(split_part(content , '|' , 14), '')::int             as adjust_discount_to
    , nullif(split_part(content , '|' , 15), '')::int             as fee_filter_id
    , nullif(split_part(content , '|' , 16), '')::decimal(18 , 2) as remaining_cumulative_discount_cap
    , nullif(split_part(content , '|' , 17), '')::char(1)         as exclusion_source
    , effective_date                                              as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'accountfeeschedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                 as _created_at
    , _source_file                                                as _source_file
from {{ source('envestnet_' + src, 'accountfeeschedule') }}
where split_part(content , '|' , 1) = 'C'
{%- endmacro -%}
