{%- macro nml_fidelity_tax_lots_lambda(instance, is_historical = false) -%}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{%- set history_relation = 'nml_fidelity_' ~ instance ~ '_tax_lots_history' %}
{%- set fresh_relation = 'nml_fidelity_' ~ instance ~ '_tax_lots_fresh' %}

{%-
    set src_models = [
          'fidelity_' ~ instance ~ '_history__vw_tlaopen_tax_accounting'
    ]
-%}

{%- if is_historical %}
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
        effective_date                      as effective_date
        , max(_source_loaded_at)            as _created_at
        , {{"'" ~ src_model ~ "'"}}         as model_source
    from {{ ref(src_model) }}
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
{%- endif %}

{%- if is_historical %}
,
{%- else %}
with
{%- endif %}
lots_base as (
    select
        effective_date, custodian, firm_source, account_custodial, account_custodial_formatted
        , cusip, security_description_lines_1_6, long_short_code, lot_quantity, current_cost_unadjusted_wash
        , closing_market_price, lot_market_value, tas_lot_acquired_date, open_lot_settlement_date, lot_received_date
        , product_code, wash_sale_indicator, open_lot_identifier, option_call_put_indicator, option_expiration_date
        , option_strike_price, sedol, _source_loaded_at, _source_file
        , nigo_out_of_balance_exception_indicator, nigo_tech_short_exception_indicator, nigo_cost_exception_indicator
    from {{ ref('fidelity_' ~ instance ~ '_history__vw_tlaopen_tax_accounting') }}
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and effective_date::date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and effective_date::date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)

, securities as (
    select
        s.effective_date
        , s.symbol
        , s.cusip
        , s.option_symbol_id_occ
        , s.security_description_line_1
        , s.closing_market_price
        , s.isin
        , s.is_head
        -- This field in the underlying view is surely compute heavy and probably scans the full table.
        , s.is_cusip_head
    from {{ ref('fidelity_' ~ instance ~ '_history__vw_secmast_1_security') }} as s
    where 1 = 1
        {%- if is_historical %}
        and (
            (s.is_cusip_head = 1)
            or (exists(select 1 from dates_to_refresh)
            and s.effective_date::date in (select distinct t.effective_date from dates_to_refresh as t))
            )
        {%- else %}
        and s.effective_date::date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)

, sweep_funds as (
    select
        effective_date
        , account_number
        , ticker
    from {{ ref('int_fidelity_' ~ instance ~ '_account_sweep_fund') }}
    where 1 = 1
        {%- if is_historical %}
        and exists(select 1 from dates_to_refresh)
        and effective_date::date in (select distinct t.effective_date from dates_to_refresh as t)
        {%- else %}
        and effective_date::date > (select max(effective_date) from {{ ref(history_relation) }})
        {%- endif %}
)

select
    t.effective_date                                                                 as effective_date
    , t.custodian                                                                    as custodian
    , cf.firm                                                                        as firm
    , t.firm_source                                                                  as firm_source
    , t.account_custodial                                                            as account_number
    , t.account_custodial_formatted                                                  as account_number_formatted

    -- Convenience lookup id.
    -- isolate product code that represents options
    ,
    coalesce(
        s.symbol
        , s.option_symbol_id_occ
        , s2.symbol
        , s2.option_symbol_id_occ
        , t.cusip
        , s.security_description_line_1
        , t.security_description_lines_1_6
    )::text(200)                                                                    as symbol
    , coalesce(
        s.symbol
        , s.option_symbol_id_occ
        , s2.symbol
        , s2.option_symbol_id_occ
    )::text(200)                                                                     as ticker
    , t.cusip::text(200)                                                             as cusip

    , case
        when t.long_short_code ilike 'S'
            then -1 * t.lot_quantity
        else t.lot_quantity
    end::decimal(22 , 5)                                                             as quantity
    , (t.current_cost_unadjusted_wash / nullif(t.lot_quantity , 0))::decimal(20 , 5) as cost_per_share
    , t.current_cost_unadjusted_wash                                                 as cost_basis
    -- Closing price on the day of lot purchase.
    , coalesce(s.closing_market_price, t.closing_market_price)::decimal(20, 5)       as current_price
    , t.lot_market_value                                                             as current_value

    -- Date the lot was acquired.
    , t.tas_lot_acquired_date                                                        as trade_date
    , t.open_lot_settlement_date                                                     as settlement_date
    -- Date the source system entered the lot.
    , t.lot_received_date                                                            as entry_date_source

    , case
        when t.product_code = 'SEMYM' or sf.ticker is not null
            then 1
        else 0
    end::int                                                                         as is_cash
    , case
        when sf.ticker is not null
            then 1
        else 0
    end::int                                                                         as is_sweep
    , case
        when t.long_short_code ilike 'S'
            then 1
        else 0
    end::int                                                                         as is_short
    , try_to_boolean(t.wash_sale_indicator)::int                                     as is_wash_sale

    , t.open_lot_identifier::text(200)                                               as lot_id_source
    , t.cusip::text(200)                                                             as security_id_source

    , s.option_symbol_id_occ::text(200)                                              as option_ticker
    , t.option_call_put_indicator::text(200)                                         as option_indicator
    , t.option_expiration_date::date                                                 as option_expiration_date
    , t.option_strike_price::decimal(20 , 5)                                         as option_strike_price

    , s.isin::text(200)                                                              as isin
    , t.sedol::text(200)                                                             as sedol

    , cmpt.normalized                                                                as product_type
    , cmpt.definition                                                                as product_type_source_definition
    , t.product_code::text(200)                                                      as product_type_source_code

    , cmsd.normalized                                                                as legacy_product_type
    , cmsd.definition                                                                as legacy_product_type_source_definition
    , t.product_code::text(200)                                                      as legacy_product_type_source_code

    , current_timestamp()::timestamp_ntz                                             as _created_at
    , t._source_loaded_at                                                            as _source_loaded_at
    , t._source_file                                                                 as _source_file
    , object_construct(
        'nigo_out_of_balance_exception_indicator' , try_to_boolean(t.nigo_out_of_balance_exception_indicator)::int
        , 'nigo_tech_short_exception_indicator' , try_to_boolean(t.nigo_tech_short_exception_indicator)::int
        , 'nigo_cost_exception_indicator' , try_to_boolean(t.nigo_cost_exception_indicator)::int
    )::variant                                                                       as _extra_fields
from lots_base as t
left join {{ ref('custodian_firms') }}                             cf
    on t.firm_source = cf.firm_source
left join securities s
    on t.effective_date = s.effective_date
    and t.cusip = s.cusip
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and s.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and s.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
left join securities s2
    on t.cusip = s2.cusip
    and s2.is_cusip_head = 1
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    {%- endif %}
left join {{ ref('custodian_mappings') }}     cmpt
    on t.custodian = cmpt.custodian
    and cmpt.field = 'product_type'
    and t.product_code = cmpt.source
left join {{ ref('custodian_mappings') }}     cmsd
    on t.custodian = cmsd.custodian
    and cmsd.field = 'legacy_product_type'
    and t.product_code = cmsd.source
left join sweep_funds sf
    on t.effective_date = sf.effective_date
    and t.account_custodial = sf.account_number
    and s.symbol = sf.ticker
    {%- if is_historical %}
    and exists(select 1 from dates_to_refresh)
    and sf.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
    {%- else %}
    and sf.effective_date > (select max(effective_date) from {{ ref(history_relation) }})
    {%- endif %}
where 1 = 1

{%- endmacro -%}
