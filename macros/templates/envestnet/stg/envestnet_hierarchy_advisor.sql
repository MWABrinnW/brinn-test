{%- macro envestnet_hierarchy_advisor(src) -%}
select
    'envestnet'                                                as system_name
    , {{ "'" ~ src ~ "'" }}                                    as system_instance
    , concat(system_name , '__' , system_instance)             as system_key
    , {{ envestnet_instance_map(src) }}                        as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as advisor_id
    , nullif(split_part(content , '|' , 3), '')::varchar(64)   as first_name
    , nullif(split_part(content , '|' , 4), '')::varchar(64)   as middle_name
    , nullif(split_part(content , '|' , 5), '')::varchar(128)  as last_name
    , nullif(split_part(content , '|' , 6), '')::varchar(64)   as rep_code
    , nullif(split_part(content , '|' , 7), '')::varchar(50)   as username
    , nullif(split_part(content , '|' , 8), '')::int           as enterprise_id
    , nullif(split_part(content , '|' , 9), '')::int           as firm_id
    , nullif(split_part(content , '|' , 10), '')::int          as branch_id
    , nullif(split_part(content , '|' , 11), '')::varchar(50)  as entitlement
    , nullif(split_part(content , '|' , 12), '')::varchar(16)  as manager_rep_code
    , nullif(split_part(content , '|' , 13), '')::varchar(64)  as ssn_number
    , nullif(split_part(content , '|' , 14), '')::date         as date_of_birth
    , nullif(split_part(content , '|' , 15), '')::varchar(16)  as crd_number
    , nullif(split_part(content , '|' , 16), '')::varchar(128) as dba_name
    , nullif(split_part(content , '|' , 17), '')::date         as start_date
    , nullif(split_part(content , '|' , 18), '')::date         as termination_date
    , nullif(split_part(content , '|' , 19), '')::varchar      as termination_reason
    , nullif(split_part(content , '|' , 20), '')::varchar(2)   as home_state
    , nullif(split_part(content , '|' , 21), '')::varchar(100) as sso_username
    , nullif(split_part(content , '|' , 22), '')::varchar(100) as alternate_sso_username
    , nullif(split_part(content , '|' , 23), '')::varchar      as selected_advisors
    , nullif(split_part(content , '|' , 24), '')::int          as advisor_status
    , nullif(split_part(content , '|' , 25), '')::varchar(16)  as advisor_code
    , nullif(split_part(content , '|' , 26), '')::varchar(250) as advisor_v2_handle
    , nullif(split_part(content , '|' , 27), '')::varchar(50)  as aoe_sso_id
    , effective_date                                           as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'hierarchy')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                              as _created_at
    , _source_file                                             as _source_file
from {{ source('envestnet_' + src, 'hierarchy') }}
where split_part(content , '|' , 1) = 'A'
{%- endmacro -%}
