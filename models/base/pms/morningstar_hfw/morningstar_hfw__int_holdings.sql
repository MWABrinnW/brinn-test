{# NOTE

    This DBT model is to slow for production.  This SQL is copied into the Alteryx flow directly and run from there.

#}

with cte_effective_dates as (
    select distinct effective_date
    from {{ ref('morningstar_hfw__base_gain_loss') }}
    where true
        and effective_date >= '2/1/2023'-- excluding pre 202302, not all dataset were being collected consistently
    {# and effective_date >= '5/20/2023'  -- narrow effective date for efficient dev testing #}
)

, cte_cusip_validate as (
    select
        cusip
        , ticker_symbol                                                                           as ticker
        , security_type_description
        , issue_entry_date
        , effective_date
        , row_number() over (partition by ticker , effective_date order by issue_entry_date desc) as rn_ticker
    from {{ ref('cusip_history__base_issues') }}-- Grant suggested using this dataset instead of Security_Master from Alteryx
    where true
        and issue_status = 'A'-- assuming this stands for Active, might need to remove this (ticker = MDT is blocked by this)
        and effective_date in (
            select effective_date
            from cte_effective_dates
        )
)

, cte_tpg_morningstar_overlap as (
    select
        client_name
        , tpg_id_number
        , morningstar_acct_number
        , morningstar_account_name
        , _created_at
        , 'Comerica' as custodian-- helps with coalesce in cte_joined
    from {{ ref('aux__base_hfw_tpg_mstar_overlap') }}
)

, cte_fa as (
    select *
    from {{ ref('morningstar_hfw__int_accounts') }}
    where effective_date in
        (
            select distinct effective_date
            from cte_effective_dates
        )
)

, cte_gain_loss as (
    select
        gl.effective_date
        , gl.advisor_name
        , gl.client_name
        , gl.account_name
        , iff(
            gl.account_number is null
            and gl.client_name = 'Friends Cove Mutual Ins. Co.'
            and gl.account_name = 'Equity Account'
            , '001050977010'
            , replace(gl.account_number , '  ' , ' ')
        )                                           as financial_account_number
        , gl.security_name
        , gl.symbol_cusip
        , coalesce(c.cusip , gl.symbol_cusip)       as cusip_mapped-- a single symbol can map to various cusip values (ex. JPO -> 46656C103, 465938405)
        , gl.acquisition_date
        , gl.short_term_unrealized_gl
        , gl.long_term_unrealized_gl
        , gl.gl_percent
        , gl.unit_cost
        , gl.price
        , gl.quantity
        , gl.market_value
        , gl.percent_of_asset_percent
        , gl.effective_at
        , gl._created_at
        , gl._source_file
        , 'DATALAKE.MORNINGSTAR_HFW.BASE_GAIN_LOSS' as system_details
    from {{ ref('morningstar_hfw__base_gain_loss') }} as gl
    left join cte_cusip_validate as c
        on gl.symbol_cusip = c.ticker--symbol_cusip has mix of tickers and cusip values
        and gl.effective_date = c.effective_date
        and c.rn_ticker = 1
    where true
        and not (
            gl.client_name like '%Sample Client%'
            and gl.account_name like '%Sample%'
            and gl.account_name like '%Account%'
        )
        and gl.effective_date in (
            select effective_date
            from cte_effective_dates
        )
)

, cte_tpg_holdings as (
    select
        t.as_of_date
        , t.customeraccountnumber
        , t.customername
        , t.customertypedesc
        , t.cusip
        , t.cusipdescription
        , t.holdingtypedesc
        , row_number() over (
            partition by
                t.as_of_date
                , t.customeraccountnumber
                , t.customername
                , t.customertypedesc
                , t.cusip
                , t.cusipdescription
                , t.effective_date
                , t.record_datetime
                , t.source_file
            order by t.fairvalue desc
        )                                as rn
        , avg(t.purchaseprice) over (
            partition by
                t.as_of_date
                , t.customeraccountnumber
                , t.customername
                , t.customertypedesc
                , t.cusip
                , t.cusipdescription
                , t.holdingtypedesc
                , t.effective_date
                , t.record_datetime
                , t.source_file
        )                                as purchaseprice
        , avg(t.marketpriceaod) over (
            partition by
                t.as_of_date
                , t.customeraccountnumber
                , t.customername
                , t.customertypedesc
                , t.cusip
                , t.cusipdescription
                , t.holdingtypedesc
                , t.effective_date
                , t.record_datetime
                , t.source_file
        )                                as marketpriceaod
        , sum(t.fairvalue) over (
            partition by
                t.as_of_date
                , t.customeraccountnumber
                , t.customername
                , t.customertypedesc
                , t.cusip
                , t.cusipdescription
                , t.effective_date
                , t.record_datetime
                , t.source_file
        )                                as sum_fairvalue
        , sum(t.parvalue) over (
            partition by
                t.as_of_date
                , t.customeraccountnumber
                , t.customername
                , t.customertypedesc
                , t.cusip
                , t.cusipdescription
                , t.effective_date
                , t.record_datetime
                , t.source_file
        )                                as sum_parvalue
        , t.effective_date
        , t.record_datetime
        , t.source_file
        , 'DATALAKE.TPG_HFW.VW_HOLDINGS' as system_details
        , o.tpg_id_number                as overlap_account_number
    from {{ ref('tpg_hfw__vw_holdings') }} as t
    left join cte_tpg_morningstar_overlap as o
        on t.customeraccountnumber = o.tpg_id_number
    where t.effective_date in (
            select effective_date
            from cte_effective_dates
        )
        and overlap_account_number is null
        and rn = 1
)

, cte_holdings_base as (
    select
        gl.financial_account_number as financial_account_number
        , gl.cusip_mapped           as cusip
        , gl.effective_date
    from cte_gain_loss as gl

    union

    select
        t.customeraccountnumber as financial_account_number
        , t.cusip               as cusip
        , t.effective_date
    from cte_tpg_holdings as t
    where rn = 1
)

, cte_holdings as (
    select
        fa.system_name                                                            as system_name
        , coalesce(gl.system_details , h.system_details)                          as system_details
        , fa.financial_account_number                                             as financial_account_number
        , fa.financial_account_number_clean                                       as financial_account_number_clean
        , fa.internal_financial_account_number                                    as internal_financial_account_number
        , coalesce(sf.household_id , fa.internal_household_number)                as internal_household_number
        , coalesce(sf.account_name , fa.financial_account_name)                   as financial_account_name
        , coalesce(sf.household_location_code , fa.location_code)                 as location_code
        , coalesce(sf.location_name , fa.location_name)                           as location_name
        , coalesce(sf.custodian , fa.custodian)                                   as custodian
        , coalesce(sf.aum_classification , fa.aum_classification_status)          as aum_classification_status
        , fa.discretion_status                                                    as discretion_status
        , fa.proxy_voting_status                                                  as proxy_voting_status
        , coalesce(c.cusip , gl.cusip_mapped , h.cusip)                           as cusip
        , coalesce(c.ticker , gl.cusip_mapped , c.ticker)                         as ticker--noqa: disable=AL03
        , regexp_replace(
            coalesce(gl.security_name , h.cusipdescription) , '[™®]'
            , ''
        )--regex excludes Trademark and Registered symbols
        , coalesce(c.security_type_description , h.holdingtypedesc)               as security_type--noqa: enable=AL03
        , coalesce(gl.market_value , h.sum_fairvalue)                             as market_value
        , coalesce(gl.quantity , h.sum_parvalue)                                  as units_shares
        , coalesce(gl.price , h.marketpriceaod)                                   as price
        , coalesce(gl.unit_cost * gl.quantity , h.purchaseprice * h.sum_parvalue) as cost_basis
        , coalesce(gl.effective_date , h.effective_date)                          as as_of_date
        , fa.aum_status                                                           as aum_status
        , coalesce(gl.effective_date , h.effective_date)                          as effective_date
        , fa.month_end_date                                                       as month_end_date
        , null                                                                    as source_filename
        , coalesce(fa.system_name , '') || '|'
        || coalesce(fa.internal_financial_account_number , '')
        || '|' || b.effective_date                                                as key_financial_account_holdings
    from cte_holdings_base as b
    inner join cte_fa as fa
        on b.financial_account_number = fa.financial_account_number
        and b.effective_date = fa.effective_date
    left join cte_tpg_holdings as h
        on b.financial_account_number = h.customeraccountnumber
        and b.cusip = h.cusip
        and b.effective_date = h.effective_date
        and h.rn = 1
    left join cte_gain_loss as gl
        on b.financial_account_number = gl.financial_account_number
        and coalesce(b.cusip , 'CASH') = coalesce(gl.cusip_mapped , 'CASH')
        and b.effective_date = gl.effective_date
    left join cte_cusip_validate as c
        on b.cusip = c.cusip
        and b.effective_date = c.effective_date
        and c.rn_ticker = 1
    left join {{ ref("int_salesforce_compass_accounts") }} as sf
        on b.financial_account_number = sf.account_number
        and b.effective_date = sf.effective_at::date
)

select *
from cte_holdings
