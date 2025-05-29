select
    effective_date                                                        as effective_date
    , to_date(_data:"As Of Date"::text , 'MM/DD/YYYY HH12:MI:SS AM')      as as_of_date
    , _data:"CustodialAccountNumber"::text                                as account_number
    , _data:"OrionAccountID"::int                                         as account_id
    , _data:"Ticker"::text                                                as ticker
    , _data:"Cusip"::text                                                 as cusip
    , _data:"TotalUnits"::decimal(20 , 5)                                 as total_units
    , _data:"Currentprice_original"::decimal(20 , 5)                      as current_price_original
    , _data:"Currentprice"::decimal(20 , 5)                               as current_price
    , _data:"CurrentValue"::decimal(20 , 5)                               as current_value
    , _data:"OriginalCostPerShare"::decimal(20 , 5)                       as original_cost_per_share
    , _data:"OriginalCostTotal"::decimal(20 , 5)                          as original_cost_total
    , to_date(_data:"AcquisitionDate"::text , 'MM/DD/YYYY HH12:MI:SS AM') as acquisition_date
    , try_to_boolean(_data:"IsCustodialCash"::text)::int                  as is_custodial_cash
    , _data:"Price_factor"::decimal(20 , 5)                               as price_factor
    , _data:"ProductType"::text                                           as product_type
    , _data:"AssetClass"::text                                            as asset_class
    , _data:"ProductCategory"::text                                       as product_category
    , _data:"ProductID"::int                                              as product_id
    , _data:"AssetID"::int                                                as asset_id
    , _data:"LotID"::int                                                  as lot_id

    , _source_file                                                        as _source_file
    , _created_at                                                         as _created_at
    , _id                                                                 as _id
    , {{ col_is_head(
        reference=source('mis', 'orion_tax_lots_29042'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
    , case
        when _created_at = max(_created_at) over (
                partition by effective_date
            )
            then 1
        else 0
    end::int                                                              as is_head_for_day
from {{ source('mis', 'orion_tax_lots_29042') }}
