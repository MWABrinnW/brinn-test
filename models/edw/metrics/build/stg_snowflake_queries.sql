{{
  config(
    materialized = 'incremental'
    , unique_key = 'query_id'
  )
}}


select
    a.query_id                          as query_id
    , a.session_id                      as session_id
    , a.start_time                      as start_at
    , a.end_time                        as end_at
    , lower(a.user_name)                as user_name
    , lower(a.role_name)                as role_name
    , lower(a.query_type)               as query_type
    , lower(a.query_text)               as query_text
    , lower(a.execution_status)         as execution_status
    , a.error_code                      as error_code
    , a.error_message                   as error_message
    , a.warehouse_id                    as warehouse_id
    , lower(a.warehouse_name)           as warehouse_name
    , lower(a.warehouse_size)           as warehouse_size
    , lower(a.warehouse_type)           as warehouse_type
    , a.query_tag                       as query_tag
    , a.user_name in ('')               as is_tooling_user
    , a.cluster_number                  as cluster_number
    , a.total_elapsed_time / 1000       as duration_seconds
    , a.compilation_time / 1000         as compilation_seconds
    , a.execution_time / 1000           as execution_seconds
    , a.queued_provisioning_time / 1000 as queued_provisioning_seconds
    , a.queued_repair_time / 1000       as queued_repair_seconds
    , a.queued_overload_time / 1000     as queued_overload_seconds
    , a.transaction_blocked_time / 1000 as transaction_blocked_seconds
    , a.bytes_scanned                   as bytes_scanned
-- many niche fields are excluded
from {{ source('snowflake_internal', 'query_history') }} as a
{% if is_incremental() -%}
    left join {{ this }} as b
        on a.query_id = b.query_id
        and b.start_at::date >= current_date() - 1
{% endif -%}
where true
    and a.start_time::date >= current_date() - 120
    {% if is_incremental() %}
        and a.start_time::date >= current_date - 1
        and b.query_id is null
        --and start_time::date > (select max(t.start_at::date - interval '1 day') from {{ this }} as t)
    {% endif %}

    {% if target.name != 'prod' %}
        and a.start_time::date >= current_date() - 7
    {% endif %}
