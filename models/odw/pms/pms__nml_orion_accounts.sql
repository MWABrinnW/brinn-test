with cte_account_values as (
    select
        acc.account_id
        , acc.account_number
        , ass.fkalclient
        , acc.effective_date

        ------------------------------------------------------------------------------------------------------
        , sum(
            case when coalesce(assb.isfeeexcluded , 0) = 0
                    then assv.calculatedvalue
                else 0
            end
        )                                                                                as billable_value
        ------------------------------------------------------------------------------------------------------
        -- Raw custodial cash. Otherwise defined as custodial cash or any position that auto liquidates?
        , sum(case when prod.is_custodial_cash = 1 then assv.calculatedvalue else 0 end) as custodial_cash_value
        , array_agg(distinct case
            when prod.is_custodial_cash = 1 and abs(assv.calculatedvalue) > 0 then prod.ticker
        end)                                                                             as custodial_cash_symbols

        ------------------------------------------------------------------------------------------------------
        -- Money market funds that don't auto liquidate at the custoidan?
        , sum(case
            when prod.product_class_category = 'M' and coalesce(prod.is_custodial_cash , 0) <> 1 then assv.calculatedvalue
            else 0
        end)                                                                             as mmf_value
        , array_agg(distinct case
            when prod.product_class_category = 'M' and coalesce(prod.is_custodial_cash , 0) <> 1
                and abs(assv.calculatedvalue) > 0
                then prod.ticker
        end)                                                                             as mmf_value_symbols
    from {{ ref('orion__accounts') }} as acc
    left join {{ ref('orion__base_vw_asset') }} as ass
        on acc.fkalclient = ass.fkalclient
        and acc.account_id = ass.accountid
    left join {{ ref('orion__base_vw_assetvalue') }} as assv
        on ass.fkasset = assv.fkasset
        and ass.fkalclient = assv.fkalclient
        and acc.effective_date = assv.effective_date
    left join {{ ref('orion__base_vw_billasset') }} as assb
        on ass.fkasset = assb.fkasset
        and ass.fkalclient = assb.fkalclient
    left join {{ ref('orion__products') }} as prod
        on ass.productid = prod.product_id
        and ass.fkalclient = prod.fkalclient
    where 1 = 1
        and acc.is_head = 1
    group by all
)

, cte_dates as (
    select
        date_key
        , quarter_start_date
        , quarter_end_date
    from {{ ref('dates') }}
    where date_key = (select max(t.effective_date) from cte_account_values as t)
)

, cte_net_flows as (
    select
        acc.fkalclient
        , acc.effective_date
        , acc.account_id
        , sum(t.transamount) as net_flows
    from {{ ref('orion__accounts') }} as acc
    inner join {{ ref('orion__base_vw_asset') }} as ass
        on acc.fkalclient = ass.fkalclient
        and acc.account_id = ass.accountid
    inner join {{ ref('orion__base_vw_transaction') }} as t
        on ass.fkasset = t.fkasset
        and ass.fkalclient = t.fkalclient
    inner join {{ ref('orion__base_vw_transactiontype') }} as tt
        on t.fktranstype = tt.pktranstype
        and t.fkalclient = tt.fkalclient
    inner join cte_dates as dt
        on acc.effective_date = dt.date_key
    where 1 = 1
        and acc.is_head = 1
        and t.fktradestatus = 1--completed transactions
        and tt.financialtype in (1 , 2 , 12)--what are financialtypes ?
        and t.transdate >= acc.effective_date - 30
    group by acc.fkalclient , acc.effective_date , acc.account_id

)

