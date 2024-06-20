with cte_accounts as (
    select distinct
        max(effective_date) over (partition by _created_at::date) as effective_date
        , lower(custodian)                                        as custodian
        , account_no                                              as account_no
    from {{ ref('flyer__stg_sod_accounts_history') }}
    where 1 = 1
        and _created_at::date = (select max(_created_at::date) from {{ ref('flyer__stg_sod_accounts_history') }})
    qualify row_number() over (partition by _created_at::date , account_no , custodian order by _created_at desc) = 1
)

, cte_schwab_cash as (
    -- Schwab presents cash as a non-security holding so it doesn't
    -- appear in the tax lots dataset. However, money market funds
    -- (SNAXX) do appear in the tax lots data.
    -- Fidelity doesn't have a non-security cash position, instead
    -- representing all cash within a MMF security position (like FDRXX).
    select
        a.effective_date               as effective_date
        , a.custodian                  as custodian
        , a.account_number             as account_number
        , 'CASH'::text(200)            as product
        , '_CASH_'::text(200)          as ticker
        , null::text(200)              as cusip
        -- Formerly cash_balance_settled_only which did not include
        -- necessary margin balances.
        , (
            a.net_credit_or_debit_settled_unsettled
            + a.margin_balance_settled_unsettled
        )::decimal(15 , 2
        )                              as quantity
        , null::decimal(20 , 5)        as cost_per_share
        , null::decimal(20 , 5)        as cost_basis
        , 1.0000                       as current_price
        , 1::int                       as is_cash
        , 1::int                       as is_sweep
        , 19000101::int                as lot_date
        , null::text(200)              as lot_num
        , 'N'                          as unsupervised
        , 'N'                          as cusiplookup
        , 'N'                          as preferred
        , 4622::text                   as securityid
        , null::text(200)              as security_type_description
        , null::text(200)              as fund_type
        , null::text(200)              as product_type
        , null::text(200)              as product_type_source_code
        , null::text(200)              as product_type_source_definition
        , null::text(200)              as legacy_product_type
        , null::text(200)              as legacy_product_type_source_code
        , null::text(200)              as legacy_product_type_source_definition

        , 'cte_schwab_cash--base_cash' as src
    from {{ ref('schwab__base_cash') }} as a
    inner join cte_accounts as v
        on a.effective_date = v.effective_date
        and upper(a.custodian) = upper(v.custodian)
        and upper(a.account_number) = upper(v.account_no)
    where true
        and a.rn_global = 1
)

, cte_schwab_money_market as (
    select
        a.effective_date                                 as effective_date
        , a.custodian                                    as custodian
        , a.account_number                               as account_number
        , 'CASH'::text(200)                              as product
        , a.ticker                                       as ticker
        , a.cusip                                        as cusip
        , a.units_shares                                 as quantity
        , a.price                                        as cost_per_share
        , a.price * a.units_shares                       as cost_basis
        , a.price                                        as current_price
        , 1::int                                         as is_cash
        , 1::int                                         as is_sweep
        , 19000101::int                                  as lot_date
        , null::text(200)                                as lot_num
        , 'N'                                            as unsupervised
        , 'N'                                            as cusiplookup
        , 'N'                                            as preferred
        , 4622::text                                     as securityid
        , null::text(200)                                as security_type_description
        , null::text(200)                                as fund_type
        , null::text(200)                                as product_type
        , null::text(200)                                as product_type_source_code
        , null::text(200)                                as product_type_source_definition
        , null::text(200)                                as legacy_product_type
        , null::text(200)                                as legacy_product_type_source_code
        , null::text(200)                                as legacy_product_type_source_definition

        , 'cte_schwab_money_market--nml_schwab_holdings' as src
    from {{ ref('nml_schwab_holdings') }} as a
    inner join cte_accounts as v
        on a.effective_date = v.effective_date
        and upper(a.custodian) = upper(v.custodian)
        and a.account_number = v.account_no
    where 1 = 1
        -- This filter was added because relying on the inner join does not
        -- perform as you would normally expect. For whatever reason, snowflake
        -- is not optimizing the query as anticipated.
        and a.effective_date = (select max(effective_date) from cte_accounts)
        and a.is_sweep = 1
)

