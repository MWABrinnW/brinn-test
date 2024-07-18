{%- macro envestnet_account_fee_schedule_fee_schedule(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)          as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as account_id
    , nullif(split_part(content , '|' , 3), '')::varchar(32)   as account_number
    , nullif(split_part(content , '|' , 4), '')::int           as fee_schedule_id
    , nullif(split_part(content , '|' , 5), '')::int           as billing_mode_id
    , nullif(split_part(content , '|' , 6), '')::varchar(1024) as fee_notes
    , nullif(split_part(content , '|' , 7), '')::char(1)       as has_custom_service_fee
    , nullif(split_part(content , '|' , 8), '')::int           as billing_frequency
    , nullif(split_part(content , '|' , 9), '')::varchar(256)  as source_rule_name
    , nullif(split_part(content , '|' , 10), '')::date         as soft_minimum_waiver_start_date
    , nullif(split_part(content , '|' , 11), '')::date         as soft_minimum_waiver_end_date
    , nullif(split_part(content , '|' , 12), '')::char(1)      as soft_minimum_waiver_source
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'accountfeeschedule')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'accountfeeschedule') }}
where split_part(content , '|' , 1) = 'A'
{%- endmacro -%}
