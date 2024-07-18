{%- macro envestnet_proposal_proposal(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)                as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as proposal_group_id
    , nullif(split_part(content , '|' , 3), '')::varchar(64)   as rep_code
    , nullif(split_part(content , '|' , 4), '')::date          as updated_date
    , nullif(split_part(content , '|' , 5), '')::varchar(32)   as proposal_type
    , nullif(split_part(content , '|' , 6), '')::varchar(128)  as title
    , nullif(split_part(content , '|' , 7), '')::int           as advisor_id
    , nullif(split_part(content , '|' , 8), '')::varchar(128)  as advisor_name
    , nullif(split_part(content , '|' , 9), '')::varchar(3)    as client_currency
    , nullif(split_part(content , '|' , 10), '')::int      as status
    , nullif(split_part(content , '|' , 11), '')::date         as created_date
    , nullif(split_part(content , '|' , 12), '')::int          as customer_id
    , nullif(split_part(content , '|' , 13), '')::varchar(64)  as city
    , nullif(split_part(content , '|' , 14), '')::varchar(64)  as state
    , nullif(split_part(content , '|' , 15), '')::varchar(24)  as zip
    , nullif(split_part(content , '|' , 16), '')::varchar(64)  as integration_code
    , nullif(split_part(content , '|' , 17), '')::varchar(250) as proposal_v2_handle
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'proposal') }}
where split_part(content , '|' , 1) = 'A'
{%- endmacro -%}
