{{ config(
    enabled = false,
    tags = ['options', 'copilot', 'trading'],
    grants = {'select': ['trading_options']}
) }}

select
    po.account_id                                                     as account_id
    , ac.account_number                                               as account_number
    , ac.account_name                                                 as account_name
    , ac.group_name                                                   as group_name
    , po.security_id                                                  as security_id
    , regexp_substr(po.security_id , '\\D+')::text(200)               as underlying_security
    , to_date(regexp_substr(po.security_id , '\\d+') , 'YYMMDD')      as expiration_date
    , regexp_substr(po.security_id , '\\D' , 6)::text(200)            as put_call
    , to_number(regexp_substr(po.security_id , '\\d{8}' , 6)) / 1000  as strike_price
    , pri.previous_close
    , iff(
        regexp_substr(po.security_id , '\\D' , 6) = 'P'
        , (div0(to_number(regexp_substr(po.security_id , '\\d{8}' , 6)) / 1000 , pri.previous_close) - 1) * -1
        , div0(to_number(regexp_substr(po.security_id , '\\d{8}' , 6)) / 1000 , pri.previous_close) - 1
    )                                                                 as otm
    , po.unrealized_pnl
    , po.quantity
    , pri.close_price
    , pri.last_trade_price
    , pri."10_day_avg_price"
    , pri.dividend_ex_date
    , pri.dividend_amount
    , (div0(pri.last_trade_price , pri."10_day_avg_price") - 1) * 100 as "unrealized_gain_%"--noqa: RF05
    , po._created_at                                                  as _created_at
from {{ ref('flyer__stg_positions') }} as po
left join {{ ref('flyer__int_accounts') }} as ac
    on po.account_id = ac.account_id
    and po.effective_date = ac.effective_date
    and po._env = ac._env
left join {{ ref('activetick__stg_prices') }} as pri
    on regexp_substr(po.security_id , '\\D+') = pri.copi_symbol
    and pri.is_head = 1
where true
    and po.is_head = 1
    and po.product = 5
order by po.account_id , po.security_id
