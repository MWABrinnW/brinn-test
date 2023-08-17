select
    po.account_id                                                    as account_id
  , ac.account_number                                                as account_number
  , ac.account_name                                                  as account_name
  , ac.group_name                                                    as group_name
  , po.security_id                                                   as security_id
  , regexp_substr(po.security_id, '\\D+')::text(200)                 as underlying_security
  , to_date(regexp_substr(po.security_id, '\\d+'), 'YYMMDD')         as expiration_date
  , regexp_substr(po.security_id, '\\D', 6)::text(200)               as put_call
  , to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000     as strike_price
  , prd.previous_close
  , iff(
                regexp_substr(po.security_id, '\\D', 6) = 'P',
                ( div0(to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000, prd.previous_close) - 1 ) * -1,
                div0(to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000, prd.previous_close) - 1
        )                                                            as otm
  , po.unrealized_pnl
  , po.quantity
  , prd.close_price
  , prd.last_trade_price
  , prd."10_day_avg_price"
  , prd.dividend_ex_date
  , prd.dividend_amount
  , ( div0(prd.last_trade_price, prd."10_day_avg_price") - 1 ) * 100 as "unrealized_gain_%"
  , po._created_at                                                   as _created_at
from {{ ref('fixflyer_options__stg_positions') }} po
left join {{ ref('fixflyer_options__int_accounts') }} ac
    on po.account_id = ac.account_id
    and ac.is_head = 1 and ac.is_latest = 1
left join {{ ref('activetick__stg_prices') }} prd
    on regexp_substr(po.security_id, '\\D+') = prd.copi_symbol
    and prd.is_head = 1
where true
  and po.is_head = 1
  and po.is_latest = 1
  and po.product = 5
order by po.account_id, po.security_id