, cte_con_dis as (
    select
        acc.fkalclient
        , acc.effective_date
        , acc.account_id
        , sum(t.transamount) as con_dis_qtd
    from {{ ref('orion__accounts') }} as acc
    inner join {{ ref('orion__base_vw_asset') }} as ass
        on acc.fkalclient = ass.fkalclient
        and acc.account_id = ass.accountid
    inner join {{ ref('orion__base_vw_transaction') }} as t
        on ass.fkasset = t.fkasset
        and ass.fkalclient = t.fkalclient
    inner join cte_dates as dt
        on acc.effective_date = dt.date_key
    where acc.is_head = 1
        and t.fktradestatus = 1--completed transactions
        and t.transdate between dt.quarter_start_date and dt.quarter_end_date
        and t.fktranstype in (
            8--Contribution
            , 9--Employer Contribution
            , 39--Merge In from Other Account
            , 41--1035 Exchange In
            , 42--Merge Out to Other Account
            , 44--1035 Exchange Out
            , 51--Distribution
            , 52--Employer Distribution
            , 61--Starting Value
            , 65--Tax Withheld
            , 76--SWD
            , 77--SWP
            , 106--Short Starting Value
            , 111--Cancel Account
            , 113--Federal Tax Withheld
            , 114--State Tax Withheld
            , 119--Folio Contribution
            , 120--Folio Distribution
            , 166--Rollover Contribution
            , 171--Internal Account Journal Out
            , 172--Internal Account Journal In
            , 175--Loan Payment
            , 176--Loan Setup
            , 179--Loan Repayment
            , 182--Loan Default
            , 185--Reportable Transfer In
            , 186--Loan Distribution
        )
    group by acc.fkalclient , acc.effective_date , acc.account_id
)

select
    a.system_name                              as system_name
    , a.system_instance                        as system_instance
    , a.system_key                             as system_key
    , a.account_id                             as account_id
    , a.household_id                           as client_id
    , a.account_number                         as account_number
    , a.account_number_formatted               as account_number_formatted
    , a.is_managed                             as is_managed
    , a.account_name                           as account_name
    , a.account_type                           as account_type
    , a.advisor::text                          as client_manager
    , a.advisor_email::text                    as client_manager_email
    , a.custodian                              as custodian
    , a.custodian_account_restriction          as custodian_account_restriction
    , a.client_open_date                       as client_open_date
    , a.opened_date                            as opened_date
    , a.closed_date_udf                        as closed_date
    , iff(a.opened_date is not null , 1 , 0)   as is_open
    , a.account_value::decimal(16 , 2)         as current_value
    , av.billable_value::decimal(16 , 2)       as billable_value
    , av.custodial_cash_value::decimal(16 , 2) as custodial_cash_value
    , av.mmf_value::decimal(16 , 2)            as mmf_value
    , a.committed_amount_udf::decimal(16 , 2)  as committed_amount
    , cd.con_dis_qtd::decimal(16 , 2)          as contributions_distributions_qtd
    , nf.net_flows::decimal(16 , 2)            as net_flows
    , a.investment_strategy                    as model_name
    , a.subadvisor                             as subadvisor
    , a.fee_schedule                           as fee_schedule
    , a.fund_family                            as fund_family
    , case
        when a.trading_instructions is not null
            then 1
        else 0
    end::boolean::int                          as has_trading_instructions
    , a.trading_instructions                   as trading_instructions
    , a.is_trading_blocked::int                as is_trading_blocked
    , a.download_source::text                  as download_source
    , a.eclipse_enabled                        as is_eclipse_enabled
    , a.is_sma::boolean::int                   as is_sma
    , a.sma_asset::text                        as sma_asset
    , a.bd_name                                as broker_dealer
    , a.effective_date                         as effective_date
    , a._created_at                            as _created_at
    , a._source_loaded_at                      as _source_loaded_at
from {{ ref('orion__accounts') }} as a
left join cte_account_values as av
    on a.account_id = av.account_id
    and a.fkalclient = av.fkalclient
    and a.effective_date = av.effective_date
left join cte_con_dis as cd
    on a.account_id = cd.account_id
    and a.fkalclient = cd.fkalclient
    and a.effective_date = cd.effective_date
left join cte_net_flows as nf
    on a.account_id = nf.account_id
    and a.fkalclient = nf.fkalclient
    and a.effective_date = nf.effective_date
where 1 = 1
    and a.is_head = 1
    and a.fkalclient = 568
