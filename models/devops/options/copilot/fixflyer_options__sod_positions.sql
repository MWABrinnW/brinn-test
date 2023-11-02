with cte_accounts as
(
    select *
    from {{ ref('fixflyer_options__sod_accounts') }}
)
,cte_schwab_cash as
(
    -- Schwab presents cash as a non-security holding so it doesn't
    -- appear in the tax lots dataset. However, money market funds
    -- (SNAXX) do appear in the tax lots data.
    -- Fidelity doesn't have a non-security cash position, instead
    -- representing all cash within a MMF security position (FDRXX).
    select
      a.effective_date                            as effective_date
    , upper(a.custodian)                          as custodiancode
    , a.account_number                            as account
    , 'CASH'::text(200)                           as product
    , '_SCHWAB_CASH'                              as symbol
    , a.cash_balance_settled_only::decimal(15, 2) as quantity
    , null::decimal(20, 5)                        as unitcost
    , null::decimal(20, 5)                        as totalcost
    , 1.0000                                      as price
    , 19000101::int                               as lotdate
    , null::text(200)                             as lotnum
    , 'N'                                         as unsupervised
    , 'N'                                         as cusiplookup
    , null::text(200)                             as cusip
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
    from {{ ref('schwab__base_cash') }}              a
    join cte_accounts                                v
        on a.effective_date = v.effective_date
            and upper(a.custodian) = upper(v.custodian)
            and upper(a.account_number) = upper(v.account_No)
    where true
        and a.rn = 1
        and a.firm_source in ('mwa', 'mps')
        and a.is_current = 1
)
,cte_fidelity_money_market as
(
    -- Fidelity money market (FDRXX) isn't included in the tax lots data.
    -- But this is a position and needs to be represented.
    select
        a.effective_date                            as effective_date
        , upper(a.custodian)                        as custodiancode
        , a.account_number                          as account
        , 'CASH'::text(200)                         as product
        , a.ticker                                  as symbol
        , sum(a.units_shares)                       as quantity
        , 1.0000::decimal(20,5)                     as unitcost
        , sum(a.market_value)                       as totalcost
        , 1.0000::decimal(20,5)                     as price
        , 19000101::int                             as lotdate
        , null::text(200)                           as lotnum
        , 'N'                                       as unsupervised
        , 'N'                                       as cusiplookup
        , null::text(200)                           as cusip
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
    from {{ ref('nml_fidelity_mwa_holdings') }} a
    join cte_accounts                                v
        on a.effective_date = v.effective_date
            and upper(a.custodian) = upper(v.custodian)
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
    , upper(a.custodian)                     as custodiancode
    , a.account_number                       as account
    , case
            when a.is_cash = 1
                then 'CASH'

            -- CUSIP DATA
            when s.cusip is not null and s.security_type_description in ('Anticipation Notes', 'Asset Backed', 'Certificate of Deposit', 'Collateralized Debt Corporate', 'GO', 'Medium Term Note', 'Mortgage Backed', 'Note', 'Prerefunded', 'Refunding', 'Reinsured', 'Secondarily Insured Municipal', 'U.S. Government', 'Unrefunded', 'Warrant', 'Zero Coupon')
                then 'FI'
            when s.cusip is not null and s.security_type_description in ('Common Equity', 'Exchange Traded Fund', 'Depositary Receipt')
                then 'EQ'

            -- SCHWAB
            when a.custodian = 'schwab'
                then case
                        -- Not sure if this is correct. Should others be included? SNAXX/SNOXX/etc
                        when a.ticker in ( 'SWGXX' )
                            then 'CASH'
                        when a.product_type_source_definition ilike any ('EQUITY OPTION')
                            then 'OPT'
                        -- We're using the legacy security type becuase there are fewer values/rollups
                        -- to consider compared to the more granular product type.
                        when a.legacy_product_type_source_definition in ('Mutual Fund - Non-Taxable', 'Mutual Fund - Taxable')
                            then 'MUT'
                        when a.legacy_product_type_source_definition in ('Certificate of Deposit'
                                                        , 'Corporate Bond'
                                                        , 'Government Bond'
                                                        , 'Municipal Bond'
                                                        , 'Treasury Bill'
                                                        , 'Treasury Note')
                            then 'FI'
                        when a.legacy_product_type_source_definition in ('Common Stock'
                                                        , 'Convertible Preferred Stock'
                                                        , 'Preferred Stock')
                            then 'EQ'
                        when a.legacy_product_type_source_definition ilike any ('real estate investment trust')
                            then 'EQ'
                        when a.legacy_product_type_source_definition in ('Other Assets'
                                                    ,'Reorganization'
                                                    ,'UIT - Taxable'
                                                    ,'Warrants'
                                                    ,'GNMA, GNMA, FHLMC, Mortgage-pools, CMO''s, etc')
                            then 'FI'
                        else 'FI'
                     end

            -- FIDELITY
            when a.custodian = 'fidelity'
                then case
                    when a.product_type_source_definition ilike 'option - %'
                        then 'OPT'
                    when a.product_type_source_definition ilike '%equity - %'
                        then 'EQ'
                    when a.product_type_source_definition ilike '%mutual fund%'
                        then 'MUT'
                    when a.product_type_source_definition ilike any ('%units - %', 'debt - ')
                        then 'FI'
                    else 'FI'
                    end

            -- OTHER CUSTODIAN
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
        end::text(200)                       as symbol
    , a.units_shares                         as quantity
    , a.cost_per_share                       as unitCost
    , a.cost_basis                           as totalCost
    , a.current_price                        as price
    , to_char(a.trade_date, 'YYYYMMDD')::int as lotdate
    , a.lot_id_source                        as lotnum
    , 'N'::text(1)                           as unsupervised
    , 'N'::text(1)                           as cusiplookup
    , a.cusip                                as cusip
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
    from {{ ref('custodian_tax_lots') }}             a
    join cte_accounts                                v
        on a.effective_date = v.effective_date
            and upper(a.custodian) = upper(v.custodian)
            and upper(a.account_number) = upper(v.account_No)
    left join cte_securities                         s
        on a.cusip = s.cusip
        and s.rn_cusip = 1
    where 1 = 1
        --and a.is_head = 1
        and a.is_current = 1
        --and a.units_shares > 0
        and a.firm_source in ('mwa', 'mps')
    qualify dense_rank() over(
        partition by a.firm_source, a.account_number
        order by case when a.firm_source = 'mwa' then 1 else 2 end
    ) = 1
)
,cte_schwab_mmf_rollup as
(
    -- To reduce total records for upload performance,
    -- rollup the schwab money market positions. Lot level
    -- detail is not necessary.
    select
          effective_date
        , custodiancode
        , account
        , product
        , symbol
        , sum(quantity)                             as quantity
        , unitcost                                  as unitcost
        , sum(totalcost)                            as totalcost
        , price
        , max(lotdate)                              as lotdate
        , null::text(200)                           as source_lot_id
        , unsupervised
        , cusiplookup
        , cusip
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
    from cte_tax_lots
    where custodiancode ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS'
    group by all
    order by custodiancode, account
)
,cte_final as
(
    select *
    from cte_tax_lots
    where 1=1
        -- these records get brought in with cte_schwab_mmf_rollup
        and not(custodiancode ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS')

    union all

    -- Schwab's MMF cash positions.
    select *
    from cte_schwab_mmf_rollup

    union all

    -- Schwab's non-security cash positions.
    select *
    from cte_schwab_cash

    union all

    -- Fidelity's MMF which encompasses all account cash.
    select *
    from cte_fidelity_money_market
)

select *
from cte_final
order by custodiancode, account, symbol
