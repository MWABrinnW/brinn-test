{% set src = source('black_diamond_houston', 'accounts') %}

select
    'black_diamond'                               as system_name
    , 'houston'                                   as system_instance
    , concat(system_name , '_' , system_instance) as system_key
    , 'mwa'                                       as firm_source
    , effective_date                              as effective_date
    , json:AccountNumber::string                  as account_number
    , h.value:AccountID::string                   as account_id
    , h.value:TaxLotID::string                    as tax_lot_id
    , h.value:Ticker::string                      as ticker
    , h.value:DisplayCusip::string                as display_cusip
    , h.value:AssetName::string                   as asset_name
    , h.value:AssetId::number                     as asset_id
    , h.value:TradeDate::date                     as trade_date
    , h.value:OpenDate::date                      as open_date
    , h.value:EMV::decimal(20 , 6)                as emv
    , h.value:Units::decimal(20 , 6)              as units
    , h.value:CostBasis::decimal(20 , 6)          as cost_basis
    , h.value:UnitCost::decimal(20 , 6)           as unit_cost
    , h.value:PriceFactor::decimal(20 , 6)        as price_factor
    , h.value:PaydownFactor::decimal(20 , 6)      as paydown_factor
    , h.value:Cash::boolean                       as cash
    , record_id                                   as record_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                             as _source_loaded_at
from {{ src }}
, lateral flatten(input => json:TaxLots) as h
