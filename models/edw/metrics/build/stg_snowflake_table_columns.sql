{{
  config(
    materialized = 'table'
  )
}}

with columns as (

    select
        lower(table_catalog)        as database_name
        , lower(table_schema)       as schema_name
        , lower(table_name)         as table_name
        , lower(table_catalog)
        || '.' || lower(table_schema)
        || '.' || lower(table_name) as fq_name
        , lower(column_name)        as column_name
        , ordinal_position          as ordinal_position
        , column_default            as column_default
        , lower(data_type)          as data_type
        , character_maximum_length  as character_maximum_length
        , character_octet_length    as character_octet_length
        , numeric_precision         as numeric_precision
        , numeric_scale             as numeric_scale
        , datetime_precision        as datetime_precision
        , comment                   as comment
        , is_identity               as is_identity
        , identity_ordered          as identity_ordered
        , identity_generation       as identity_generation
        , identity_start            as identity_start
        , identity_increment        as identity_increment
        , identity_maximum          as identity_maximum
        , identity_minimum          as identity_minimum
        , identity_cycle            as identity_cycle
    from {{ source('snowflake_internal', 'columns') }}
    where true
        -- exclude deleted columns (deleted is a timestamp field)
        and deleted is null
        and fq_name is not null

)

, keyed as (

    select
        *
        , concat(
            database_name
            , '.' , schema_name
            , '.' , table_name
            , '.' , column_name
        ) as table_column_key
        , concat(
            database_name
            , '.' , schema_name
            , '.' , table_name
        ) as table_key

    from columns

)

select * from keyed
