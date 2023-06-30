select
    po.account_id
  , ac.accountnumber                                               as account_number
  , ac.name                                                        as account_name
  , gr.name                                                        as group_name
  , po.security_id
  , regexp_substr(po.security_id, '\\D+')::string                  as underlying_security
  , to_date(regexp_substr(po.security_id, '\\d+'), 'YYMMDD')       as expiration_date
  , regexp_substr(po.security_id, '\\D', 6)::string                as put_call
  , to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000   as strike_price
  , prd.previous_close
  , iff(
                regexp_substr(po.security_id, '\\D', 6) = 'P',
                (div0(to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000, prd.previous_close) - 1) * -1,
                div0(to_number(regexp_substr(po.security_id, '\\d{8}', 6)) / 1000, prd.previous_close) - 1
        )                                                          as otm
  , po.unrealized_pnl
  , po.quantity
  , prd.close_price
  , prd.last_trade_price
  , prd."10_day_avg_price"
  , prd.dividend_ex_date
  , prd.dividend_amount
  , (div0(prd.last_trade_price, prd."10_day_avg_price") - 1) * 100 as "unrealized_gain_%"
  , po.record_datetime
from {{ ref('fixflyer_options__stg_copilot_positions') }} po
left join (
              select
                  accountid
                , accountnumber
                , name
              from {{ ref('fixflyer_options__stg_copilot_accounts') }}
              where is_head = 1
          )                                               ac
          on po.account_id = ac.accountid
left join (
              select
                  groupid
                , name
              from {{ ref('fixflyer_options__stg_groups_raw') }}
              where is_head = 1
          )                                               gr
          on po.group_id = gr.groupid
left join (
              select
                  copi_symbol
                , dividend_ex_date
                , dividend_amount
                , close_price
                , last_trade_price
                , previous_close
                , "10_day_avg_price"
              from {{ ref('activetick__stg_activetick_prices') }}
              where is_head = 1
          )                                               prd
          on regexp_substr(po.security_id, '\\D+') = prd.copi_symbol
where true
  and po.product = '5'
  and po.is_head = 1
