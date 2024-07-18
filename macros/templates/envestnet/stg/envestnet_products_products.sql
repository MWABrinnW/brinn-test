{%- macro envestnet_products_products(src) -%}
select
    'envestnet'                                                  as system_name
    , {{ "'" ~ src ~ "'" }}                                      as system_instance
    , concat(system_name , '__' , system_instance)               as system_key
    , {{ envestnet_instance_map(src) }}                          as firm_source
    , nullif(split_part(content , '|' , 1), '')::char(1)       as record_type
    , nullif(split_part(content , '|' , 2), '')::int           as product_id
    , nullif(split_part(content , '|' , 3), '')::varchar(128)  as product_name
    , nullif(split_part(content , '|' , 4), '')::varchar(128)  as manager_name
    , nullif(split_part(content , '|' , 5), '')::int       as product_type_id
    , nullif(split_part(content , '|' , 6), '')::int       as tax_efficiency
    , nullif(split_part(content , '|' , 7), '')::int           as risk_rating
    , nullif(split_part(content , '|' , 8), '')::date          as last_model_change_date
    , nullif(split_part(content , '|' , 9), '')::int           as status
    , nullif(split_part(content , '|' , 10), '')::int          as imr_status
    , nullif(split_part(content , '|' , 11), '')::int          as account_minimum
    , nullif(split_part(content , '|' , 12), '')::int          as style_type
    , nullif(split_part(content , '|' , 13), '')::varchar(3)   as currency
    , nullif(split_part(content , '|' , 14), '')::int          as portfolio_id
    , nullif(split_part(content , '|' , 15), '')::varchar(128) as portfolio_name
    , nullif(split_part(content , '|' , 16), '')::int          as manager_firm_id
    , nullif(split_part(content , '|' , 17), '')::varchar(128) as manager_firm_name
    , nullif(split_part(content , '|' , 18), '')::int          as sleeve_security_id
    , nullif(split_part(content , '|' , 19), '')::int          as dashboard_product_type
    , nullif(split_part(content , '|' , 20), '')::int          as product_class_id
    , nullif(split_part(content , '|' , 21), '')::int     as pricing_tier
    , nullif(split_part(content , '|' , 22), '')::int          as overlay_product_id
    , nullif(split_part(content , '|' , 23), '')::varchar(128) as overlay_product_name
    , nullif(split_part(content , '|' , 24), '')::varchar(22)  as ticker
    , nullif(split_part(content , '|' , 25), '')::varchar(32)  as product_risk_method
    , nullif(split_part(content , '|' , 26), '')::varchar(32)  as portfolio_risk_method
    , nullif(split_part(content , '|' , 27), '')::varchar(128) as program_id
    , nullif(split_part(content , '|' , 28), '')::varchar(80)  as benchmark
    , nullif(split_part(content , '|' , 29), '')::int          as benchmark_id
    , nullif(split_part(content , '|' , 30), '')::int      as index_type
    , nullif(split_part(content , '|' , 31), '')::int      as index_scope
    , nullif(split_part(content , '|' , 32), '')::varchar(250) as product_v2_handle
    , effective_date                                             as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'products')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                as _created_at
    , _source_file                                               as _source_file
from {{ source('envestnet_' + src, 'products') }}
where split_part(content , '|' , 1) = 'A'
{%- endmacro -%}
