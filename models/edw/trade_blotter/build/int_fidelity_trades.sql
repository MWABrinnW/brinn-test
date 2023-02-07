select
    effective_date
    ,null as record_id
    ,null as allocation_id
    ,trade_reference_number as order_id -- or trade_entry?
    ,trade_date as trade_date
    ,settlement_date as settle_date
    ,null as asset_type
    ,symbol as symbol
    ,cusip as cusip
    ,null as ticker -- why?
    ,security_type as source_security_type --security_type (security type code, need to join for actual type)
    ,security_description_line_1 as source_security_description
    ,case when buy_sell_code = 'B' then 'buy' when buy_sell_code = 'S' then 'sell' as order_side
    ,null as order_effect
    ,quantity as units
    ,price as unit_price
    ,principal as principal
    ,accrued_interest as interest -- is this the same?
    ,null as commission -- which commission field?
    ,null as fees -- which: sec_fee, options_regulatory_fee, service_charge_misc_fee, execution_fee, local_currency_fees, etc
    ,net as net
    ,account_custodial as financial_account
    ,'fidelity' as custodian
    ,institutional_third_party as counter_party -- is this right?

    /* NEW */
    ,account_custodial_formatted as financial_account_formatted
    ,basis_price_code as basis_price_name
    ,case when market_code = 'P' then 1 else 0 end as is_prime_broker
    ,case when cancel_code = 1 then 1 else 0 end is is_cancelled

    ,'mwa' as firm
    ,null as venue -- how will we assign?
    ,null as platform -- how will we assign?
    ,null as trader
    ,null as trade_start_utc
    ,null as trade_end_utc
    ,null as source_trade_datetime
    ,null as source_trade_tz -- null?
    ,_created_at as _created_at
    ,_source_file as _source_file
from {{ ref('fidelity_mwa_history__vw_trdrev_td') }}
where true
    and is_head = 1