, cte_fidelity_money_market as (
    -- Fidelity money market (FDRXX) isn't included in the tax lots data.
    -- But this is a position and needs to be represented.
    select
        a.effective_date                                         as effective_date
        , a.custodian                                            as custodian
        , a.account_number                                       as account_number
        , case
            when a.is_sweep = 1
                then 'CASH'
            else 'MUT'
        end::text(200)                                           as product
        , a.ticker                                               as ticker
        , null::text(200)                                        as cusip
        , sum(a.quantity)                                        as quantity
        , 1.0000::decimal(20 , 5)                                as price
        , sum(a.market_value)                                    as lot_cost
        , 1.0000::decimal(20 , 5)                                as current_price
        , a.is_cash                                              as is_cash
        , a.is_sweep                                             as is_sweep
        , 19000101::int                                          as lot_date
        , null::text(200)                                        as lot_num
        , 'N'                                                    as unsupervised
        , 'N'                                                    as cusiplookup
        , 'N'                                                    as preferred
        , 4622::text                                             as securityid
        , null::text(200)                                        as security_type_description
        , null::text(200)                                        as fund_type
        , null::text(200)                                        as product_type
        , null::text(200)                                        as product_type_source_code
        , null::text(200)                                        as product_type_source_definition
        , null::text(200)                                        as legacy_product_type
        , null::text(200)                                        as legacy_product_type_source_code
        , null::text(200)                                        as legacy_product_type_source_definition

        , 'cte_fidelity_money_market--nml_fidelity_mwa_holdings' as src
    from {{ ref('nml_fidelity_mwa_holdings') }} as a
    inner join cte_accounts as v
        on a.effective_date = v.effective_date
        and upper(a.custodian) = upper(v.custodian)
        and upper(a.account_number) = upper(v.account_no)
    where 1 = 1
        and a.effective_date = (select max(effective_date) from cte_accounts)
        -- This will include all cash positions and not just the single sweep position.
        -- Robert A confirmed they want all Fidelity MMF tagged as cash so that
        -- scenarios where an account holds cash positions in more than just the core
        -- sweep they see that too.
        and a.is_cash = 1
    group by all
)

, cte_fidelity_cash as (
    -- Fidelity cash is captured via MMF positions/holdings. We also need to capture
    -- margin/credit balances that aren't/shouldn't be attributed to a particular holding
    -- , I think...
    select
        a.effective_date                                   as effective_date
        , a.custodian                                      as custodian
        , a.account_custodial                              as account_number
        , 'CASH'::text(200)                                as product
        , '_CASH_'::text(200)                              as ticker
        , null::text(200)                                  as cusip
        , -(a.net_trade_date_balance)                      as quantity
        , 1.0000::decimal(20 , 5)                          as price
        , -(a.net_trade_date_balance)                      as lot_cost
        , 1.0000::decimal(20 , 5)                          as current_price
        , 1::int                                           as is_cash
        , 0::int                                           as is_sweep
        , 19000101::int                                    as lot_date
        , null::text(200)                                  as lot_num
        , 'N'                                              as unsupervised
        , 'N'                                              as cusiplookup
        , 'N'                                              as preferred
        , 4622::text                                       as securityid
        , null::text(200)                                  as security_type_description
        , null::text(200)                                  as fund_type
        , null::text(200)                                  as product_type
        , null::text(200)                                  as product_type_source_code
        , null::text(200)                                  as product_type_source_definition
        , null::text(200)                                  as legacy_product_type
        , null::text(200)                                  as legacy_product_type_source_code
        , null::text(200)                                  as legacy_product_type_source_definition

        , 'cte_fidelity_cash--vw_acctbald_account_balance' as src
    from {{ ref('fidelity_mwa_history__vw_acctbald_account_balance') }} as a
    inner join cte_accounts as v
        on a.effective_date = v.effective_date
        and upper(a.custodian) = upper(v.custodian)
        and upper(a.account_custodial) = upper(v.account_no)
    where 1 = 1
        and abs(a.net_trade_date_balance) > 0
)

, cte_securities as (
    select
        cusip
        , ticker_symbol
        , security_type_description
        , fund_type
        , row_number()
            over (partition by cusip order by iff(security_type_description is not null , 0 , 1) asc , issue_entry_date desc)
            as rn_cusip
        , row_number()
            over (
                partition by ticker_symbol order by iff(security_type_description is not null , 0 , 1) asc , issue_entry_date desc
            )
            as rn_ticker
    from {{ ref('cusip_history__base_issues') }}
    where 1 = 1
        and is_head = 1
    order by ticker_symbol , cusip
)

