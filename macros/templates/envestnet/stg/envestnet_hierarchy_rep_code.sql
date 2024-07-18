{%- macro envestnet_hierarchy_rep_code(src) -%}
select
    'envestnet'                                       as system_name
    , {{ "'" ~ src ~ "'" }}                                              as system_instance
    , concat(system_name , '__' , system_instance)    as system_key
    , {{ envestnet_instance_map(src) }}                                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)          as record_type
    , nullif(split_part(content , '|' , 2), '')::int              as rep_code_id
    , nullif(split_part(content , '|' , 3), '')::varchar(16)      as rep_code
    , nullif(split_part(content , '|' , 4), '')::varchar(16)      as branch_code
    , nullif(split_part(content , '|' , 5), '')::int          as is_split_rep_code
    , nullif(split_part(content , '|' , 6), '')::int              as firm_id
    , nullif(split_part(content , '|' , 7), '')::int              as enterprise_id
    , nullif(split_part(content , '|' , 8), '')::int              as branch_id
    , nullif(split_part(content , '|' , 9), '')::varchar(16)      as participating_rep_code
    , nullif(split_part(content , '|' , 10), '')::decimal(18 , 4) as percentage
    , nullif(split_part(content , '|' , 11), '')::varchar(256)    as rep_code_description
    , nullif(split_part(content , '|' , 12), '')::int         as is_primary
    , nullif(split_part(content , '|' , 13), '')::int         as is_default
    , nullif(split_part(content , '|' , 14), '')::int             as ensemble_id
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'hierarchy')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                     as _created_at
    , _source_file                                    as _source_file
from {{ source('envestnet_' + src, 'hierarchy') }}
where split_part(content , '|' , 1) = 'R'
{%- endmacro -%}
