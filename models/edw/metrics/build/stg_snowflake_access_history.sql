{{
  config(
    materialized = 'incremental'
    , unique_key = 'query_id'
  )
}}

-- Small scale duplication is possible, and may be expensive to de-dupe
select
    query_id::text                   as query_id
    , query_start_time::timestamp_tz as start_at
    , user_name::text                as user_name
    , direct_objects_accessed::array as direct_objects_accessed
    , base_objects_accessed::array   as base_objects_accessed
    , objects_modified::array        as objects_modified
from {{ source('snowflake_internal', 'access_history') }}
where true
    and start_at::date >= current_date() - 120

    {% if is_incremental() %}
        and start_at > (select max(t.start_at) from {{ this }} as t)
    {% endif %}

    {% if target.name != 'prod' %}
        and start_at::date >= current_date() - 7
    {% endif %}
