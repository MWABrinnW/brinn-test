{{ config(
    materialized='incremental',
    unique_key='date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['date', 'fkalclient', 'left(account_number, 1)']
) }}

{% set lookback = cvar('lookback') %}
{% set dev_filter = cvar('dev_day_filter') %}
{%- set max_lookback = 183 -%}

{% if is_incremental() -%}
    with cte_max_createddate as (
        select max(createddate) as max_createddate from {{ this }}
    )

    , cte_effective_dates as (
        select distinct transdate
        from {{ ref('orion__base_vw_transaction') }}
        where 1=1
            and createddate > (select max_createddate from cte_max_createddate)
    )
{% endif -%}


select
    t.system_name                                    as system_name
    , t.system_instance                              as system_instance
    , t.system_key                                   as system_key
    , t.firm_source                                  as firm_source
    , a.account_number                               as account_number
    , a.custodian                                    as custodian
    , a.account_id                                   as account_id
    , a.account_type                                 as account_type
    , a.account_name                                 as account_name

    , t.transdate                                    as date
    , t.settledate                                   as settlement_date
    , t.trancreateddate                              as created_date
    , t.editeddate                                   as edited_date

    , prod.symbol                                    as symbol
    , prod.cusip                                     as cusip
    , prod.ticker                                    as ticker
    , prod.is_ticker_cusip                           as is_ticker_cusip
    , prod.is_custodial_cash                         as is_custodial_cash
    , prod.product_name                              as product_name
    , prod.product_type                              as product_type
    , prod.product_category                          as product_category
    , prod.asset_class                               as asset_class
    , prod.product_id                                as product_id
    -- Looks at asset (holding) only
    , ass.assetismanaged::int                        as is_asset_managed
    -- Looks as product.
    , prod.is_product_managed::int                   as is_product_managed

    , t.fktranstype                                  as type_id
    , tt.type                                        as type_code
    , tt.name                                        as type_name
    , tt.description                                 as type_description

    , t.nounits                                      as quantity
    , t.navprice                                     as price
    , t.transamount                                  as amount

    , tt.signfield                                   as sign_field

    , t.notes                                        as notes
    , t.pktransaction                                as id
    , ass.fkasset                                    as asset_id

    , tt.fktranstype_cashoffset                      as type_cash_offset

    , ts.sstatusdesc                                 as trade_status
    , t.fktradestatus                                as trade_status_id


    , t.fkalclient                                   as fkalclient

    , current_timestamp()::timestamp_ntz             as _created_at
    , t._extracted_at::timestamp_ntz                 as _source_loaded_at
    , t.createddate                                  as createddate
    , t._source_file::varchar(200)                   as _source_file
from {{ ref('orion__base_vw_transaction') }} as t
inner join {{ ref('orion__base_vw_asset') }} as ass
    on t.fkasset = ass.fkasset
    and t.fkalclient = ass.fkalclient
inner join {{ ref('orion__accounts') }} as a
    on ass.accountid = a.account_id
    and ass.fkalclient = a.fkalclient
    and a.is_head = 1
left join {{ ref('orion__base_vw_transactiontype') }} as tt
    on t.fktranstype = tt.pktranstype
    and t.fkalclient = tt.fkalclient
left join {{ ref('orion__bld_products') }} prod
    on ass.fkalclient = prod.fkalclient
    and ass.productid = prod.product_id
left join {{ ref('orion__base_vw_tradestatus') }} as ts
    on t.fkalclient = ts.fkalclient
    and t.fktradestatus = ts.pktradestatus
where 1 = 1
    -- Max lookback for a full refresh.
    and t.transdate >= current_date() - {{ max_lookback }}
    {%- if target.name not in ['prod'] %}
        --Restrict lookback window in dev.
        and t.transdate >= current_date() - {{ dev_filter }}
    {%- endif %}

    {%- if is_incremental() %}
        -- Restrict lookback for incremental run.
        and t.transdate >= current_date() - {{ lookback }}
        -- These are the dates that need added/refreshed.
        and t.transdate in (
            select tmp.transdate from cte_effective_dates as tmp
        )
    {% endif -%}
