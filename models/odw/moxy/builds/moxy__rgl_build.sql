select
    a.trading_id                                as "portfolio"
    , a.account_number                          as account_number
    , 'USD'                                     as "curr"
    , to_char(a._created_at::date , 'YYYYMMDD') as "posidate"
    , rgl.total_gainloss::decimal(20 , 2)       as "rytdgain"
    , rgl.long_term_gainloss::decimal(20 , 2)   as "rytdgainlng"
    , a.is_intraday_import                      as is_intraday_import
from {{ ref('moxy__stg_rgl_ytd') }} as rgl
inner join {{ ref('mis__bld_accounts') }} as a
    on lower(rgl.account_number) = lower(a.account_number)
    and a.is_moxy = 1
    and a.rn = 1
where 1 = 1
    and rgl.is_head = 1
