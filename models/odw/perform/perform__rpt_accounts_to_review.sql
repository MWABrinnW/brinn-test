with cte_build as (
    select
        a.*
        , case
            when a.model in (
                    'Mariner - Municipal 1-10yr Ladder'
                    , 'Mariner - Municipal 1-5yr Ladder'
                    , 'Mariner - Taxable 1-10yr Ladder'
                    , 'Mariner - Taxable 1-5yr Ladder'
                ) then 1
            else 0
        end::int               as is_laddered
        , case
            when is_laddered = 1
                then 125000
            else 500000
        end::int               as min_investment
        , upper(a.account_key) as account_number
        {# , rti.status             as rti_status
        , rti.is_ready_to_invest as rti_is_ready_to_invest #}
    from {{ ref('perform__accounts_build') }} as a
    {# left join {{ ref('perform__stg_accounts_ready_to_invest') }} as rti
        on a.pms_account_id = rti.pms_account_id
        and rti.is_head = 1
        and rti.rn = 1 #}
    where 1 = 1
-- Exclude accounts that already exist on the ready to invest list.
--and rti.account_number is null
)


, cte_tax_lots as (
    select
        a.*
        , h.effective_date                                                   as effective_date
        , h.system_key                                                       as system_key
        , h.ticker                                                           as ticker
        , h.cusip                                                            as cusip
        , h.market_value                                                     as market_value
        , h.quantity                                                         as quantity
        , h.product_category                                                 as product_category
        , h.product_type                                                     as product_type
        , h.asset_class                                                      as asset_class

        , case
            -- Check for illegal cash in laddered accounts.
            when h.product_category ilike 'cash' and a.is_laddered = 1
                then case
                        when h.custodian ilike 'schwab'
                            and upper(h.ticker) in ('SCHWABCASH' , 'CASH:SWEEP' , 'CASH:CASH' , 'SWGXX')
                            then 0
                        when h.custodian ilike 'fidelity'
                            and upper(h.ticker) in ('FCASH' , 'FID:CASH' , 'QIWSQ' , 'FDRXX')
                            then 0
                        when lower(h.custodian) not in ('schwab' , 'fidelity')
                            then 0
                        else 1
                    end
            -- Check for illegal cash in non-laddered accounts.
            when h.product_category ilike 'cash' and a.is_laddered = 0
                then case
                        when h.custodian ilike 'schwab'
                            and upper(h.ticker) in ('SCHWABCASH' , 'CASH:SWEEP' , 'CASH:CASH' , 'SNOXX' , 'SWGXX')
                            then 0
                        when h.custodian ilike 'fidelity'
                            and upper(h.ticker) in ('FCASH' , 'FID:CASH' , 'QIWSQ' , 'FDRXX')
                            then 0
                        when lower(h.custodian) not in ('schwab' , 'fidelity')
                            then 0
                        else 1
                    end
            when h.product_category is null then null
            else 0
        end::int                                                             as is_illegal_cash
        , case when h.product_type in ('Bond' , 'CD') then 1 else 0 end::int as is_bond
        , case
            -- Check for illegal assets in laddered accounts.
            -- They can only authorized cash positions, no exceptions.
            when a.is_laddered = 1
                then case
                        when h.product_category not ilike 'cash'
                            then 1
                        else 0
                    end
            -- Check for illegal assets in non-laddered accounts.
            when a.is_laddered = 0
                then case
                        when h.product_type not in ('Bond' , 'CD') and h.product_category not ilike 'cash' then 1
                        else 0
                    end
            else 0
        end::int                                                             as is_illegal_asset
    from pr_347.orion__bld_holdings as h
    inner join cte_build as a
        on h.account_number = a.account_number
    where 1 = 1
        --       and is_head = 1
        and h.effective_date = '10/31/2024'--#################
        and h.fkalclient = 568
        and h.quantity > 0
--       and account_number in (
--         select distinct
--             account_number
--         from cte_build
--     )
)

, cte_accounts as (
    select
        account_number                                                                  as account_number
        , pms_account_id                                                                as pms_account_id
        , is_in_perform                                                                 as is_in_perform
        , description                                                                   as description
        , custodian                                                                     as custodian
        , type                                                                          as type
        , subadvisor_date_opened                                                        as subadvisor_date_opened
        , status                                                                        as status
        , model                                                                         as model
        , financial_advisor                                                             as financial_advisor
        , try_to_boolean(prime_broker)::int                                             as is_prime_broker
        , source                                                                        as source
        , is_laddered                                                                   as is_laddered
        , min_investment                                                                as min_investment
        , sum(market_value)::decimal(20 , 2)                                            as market_value
        -- Minimum investment rules allow for a %5 buffer.
        , case when sum(market_value) >= (min_investment * 0.95) then 1 else 0 end::int as has_min_investment
        -- Cash
        , max(coalesce(is_illegal_cash , 0))                                            as has_illegal_cash
        -- Non-cash
        , max(coalesce(is_illegal_asset , 0))                                           as has_illegal_assets
        -- Illegal cash or non-cash position
        , max(greatest(coalesce(is_illegal_asset , 0) , coalesce(is_illegal_cash , 0))) as has_illegal_positions
        , max(coalesce(is_bond , 0))                                                    as has_bonds
        , listagg(distinct case when is_illegal_cash = 1 then ticker end , ';')         as illegal_cash_tickers
        , listagg(distinct case when is_illegal_asset = 1 then ticker end , ';')        as illegal_asset_tickers
        , crm_account_id                                                                as crm_account_id
    from cte_tax_lots
    group by all
)

select
    a.account_number                 as account_number
    , a.pms_account_id               as pms_account_id
    , a.is_in_perform                as is_in_perform
    , a.description                  as description
    , a.custodian                    as custodian
    , a.type                         as type
    , a.subadvisor_date_opened::date as subadvisor_date_opened
    , a.status                       as status
    , a.model                        as model
    , a.financial_advisor            as financial_advisor
    , a.is_prime_broker              as is_prime_broker
    , a.market_value                 as market_value
    , a.is_laddered                  as is_laddered
    , a.min_investment               as min_investment
    , a.has_min_investment           as has_min_investment
    , a.source                       as source
    , a.has_bonds                    as has_bonds
    , a.has_illegal_cash             as has_illegal_cash
    , a.illegal_cash_tickers         as illegal_cash_tickers
    , a.has_illegal_positions        as has_illegal_positions
    , a.illegal_asset_tickers        as illegal_asset_tickers

    , a.crm_account_id               as crm_account_id
    , c.case_num                     as case_num
    , c.case_status                  as case_status
--   , case
-- If a non-laddered account doesn't have illegal positions but does hold bonds or CDs
-- then it needs review.
--         when is_laddered = 0
--             then case
--                      when has_illegal_positions = 0 and has_bonds = 1
--                          then 1
-- Any non-cash, non-bond, or non-CD holdings are not permitted.
--                         when has_illegal_assets = 1
--                             then 1
--                      else 0
--             end
--         else 0 end::int  as needs_review
--   , case
--         when has_min_investment = 1 and has_illegal_positions = 0
--             then 1
--         else 0 end::int  as is_ready_to_invest
from cte_accounts as a
left join {{ ref('perform__rpt_cases') }} as c
    on a.crm_account_id = c.crm_account_id
where 1 = 1
limit 15000
