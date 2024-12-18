with schwab_allocations_from_perform as (
    select
        trade_date
        , broker_name
        , broker_id
        , settle_date
        , cusip
        , order_id
        , account_number_formatted
        , unit_price
        , units
        , principal
        , interest
        , net
        , case
            when order_side ilike 'buy' then 'B'
            when lower(order_side) in ('sell' , 'sale') then 'S'
        end::text    as order_side
        , trade_date as effective_date
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
        and custodian ilike 'schwab'
        and trade_away::int = 1
)

, grouping as (
    select
        to_char(try_to_date(trade_date) , 'YYYYMMDD')::text    as trade_date
        , upper(broker_name)::text                             as broker_name
        , broker_id::text                                      as broker_id
        , order_side                                           as order_side
        , to_char(try_to_date(settle_date) , 'YYYYMMDD')::text as settle_date
        , cusip::text                                          as cusip
        , order_id::text                                       as order_id
        , count(distinct account_number_formatted)::int        as record_count
        , to_varchar(unit_price , '9999999.0000')::text        as unit_price

        , sum(units)::text                                     as total_units
        , sum(principal)                                       as total_principal
        , sum(interest)                                        as total_interest
        , sum(net)                                             as total_net

        , effective_date                                       as effective_date

    from schwab_allocations_from_perform
    group by all
)

, headers as (
    select
        -- col1
        'PH'::text                                              as record_type
        -- col2
        , trade_date::text                                      as transmission_date
        , '8109543'::text                                       as master_account
        , coalesce(nullif(trim(broker_name) , '') , '""')::text as broker_name
        , case
            when broker_name = 'TMCC' then 'PERS'
            when broker_name = 'BDDK' then 'Fidelity'
            when broker_name = 'MADV-AIP' then 'PERS'
            when broker_name = 'MADV' then 'TMCC'
            when broker_name = 'Fidelity' then 'Fidelity'
            when broker_name = 'Schwab' then 'Schwab'
            else coalesce(nullif(trim(broker_name) , '') , '""')
        end::text                                               as clearing_broker
        , coalesce(nullif(trim(broker_id) , '') , '""')::text   as broker_id
        , order_side::text                                      as order_side
        , trade_date::text                                      as trade_date
        , settle_date::text                                     as settle_date
        , cusip::text                                           as cusip
        , cusip::text                                           as symbol
        , 'AGENT'::text                                         as capacity
        , 'OTC'::text                                           as exchange
        , null::text                                            as description
        , null::text                                            as security
        , null::text                                            as notes

        , concat(order_id , '_0')::text                         as line_item
        , effective_date                                        as effective_date
    from grouping
    order by effective_date , line_item
)

, footers as (
    select
        -- col1
        'PT'::text                                                 as record_type
        -- col2
        , lpad(to_varchar(record_count) , 5 , '0')::text           as record_count
        -- col3
        , null::text                                               as ipo
        -- col4
        , lpad(to_varchar(total_units) , 9 , '0')::text            as total_units
        -- col5
        , trim(unit_price)::text                                   as unit_price
        -- col6
        , trim(to_varchar(total_principal , '999999999.00'))::text as total_principal
        -- col7
        , trim(to_varchar(total_interest , '999999999.00'))::text  as total_interest
        -- col8
        , '0.00'::text                                             as commission
        -- col9
        , '0.00'::text                                             as other_fee
        -- col10
        , '0.00'::text                                             as not_used_1
        -- col11
        , trim(to_varchar(total_net , '999999999.0000'))::text     as total_net
        -- col12
        , null::text                                               as notes
        -- col13
        , null::text                                               as not_used_2
        -- col14
        , null::text                                               as not_used_3
        -- col15
        , null::text                                               as not_used_4
        -- col16
        , null::text                                               as not_used_5

        , concat(order_id , '_9')::text                            as line_item
        , effective_date                                           as effective_date
    from grouping
    order by effective_date , line_item
)

, body as (
    select
        account_number_formatted::text            as account_number
        , lpad(to_varchar(units) , 9 , '0')::text as units
        , null::text                              as col_3
        , null::text                              as col_4
        , null::text                              as col_5
        , null::text                              as col_6
        , null::text                              as col_7
        , null::text                              as col_8
        , null::text                              as col_9
        , null::text                              as col_10
        , null::text                              as col_11
        , null::text                              as col_12
        , null::text                              as col_13
        , null::text                              as col_14
        , null::text                              as col_15
        , null::text                              as col_16

        , concat(order_id , '_1')::text           as line_item
        , effective_date                          as effective_date
    from schwab_allocations_from_perform
    order by effective_date , line_item , account_number_formatted
)

, unioned as (
    select *
    from headers
    union all
    select *
    from body
    union all
    select *
    from footers
)

select
    record_type
    , transmission_date
    , master_account
    , broker_name
    , clearing_broker
    , broker_id
    , order_side
    , trade_date
    , settle_date
    , cusip
    , symbol
    , capacity
    , exchange
    , description
    , security
    , notes

    , line_item
    , effective_date
from unioned
where 1 = 1
order by effective_date , line_item , record_type
