{%- macro envestnet_tax_lots(src) -%}
select
    'envestnet'                                       as system_name
    , {{ "'" ~ src ~ "'" }}                                              as system_instance
    , concat(system_name , '__' , system_instance)    as system_key
    , {{ envestnet_instance_map(src) }}                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::int              as account_id
    , nullif(split_part(content , '|' , 2), '')::varchar(32)      as account_number
    , nullif(split_part(content , '|' , 3), '')::date             as as_of_date
    , nullif(split_part(content , '|' , 4), '')::int              as security_id
    , nullif(split_part(content , '|' , 5), '')::varchar(22)      as cusip
    , nullif(split_part(content , '|' , 6), '')::varchar(22)      as ticker
    , nullif(split_part(content , '|' , 7), '')::decimal(19 , 8)  as quantity
    , nullif(split_part(content , '|' , 8), '')::decimal(18 , 2)  as market_value
    , nullif(split_part(content , '|' , 9), '')::decimal(18 , 2)  as total_cost
    , nullif(split_part(content , '|' , 10), '')::decimal(18 , 6) as market_price
    , nullif(split_part(content , '|' , 11), '')::date            as purchase_date
    , nullif(split_part(content , '|' , 12), '')::decimal(18 , 2) as accrued_income
    , nullif(split_part(content , '|' , 13), '')::decimal(18 , 2) as accrued_interest
    , nullif(split_part(content , '|' , 14), '')::int             as unsupervised_indicator
    , nullif(split_part(content , '|' , 15), '')::int             as short_position_indicator
    -- Skipping ITD Performance and Inception Date as they are deprecated
    , nullif(split_part(content , '|' , 18), '')::varchar(4)      as security_type
    , nullif(split_part(content , '|' , 19), '')::int             as security_style
    , nullif(split_part(content , '|' , 20), '')::varchar(3)      as currency
    , nullif(split_part(content , '|' , 21), '')::varchar(3)      as tax_currency
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'taxlots')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                     as _created_at
    , _source_file                                    as _source_file
from {{ source('envestnet_' + src, 'taxlots') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records
{%- endmacro -%}
