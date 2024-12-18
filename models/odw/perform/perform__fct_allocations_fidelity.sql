-- Fidelity block upload specs
-- https://marinerholdingsllc.app.box.com/file/730139987534?s=qi9u7kc1nttnomi23ny5ug57h6cqm5lx
with fidelity_allocations_from_perfrom as (
    select
        trade_date
        , account_number
        , account_number_formatted
        , order_side
        , units
        , cusip
        , broker_id
        , order_id
        , unit_price
        , settle_date
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and custodian ilike 'fidelity'
        and trade_away::int = 1
)

, trades as (
    select
        null::text                                             as account_number--col_1
        , case
            when order_side ilike 'buy' then 'B'
            when lower(order_side) in ('sell' , 'sale') then 'S'
        end::text                                              as order_side--col_3
        , sum(units)::text                                     as units--col_4
        , cusip::text                                          as cusip--col_5
        , 'M'::text                                            as price_type--col_6
        , 'D'::text                                            as time_in_force--col_7
        , 'S'::text                                            as quantity_type--col_9
        , 'T'::text                                            as block_indicator--col_11
        , coalesce(nullif(trim(broker_id) , '') , '""')::text  as broker_id--col_12
        , order_id::text                                       as order_id--col_18
        , unit_price::text                                     as unit_price--col_19
        , 0::number(20 , 5)                                    as commission_amount--col_20
        , to_char(try_to_date(trade_date) , 'MMDDYYYY')::text  as trade_date--col_21
        , to_char(try_to_date(settle_date) , 'MMDDYYYY')::text as settle_date--col_22
        , trade_date                                           as effective_date
    from fidelity_allocations_from_perfrom
    group by all
)

, allocations as (
    select
        account_number_formatted::text as account_number--col_1
        , null::text                   as order_side--col_3
        , units::text                  as units--col_4
        , cusip::text                  as cusip--col_5
        , null::text                   as price_type--col_6
        , null::text                   as time_in_force--col_7
        , 'S'::text                    as quantity_type--col_9
        , 'A'::text                    as block_indicator--col_11
        , null::text                   as broker_id--col_12
        , order_id::text               as order_id--col_18
        , null::text                   as unit_price--col_19
        , null::number(20 , 5)         as commission_amount--col_20
        , null::text                   as trade_date--col_21
        , null::text                   as settle_date--col_22
        , trade_date                   as effective_date
    from fidelity_allocations_from_perfrom
)

, unioned as (
    select *
    from trades
    union all
    select *
    from allocations
)

, final as (
    select
        account_number                      as account_number
        , null::text                        as account_type
        , order_side                        as order_action
        , units                             as quantity
        , cusip                             as symbol_cusip
        , price_type                        as price_type
        , time_in_force                     as time_in_force
        , null::text                        as stop_price_limit_price
        , quantity_type                     as quantity_type
        , null::text                        as exchange_to_symbol
        , block_indicator                   as block_indicator
        , broker_id                         as block_id
        , null::text                        as nav
        , null::text                        as misc_fee
        , null::text                        as sol_unsol
        , null::text                        as nav_reason
        , null::text                        as rep_of_entry
        , order_id                          as trade_away_id
        , unit_price::number(20 , 6)        as price_share
        , commission_amount::number(20 , 2) as commission_amount
        , trade_date                        as trade_date
        , settle_date                       as settlement_date
        , effective_date                    as effective_date
    from unioned
)

select *
from final
where 1 = 1
order by effective_date asc , trade_away_id asc , block_indicator desc
