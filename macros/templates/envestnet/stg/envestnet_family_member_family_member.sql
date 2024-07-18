{%- macro envestnet_family_member_family_member(src) -%}
select
    'envestnet'                                                as system_name
    , {{ "'" ~ src ~ "'" }}                                    as system_instance
    , concat(system_name , '__' , system_instance)             as system_key
    , {{ envestnet_instance_map(src) }}                        as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as family_customer_id
    , nullif(split_part(content , '|' , 3), '')::int           as entity_type
    , nullif(split_part(content , '|' , 4), '')::int           as family_member_id
    , nullif(split_part(content , '|' , 5), '')::varchar(64)   as first_name
    , nullif(split_part(content , '|' , 6), '')::varchar(64)   as middle_name
    , nullif(split_part(content , '|' , 7), '')::varchar(64)   as last_name
    , nullif(split_part(content , '|' , 8), '')::int           as salutation
    , nullif(split_part(content , '|' , 9), '')::int           as relationship
    , nullif(split_part(content , '|' , 10), '')::date         as date_of_birth
    , nullif(split_part(content , '|' , 11), '')::int          as gender
    , nullif(split_part(content , '|' , 12), '')::int          as marital_status
    , nullif(split_part(content , '|' , 13), '')::int          as dependents
    , nullif(split_part(content , '|' , 14), '')::varchar(16)  as ssn_tin
    , nullif(split_part(content , '|' , 15), '')::int          as employment_status
    , nullif(split_part(content , '|' , 16), '')::varchar(32)  as occupation
    , nullif(split_part(content , '|' , 17), '')::varchar(35)  as income_source
    , nullif(split_part(content , '|' , 18), '')::varchar(35)  as employer_name
    , nullif(split_part(content , '|' , 19), '')::int          as years_employed
    , nullif(split_part(content , '|' , 20), '')::int          as country_of_citizenship
    , nullif(split_part(content , '|' , 21), '')::int          as tax_residence_country
    , nullif(split_part(content , '|' , 22), '')::varchar(150) as external_member_code
    , nullif(split_part(content , '|' , 23), '')::varchar(250) as family_member_v2_handle
    , effective_date                                           as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'familymember')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                              as _created_at
    , _source_file                                             as _source_file
from {{ source('envestnet_' + src, 'familymember') }}
where split_part(content , '|' , 1) = 'M'

{%- endmacro -%}
