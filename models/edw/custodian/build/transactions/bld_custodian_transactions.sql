-- depends_on: {{ ref('fidelity_mwa_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_mps_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_swag_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_actvyd_activity') }}
-- depends_on: {{ ref('schwab__base_transactions') }}

{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{% set max_lookback = 180 %}
{% set lookback = 10 %}

{%-
    set source_models = [
          'fidelity_mwa_history__vw_actvyd_activity'
         ,'fidelity_mps_history__vw_actvyd_activity'
         ,'fidelity_swag_history__vw_actvyd_activity'
         ,'fidelity_baystate_history__vw_actvyd_activity'
         ,'schwab__base_transactions'
    ]
-%}

{%-
    set nml_models = [
          'nml_fidelity_mwa_transactions'
         ,'nml_fidelity_mps_transactions'
         ,'nml_fidelity_swag_transactions'
         ,'nml_fidelity_baystate_transactions'
         ,'nml_schwab_transactions'
    ]
-%}

{% if is_incremental() -%}
    with cte_source_stats as (
        {% for src_model in source_models -%}
            select
                --noqa: disable=LT01
                effective_date                               as effective_date
                , {{ "'" ~ src_model ~ "'" }}                as model_source
                , custodian                                  as custodian
                , firm_source                                as firm_source
                , max(_source_loaded_at)                     as _source_loaded_at
                --noqa: enable=LT01
            from {{ ref(src_model) }}
            where effective_date >= current_date - {{ lookback }}
            group by all
            {% if not loop.last -%}

                union all

            {% endif -%}
        {% endfor -%}
    )

    , cte_destination_stats as (
        select
            effective_date           as effective_date
            , custodian              as custodian
            , firm_source            as firm_source
            , max(_source_loaded_at) as _source_loaded_at
        from {{ this }}
        where effective_date >= current_date - {{ lookback }}
        group by all
    )

    , cte_comparison as (
        select
            a.effective_date      as effective_date
            , a.custodian         as custodian
            , a.firm_source       as firm_source
            , a._source_loaded_at as _source_loaded_at
            , b._source_loaded_at as _destination_source_loaded_at
        from cte_source_stats as a
        left join cte_destination_stats as b
            on a.effective_date = b.effective_date
            and a.custodian = b.custodian
            and a.firm_source = b.firm_source
        where a.firm_source is not null and (b.custodian is null or a._source_loaded_at > b._source_loaded_at)
        group by all
    )

{% endif -%}

{% for nml_model in nml_models -%}
    select
        a.* exclude (is_head , is_current)
        , current_timestamp() as _created_at
    from {{ ref(nml_model) }} as a
    {% if is_incremental() -%}
        inner join cte_comparison as b
            on a.effective_date = b.effective_date
    {% endif -%}
    where 1 = 1
        and a.effective_date >= current_date - {{ max_lookback }}
        {% if is_incremental() -%}
            and a.effective_date >= current_date - {{ lookback }}
        {% endif -%}

    {%- if not loop.last %}

        union all

    {% endif -%}
{%- endfor %}
