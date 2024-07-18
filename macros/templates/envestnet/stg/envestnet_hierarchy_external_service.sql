{%- macro envestnet_hierarchy_external_service(src) -%}
    SELECT
          'envestnet'                                    as system_name
        , {{ "'" ~ src ~ "'" }}                                             as system_instance
        , concat(system_name , '__' , system_instance)   as system_key
        , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content, '|', 1), '')::char(1) as record_type
    , nullif(split_part(content, '|', 2), '')::int as firm_id
    , nullif(split_part(content, '|', 3), '')::int as branch_id
    , nullif(split_part(content, '|', 4), '')::int as advisor_id
    , nullif(split_part(content, '|', 5), '')::int as service_id
    , nullif(split_part(content, '|', 6), '')::varchar(100) as service_username
        , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'hierarchy')) }}
        , {{ col_is_current(date_col='effective_date') }}
        , _created_at                                    as _created_at
        , _source_file                                   as _source_file
from {{ source('envestnet_' + src, 'hierarchy') }}
where split_part(content, '|', 1) = 'S'
{%- endmacro -%}


envestnet_hierarchy_firm_external_service
