{%- macro envestnet_family_member_family(src) -%}
select
    'envestnet'                                                as system_name
    , {{ "'" ~ src ~ "'" }}                                    as system_instance
    , concat(system_name , '__' , system_instance)             as system_key
    , {{ envestnet_instance_map(src) }}                        as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as family_customer_id
    , nullif(split_part(content , '|' , 3), '')::varchar(150)  as family_name
    , nullif(split_part(content , '|' , 4), '')::varchar(16)   as split_rep_code
    , nullif(split_part(content , '|' , 5), '')::char(1)       as disable_qpr_download_flag
    , nullif(split_part(content , '|' , 6), '')::char(1)       as disable_access_qpr_flag
    , nullif(split_part(content , '|' , 7), '')::char(1)       as sample_client_flag
    , nullif(split_part(content , '|' , 8), '')::varchar(150)  as external_unique_id
    , nullif(split_part(content , '|' , 9), '')::varchar(250)  as client_v2_handle
    , effective_date                                           as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'familymember')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                              as _created_at
    , _source_file                                             as _source_file
from {{ source('envestnet_' + src, 'familymember') }}
where split_part(content , '|' , 1) = 'F'

{%- endmacro -%}
