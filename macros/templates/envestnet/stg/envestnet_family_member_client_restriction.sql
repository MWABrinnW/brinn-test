{%- macro envestnet_family_member_client_restriction(src) -%}
select
    'envestnet'                                                as system_name
    , {{ "'" ~ src ~ "'" }}                                    as system_instance
    , concat(system_name , '__' , system_instance)             as system_key
    , {{ envestnet_instance_map(src) }}                        as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as restriction_id
    , nullif(split_part(content , '|' , 3), '')::int           as customer_id
    , nullif(split_part(content , '|' , 4), '')::int           as restriction_type
    , nullif(split_part(content , '|' , 5), '')::int           as entity_id
    , nullif(split_part(content , '|' , 6), '')::date          as issued_on
    , nullif(split_part(content , '|' , 7), '')::date          as expired_on
    , nullif(split_part(content , '|' , 8), '')::varchar(2048) as memo
    , nullif(split_part(content , '|' , 9), '')::varchar(256)  as updated_by
    , nullif(split_part(content , '|' , 10), '')::varchar(50)  as restricted_value
    , nullif(split_part(content , '|' , 11), '')::int          as restriction_source
    , nullif(split_part(content , '|' , 12) , '')::date        as updated_on
    , effective_date                                           as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'familymember')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                              as _created_at
    , _source_file                                             as _source_file
from {{ source('envestnet_' + src, 'familymember') }}
where split_part(content , '|' , 1) = 'R'

{%- endmacro -%}
