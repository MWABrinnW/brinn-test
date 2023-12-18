with cte_tax_lots as (
                         select effective_date
                              , account_number
                              , item_issue_id
                              , symbol_ticker
                              , cusip
                              , product_category_code
                              , sum(current_quantity)     as quantity
                              , sum(current_market_value) as market_value
                         from {{ ref('schwab__base_tax_lots') }}
                         where 1 = 1
                           and is_head = 1
                           and master_number = '08261207'
                         group by all
                     )
   , cte_positions as (
                          select effective_date
                               , account_number
                               , item_issue_id
                               , ticker_symbol
                               , cusip
                               , security_description_line_1
                               , sum(quantity_settled_and_unsettled)     as quantity
                               , sum(market_value_settled_and_unsettled) as market_value
                          from {{ ref('schwab__base_positions') }}
                          where 1 = 1
                            and is_head = 1
                            and master_number = '08261207'
                            and coalesce(ticker_symbol, 'blank') != 'SWGXX' -- exclude sweep positions which don't have any lots
                          group by all
                      )
select coalesce(tl.effective_date, p.effective_date)                                       as effective_date
     , coalesce(tl.account_number, p.account_number)                                       as account_number
     , coalesce(tl.item_issue_id, p.item_issue_id)                                         as item_issue_id
     , coalesce(tl.symbol_ticker, p.ticker_symbol)                                         as ticker
     , coalesce(tl.cusip, p.cusip)                                                         as cusip
     , tl.quantity::decimal(10, 2)                                                         as tax_lot_quantity
     , p.quantity::decimal(10, 2)                                                          as position_quantity
     , coalesce(tax_lot_quantity - position_quantity, tax_lot_quantity, position_quantity) as quantity_diff
     , case
           when tax_lot_quantity is null then 'Position without Tax Lots'
           when position_quantity is null then 'Tax Lot without Positions'
           when tax_lot_quantity != position_quantity then 'Position vs Tax Lot quantity mismatch'
    end                                                                                    as explanation
     , tl.market_value::decimal(10, 2)                                                     as tax_lot_value
     , p.market_value::decimal(10, 2)                                                      as position_value
     , coalesce(tax_lot_value - position_value, tax_lot_value, position_value)             as value_diff

from cte_tax_lots tl
         full outer join cte_positions p
                         on tl.effective_date = p.effective_date
                             and tl.account_number = p.account_number
                             and tl.item_issue_id = p.item_issue_id
where 1 = 1
  and quantity_diff != 0
order by explanation, abs(quantity_diff) desc
