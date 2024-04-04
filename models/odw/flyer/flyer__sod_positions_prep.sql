with cte_accounts as
(
    select *
    from {{ ref('flyer__sod_accounts') }}
)
,cte_fidelity_sweep_assignments as
(
    select account_number, ticker
    from {{ ref('int_fidelity_account_sweep_fund') }}
    where 1=1
        and is_head = 1
    qualify row_number() over(partition by account_number order by firm_source) = 1
)
,cte_schwab_cash as
(
    -- Schwab presents cash as a non-security holding so it doesn't
    -- appear in the tax lots dataset. However, money market funds
    -- (SNAXX) do appear in the tax lots data.
    -- Fidelity doesn't have a non-security cash position, instead
    -- representing all cash within a MMF security position (FDRXX).
    select
        a.effective_date                              as effective_date
        , a.custodian                                 as custodian
        , a.account_number                            as account_number
        , 'CASH'::text(200)                           as product
        , '_SCHWAB_CASH'::text(200)                   as ticker
        , null::text(200)                             as cusip
        , a.cash_balance_settled_only::decimal(15, 2) as quantity
        , null::decimal(20, 5)                        as price
        , null::decimal(20, 5)                        as lot_cost
        , 1.0000                                      as current_price
        , 1::int                                      as is_cash
        , 1::int                                      as is_sweep
        , 19000101::int                               as lot_date
        , null::text(200)                             as lot_num
        , 'N'                                         as unsupervised
        , 'N'                                         as cusiplookup
        , 'N'                                         as preferred
        , 4622::text                                  as securityid
        , null::text(200)                             as security_type_description
        , null::text(200)                             as fund_type
        , null::text(200)                             as product_type
        , null::text(200)                             as product_type_source_code
        , null::text(200)                             as product_type_source_definition
        , null::text(200)                             as legacy_product_type
        , null::text(200)                             as legacy_product_type_source_code
        , null::text(200)                             as legacy_product_type_source_definition

        , 'cte_schwab_cash--base_cash'                as src
    from {{ ref('schwab__base_cash') }}              a
    join cte_accounts                                v
        on upper(a.custodian) = upper(v.custodian)
            and upper(a.account_number) = upper(v.account_No)
    where true
        and a.rn = 1
        and a.firm_source in ('mwa', 'mps')
        and a.is_current = 1
)
,cte_schwab_money_market as
(
    select
        a.effective_date                              as account_number
        , a.custodian                                 as custodian
        , a.account_number                            as account_number
        , 'CASH'::text(200)                           as product
        , a.ticker                                    as ticker
        , a.cusip                                     as cusip
        , a.units_shares                              as quantity
        , a.price                                     as price
        , a.units_shares                              as lot_cost
        , 1.0000                                      as current_price
        , 1::int                                      as is_cash
        , 1::int                                      as is_sweep
        , 19000101::int                               as lot_date
        , null::text(200)                             as lot_num
        , 'N'                                         as unsupervised
        , 'N'                                         as cusiplookup
        , 'N'                                         as preferred
        , 4622::text                                  as securityid
        , null::text(200)                             as security_type_description
        , null::text(200)                             as fund_type
        , null::text(200)                             as product_type
        , null::text(200)                             as product_type_source_code
        , null::text(200)                             as product_type_source_definition
        , null::text(200)                             as legacy_product_type
        , null::text(200)                             as legacy_product_type_source_code
        , null::text(200)                             as legacy_product_type_source_definition

        , 'cte_schwab_money_market--nml_schwab_holdings'  as src
    from {{ ref('nml_schwab_holdings') }} a
    join cte_accounts                     v
        on upper(a.custodian) = upper(v.custodian)
        and a.account_number = v.account_no
    where 1=1
        and is_current = 1
        and is_sweep = 1
)
,cte_fidelity_money_market as
(
    -- Fidelity money market (FDRXX) isn't included in the tax lots data.
    -- But this is a position and needs to be represented.
    select
        a.effective_date                            as effective_date
        , a.custodian                               as custodian
        , a.account_number                          as account_number
        , case
            when a.is_sweep = 1
                then 'CASH'
            else 'MUT'
            end::text(200)                          as product
        , a.ticker                                  as ticker
        , null::text(200)                           as cusip
        , sum(a.quantity)                           as quantity
        , 1.0000::decimal(20,5)                     as price
        , sum(a.market_value)                       as lot_cost
        , 1.0000::decimal(20,5)                     as current_price
        , is_cash                                   as is_cash
        , is_sweep                                  as is_sweep
        , 19000101::int                             as lot_date
        , null::text(200)                           as lot_num
        , 'N'                                       as unsupervised
        , 'N'                                       as cusiplookup
        , 'N'                                       as preferred
        , 4622::text                                as securityid
        , null::text(200)                           as security_type_description
        , null::text(200)                           as fund_type
        , null::text(200)                           as product_type
        , null::text(200)                           as product_type_source_code
        , null::text(200)                           as product_type_source_definition
        , null::text(200)                           as legacy_product_type
        , null::text(200)                           as legacy_product_type_source_code
        , null::text(200)                           as legacy_product_type_source_definition

        , 'cte_fidelity_money_market--nml_fidelity_mwa_holdings' as src
    from {{ ref('nml_fidelity_mwa_holdings') }} a
    join cte_accounts                                v
        on upper(a.custodian) = upper(v.custodian)
            and upper(a.account_number) = upper(v.account_No)
    where true
        --and is_head = 1
        and is_current = 1
        and is_cash = 1
    group by all
)
,cte_securities as
(
    select
        cusip, ticker_symbol, security_type_description, fund_type
        , row_number() over(partition by cusip order by iff(security_type_description is not null, 0, 1) asc, issue_entry_date desc) as rn_cusip
        , row_number() over(partition by ticker_symbol order by iff(security_type_description is not null, 0, 1) asc, issue_entry_date desc) as rn_ticker
    from {{ ref('cusip_history__base_issues') }}
    where 1=1
        and is_head = 1
        {# and (
            cusip in (select distinct cusip from cte_tax_lots)
            or ticker_symbol in (select distinct ticker from cte_tax_lots)
        ) #}
    order by ticker_symbol, cusip
)
,cte_tax_lots as
(
    -- These are the tax lots from the custodians.
    select
        a.effective_date                       as effective_date
        , a.custodian                            as custodian
        , a.account_number                       as account_number
        , case
                when a.is_cash = 1
                    then 'CASH'

                -- [CUSIP DATA]
                when s.cusip is not null and s.security_type_description in ('Anticipation Notes', 'Asset Backed', 'Certificate of Deposit', 'Collateralized Debt Corporate', 'GO', 'Medium Term Note', 'Mortgage Backed', 'Note', 'Prerefunded', 'Refunding', 'Reinsured', 'Secondarily Insured Municipal', 'U.S. Government', 'Unrefunded', 'Warrant', 'Zero Coupon')
                    then 'FI'

                -- This is not reliable. Example: AEPGX
                --when s.cusip is not null and s.security_type_description in ('Common Equity', 'Exchange Traded Fund', 'Depositary Receipt')
                --    then 'EQ'

                -- We can't use this because it doesn't reliably tag mutual funds.
                -- Fund from cusip might tag some ETFs as a "Fund", for instance.
                -- Example: ARGT
                -- when s.cusip is not null and s.security_type_description = 'Fund'
                --    then 'MUT'

                -- This handles something like cusip=09261H305. But not all REIT are FI.
                when a.custodian ilike 'fidelity' and a.product_type_source_definition ilike any ('%Units - REIT%') and len(a.ticker) >= 9
                    then 'FI'

                -- [SCHWAB]
                when a.custodian ilike 'schwab' and a.ticker in ( 'SWGXX' )
                    -- Not sure if this is correct. Should others be included? SNAXX/SNOXX/etc
                    then 'CASH'
                -- We're using the legacy security type becuase there are fewer values/rollups
                -- to consider compared to the more granular product "product_type_source_definition".
                when a.custodian ilike 'schwab' and a.legacy_product_type_source_definition in ('Mutual Fund - Non-Taxable', 'Mutual Fund - Taxable')
                    then 'MUT'
                when a.custodian ilike 'schwab' and a.product_type_source_definition ilike any ('EQUITY OPTION', 'OPTION INDEX')
                    then 'OPT'
                when a.custodian ilike 'schwab' and a.legacy_product_type_source_definition in ('Certificate of Deposit'
                                                                                                , 'Corporate Bond'
                                                                                                , 'Government Bond'
                                                                                                , 'Municipal Bond'
                                                                                                , 'Treasury Bill'
                                                                                                , 'Treasury Note')
                    then 'FI'
                when a.custodian ilike 'schwab' and a.product_type_source_definition ilike any ('%CLOSED END MUTUAL FUND%')
                    then 'MUT'
                when a.custodian ilike 'schwab' and a.legacy_product_type_source_definition in ('Common Stock'
                                                                                                , 'Convertible Preferred Stock'
                                                                                                , 'Preferred Stock')
                    then 'EQ'
                when a.custodian ilike 'schwab' and a.legacy_product_type_source_definition ilike any ('real estate investment trust')
                    then 'EQ'
                when a.custodian ilike 'schwab' and a.legacy_product_type_source_definition in ('Other Assets'
                                                                                                ,'Reorganization'
                                                                                                ,'UIT - Taxable'
                                                                                                ,'Warrants'
                                                                                                ,'GNMA, GNMA, FHLMC, Mortgage-pools, CMO''s, etc')
                    then 'FI'

                -- [FIDELITY]
                when a.custodian ilike 'fidelity' and a.product_type_source_definition ilike 'option - %'
                    then 'OPT'
                when a.custodian ilike 'fidelity' and a.product_type_source_definition ilike '%mutual fund%'
                    then 'MUT'
                when a.custodian ilike 'fidelity' and a.product_type_source_definition ilike '%equity - %'
                    then 'EQ'
                when a.custodian ilike 'fidelity' and a.product_type_source_definition ilike any ('%units - %', 'debt - ')
                    then 'FI'

                -- [OTHER CUSTODIAN]
                else
                    'FI'
                end::text(200)                   as product
        -- Cleanup the symbol value for scenarios where there is not ticker or cusip.
        -- This can happen for something like a private limited partnership.
        -- Equities have max length of 10 for symbol in copilot.
        , case
            when product in ('FI','EQ')
                then left(replace(replace(a.symbol,'-',''),' ',''),10)
            else
                a.symbol
            end::text(200)                       as ticker
        , a.cusip                                as cusip
        , a.quantity                             as quantity
        , a.cost_per_share                       as price
        , a.cost_basis                           as lot_cost
        , a.current_price                        as current_price
        , a.is_cash                              as is_cash
        , a.is_sweep                             as is_sweep
        , to_char(a.trade_date, 'YYYYMMDD')::int as lot_date
        , a.lot_id_source                        as lot_num
        , 'N'::text(1)                           as unsupervised
        , 'N'::text(1)                           as cusiplookup
        , 'N'::text(1)                           as preferred
        , a.security_id_source                   as securityId
        , s.security_type_description
        , s.fund_type
        , a.product_type
        , a.product_type_source_code
        , a.product_type_source_definition
        , a.legacy_product_type
        , a.legacy_product_type_source_code
        , a.legacy_product_type_source_definition

        , 'cte_tax_lots--custodian_tax_lots'     as src
    from {{ ref('custodian_tax_lots') }}             a
    join cte_accounts                                v
        on upper(a.custodian) = upper(v.custodian)
            and upper(a.account_number) = upper(v.account_No)
    left join cte_securities                         s
        on a.cusip = s.cusip
        and s.rn_cusip = 1
    where 1 = 1
        and a.is_current = 1
        and a.firm_source in ('mwa', 'mps')
        -- exclude because we pull from holdings
        and not(a.custodian = 'fidelity' and a.is_cash = 1)
    qualify dense_rank() over(
        partition by a.effective_date, a.account_number
        order by case when a.firm_source = 'mwa' then 1 when a.firm_source = 'mps' then 2 else 3 end
    ) = 1
)
,cte_schwab_mmf_rollup as
(
    -- To reduce total records for upload performance,
    -- rollup the schwab money market positions. Lot level
    -- detail is not necessary. These are non-sweep positions
    -- so they should typically get assigned a product of MUT
    -- and not CASH.
    select
          effective_date
        , custodian
        , account_number
        , product
        , ticker
        , cusip
        , sum(quantity)                             as quantity
        , price                                     as price
        , sum(lot_cost)                             as lot_cost
        , current_price
        , is_cash
        , is_sweep
        , max(lot_date)                             as lot_date
        , null::text(200)                           as lot_num
        , unsupervised
        , cusiplookup
        , preferred
        , securityid
        , null::text(200)                           as security_type_description
        , null::text(200)                           as fund_type
        , null::text(200)                           as product_type
        , null::text(200)                           as product_type_source_code
        , null::text(200)                           as product_type_source_definition
        , null::text(200)                           as legacy_product_type
        , null::text(200)                           as legacy_product_type_source_code
        , null::text(200)                           as legacy_product_type_source_definition

        , 'cte_schwab_mmf_rollup--cte_tax_lots'     as src
    from cte_tax_lots
    where custodian ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS'
    group by all
    order by custodian, account_number
)
,cte_final as
(
    select *
    from cte_tax_lots
    where 1=1
        -- These records get brought in with cte_schwab_mmf_rollup.
        and not(custodian ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS')

    union all

    -- Schwab MMF sweep positions (SWGXX), which aren't in tax lots.
    select *
    from cte_schwab_money_market

    union all

    -- Schwab's MMF cash positions rolled up.
    -- These have tax lots but copilot doesn't
    -- need tax lot level detail for these because
    -- they are basically cash.
    select *
    from cte_schwab_mmf_rollup

    union all

    -- Schwab's non-security cash positions. Schwab
    -- uses raw cash instead of MMF, except for SWGXX.
    select *
    from cte_schwab_cash

    union all

    -- Fidelity's MMF which encompasses all account cash.
    select *
    from cte_fidelity_money_market
)
,cte_product_mapping as
(
    -- We need to handle any tickers that are currently resolving to
    -- more than one product. We can create an order of preference
    -- and then make it available to apply to any tickers that
    -- have more than one distinct product value.

    -- Note that this will override some positions that we _maybe_
    -- wouldn't want to technically override. Cash-like mutual funds
    -- like FDRXX are sweep positions for some accounts and not for others.
    -- Originally, we would have some accounts upload with it tagged
    -- as CASH and others as MUT, depending on the acccount-level
    -- settings maintained at Fidelity.
    -- See ref('int_fidelity_account_sweep_fund')
    select
        ticker, product, dense_rank() over(
            partition by ticker
            order by case
                when product ilike 'cash' then 1
                when product ilike 'opt' then 2
                when product ilike 'mut'then 3
                when product ilike 'eq' then 4
                when product ilike 'fi' then 5
                else 6 end) as rank
    from cte_final
    group by ticker, product
)

select
      a.effective_date
    , a.custodian
    , a.account_number
    , coalesce(pm.product, a.product) as product
    , a.ticker
    , a.cusip
    , a.quantity
    , a.price
    , a.lot_cost
    , a.current_price
    , a.is_cash
    , a.is_sweep
    , a.lot_date
    , a.lot_num
    , a.unsupervised
    , a.cusiplookup
    , a.preferred
    , a.securityid
    , a.security_type_description
    , a.fund_type
    , a.product_type
    , a.product_type_source_code
    , a.product_type_source_definition
    , a.legacy_product_type
    , a.legacy_product_type_source_code
    , a.legacy_product_type_source_definition
    , a.src
from cte_final a
left join cte_product_mapping pm
    on a.ticker = pm.ticker
    and pm.rank = 1
order by custodian, account_number, ticker