, cte_tax_lots as (
    -- These are the tax lots from the custodians.
    select
        a.effective_date                          as effective_date
        , a.custodian                             as custodian
        , a.account_number                        as account_number
        , case
            when a.is_cash = 1 then 'CASH'
            -- FIDELITY --
            when a.custodian ilike 'fidelity'
                then
                    case
                        -- exemptions that don't follow the other FI, OPT, and MUT ilike rules
                        when a.product_type_source_definition in (
                                'Debt - Certificate of Deposit' , 'Rights to Ownership - Warrants' , 'Equity - Preferred Stock'
                                , 'Equity - Closed-End Mutual Fund - Taxable'
                            )
                            then 'EQ'
                        -- standard Fidelity logic
                        when a.product_type_source_definition ilike 'debt%'
                            then 'FI'
                        when a.product_type_source_definition ilike 'option%'
                            then 'OPT'
                        when a.product_type_source_definition ilike '%mutual fund%'
                            then 'MUT'
                        else 'EQ'
                    end
            -- SCHWAB --
            when a.custodian ilike 'schwab'
                then
                    case
                        -- exemptions that don't follow standard product_category_code rules
                        when a.product_type_source_code in ('WAR' , 'PRD')
                            then 'EQ'
                        -- standard Schwab logic
                        when a._extra_fields:product_category_code::text(200) = 'DEBT'
                            then 'FI'
                        when a._extra_fields:product_category_code::text(200) = 'DERV'
                            then 'OPT'
                        when a._extra_fields:product_category_code::text(200) = 'EQTY'
                            then 'EQ'
                        when a._extra_fields:product_category_code::text(200) = 'O'
                            then 'MUT'
                        else 'EQ'
                    end
            -- Other Custodians --
            else 'EQ'
        end::text(200)                            as product
        -- Cleanup the symbol value for scenarios where there is not ticker or cusip.
        -- This can happen for something like a private limited partnership.
        -- Equities have max length of 10 for symbol in copilot.
        , case
            when product in ('FI' , 'EQ')
                then left(replace(replace(a.symbol , '-' , '') , ' ' , '') , 10)
            else
                a.symbol
        end::text(200)                            as ticker
        , a.cusip                                 as cusip
        , a.quantity                              as quantity
        , a.cost_per_share                        as cost_per_share
        , a.cost_basis                            as cost_basis
        , a.current_price                         as current_price
        , a.is_cash                               as is_cash
        , a.is_sweep                              as is_sweep
        , to_char(a.trade_date , 'YYYYMMDD')::int as lot_date
        , a.lot_id_source                         as lot_num
        , 'N'::text(1)                            as unsupervised
        , 'N'::text(1)                            as cusiplookup
        , 'N'::text(1)                            as preferred
        , a.security_id_source                    as securityid
        , s.security_type_description
        , s.fund_type
        , a.product_type
        , a.product_type_source_code
        , a.product_type_source_definition
        , a.legacy_product_type
        , a.legacy_product_type_source_code
        , a.legacy_product_type_source_definition

        , 'cte_tax_lots--custodian_tax_lots'      as src
    from {{ ref('custodian_tax_lots') }} as a
    inner join cte_accounts as v
        on a.effective_date = v.effective_date
        and upper(a.custodian) = upper(v.custodian)
        and upper(a.account_number) = upper(v.account_no)
    left join cte_securities as s
        on a.cusip = s.cusip
        and s.rn_cusip = 1
    where 1 = 1
        and a.effective_date in (select distinct effective_date from cte_accounts)
        and a.rn_global = 1
        -- exclude because we pull from holdings
        and not (a.custodian = 'fidelity' and a.is_cash = 1)
)

, cte_schwab_mmf_rollup as (
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
        , sum(quantity)                         as quantity
        , cost_per_share
        , sum(cost_basis)                       as cost_basis
        , current_price
        , is_cash
        , is_sweep
        , max(lot_date)                         as lot_date
        , null::text(200)                       as lot_num
        , unsupervised
        , cusiplookup
        , preferred
        , securityid
        , null::text(200)                       as security_type_description
        , null::text(200)                       as fund_type
        , null::text(200)                       as product_type
        , null::text(200)                       as product_type_source_code
        , null::text(200)                       as product_type_source_definition
        , null::text(200)                       as legacy_product_type
        , null::text(200)                       as legacy_product_type_source_code
        , null::text(200)                       as legacy_product_type_source_definition
        , 'cte_schwab_mmf_rollup--cte_tax_lots' as src
    from cte_tax_lots
    where custodian ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS'
    group by all
    order by custodian , account_number
)

, cte_final as (
    select *
    from cte_tax_lots
    where 1 = 1
        -- These records get brought in with cte_schwab_mmf_rollup.
        and not (custodian ilike 'SCHWAB' and product_type_source_definition ilike 'SCHWAB NON-SWEEP MONEY MARKET FUNDS')

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

    -- Fidelity margin/credit balances.
    union all
    select *
    from cte_fidelity_cash
)

, cte_product_mapping as (
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
        ticker
        , product
        , dense_rank() over (
            partition by ticker
            order by case
                when product ilike 'cash' then 1
                when product ilike 'opt' then 2
                when product ilike 'eq' then 3
                when product ilike 'mut' then 4
                when product ilike 'fi' then 5
                else 6
            end
        ) as rank
    from cte_final
    group by ticker , product
)

select
    a.effective_date
    , a.custodian
    , a.account_number
    , coalesce(pm.product , a.product) as product
    , a.ticker
    , a.cusip
    , a.quantity
    , a.cost_per_share
    , a.cost_basis
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
from cte_final as a
left join cte_product_mapping as pm
    on a.ticker = pm.ticker
    and pm.rank = 1
order by a.custodian , a.account_number , a.ticker
