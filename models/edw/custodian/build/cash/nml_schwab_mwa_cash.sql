select a.effective_date                                                                   as effective_date
     , a.custodian                                                                        as custodian
     , a.firm                                                                             as firm
     , a.firm_source                                                                      as firm_source
     , a.account_number                                                                   as account_number
     , a.account_number                                                                   as account_number_formatted
     , (a.cash_margin_balance_settled_only + a.cash_balance_settled_only)::decimal(15, 2) as cash_value
     , a.money_market_funds_settled_unsettled::decimal(15, 2)                             as money_market_value
     , a.equity_including_options::decimal(15, 2)                                         as option_market_value
     , a.cash_margin_balance_settled_only::decimal(15, 2)                                 as margin_equity_value
     , a.is_head                                                                          as is_head
     , a.is_current                                                                       as is_current
     , null::text(200)                                                                    as _source_file
     , a._source_loaded_at                                                                as _source_loaded_at
from {{ ref('schwab__base_cash') }} a
where true
    and a.firm_source = 'mwa'
    and a.rn = 1
