{%- macro envestnet_family_member_investment_group_restriction(src) -%}
select
    'envestnet'                                                                                   as system_name
    , {{ "'" ~ src ~ "'" }}                                                                       as system_instance
    , concat(system_name , '__' , system_instance)                                                as system_key
    , {{ envestnet_instance_map(src) }}                                                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)                                          as record_type
    , nullif(split_part(content , '|' , 2), '')::int                                              as goal_id
    , nullif(split_part(content , '|' , 3), '')::varchar(128)                                     as goal_name
    , nullif(split_part(content , '|' , 4), '')::int                                              as restriction_type
    , nullif(split_part(content , '|' , 5), '')::varchar(50)                                      as restricted_value
    , nullif(split_part(content , '|' , 6), '')::varchar(2048)                                    as memo
    , nullif(split_part(content , '|' , 7), '')::varchar(50)                                      as buy_restriction
    , nullif(split_part(content , '|' , 8), '')::varchar(50)                                      as sell_restriction
    , to_timestamp(nullif(split_part(content , '|' , 9) , 'MM/DD/YYYY HH:MI AM'), '')::timestamp  as issued_on
    , nullif(split_part(content , '|' , 10), '')::date                                            as expired_on
    , nullif(split_part(content , '|' , 11), '')::varchar(256)                                    as updated_by
    , to_timestamp(nullif(split_part(content , '|' , 12) , 'MM/DD/YYYY HH:MI AM'), '')::timestamp as updated_on
    , effective_date                                                                              as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'familymember')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                                                 as _created_at
    , _source_file                                                                                as _source_file
from {{ source('envestnet_' + src, 'familymember') }}
where split_part(content , '|' , 1) = 'I'

{%- endmacro -%}
