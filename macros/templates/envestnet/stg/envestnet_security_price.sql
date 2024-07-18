{%- macro envestnet_security_price(src) -%}
select
    'envestnet'                                      as system_name
    , {{ "'" ~ src ~ "'" }}                                             as system_instance
    , concat(system_name , '__' , system_instance)   as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::int             as security_id
    , nullif(split_part(content , '|' , 2), '')::varchar(22)     as cusip
    , nullif(split_part(content , '|' , 3), '')::varchar(22)     as ticker
    , nullif(split_part(content , '|' , 4), '')::int             as pricing_custodian
    , nullif(split_part(content , '|' , 5), '')::date            as price_date
    , nullif(split_part(content , '|' , 6), '')::decimal(18 , 6) as price
    , nullif(split_part(content , '|' , 7), '')::varchar(3)      as currency
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'securityprice')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                    as _created_at
    , _source_file                                   as _source_file
from {{ source('envestnet_' + src, 'securityprice') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records
{%- endmacro -%}
