{{
  config(
    materialized = 'table'
  )
}}

with tables as (

    select
        lower(table_catalog)         as database_name
        , lower(table_schema)        as schema_name
        , lower(table_name)          as table_name
        , lower(table_catalog)
        || '.' || lower(table_schema)
        || '.' || lower(table_name)  as fq_name
        , lower(table_catalog)       as table_catalog
        , lower(table_owner)         as table_owner
        , case
            when table_type = 'BASE TABLE' then 'table'
            else lower(table_type)
        end                          as table_type
        , created                    as created_at
        , last_altered               as last_altered_at
        , clustering_key             as clustering_key
        , row_count                  as row_count
        , bytes                      as bytes
        , round(bytes / 1000000 , 2) as megabytes
        , is_transient = 'YES'       as is_transient
        , auto_clustering_on = 'YES' as is_auto_clustering_on
    from {{ source('snowflake_internal', 'tables') }}
    where true
        and deleted is null
        and fq_name is not null
)

, keyed as (

    select
        *
        , fq_name as table_key
    from tables

)

select * from keyed
