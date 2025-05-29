{{ config(
    materialized='incremental',
    cluster_by=['effective_date', 'fkalclient', 'trunc(fkasset, -5)'],
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{% set start_date = cvar('start_date_orion') %}
{% set lookback = cvar('lookback') %}


select
    ci.clientname                                      as clientname
    , ci.system_name                                   as system_name
    , ci.system_instance                               as system_instance
    , ci.system_key                                    as system_key
    , ci.firm_source                                   as firm_source
    , a.content:fkalclient::integer                    as fkalclient
    , a.content:recordsource::varchar(5)               as recordsource
    , a.content:fkasset::integer                       as fkasset
    , a.content:fkassetcostbasis::bigint               as fkassetcostbasis
    , a.content:asofdate::date                         as asofdate
    , a.content:longtermcost::double precision         as longtermcost
    , a.content:shorttermcost::double precision        as shorttermcost
    , a.content:longtermunits::double precision        as longtermunits
    , a.content:shorttermunits::double precision       as shorttermunits
    , a.content:acquireddate::date                     as acquireddate
    , a.content:amortizationamt::double precision      as amortizationamt
    , a.content:originalcostpershare::double precision as originalcostpershare
    , a.content:checksum_current::integer              as checksum_current
    , a.content:createddate::timestamp                 as createddate
    , a.effective_at::date                             as effective_date
    , a._pk::varchar(200)                              as _pk
    , a._extracted_at::timestamp_ntz                   as _extracted_at
    , current_timestamp()                              as _created_at
    , a._created_at::timestamp_ntz                     as _source_loaded_at
    , a._source_file                                   as _source_file
    , a._checksum                                      as _checksum
    , a._is_full                                       as _is_full
from {{ source('orion', 'vw_costbasisunrealized') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
where 1 = 1
        -- limits the build on a full refresh from an explicit date from the variable directory
        and a.effective_at::date >= '{{ start_date }}'
    {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window in dev.
        and a.effective_at::date >= current_date() - {{ lookback }}
    {%- endif %}
    {% if is_incremental() -%}
        -- Restrict lookback for incremental run.
        and a.effective_at::date >= current_date() - {{ lookback }}
        -- These are the dates that need added/refreshed.
        and a.effective_at::date in (
            select aa.effective_date
            from (
                select
                    effective_at::date                    as effective_date
                    , max(content:createddate::timestamp) as _created_at
                from {{ source('orion', 'vw_costbasisunrealized') }}
                where effective_at::date >= current_date() - {{ lookback }}
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
order by a.effective_at::date , a.content:fkalclient::int , trunc(a.content:fkasset::int , -5)
