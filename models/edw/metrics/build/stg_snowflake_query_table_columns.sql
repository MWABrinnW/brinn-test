{{
  config(
    materialized = 'incremental'
    , unique_key = 'query_id'
  )
}}

with access_history as (

    -- a query can reference the same table and-or columns multiple times
    select distinct
        queries.query_id                                             as query_id
        , queries.start_at                                           as start_at
        , lower(queries.user_name)                                   as user_name
        , lower(split_part(tables.value:objectName::text , '.' , 1)) as database_name
        , lower(split_part(tables.value:objectName::text , '.' , 2)) as schema_name
        , lower(split_part(tables.value:objectName::text , '.' , 3)) as table_name
        , lower(database_name)
        || '.' || lower(schema_name)
        || '.' || lower(table_name)                                  as fq_name
        , lower(table_columns.value:columnName)                      as column_name

    from {{ ref('stg_snowflake_access_history') }} as queries
    , lateral flatten(queries.direct_objects_accessed) as tables
    , lateral flatten(tables.value:columns) as table_columns

    where true
        and fq_name is not null
        and queries.start_at::date >= current_date() - 120

        {% if is_incremental() %}
            and queries.start_at > (select max(t.start_at) from {{ this }} as t)
        {% endif %}

        {% if target.name != 'prod' %}
            and queries.start_at::date >= current_date() - 7
        {% endif %}

)

, keyed as (

    select
        *
        , md5(
            concat(
                query_id
                , '-' , database_name
                , '.' , schema_name
                , '.' , table_name
                , '.' , column_name
            )
        ) as query_table_column_key
        , md5(
            concat(
                query_id
                , '-' , database_name
                , '.' , schema_name
                , '.' , table_name
            )
        ) as query_table_key
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

    from access_history

)

select * from keyed
