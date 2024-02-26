select
    account_number              as custodialaccountnumber
    , account_id                as orionaccountid
    , quantity                  as totalunits
    , price                     as currentprice
    , market_value              as currentvalue
    , null::decimal(20 , 2)     as currentprice_raw
    , null::decimal(20 , 2)     as currentvalue_raw
    , null::decimal(20 , 2)     as currentprice_unfactored
    , null::decimal(20 , 2)     as currentvalue_unfactored
    , is_custodial_cash         as iscustodialcash
    , cost_per_share            as originalcostpershare
    , total_cost_basis_quantity as originalcosttotal
    , acquired_date             as acquisitiondate
    , product_type              as producttype
    , asset_class               as assetclass
    , product_category          as productcategory
    , product_id                as productid
    , asset_id                  as asset_id
    , lot_id                    as lotid
    , ticker                    as ticker
    , null::decimal(20 , 5)     as factor
    , _created_at               as record_datetime
    , _created_at::date         as record_date
    , cusip                     as cusip
from {{ ref('orion__tax_lots') }}
where 1 = 1
    and effective_date = '2/16/2024'
    --and EstateItem__c.Status__c = 'Open'
    --and EstateItem__c.Trading_ID__c != ''
    --and EstateItem__c.Trading_System__c = 'Axys/Moxy - Cincinnati'
