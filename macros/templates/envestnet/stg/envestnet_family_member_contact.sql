{%- macro envestnet_family_member_contact(src) -%}
select
    'envestnet'                                                as system_name
    , {{ "'" ~ src ~ "'" }}                                    as system_instance
    , concat(system_name , '__' , system_instance)             as system_key
    , {{ envestnet_instance_map(src) }}                        as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as owner_id
    , nullif(split_part(content , '|' , 3), '')::int           as owner_type
    , nullif(split_part(content , '|' , 4), '')::int           as contact_type
    , nullif(split_part(content , '|' , 5), '')::varchar(128)  as contact_name
    , nullif(split_part(content , '|' , 6), '')::int           as address_type
    , nullif(split_part(content , '|' , 7), '')::varchar(128)  as address_line_1
    , nullif(split_part(content , '|' , 8), '')::varchar(128)  as address_line_2
    , nullif(split_part(content , '|' , 9), '')::varchar(64)   as city
    , nullif(split_part(content , '|' , 10), '')::varchar(64)  as state
    , nullif(split_part(content , '|' , 11), '')::varchar(24)  as zip
    , nullif(split_part(content , '|' , 12), '')::varchar(64)  as country
    , nullif(split_part(content , '|' , 13), '')::varchar(64)  as phone_1
    , nullif(split_part(content , '|' , 14), '')::varchar(64)  as phone_2
    , nullif(split_part(content , '|' , 15), '')::varchar(64)  as fax
    , nullif(split_part(content , '|' , 16), '')::varchar(256) as email
    , nullif(split_part(content , '|' , 17), '')::int          as use_as_qpr_mailing_address
    , effective_date                                           as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'familymember')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                              as _created_at
    , _source_file                                             as _source_file
from {{ source('envestnet_' + src, 'familymember') }}
where split_part(content , '|' , 1) = 'C'

{%- endmacro -%}
