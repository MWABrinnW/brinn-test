{%- macro envestnet_hierarchy_firm(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as firm_id
    , nullif(split_part(content , '|' , 3), '')::varchar(128)  as firm_name
    , nullif(split_part(content , '|' , 4), '')::varchar(20)   as firm_short_name
    , nullif(split_part(content , '|' , 5), '')::int           as enterprise_id
    , nullif(split_part(content , '|' , 6), '')::varchar(64)   as broker_symbol
    , nullif(split_part(content , '|' , 7), '')::varchar(16)   as crd_number
    , nullif(split_part(content , '|' , 8), '')::int       as bank_account_type
    , nullif(split_part(content , '|' , 9), '')::varchar(128)  as bank_name
    , nullif(split_part(content , '|' , 10), '')::varchar(64)  as bank_account_number
    , nullif(split_part(content , '|' , 11), '')::varchar(128) as bank_account_name
    , nullif(split_part(content , '|' , 12), '')::varchar(64)  as aba_routing_no
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'hierarchy')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'hierarchy') }}
where split_part(content , '|' , 1) = 'F'
{%- endmacro -%}
