{%- macro envestnet_proposal_investment(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)                as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as proposal_group_id
    , nullif(split_part(content , '|' , 3), '')::int           as proposal_id
    , nullif(split_part(content , '|' , 4), '')::int           as customer_registration_id
    , nullif(split_part(content , '|' , 5), '')::int           as product_id
    , nullif(split_part(content , '|' , 6), '')::varchar(128)  as product_name
    , nullif(split_part(content , '|' , 7), '')::float         as allocation_percentage
    , nullif(split_part(content , '|' , 8), '')::int           as product_type_id
    , nullif(split_part(content , '|' , 9), '')::int           as limited_partnership
    , nullif(split_part(content , '|' , 10), '')::int          as discretion
    , nullif(split_part(content , '|' , 11), '')::varchar(256) as program
    , nullif(split_part(content , '|' , 12), '')::int          as pricing_tier
    , nullif(split_part(content , '|' , 13), '')::varchar(250) as product_overlay_feature
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'proposal') }}
where split_part(content , '|' , 1) = 'F'
{%- endmacro -%}
