{{ config(
    materialized='incremental',
    cluster_by=['effective_date', 'fkalclient', 'trunc(fkasset, -5)'],
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{% set lookback = cvar('lookback') %}
{% set dev_filter = cvar('dev_day_filter') %}

select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:fkalclient::integer               as fkalclient
    , a.content:fkasset::integer                  as fkasset
    , a.content:asofdateint::integer              as asofdateint
    , a.content:asofdate::date                    as asofdate
    , a.content:unitbalance::double precision     as unitbalance
    , a.content:navprice::double precision        as navprice
    , a.content:calculatedvalue::double precision as calculatedvalue
    , a.content:createddate::timestamp            as createddate
    , a.content:asofdate::date                    as effective_date
    , a._extracted_at::timestamp_ntz              as _extracted_at
    , a._pk                                       as _pk
    , a._is_full::int                             as _is_full
    , current_timestamp()::timestamp_ntz          as _created_at
    , a._created_at::timestamp_ntz                as _source_loaded_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_assetvalue') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
where 1 = 1
    -- Max lookback for a full refresh.
    and a.content:asofdate::date >= '1/1/2024'
    {%- if target.name not in ['prod'] %}
        -- Restrict lookback window in dev.
        and a.content:asofdate::date >= current_date() - {{ dev_filter }}
    {%- endif %}

    {% if is_incremental() -%}
        -- Restrict lookback for incremental run.
        and a.content:asofdate::date >= current_date() - {{ lookback }}
        -- These are the dates that need added/refreshed.
        and a.content:asofdate::date in (
            select aa.effective_date
            from (
                select
                    content:asofdate::date                as effective_date
                    , max(content:createddate::timestamp) as _created_at
                from {{ source('orion', 'vw_assetvalue') }}
                where content:asofdate::date >= current_date() - {{ lookback }}
                group by 1
            ) as aa
            where aa._created_at
                > coalesce((
                    select max(createddate) from {{ this }}
                    where effective_date >= current_date() - {{ lookback }}
                ) , aa._created_at::timestamp_ntz - interval '1 day')
            group by all
        )
    {% endif -%}
order by a.content:asofdate::date , a.content:fkalclient::int , trunc(a.content:fkasset::int , -5)
