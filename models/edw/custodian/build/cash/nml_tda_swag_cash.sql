select
    a.effective_date           as effective_date
    , a.custodian              as custodian
    , a.firm                   as firm
    , a.firm_source            as firm_source
    , a.account_number         as account_number
    , a.account_number         as account_number_formatted
    , sum(case when a.symbol = 'Cash'
            then a.amount
        else 0
    end)::decimal(15 , 2)      as total_cash_value
    , sum(case when a.security_type = 'MF'
            then a.amount
        else 0
    end)::decimal(15 , 2)      as money_market_value
    , null::decimal(15 , 2)    as option_market_value
    , null::decimal(15 , 2)    as margin_equity_value
    , a.is_head                as is_head
    , max(a._source_file)      as _source_file
    , max(a._source_loaded_at) as _source_loaded_at
from {{ ref('tda__base_pos') }} as a
where true
    and a.firm_source = 'swag'
group by
    a.effective_date , a.custodian , a.firm , a.firm_source , a.account_number
    , a.is_head , a.is_current
