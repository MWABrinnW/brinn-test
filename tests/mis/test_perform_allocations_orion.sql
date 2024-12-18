with a as (
    select
        trade_date                                 as trade_date
        , order_side::text                         as order_side
        , order_id::text                           as order_id
        , count(distinct account_number_formatted) as accounts
        , max(cusip)                               as cusip
        , sum(units)                               as units_block
        , sum(units)                               as units_allocated
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and trade_date >= current_date() - 4
        and trade_away::int = 1
    group by all
)

, b as (
    select
        a.trade_date                as trade_date
        , max(case
            when b.trans_type = 10 then 'buy'
            when b.trans_type = 53 then 'sell'
        end::text)                  as order_side
        , b.orderid::text           as order_id
        , count(distinct acct_code) as accounts
        , max(cusip)                as cusips
        , sum(b.units)              as units_block
        , sum(b.units)              as units_allocated
    from (
        select distinct trade_date
        from a
    ) as a
    left join {{ ref('perform__fct_allocations_orion') }} as b
        on a.trade_date = b.effective_date
        and b.effective_date >= current_date() - 4
        -- We need to exclude the manufactured cash trades that are created
        -- in the orion model.
        and b.line_item not ilike '%_1'
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
