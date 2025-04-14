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
    , _created_at
    , {{ col_is_head_for_day(partition_col='json:effective_date') }}
from {{ source('raw', 'holdings') }}
where true
-- unions holdings from the legacy masters pipeline prior to 2025
union all
select
    lh.effective_date
    , lh.system_name
    , lh.system_instance
    , lh.system_key
    , lh.firm_source
    , lh.account_id
    , lh.account_number_formatted
    , lh.account_number
    , lh.is_legacy
    , lh.custodian
    , lh.cusip
    , lh.ticker
    , lh.is_custodial_cash
    , lh.security_id
    , lh.security_name
    , lh.security_type
    , lh.security_subtype
    , lh.asset_class
    , lh.market_value
    , lh.quantity
    , lh.price
    , lh.price_unfactored
    , lh.factor
    , lh.cost_basis
    , lh.is_manual_holdings
    , lh._created_at
    , lh.is_head_for_day
from {{ ref('stg_legacy_holdings') }} as lh
order by effective_date , system_key , account_number , market_value
