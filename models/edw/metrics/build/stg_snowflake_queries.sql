{{
  config(
    materialized = 'incremental'
    , unique_key = 'query_id'
  )
}}


select
    query_id                          as query_id
    , session_id                      as session_id
    , start_time                      as start_at
    , end_time                        as end_at
    , lower(user_name)                as user_name
    , lower(role_name)                as role_name
    , lower(query_type)               as query_type
    , lower(query_text)               as query_text
    , lower(execution_status)         as execution_status
    , error_code                      as error_code
    , error_message                   as error_message
    , warehouse_id                    as warehouse_id
    , lower(warehouse_name)           as warehouse_name
    , lower(warehouse_size)           as warehouse_size
    , lower(warehouse_type)           as warehouse_type
    , query_tag                       as query_tag
    , user_name in ('')               as is_tooling_user
    , cluster_number                  as cluster_number
    , total_elapsed_time / 1000       as duration_seconds
    , compilation_time / 1000         as compilation_seconds
    , execution_time / 1000           as execution_seconds
    , queued_provisioning_time / 1000 as queued_provisioning_seconds
    , queued_repair_time / 1000       as queued_repair_seconds
    , queued_overload_time / 1000     as queued_overload_seconds
    , transaction_blocked_time / 1000 as transaction_blocked_seconds
    , bytes_scanned                   as bytes_scanned
-- many niche fields are excluded
from {{ source('snowflake_internal', 'query_history') }}
where true
    and start_at::date >= current_date() - 120

    {% if is_incremental() %}
        and start_time > (select max(t.start_at) from {{ this }} as t)
    {% endif %}

    {% if target.name != 'prod' %}
        and start_time::date >= current_date() - 7
    {% endif %}
