{%- macro envestnet_proposal_registration_owner(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)                as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as proposal_group_id
    , nullif(split_part(content , '|' , 3), '')::int           as proposal_id
    , nullif(split_part(content , '|' , 4), '')::int           as customer_registration_id
    , nullif(split_part(content , '|' , 5), '')::int      as owner_type
    , nullif(split_part(content , '|' , 6), '')::varchar(25)   as entity_type
    , nullif(split_part(content , '|' , 7), '')::varchar(20)   as prefix
    , nullif(split_part(content , '|' , 8), '')::varchar(64)   as first_name
    , nullif(split_part(content , '|' , 9), '')::varchar(64)   as middle_name
    , nullif(split_part(content , '|' , 10), '')::varchar(64)  as last_name
    , nullif(split_part(content , '|' , 11), '')::varchar(16)  as ssn_tax_id
    , nullif(split_part(content , '|' , 12), '')::int          as ssn_tax_id_flag
    , nullif(split_part(content , '|' , 13), '')::date         as date_of_birth
    , nullif(split_part(content , '|' , 14), '')::varchar(128) as address_line1
    , nullif(split_part(content , '|' , 15), '')::varchar(128) as address_line2
    , nullif(split_part(content , '|' , 16), '')::varchar(64)  as city
    , nullif(split_part(content , '|' , 17), '')::varchar(64)  as state
    , nullif(split_part(content , '|' , 18), '')::varchar(24)  as zip_code
    , nullif(split_part(content , '|' , 19), '')::varchar(24)  as country
    , nullif(split_part(content , '|' , 20), '')::varchar(256) as email
    , nullif(split_part(content , '|' , 21), '')::varchar(24)  as phone_day
    , nullif(split_part(content , '|' , 22), '')::varchar(24)  as phone_evening
    , nullif(split_part(content , '|' , 23), '')::varchar(30)  as identification_number
    , nullif(split_part(content , '|' , 24), '')::int          as family_member_id
    , nullif(split_part(content , '|' , 25), '')::int          as address_type
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'proposal') }}
where split_part(content , '|' , 1) = 'E'
{%- endmacro -%}
