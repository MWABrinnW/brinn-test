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
    select effective_date, max(_source_loaded_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
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
    from {{ ref('fidelity_swag_history__vw_raw_positd_position') }}
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
    p.effective_date                           as effective_date
    , p.custodian                              as custodian
    , cf.firm                                  as firm
    , p.firm_source                            as firm_source
    , p.account_custodial                      as account_number
    , p.account_custodial_formatted            as account_number_formatted
    , coalesce(p.symbol , p.cusip)             as symbol
    , case
        when p.security_description_line_1 = 'Option'
            then s1.option_symbol_id_occ
        else p.symbol
    end                                        as ticker
    , p.cusip                                  as cusip
    , rtrim(ltrim(regexp_replace(concat_ws(
        ' '
        , coalesce(p.security_description_line_1 , '')
        , coalesce(p.security_description_line_2 , '')
        , coalesce(p.security_description_line_4 , '')
        , coalesce(p.security_description_line_4 , '')
        , coalesce(p.security_description_line_5 , '')
    )
    , '(\s{2,})' , ' ') , ' '))                as security_name_source
    , case
        -- What about FCASH?
        when p.product_code = 'SEMYM' or sweep.ticker is not null
            then 1
        else 0
    end::int                                   as is_cash
    , case
        when sweep.ticker is not null
            then 1
        else 0
    end::int                                   as is_sweep

    , p.position_market_value::decimal(15 , 2) as market_value
    , p.trade_date_quantity::decimal(20 , 7)   as units_shares
    , p.trade_date_quantity::decimal(20 , 7)   as quantity
    , p.trade_date_quantity::decimal(20 , 7)   as quantity_settled
    , (
        p.settlement_date_quantity
        - p.trade_date_quantity
    )::decimal(20 , 7
    )                                          as quantity_unsettled

    , p.market_price::decimal(20 , 7)          as price
    , p.unfactored_price::decimal(20 , 7)      as price_unfactored
    , p.current_factor_amount::decimal(20 , 7) as factor

    , cb.cost_basis::decimal(19 , 9)           as cost_basis

    , p.cusip::varchar(500)                    as security_id_source

    , s2.symbol::varchar(500)                  as underlying_ticker
    , s1.underlying_cusip::varchar(500)        as underlying_cusip
    , s1.underlying_cusip::varchar(500)        as underlying_security_id_source

    , cmpt.normalized::varchar(500)            as product_type
    , cmpt.definition::varchar(500)            as product_type_source_definition
    , p.product_code::text(500)                as product_type_source_code

    , cmat.normalized::varchar(500)            as account_type
    , cmat.definition::varchar(500)            as account_type_source
    , p.account_type::varchar(500)             as account_type_source_code

    , p.isin::varchar(500)                     as isin
    , p.sedol::varchar(500)                    as sedol

    , null::variant                            as extra_fields

    , current_timestamp()::timestamp_ntz       as _created_at
    , p._source_loaded_at                      as _source_loaded_at
    , p._source_file                           as _source_file
from {{ ref('fidelity_swag_history__vw_positd_position') }} as p
left join {{ ref('custodian_firms') }} as cf
    on p.firm_source = cf.firm_source
left join {{ ref('fidelity_swag_history__vw_secmast_1_security') }} as s1
    on p.effective_date = s1.effective_date
    and p.cusip = s1.cusip
    and s1.effective_date in (select effective_date from dates_to_refresh group by effective_date)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
left join {{ ref('fidelity_swag_history__vw_secmast_1_security') }} as s2
    on s1.effective_date = s2.effective_date
    and s1.underlying_cusip = s2.cusip
    and s2.effective_date in (select effective_date from dates_to_refresh group by effective_date)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
left join {{ ref('custodian_mappings') }} as cmat
    on p.custodian = cmat.custodian
    and cmat.field = 'account_type'
    and p.account_type = cmat.source
left join {{ ref('custodian_mappings') }} as cmpt
    on p.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and p.product_code = cmpt.source
left join {{ ref('int_fidelity_swag_cost_basis') }} as cb
    on p.effective_date = cb.effective_date
    and p.account_custodial = cb.account_custodial
    and p.cusip = cb.cusip
    and cb.effective_date in (select effective_date from dates_to_refresh group by effective_date)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
left join {{ ref('int_fidelity_swag_account_sweep_fund') }} as sweep
    on p.effective_date = sweep.effective_date
    and p.account_custodial = sweep.account_number
    and p.symbol = sweep.ticker
    and sweep.effective_date in (select effective_date from dates_to_refresh group by effective_date)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
where 1 = 1
    and p.effective_date in (select effective_date from dates_to_refresh group by effective_date)
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
