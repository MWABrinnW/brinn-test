with cte_accounts_transposed as (
    select
        portfolio_id
        , trading_id
        , pms_account_id
        , crm_account_id
        , is_intraday_import
        , nm as advent_label
        , v  as value
    from {{ ref('moxy__accounts_build_flat') }}
    unpivot (
        v for nm in
        (
            acctno , atype , bill , cust , custodi , discret , eqstrat
            , feemgr , udef2 , goal , hhold , qbmgrid , status , name
            , stdate , udef1 , taxstat , assist , cashbuf , primres , ytdrgl
            , ndscnt , trdstat , portstat , eqstrat , ornid , recdate
        )
    )
)

, cte_types_mapped as (
    select
        column1   as advent_label
        , column2 as advent_type
    from
        values
        ('acctno' , '$')
        , ('assist' , '$')
        , ('atype' , '$')
        , ('bill' , '$')
        , ('cashbuf' , '#')
        , ('cust' , '$')
        , ('custodi' , '$')
        , ('discret' , '$')
        , ('eqstrat' , '$')
        , ('feemgr' , '$')
        , ('goal' , '#')
        , ('hhold' , '$')
        , ('name' , '$')
        , ('ndscnt' , '#')
        , ('ornid' , '$')
        , ('portsta' , '#')
        , ('primres' , '$')
        , ('qbmgrid' , '$')
        , ('recdate' , '$')
        , ('status' , '$')
        , ('stdate' , '%')
        , ('taxstat' , '$')
        , ('trdstat' , '$')
        , ('udef1' , '$')
        , ('udef2' , '$')
        , ('ytdrgl' , '#')
)

select
    a.portfolio_id          as portfolio
    , tm.advent_type        as trancode
    , lower(a.advent_label) as labname
    , a.value               as labdef
    , a.is_intraday_import  as is_intraday_import
    , a.trading_id          as trading_id
from cte_accounts_transposed as a
inner join cte_types_mapped as tm
    on lower(a.advent_label) = lower(tm.advent_label)
