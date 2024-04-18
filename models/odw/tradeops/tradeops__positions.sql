select
    a.effective_date        as effective_date
    , a.platform            as platform
    , a.venue               as venue
    , lower(acc.custodian)  as custodian
    , a.account_id          as account_id
    , acc.account_number    as account_number
    , acc.account_name      as account_name

    , a.position_id         as position_id
    , a.security_id         as symbol
    --, a.price              as price
    , a.current_price       as prev_close_price
    , a.average_price       as average_price
    , a.last_modified_at    as last_modified_at

    , a.option_ticker       as option_ticker
    , a.option_ex_date      as option_ex_date
    , a.option_type         as option_type
    , a.option_strike_price as option_strike_price

    , a.is_head             as is_head
    , a._created_at         as last_collected_at
    --, a._source_file       as _source_file
from {{ ref('flyer__stg_positions') }} as a
left join {{ ref('flyer__stg_accounts') }} as acc
    on a.effective_date = acc.effective_date
    and a.account_id = acc.account_id
    and acc.is_head_for_day = 1
where 1 = 1
    and a.is_head = 1
    and a._env = {{ "'" ~ copilot_env() ~ "'" }}
order by a.account_id , a.security_id
