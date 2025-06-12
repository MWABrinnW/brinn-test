-- From the legacy masters pipeline prior to 2025
select
    lh.effective_date::date                      as effective_date
    , lh.system_name::varchar                    as system_name
    , lh.system_details::text                    as system_instance
    , sk.system_key::text                        as system_key
    , sk.firm_source::text                       as firm_source
    , lh.internal_financial_account_number::text as account_id
    , lh.financial_account_number::text          as account_number_formatted
    , lh.financial_account_number_clean::text    as account_number
    , null::text                                 as client_id
    , null::text                                 as client_name
    , lh.custodian::text                         as custodian
    , lh.cusip::text                             as cusip
    , lh.ticker::text                            as ticker
    , null::int                                  as is_ticker_cusip
    , null::int                                  as is_custodial_cash
    , lh.account_holdings_id::text               as security_id
    , lh.security_name::text                     as security_name
    , lh.security_type::text                     as security_type
    , lh.product_category::text                  as security_subtype
    , lh.product_class::text                     as asset_class
    , lh.market_value::number(19 , 9)            as market_value
    , lh.units_shares::number(19 , 9)            as quantity
    , lh.price::number(19 , 9)                   as price
    , null::number(19 , 9)                       as price_unfactored
    , null::number(19 , 9)                       as factor
    , lh.cost_basis::number(19 , 9)              as cost_basis
    , 1::int                                     as is_legacy
    , 0::int                                     as is_manual_holdings
    , lh.record_datetime::datetime               as _created_at
    , lh.record_datetime::datetime               as _source_loaded_at
    , null::text                                 as _source_file
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
order by effective_date , system_key , account_number
