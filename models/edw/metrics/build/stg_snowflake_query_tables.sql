{{
  config(
    materialized = 'incremental'
    , unique_key = 'query_table_key'
  )
}}

with snowflake_access_history as (

    -- a query can reference the same object multiple times
    select distinct
        ah.query_id                                                            as query_id
        , ah.start_at                                                          as start_at
        , q.end_at                                                             as end_at
        , lower(ah.user_name)                                                  as user_name
        , q.role_name                                                          as role_name
        , lower(split_part(objects_accessed.value:objectName::text , '.' , 1)) as database_name
        , lower(split_part(objects_accessed.value:objectName::text , '.' , 2)) as schema_name
        , lower(split_part(objects_accessed.value:objectName::text , '.' , 3)) as table_name
        , database_name
        || '.' || schema_name
        || '.' || table_name                                                   as fq_name
        , lower(objects_accessed.value:objectDomain::string)                   as table_type
        , objects_accessed.value:columns                                       as columns_array

        , q.query_type                                                         as query_type
        , q.execution_status                                                   as execution_status
        , q.error_code                                                         as error_code
        , q.error_message                                                      as error_message
        , q.warehouse_id                                                       as warehouse_id
        , q.warehouse_name                                                     as warehouse_name
        , q.warehouse_size                                                     as warehouse_size
        , q.warehouse_type                                                     as warehouse_type
        , q.query_tag                                                          as query_tag
        , q.is_tooling_user                                                    as is_tooling_user
        , q.cluster_number                                                     as cluster_number
        , q.duration_seconds                                                   as duration_seconds
        , q.compilation_seconds                                                as compilation_seconds
        , q.execution_seconds                                                  as execution_seconds
        , q.queued_provisioning_seconds                                        as queued_provisioning_seconds
        , q.queued_repair_seconds                                              as queued_repair_seconds
        , q.queued_overload_seconds                                            as queued_overload_seconds
        , q.transaction_blocked_seconds                                        as transaction_blocked_seconds
        , q.bytes_scanned                                                      as bytes_scanned
    from {{ ref('stg_snowflake_access_history') }} as ah
    left join {{ ref('stg_snowflake_queries') }} as q
        on ah.query_id = q.query_id
    , lateral flatten(ah.direct_objects_accessed) as objects_accessed
    where true
        and fq_name is not null
        and ah.start_at::date >= current_date() - 120
        {% if is_incremental() %}
            and ah.start_at > (select max(t.start_at) from {{ this }} as t)
        {% endif %}

        {% if target.name != 'prod' %}
            and ah.start_at::date >= current_date() - 7
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
            )
        ) as query_table_key
        , concat(
            database_name
            , '.' , schema_name
            , '.' , table_name
        ) as table_key

    from snowflake_access_history

)

select * from keyed
