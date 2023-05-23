with cte_effective_dates as
    (
        select distinct effective_date
        from {{ ref('morningstar_hfw__base_gain_loss')}}
        where true
            and effective_date >= '2/1/2023'
            {# and effective_date >= '3/1/2023' #}
    )
   , cte_cusip_validate as
    (
        select cusip
             , ticker_symbol                                                          as ticker
             , SECURITY_TYPE_DESCRIPTION
             , ISSUE_ENTRY_DATE
             , effective_date
             , row_number() over (partition by ticker order by ISSUE_ENTRY_DATE desc) as rn_ticker
        from {{ ref('cusip_history__base_issues') }} -- Grant suggested using this dataset instead of Security_Master from Alteryx
        where true
          and issue_status = 'A' -- assuming this stands for Active, might need to remove this (ticker = MDT is blocked by this)
          and effective_date in (
                                    select effective_date
                                    from cte_effective_dates
                                )
    )
   , cte_tpg_morningstar_overlap as
    (
        select 
            client_name
            ,tpg_id_number
            ,morningstar_acct_number
            ,morningstar_account_name
            ,_created_at
             , 'Comerica' as custodian -- helps with coalesce in cte_joined
        from {{ ref('aux__base_hfw_tpg_mstar_overlap') }}
    )   
   , cte_fa as
    (
        select *
        from {{ ref('morningstar_hfw__int_accounts') }}
        where effective_date in 
            (
                select distinct effective_date
                from cte_effective_dates
            )
    )
   , cte_gain_loss as
    (
        select gl.effective_date
             , gl.advisor_name
             , gl.client_name
             , gl.account_name
             , iff(gl.account_number is null
                       and gl.client_name = 'Friends Cove Mutual Ins. Co.'
                       and gl.account_name = 'Equity Account',
                   '001050977010',
                   replace(gl.account_number, '  ', ' '))   as financial_account_number
             , gl.security_name
             , gl.symbol_cusip
             , coalesce(c.cusip, gl.SYMBOL_CUSIP)        as cusip_mapped
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
        from {{ref('morningstar_hfw__base_gain_loss') }} gl
        left join cte_cusip_validate c
            on gl.SYMBOL_CUSIP = c.TICKER --symbol_cusip has mix of tickers and cusip values
            and gl.effective_date = c.effective_date
            and c.rn_ticker = 1
        where true
            and not (gl.client_name like '%Sample Client%'
            and gl.account_name like '%Sample%'
            and gl.account_name like '%Account%')
            and gl.effective_date in (
                                        select effective_date
                                        from cte_effective_dates
                                     )
    )
   , cte_tpg_holdings as
    (
        select t.as_of_date,
               t.customeraccountnumber,
               t.customername,
               t.customertypedesc,
               t.cusip,
               t.cusipdescription,
               t.holdingtypedesc,
               row_number() over (
                   partition by as_of_date,
                       customeraccountnumber,
                       customername,
                       customertypedesc,
                       cusip,
                       CUSIPDESCRIPTION,
                       effective_date,
                       record_datetime,
                       source_file
                   order by fairvalue desc )  as rn,
               avg(purchaseprice) over (
                   partition by as_of_date,
                       customeraccountnumber,
                       customername,
                       customertypedesc,
                       cusip,
                       cusipdescription,
                       holdingtypedesc,
                       effective_date,
                       record_datetime,
                       source_file
                   )                          as purchaseprice,
               avg(marketpriceaod) over (
                   partition by as_of_date,
                       customeraccountnumber,
                       customername,
                       customertypedesc,
                       cusip,
                       cusipdescription,
                       holdingtypedesc,
                       effective_date,
                       record_datetime,
                       source_file
                   )                          as marketpriceaod,
               sum(FAIRVALUE) over (
                   partition by as_of_date,
                       customeraccountnumber,
                       customername,
                       customertypedesc,
                       cusip,
                       CUSIPDESCRIPTION,
                       effective_date,
                       record_datetime,
                       source_file
                   )                          as sum_fairvalue,
               sum(parvalue) over (
                   partition by as_of_date,
                       customeraccountnumber,
                       customername,
                       customertypedesc,
                       cusip,
                       CUSIPDESCRIPTION,
                       effective_date,
                       record_datetime,
                       source_file
                   )                          as sum_parvalue,
               effective_date,
               record_datetime,
               source_file,
               'DATALAKE.TPG_HFW.VW_HOLDINGS' as system_details,
               o.TPG_ID_NUMBER                as overlap_account_number
        from {{ ref('tpg_hfw__vw_holdings') }} t
        left join cte_tpg_morningstar_overlap o
            on t.CUSTOMERACCOUNTNUMBER = o.TPG_ID_NUMBER
        where t.effective_date in (
                                    select effective_date
                                    from cte_effective_dates
                                )
            and overlap_account_number is null
    )
   , cte_holdings_base as
    (
        select gl.financial_account_number as financial_account_number
             , gl.cusip_mapped             as cusip
             , gl.effective_date
        from cte_gain_loss gl

        union

        select t.customeraccountnumber as financial_account_number
             , t.cusip                 as cusip
             , t.effective_date
        from cte_tpg_holdings t
        where rn = 1
    )
   , cte_holdings as
    (
        select
              fa.system_name                                                         as system_name
            , coalesce(gl.system_details, h.system_details)                          as system_details
            , fa.financial_account_number                                            as financial_account_number
            , fa.financial_account_number_clean                                      as financial_account_number_clean
            , fa.internal_financial_account_number                                   as internal_financial_account_number
            , coalesce(sf.household_id, fa.internal_household_number)                as internal_household_number
            , coalesce(sf.account_name, fa.financial_account_name)                   as financial_account_name
            , coalesce(sf.household_location_code, fa.location_code)                 as location_code
            , coalesce(sf.location, fa.location_name)                                as location_name
            , coalesce(sf.custodian, fa.custodian)                                   as custodian
            , coalesce(sf.aum_classification, fa.aum_classification_status)          as aum_classification_status
            , fa.discretion_status                                                   as discretion_status
            , fa.proxy_voting_status                                                 as proxy_voting_status
            , coalesce(c.cusip, gl.cusip_mapped, h.cusip)                            as cusip
            , coalesce(c.ticker, gl.cusip_mapped, c.ticker)                          as ticker
            , regexp_replace(coalesce(gl.security_name, h.cusipdescription), '[™®]',
                            '') --regex excludes Trademark and Registered symbols
            , coalesce(c.security_type_description, h.holdingtypedesc)               as security_type
            , coalesce(gl.market_value, h.sum_fairvalue)                             as market_value
            , coalesce(gl.quantity, h.sum_parvalue)                                  as units_shares
            , coalesce(gl.price, h.marketpriceaod)                                   as price
            , coalesce(gl.unit_cost * gl.quantity, h.purchaseprice * h.sum_parvalue) as cost_basis
            , coalesce(gl.effective_date, h.effective_date)                          as as_of_date
            , fa.aum_status                                                          as aum_status
            , coalesce(gl.effective_date, h.effective_date)                          as effective_date
            , fa.month_end_date                                                      as month_end_date
            , null                                                                   as source_filename
            , nvl(fa.system_name, '') || '|' ||
            nvl(fa.internal_financial_account_number, '') ||
            '|' || b.effective_date                                                  as key_financial_account_holdings
        from cte_holdings_base b
        join cte_fa fa 
            on b.financial_account_number = fa.financial_account_number
            and b.effective_date = fa.effective_date
        left join cte_tpg_holdings h 
            on b.financial_account_number = h.customeraccountnumber
            and b.cusip = h.cusip
            and b.effective_date = h.effective_date
            and h.rn = 1
        left join cte_gain_loss gl 
            on b.financial_account_number = gl.financial_account_number
            and nvl(b.cusip, 'CASH') = nvl(gl.cusip_mapped, 'CASH')
            and b.effective_date = gl.effective_date
        left join cte_cusip_validate c 
            on b.cusip = c.CUSIP
            and b.effective_date = c.effective_date
            and c.rn_ticker = 1
        left join {{ ref("int_salesforce_compass_accounts")}} sf
            on b.financial_account_number = sf.account_number
            and b.effective_date = sf.effective_at::date
    )

select *
from cte_holdings
