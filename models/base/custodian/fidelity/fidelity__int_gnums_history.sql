{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
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
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    select effective_date, max(_source_loaded_at) as _created_at, {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref('fidelity__stg_gnums') }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
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

select
    a.effective_date                                           as effective_date
    , 'fidelity'                                               as custodian
    , a.firm_source                                            as firm_source
    , a.account_number_formatted                               as account_number_formatted
    , a.account_number                                         as account_number
    , a.primary_account_holder                                 as primary_account_holder
    , a.gnum                                                   as gnum
    , gnum_source                                              as gnum_source
    , case when gnum_source = 'PRIMARY_GNUM' then 1 else 0 end as is_primary
    , gnum_name                                                as gnum_name
    , gnum_source_desc                                         as gnum_source_desc
    , a.is_head                                                as is_head
    , a.is_current                                             as is_current
    , current_timestamp()::timestamp_ntz                       as _created_at
    , a._source_loaded_at                                      as _source_loaded_at
    , a._source_file                                           as _source_file
    , a._row_number                                            as _row_number
    , a._checksum                                              as _checksum
from {{ ref('fidelity__stg_gnums') }} as a
unpivot (gnum for gnum_source in (
    primary_gnum , secondary_gnum_1 , secondary_gnum_2 , secondary_gnum_3 , secondary_gnum_4 , secondary_gnum_5
    , secondary_gnum_6 , secondary_gnum_7 , secondary_gnum_8 , secondary_gnum_9 , secondary_gnum_10
))
unpivot (gnum_name for gnum_source_desc in (
    primary_gnum_advisor
    , secondary_gnum_name_1
    , secondary_gnum_name_2
    , secondary_gnum_name_3
    , secondary_gnum_name_4
    , secondary_gnum_name_5
    , secondary_gnum_name_6
    , secondary_gnum_name_7
    , secondary_gnum_name_8
    , secondary_gnum_name_9
    , secondary_gnum_name_10
))
where true
    and (
        (gnum_source = 'PRIMARY_GNUM' and gnum_source_desc = 'PRIMARY_GNUM_ADVISOR')
        or (gnum_source = 'SECONDARY_GNUM_1' and gnum_source_desc = 'SECONDARY_GNUM_NAME_1')
        or (gnum_source = 'SECONDARY_GNUM_2' and gnum_source_desc = 'SECONDARY_GNUM_NAME_2')
        or (gnum_source = 'SECONDARY_GNUM_3' and gnum_source_desc = 'SECONDARY_GNUM_NAME_3')
        or (gnum_source = 'SECONDARY_GNUM_4' and gnum_source_desc = 'SECONDARY_GNUM_NAME_4')
        or (gnum_source = 'SECONDARY_GNUM_5' and gnum_source_desc = 'SECONDARY_GNUM_NAME_5')
        or (gnum_source = 'SECONDARY_GNUM_6' and gnum_source_desc = 'SECONDARY_GNUM_NAME_6')
        or (gnum_source = 'SECONDARY_GNUM_7' and gnum_source_desc = 'SECONDARY_GNUM_NAME_7')
        or (gnum_source = 'SECONDARY_GNUM_8' and gnum_source_desc = 'SECONDARY_GNUM_NAME_8')
        or (gnum_source = 'SECONDARY_GNUM_9' and gnum_source_desc = 'SECONDARY_GNUM_NAME_9')
        or (gnum_source = 'SECONDARY_GNUM_10' and gnum_source_desc = 'SECONDARY_GNUM_NAME_10')
    )
    -- Offer query optimizer a chance to prune early.
    and exists (select 1 from dates_to_refresh)
    and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
