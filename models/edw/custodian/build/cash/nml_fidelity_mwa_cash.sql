select
    a.effective_date                          as effective_date
    , a.custodian                             as custodian
    , cf.firm                                 as firm
    , a.firm_source                           as firm_source
    , account_custodial                       as account_number
    , account_custodial_formatted             as account_number_formatted
    , cash_collected_balance::decimal(15 , 2) as total_cash_value
    , cash_money_markets::decimal(15 , 2)     as money_market_value
    , option_market_value::decimal(15 , 2)    as option_market_value
    , margin_equity::decimal(15 , 2)          as margin_equity_value
    , is_head                                 as is_head
    , _source_file                            as _source_file
    , _source_loaded_at                       as _source_loaded_at
from {{ ref('fidelity_mwa_history__vw_acctbald_account_balance') }} as a
left join {{ ref('custodian_firms') }} as cf
    on a.firm_source = cf.firm_source
