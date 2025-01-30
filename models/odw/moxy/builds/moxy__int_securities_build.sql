with cte_securities_from_positions as (
    select
        symbol                as symbol
        , ticker              as ticker
        , cusip               as cusip
        , is_asset_managed    as is_managed
        , effective_date      as effective_date
        , case
            when product_type in ('Bond' , 'CD')
                then current_price * 100
            else
                current_price
        end                   as factored_price
        , max(factored_price) as price
        -- , max(current_price)           as price
        , product_name        as product_name
        , array_distinct(
            array_construct(min(account_number) , max(account_number))
        )                     as account_examples
        , is_intraday_import  as is_intraday_import
    from {{ ref('mis__tax_lots') }}
    where 1 = 1
        and is_moxy = 1
        and quantity != 0
    group by all
)

, cte_moxy_securities as (
    select
        symbol
        , is_managed
        , sec_type
        , type
        , iso
    from {{ ref('moxy__stg_securities') }}
    where is_head = 1 and rn = 1
)

, cte_securities_mapped_to_moxy as (
    select
        a.symbol                        as symbol
        , a.ticker                      as ticker
        , a.cusip                       as cusip
        , a.price                       as price
        , a.effective_date              as effective_date
        , a.is_managed                  as is_managed
        , s.sec_type                    as sec_type
        , iff(s.symbol is null , 1 , 0) as is_new
        , a.product_name                as product_name
        , a.account_examples            as account_examples
        , a.is_intraday_import          as is_intraday_import
    from cte_securities_from_positions as a
    left join cte_moxy_securities as s
        on upper(a.ticker) = upper(s.symbol)
        and a.is_managed = s.is_managed
)

, cte_cusip_data as (
    select
        cusip           as cusip
        , ticker_symbol as ticker
        , iso_cfi_code  as iso_cfi_code
        , row_number() over (
            partition by cusip
            order by issue_entry_date desc
        )               as rn_cusip
        , row_number() over (
            partition by ticker_symbol
            order by issue_entry_date desc
        )               as rn_ticker
    from {{ ref('cusip_history__base_issues') }}
    where 1 = 1
        and is_head = 1
        and (
            cusip in (
                select distinct t.cusip from cte_securities_mapped_to_moxy as t
                where t.is_new = 1
            )
            or ticker_symbol in (
                select distinct t.ticker from cte_securities_mapped_to_moxy as t
                where t.is_new = 1
            )
        )
)

, cte_final as (
    select
        s.symbol                                        as symbol
        , s.ticker                                      as ticker
        , s.cusip                                       as cusip
        , s.sec_type                                    as sec_type
        , s.is_managed                                  as is_managed
        , s.is_new                                      as is_new
        , s.price                                       as price
        , s.product_name                                as product_name
        , s.account_examples                            as account_examples
        , coalesce(cus.iso_cfi_code , tic.iso_cfi_code) as iso_cfi
        -- New securities are guessed OR fallback to unknown (xmus/xuus)
        , case
            when len(s.symbol) = 21
                then case
                        when substring(s.symbol , 13 , 1) ilike 'c'
                            then 'cl'
                        when substring(s.symbol , 13 , 1) ilike 'p'
                            then 'pt'
                    end
            when s.is_managed = 1
                then case
                        when left(iso_cfi , 2) ilike 'es'
                            then 'cs'
                        when left(iso_cfi , 2) ilike 'dn'
                            then 'mb'
                        when left(iso_cfi , 2) ilike 'db'
                            then 'cb'
                        else
                            'xm'
                    end
            when s.is_managed = 0
                then 'xu'
        end                                             as map_type
        , map_type || 'us'                              as new_sec_type
        , s.is_intraday_import                          as is_intraday_import
        , s.effective_date                              as effective_date
    from cte_securities_mapped_to_moxy as s
    left join cte_cusip_data as cus
        on s.cusip = cus.cusip
        and cus.rn_cusip = 1
    left join cte_cusip_data as tic
        on s.ticker = tic.ticker
        and tic.rn_ticker = 1
)

select
    symbol                              as symbol
    , ticker                            as ticker
    , cusip                             as cusip
    , coalesce(sec_type , new_sec_type) as sec_type
    , is_managed                        as is_managed
    , price                             as price
    , is_new                            as is_new
    , iso_cfi                           as iso_cfi
    , product_name                      as product_name
    , account_examples                  as account_examples
    , is_intraday_import                as is_intraday_import
    , effective_date                    as effective_date
from cte_final
order by symbol
