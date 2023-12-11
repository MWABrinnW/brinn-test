select
     a.effective_date                         as effective_date
    ,a.custodian                              as custodian
    ,cf.firm                                  as firm
    ,a.firm_source                            as firm_source
    ,left(a.account_number, 9)                as account_number
    ,left(a.account_number, 9)                as account_number_formatted
    ,a.trade_date_liquidating_value::decimal(15,2)  as total_cash_value
    ,null::decimal(15,2)                      as money_market_value
    ,null::decimal(15,2)                      as option_market_value
    ,null::decimal(15,2)                      as margin_equity_value
    ,a.is_head                                as is_head
    ,a.is_current                             as is_current
    ,a._source_file                           as _source_file
    ,a._source_loaded_at                      as _source_loaded_at
from {{ ref('pershing_mwa__gcus_a') }} a
left join {{ ref('custodian_firms') }} cf
    on a.firm_source = cf.firm_source
where true
    and a.cusip_number = 'USD999997'
