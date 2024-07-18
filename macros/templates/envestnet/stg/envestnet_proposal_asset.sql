{%- macro envestnet_proposal_asset(src) -%}
select
    'envestnet'                                      as system_name
    , {{ "'" ~ src ~ "'" }}                                             as system_instance
    , concat(system_name , '__' , system_instance)   as system_key
    , {{ envestnet_instance_map(src) }}                                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)                  as record_type
    , nullif(split_part(content , '|' , 2), '')::int             as proposal_group_id
    , nullif(split_part(content , '|' , 3), '')::int             as proposal_id
    , nullif(split_part(content , '|' , 4), '')::varchar(24)     as asset_account_number
    , nullif(split_part(content , '|' , 5), '')::varchar(22)     as ticker
    , nullif(split_part(content , '|' , 6), '')::varchar(128)    as asset_description
    , nullif(split_part(content , '|' , 7), '')::varchar(128)    as asset_style
    , nullif(split_part(content , '|' , 8), '')::decimal(18 , 4) as asset_quantity
    , nullif(split_part(content , '|' , 9), '')::decimal(18 , 2) as asset_market_value
    , nullif(split_part(content , '|' , 10), '')::int            as investable_flag
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'proposal')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                    as _created_at
    , _source_file                                   as _source_file
from {{ source('envestnet_' + src, 'proposal') }}
where split_part(content , '|' , 1) = 'G'
{%- endmacro -%}
