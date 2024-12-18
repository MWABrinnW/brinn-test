with a as (
    select
        trade_date                                 as trade_date
        , order_side                               as order_side
        , order_id                                 as order_id
        , count(distinct account_number_formatted) as accounts
        , count(distinct cusip)                    as cusips
        , sum(units)                               as units_block
        , sum(units)                               as units_allocated
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and trade_date >= current_date() - 4
        and custodian ilike 'fidelity'
        and trade_away::int = 1
    group by all
)

, b as (
    select
        a.trade_date                                                                          as trade_date
        , max(case when b.order_action = 'B' then 'buy'
            when b.order_action = 'S' then 'sell'
        end::text)                                                                            as order_side
        , trade_away_id                                                                       as trade_away_id
        , count(distinct account_number)                                                      as accounts
        , count(distinct symbol_cusip)                                                        as cusips
        , sum(case when account_number is null then quantity::decimal(20 , 2) else 0 end)     as units_block
        , sum(case when account_number is not null then quantity::decimal(20 , 2) else 0 end) as units_allocated
    from (
        select distinct aa.trade_date
        from a as aa
    ) as a
    left join {{ ref('perform__fct_allocations_fidelity') }} as b
        on a.trade_date = b.effective_date
        and b.effective_date >= current_date() - 4
    group by all
)

, a_intersect_b as (

    select *
    from a
    intersect
    select *
    from b

)

, a_except_b as (

    select *
    from a
    except
    select *
    from b

)

, b_except_a as (

    select *
    from b
    except
    select *
    from a

)

, all_records as (

    select
        *
        , true as in_a
        , true as in_b
    from a_intersect_b

    union all

    select
        *
        , true  as in_a
        , false as in_b
    from a_except_b

    union all

    select
        *
        , false as in_a
        , true  as in_b
    from b_except_a

)

select *
from all_records
where 1 = 1
    and (in_a <> in_b or coalesce(units_block , 0) <> coalesce(units_allocated , 0))
order by trade_date , order_side
