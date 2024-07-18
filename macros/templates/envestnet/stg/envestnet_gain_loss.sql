{%- macro envestnet_gain_loss(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::int             as account_id
    , nullif(split_part(content , '|' , 2), '')::varchar(32)     as account_number
    , nullif(split_part(content , '|' , 3), '')::int             as security_id
    , nullif(split_part(content , '|' , 4), '')::varchar(22)     as cusip
    , nullif(split_part(content , '|' , 5), '')::varchar(22)     as ticker
    , nullif(split_part(content , '|' , 6), '')::date            as sale_date
    , nullif(split_part(content , '|' , 7), '')::decimal(18 , 2) as proceeds
    , nullif(split_part(content , '|' , 8), '')::decimal(19 , 8) as sale_units
    , nullif(split_part(content , '|' , 9), '')::decimal(18 , 2) as total_cost
    , nullif(split_part(content , '|' , 10), '')::date           as purchase_date
    , nullif(split_part(content , '|' , 11), '')::int            as unsupervised_indicator
    , nullif(split_part(content , '|' , 12), '')::int            as short_position_indicator
    , nullif(split_part(content , '|' , 13), '')::varchar(3)     as tax_currency
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'gainloss')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'gainloss') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records
{%- endmacro -%}
