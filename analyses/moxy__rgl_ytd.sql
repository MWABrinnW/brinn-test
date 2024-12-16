with cte_short_term_rgl as (
    select accountid,
        sum(gain_loss) as short_term_gain_loss,
        sum(nounits) as short_term_units
    from {{ ref('mis__bld_gain_loss') }}
    where islongterm = 0
        and is_moxy = 1
        and (EXTRACT(YEAR FROM selldate)) = EXTRACT(YEAR FROM CURRENT_DATE())
        and unknown_cost = 0
        and upper(recordsource) = 'C'
    group by accountid
)
, cte_long_term_rgl as (
    select accountid, 
        sum(gain_loss) as long_term_gain_loss,
        sum(nounits) as long_term_units
    from {{ ref('mis__bld_gain_loss') }}
    where islongterm = 1
        and is_moxy = 1
        and (EXTRACT(YEAR FROM selldate)) = EXTRACT(YEAR FROM CURRENT_DATE())
        and unknown_cost = 0
        and upper(recordsource) = 'C'
    group by accountid
)
, cte_portfolios as (
    select pms_account_id
        , trading_id
    from {{ ref('mis__bld_accounts') }}
    where is_moxy = 1
)
, cte_core_rgl as (
    select distinct accountid 
        , acctcode
    from {{ ref('mis__bld_gain_loss') }}
    where is_moxy = 1
)
select rgl.accountid                                    as accountid
    , rgl.acctcode                                      as CustodialAccount
    , port.trading_id                                   as PortID
    , CURRENT_DATE()                                    as PosiDate
    , 'USD'                                             as Curr
    , IFNULL(strgl.short_term_gain_loss, 0)             as short_term_gain_loss
    , IFNULL(strgl.short_term_units, 0)                 as short_term_units
    , IFNULL(ltrgl.long_term_gain_loss, 0)              as RYTDGaining
    , IFNULL(ltrgl.long_term_units, 0)                  as long_term_units
    , (
        IFNULL(strgl.short_term_gain_loss, 0) + IFNULL(ltrgl.long_term_gain_loss, 0)
     )                                                  as RYTDGain
    , (
        IFNULL(strgl.short_term_units, 0) + IFNULL(ltrgl.long_term_units, 0)
     )                                                  as total_units
from cte_core_rgl rgl
left join cte_portfolios port 
    on rgl.accountid::varchar = port.pms_account_id::varchar
left join cte_short_term_rgl strgl 
    on strgl.accountid = rgl.accountid
left join cte_long_term_rgl ltrgl 
    on ltrgl.accountid = rgl.accountid