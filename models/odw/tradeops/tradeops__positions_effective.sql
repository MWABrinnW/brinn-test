with cte_positions as (
    select
        a.effective_date        as effective_date
        , a.system_key          as system_key
        , lower(acc.custodian)  as custodian
        , a.account_id          as account_id
        , acc.account_number    as account_number
        , acc.account_name      as account_name

        , a.product_type        as product_type
        , a.option_symbol       as option_symbol
        , a.option_ticker       as option_ticker
        , a.option_ex_date      as option_ex_date
        , a.option_type         as option_type
        , a.option_strike_price as option_strike_price

        , a.quantity            as quantity
        , a.position_id         as position_id
        , a.security_id         as security_id
        , a.current_price       as prev_close_price
        , a.average_price       as average_price
        , a.last_modified_at    as last_modified_at

        , a.is_head             as is_head
        , a._created_at         as _created_at
        , a._source_file        as _source_file
    from {{ ref('flyer__stg_positions') }} as a
    left join {{ ref('flyer__stg_accounts') }} as acc
        on a.effective_date = acc.effective_date
        and a.account_id = acc.account_id
        and acc.is_head_for_day = 1
    where 1 = 1
        and a.is_head = 1
        and a._env = {{ "'" ~ copilot_env() ~ "'" }}
    order by a.account_id , a.security_id
)

, cte_pricing as (
    select
        ticker
        , last_price
        , prev_close_price
        , bid_price
        , ask_price
        , _created_at
    from {{ ref('activetick__stg_prices') }}
)

, cte_restrictions as (
    select
        system_key
        , account_id
        , account_number
        , restriction_type
        , type
        , nullif(value , '') as value
        , security_id
        , cusip
    from {{ ref('tradeops__accounts_restrictions') }}
    qualify row_number() over (partition by account_id , security_id order by last_collected_at desc) = 1
)

, cte_accounts_with_limit as (
    select distinct
        account_id
        , account_number
    from cte_restrictions
    where type = 'LIMIT_COVERAGE'
)

, cte_accounts_with_omit as (
    select distinct
        account_id
        , account_number
    from cte_restrictions
    where type = 'OMIT'
)

, cte_accounts_with_target as (
    select distinct
        account_id
        , account_number
    from cte_restrictions
    where type = 'TARGET'
)


select
    a.effective_date
    , a.system_key
    , a.custodian
    , a.account_id
    , a.account_number
    , a.account_name
    , a.position_id
    , a.product_type                                                                          as product_type
    , coalesce(a.option_symbol, a.security_id)                                                as ticker
    , coalesce(cusip_ticker.cusip, cusip.cusip)                                               as cusip
    , a.option_ticker                                                                         as option_ticker
    , a.option_ex_date                                                                        as option_ex_date
    , a.option_type                                                                           as option_type
    , a.option_strike_price                                                                   as option_strike_price

    , a.quantity                                                                              as actual_quantity
    , case
        when limi.security_id is not null
            then coalesce(greatest(try_to_decimal(limi.value, 20, 3), 0), a.quantity)
        else a.quantity
        end::decimal(20,3)                                                                    as restricted_quantity
    , pri.last_price                                                                          as last_price
    , pri.bid_price                                                                           as bid_price
    , pri.ask_price                                                                           as ask_price
    , pri._created_at                                                                         as price_updated_at
    , coalesce(pri.prev_close_price , a.prev_close_price)                                     as prev_close_price
    , nullif(
        ''::varchar(2000)
        -- OMIT
        || coalesce(case when omit.account_id is not null
                then 'OMIT restriction; '
        end , '')
        -- LIMIT
        || coalesce(case when limi.account_id is not null
                then 'LIMIT restriction; '
        end , '')
        -- TARGET
        || coalesce(case when tgt.account_id is not null
                then 'TARGET restriction; '
        end , '')
    , '')                                                                                     as restriction_details
    , coalesce(tgt.value , omit.value , limi.value)::text(200)                                as value
    , case
        when omit_acct.account_id is not null
            then 1
        else 0
    end::int                                                                                  as account_has_omit_restrictions
    , case
        when limit_acct.account_id is not null
            then 1
        else 0
    end::int                                                                                  as account_has_limit_restrictions
    , case
        when tgt_acct.account_id is not null
            then 1
        else 0
    end::int                                                                                  as account_has_target_restrictions
    , case
        when coalesce(restriction_details , '') ilike any ('%omit %' , '%limit %')
            then 1
        when tgt_acct.account_id is not null and tgt.security_id is null
            then 1
        else 0
    end::int                                                                                  as is_excluded
    --, a.last_modified_at
    , a.is_head
    , a._created_at                                                                           as last_collected_at
    --, a._source_file
from cte_positions                      as a
left join cte_pricing                   as pri
    on a.security_id = pri.ticker
left join cte_restrictions              as omit
    on a.account_id = omit.account_id
    and a.security_id = omit.security_id
    and omit.type = 'OMIT'
left join cte_restrictions              as limi
    on a.account_id = limi.account_id
    and a.security_id = limi.security_id
    and limi.type = 'LIMIT_COVERAGE'
left join cte_restrictions              as tgt
    on a.account_id = tgt.account_id
    and a.security_id = tgt.security_id
    and tgt.type = 'TARGET'
left join cte_accounts_with_omit        as omit_acct
    on a.account_id = omit_acct.account_id
left join cte_accounts_with_omit        as limit_acct
    on a.account_id = limit_acct.account_id
left join cte_accounts_with_target      as tgt_acct
    on a.account_id = tgt_acct.account_id
left join {{ ref('bld_securities') }}   as cusip_ticker
    on a.security_id = cusip_ticker.ticker
    and cusip_ticker.rn_ticker = 1
left join {{ ref('bld_securities') }}   as cusip
    on a.security_id = cusip.cusip
where 1 = 1
