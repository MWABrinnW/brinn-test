select
    json:"effective_date"::text               as effective_date
    , json:"system_name"::text                as system_name
    , json:"system_instance"::text            as system_instance
    , json:"system_key"::text                 as system_key
    , json:"firm_source"::text                as firm_source
    , json:"account_number_formatted"::text   as account_number_formatted
    , json:"account_number"::text             as account_number
    , json:"account_value"::number(18 , 2)    as account_value
    , json:"account_id_crm"::text             as account_id_crm
    , json:"account_id_pms"::text             as account_id_pms
    , json:"account_name"::text               as account_name
    , json:"client_id_crm"::text              as client_id_crm
    , json:"client_id_pms"::text              as client_id_pms
    , json:"client_name"::text                as client_name
    , json:"custodian"::text                  as custodian
    , json:"aum_classification"::text         as aum_classification
    , json:"advisor"::text                    as advisor
    , json:"is_active"::int                   as is_active
    , json:"opened_date"::text                as opened_date
    , json:"closed_date"::text                as closed_date
    , json:"location_code"::text              as location_code
    , json:"office_name"::text                as office_name
    , json:"link"::text                       as link
    , json:"link_type"::text                  as link_type
    , json:"link_subtype"::text               as link_subtype
    , json:"is_market_month_end"::int         as is_market_month_end
    , json:"is_market_day"::int               as is_market_day
    , json:"is_manual_account"::int           as is_manual_account
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
    , json:"is_legacy"::int                   as is_legacy
    , json:"is_excluded"::int                 as is_excluded
    , json:"excluded_reasons"::text           as excluded_reasons
    , _created_at
    , {{ col_is_head_for_day(partition_col='json:effective_date') }}
from {{ source('raw', 'holdings') }}
where true
