select
-- account fields, foundation in odw, joins to holdings
    json:"effective_date"::text               as effective_date
    , json:"system_name"::text                as system_name
    , json:"system_instance"::text            as system_instance
    , json:"system_key"::text                 as system_key
    , json:"firm_source"::text                as firm_source
    , json:"account_id_pms"::text             as account_id_pms
    , json:"account_number_formatted"::text   as account_number_formatted
    , json:"account_number"::text             as account_number
    , json:"is_legacy"::int                   as is_legacy

    -- holdings fields, joins to accounts
    , json:"custodian"::text                  as custodian
    , json:"cusip"::text                      as cusip
    , json:"ticker"::text                     as ticker
    , null::int                               as is_ticker_cusip
    , json:"is_custodial_cash"::int           as is_custodial_cash
    , json:"security_id"::text                as security_id
    , json:"security_name"::text              as security_name
    , json:"security_type"::text              as security_type
    , json:"security_subtype"::text           as security_subtype
    , json:"asset_class"::text                as asset_class
    , json:"market_value"::number(19 , 9)     as market_value
    , json:"quantity"::number(19 , 9)         as quantity
    , json:"price"::number(19 , 9)            as price
    , json:"price_unfactored"::number(19 , 9) as price_unfactored
    , json:"factor"::number(19 , 9)           as factor
    , json:"cost_basis"::number(19 , 9)       as cost_basis
    , json:"is_manual_holdings"::int          as is_manual_holdings
    , _created_at                             as _created_at
    , {{ col_is_head_for_day(
        partition_col='json:effective_date::date'
        ) }}
from {{ source('raw', 'holdings') }}

-- Unions holdings from the legacy masters prior to 2025.
union all

select
    lh.effective_date             as effective_date
    , lh.system_name              as system_name
    , lh.system_instance          as system_instance
    , lh.system_key               as system_key
    , lh.firm_source              as firm_source
    , lh.account_id               as account_id
    , lh.account_number_formatted as account_number_formatted
    , lh.account_number           as account_number
    , lh.is_legacy                as is_legacy
    , lh.custodian                as custodian
    , lh.cusip                    as cusip
    , lh.ticker                   as ticker
    , null::int                   as is_ticker_cusip
    , lh.is_custodial_cash        as is_custodial_cash
    , lh.security_id              as security_id
    , lh.security_name            as security_name
    , lh.security_type            as security_type
    , lh.security_subtype         as security_subtype
    , lh.asset_class              as asset_class
    , lh.market_value             as market_value
    , lh.quantity                 as quantity
    , lh.price                    as price
    , lh.price_unfactored         as price_unfactored
    , lh.factor                   as factor
    , lh.cost_basis               as cost_basis
    , lh.is_manual_holdings       as is_manual_holdings
    , lh._created_at              as _created_at
    , 1::int                      as is_head_for_day
from {{ ref('stg_legacy_holdings') }} as lh
order by effective_date , system_key , account_number , market_value
