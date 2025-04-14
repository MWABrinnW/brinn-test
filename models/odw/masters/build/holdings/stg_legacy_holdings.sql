-- unions holdings from the legacy masters pipeline prior to 2025
select
    lh.effective_date::date                           as effective_date
    , lh.system_name::varchar(200)                    as system_name
    , lh.system_details::text(200)                    as system_instance
    , sk.system_key::text(200)                        as system_key
    , sk.firm_source::text(200)                       as firm_source
    , lh.internal_financial_account_number::text(200) as account_id
    , lh.financial_account_number::text(200)          as account_number_formatted
    , lh.financial_account_number_clean::text(200)    as account_number
    , lh.custodian::text(200)                         as custodian
    , lh.cusip::text(200)                             as cusip
    , lh.ticker::text(200)                            as ticker
    , null::int                                       as is_custodial_cash
    , lh.account_holdings_id::number(38 , 5)          as security_id
    , lh.security_name::text(200)                     as security_name
    , lh.security_type::text(200)                     as security_type
    , lh.product_category::text(200)                  as security_subtype
    , lh.product_class::text(200)                     as asset_class
    , lh.market_value::float                          as market_value
    , lh.units_shares::float                          as quantity
    , lh.price::float                                 as price
    , null::number(19 , 9)                            as price_unfactored
    , null::number(19 , 9)                            as factor
    , lh.cost_basis::float                            as cost_basis
    , 0::int                                          as is_manual_holdings
    , 1::int                                          as is_legacy
    , lh.record_datetime::datetime                    as _source_loaded_at
    , lh.record_datetime::datetime                    as _created_at
    , 1::int                                          as is_head_for_day
from {{ source('edw_mwa', 'account_holdings_monthly') }} as lh
-- normalize system key for legacy data
left join {{ ref('system_firm') }} as sk
    on lh.system_name = sk.legacy_system_name
where true
    and lh.effective_date <= '2024-12-31'
qualify row_number() over (
        partition by lh.effective_date , lh.month_end_date , lh.account_holdings_id
        order by lh.effective_date desc
    ) = 1
order by effective_date , system_key , account_number , market_value
