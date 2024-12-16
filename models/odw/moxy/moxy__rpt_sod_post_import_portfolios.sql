with cte_moxy_stg_accounts as (
    select
        portfolio_id
        , portfolio_name
        , account_number
        , account_number_formatted
        , close_date
        , portfolio_status_id
        , user_def_10
    from {{ ref('moxy__stg_accounts') }}
    where _created_at = (
            select max(_created_at)
            from {{ ref('moxy__stg_accounts') }}
        )
        and portfolio_status_id = 1
)

, cte_base as (
    select
        lower(a.portfolio_id)        as portfolio_id_left
        , a.portfolio_name           as portfolio_name_left
        , a.account_number           as account_number_left
        , a.account_number_formatted as account_number_formatted_left
        , a.close_date               as close_date_left
        , a.portfolio_status_id      as portfolio_status_id_left
        , a.user_def_10              as user_def_10_left
        , lower(b.portfolio_id)      as portfolio_id_right
        , b.acctno                   as acct_no_right
        , b.name                     as portfolio_name_right
        , b.account_number           as account_number_right
        , b.trdstat                  as trade_status_right
        , b.status                   as status_right
        , b.portstat                 as portfolio_status_right
        , b.cust                     as cust_right
        , b.recdate                  as recdate_right
    from cte_moxy_stg_accounts as a
    full outer join {{ ref('moxy__accounts_build_flat') }} as b
        on lower(a.portfolio_id) = lower(b.portfolio_id)
)

-- left unjoined accounts
, cte_moxy_orphans as (
    select
        portfolio_id_left               as "PortID"
        , portfolio_name_left           as "PortName"
        , account_number_left           as "AcctID"
        , 'Orphan Moxy Account - Stale' as "Error Type"
    from cte_base
    where portfolio_id_right is null
)

-- right unjoined accounts
, cte_orion_orphans as (
    select
        portfolio_id_right                      as "PortID"
        , portfolio_name_right                  as "PortName"
        , account_number_right                  as "AcctID"
        , 'Orphan Orion Account - Not Imported' as "Error Type"
    from cte_base
    where portfolio_id_left is null
)

, cte_joined as (
    select *
    from cte_base
    where portfolio_id_right is not null
        and portfolio_id_left is not null
)

, cte_moxy_undefined as (
    select
        portfolio_id_left                  as "PortID"
        , portfolio_name_left              as "PortName"
        , account_number_left              as "AcctID"
        , 'Moxy Undefined - Holdings Only' as "Error Type"
    from cte_joined
    where portfolio_name_left like 'undefined%'
)

, cte_moxy_stale as (
    select
        portfolio_id_left                    as "PortID"
        , portfolio_name_left                as "PortName"
        , account_number_left                as "AcctID"
        , 'Stale Moxy Account - Out Of Date' as "Error Type"
    from cte_joined
    where date(user_def_10_left) != date(recdate_right)
)

select *
from cte_moxy_orphans

union all

select *
from cte_orion_orphans

union all

select *
from cte_moxy_undefined

union all

select *
from cte_moxy_stale
order by "Error Type" , "PortID"
