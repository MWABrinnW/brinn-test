select
    a.effective_date                                       as effective_date
    , a.platform                                           as platform
    , a.venue                                              as venue
    , lower(acc.custodian)                                 as custodian
    , a.account_id                                         as account_id
    , acc.account_number                                   as account_number
    , acc.account_name                                     as account_name

    , a.position_id                                        as position_id
    , coalesce(a.option_symbol , a.security_id)::text(200) as ticker
    , coalesce(cusip_ticker.cusip , cusip.cusip)           as cusip

    , a.quantity                                           as quantity

    , a.current_price                                      as prev_close_price
    , a.average_price                                      as avg_cost
    , a.last_modified_at                                   as last_modified_at

    , a.is_head                                            as is_head
    , a._created_at                                        as last_collected_at
from {{ ref('flyer__stg_positions') }} as a
left join {{ ref('flyer__stg_accounts') }} as acc
    on a.effective_date = acc.effective_date
    and a.account_id = acc.account_id
    and acc.is_head_for_day = 1
left join {{ ref('bld_securities') }} as cusip_ticker
    on a.security_id = cusip_ticker.ticker
    and cusip_ticker.rn_ticker = 1
left join {{ ref('bld_securities') }} as cusip
    on a.security_id = cusip.cusip
where 1 = 1
    and a.is_head_for_day = 1
    and a._env = {{ "'" ~ flyer_env() ~ "'" }}
order by a.account_id , a.security_id
