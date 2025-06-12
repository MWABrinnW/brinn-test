{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['revenue_period_end_date', 'system_key']
) }}

{%-
    set src_models = [
          'black_diamond_baystate__base_bills'
    ]
-%}

{%-
    set nml_models = [
          'nml_bills_black_diamond_baystate'
    ]
-%}

with destination_summary as (
    {%- if is_incremental() %}
        select
            system_key               as system_key
            , max(_created_at)       as _created_at
            , max(_source_loaded_at) as _source_loaded_at
        from {{ this }}
        group by all
    {%- else %}
    select
        null::text                  as system_key
        , null::timestamp_ntz       as _created_at
        , null::timestamp_ntz       as _source_loaded_at
    {%- endif %}
)

, source_summary as (
    {% for src_model in src_models -%}
        select
            system_key                             as system_key
            , max(_created_at)                     as _created_at
            , {{ "'" ~ src_model ~ "'" }} as model_source
        from {{ ref(src_model) }}
        group by all

        {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, spine as (
    select system_key from source_summary
    group by all
    union distinct
    select system_key from destination_summary
    group by all
)

, systems_to_refresh as (
    select
        a.system_key    as system_key
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
        , case
            when s._created_at > coalesce(d._created_at , s._created_at - interval '1 day')
                then 1
            else 0
        end::int        as is_stale
    from spine as a
    left join source_summary as s
        on a.system_key = s.system_key
    left join destination_summary as d
        on a.system_key = d.system_key
    where 1 = 1
    group by all
    order by 1
)

-------------------------------------------------------------------

{{ build_billing_wealth_template(src_models=src_models, nml_models=nml_models) }}
