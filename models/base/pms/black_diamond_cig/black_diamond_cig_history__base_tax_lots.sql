{% set src = source('black_diamond_cig', 'accounts') %}

SELECT 
    'black_diamond' as pms
    , 'cig' as pms_location
    , 'mwa' AS firm_source
    , EFFECTIVE_DATE                             AS EFFECTIVE_DATE
    , JSON:AccountNumber::string as account_number
    , H.value:AccountID::string as account_id
    , H.value:TaxLotID::string as tax_lot_id
    , H.value:Ticker::string as ticker
    , H.value:DisplayCusip::string as display_cusip
    , H.value:AssetName::string as asset_name
    , H.value:AssetId::Number as asset_id
    , H.value:TradeDate::Date as trade_date
    , H.value:OpenDate::Date as open_date
    , H.value:EMV::Decimal(20, 6) as emv
    , H.value:Units::Decimal(20, 6) as units
    , H.value:CostBasis::Decimal(20, 6) as cost_basis
    , H.value:UnitCost::Decimal(20, 6) as unit_cost
    , H.value:PriceFactor::Decimal(20, 6) as price_factor
    , H.value:PaydownFactor::Decimal(20, 6) as paydown_factor
    , H.value:Cash::boolean as cash
    , RECORD_ID as record_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ src }},
     lateral flatten(input => JSON:TaxLots) H