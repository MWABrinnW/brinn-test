{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set src_models = [
        source('black_diamond_houston', 'accounts')
    ]
-%}

{%- set extra_columns -%}
    , max(case when atag.tag_name = 'PB' then atag.tag_value end)                   as pb
    , max(case when atag.tag_name = 'TR' then atag.tag_value end)                   as tr
    , max(case when atag.tag_name = 'WAS Account' then atag.tag_value end)          as was_account
    , max(case when atag.tag_name = 'Notes' then atag.tag_value end)                as notes
    , max(case when atag.tag_name = 'State2' then atag.tag_value end)               as state2
    , max(case when atag.tag_name = 'Strategy' then atag.tag_value end)             as strategy
    , max(case when atag.tag_name = 'Lot' then atag.tag_value end)                  as lot
    , max(case when atag.tag_name = 'R' then atag.tag_value end)                    as r
    , max(case when atag.tag_name = 'SI Custody' then atag.tag_value end)           as si_custody
    , max(case when atag.tag_name = 'Account Registration' then atag.tag_value end) as account_registration
    , max(case when atag.tag_name = 'TD Account Number' then atag.tag_value end)    as td_account_number
    , max(case when atag.tag_name = 'Stonnington Referral' then atag.tag_value end) as stonnington_referral
    , max(case when atag.tag_name = 'Regulatory Account' then atag.tag_value end)   as regulatory_account
    , max(case when atag.tag_name = 'QB' then atag.tag_value end)                   as qb
    , max(case when atag.tag_name = 'MWA Contract' then atag.tag_value end)         as mwa_contract
    , max(case when atag.tag_name = 'Rest Notes' then atag.tag_value end)           as rest_notes
    , max(case when atag.tag_name = 'SAN Account' then atag.tag_value end)          as san_account
    , max(case when atag.tag_name = 'State' then atag.tag_value end)                as state
{%- endset -%}

{%- set sql = black_diamond_base_accounts(
    src=src_models[0],
    instance='houston',
    firm_source='mwa',
    extra_columns=extra_columns,
    extra_joins=none,
    where_clause="and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)",
    is_lambda=true
) %}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, max(_created_at) as _created_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
    order by 1
    {% else -%}
    select null::date as effective_date
        , null::timestamp as _created_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
    select
        effective_date                  as effective_date
        , max(record_datetime)          as _created_at
        , {{"'" ~ src_model ~ "'"}}     as model_source
    from {{ src_model }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date from source_summary group by all
    union
    select effective_date from destination_summary group by all
)


, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
    left join destination_summary d
        on a.effective_date = d.effective_date
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

{{ sql }}
