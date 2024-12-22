select
    max(a.content:effective_date::date) over (
        partition by a._created_at
    )                                                     as effective_date
    , a.content:account_id::int                           as account_id
    , a.content:account_number::text                      as account_number
    , a.content:account_number_formatted::text            as account_number_formatted
    , a.content:household_id::int                         as household_id
    , a.content:household_name::text                      as household_name
    , a.content:custodian::text                           as custodian
    , a.content:symbol::text                              as symbol
    , a.content:cusip::text                               as cusip
    , a.content:ticker::text                              as ticker
    , a.content:is_ticker_cusip::int                      as is_ticker_cusip
    , a.content:is_custodial_cash::int                    as is_custodial_cash
    , a.content:product_name::text                        as product_name
    , a.content:product_type::text                        as product_type
    , a.content:product_category::text                    as product_category
    , a.content:asset_class::text                         as asset_class
    , a.content:lot_quantity::decimal(20 , 5)             as lot_quantity
    , a.content:current_price::decimal(20 , 5)            as current_price
    , a.content:lot_value::decimal(20 , 2)                as lot_value
    , a.content:factor::decimal(20 , 5)                   as factor
    , a.content:is_asset_managed::int                     as is_asset_managed
    , a.content:is_product_managed::int                   as is_product_managed
    , a.content:acquired_date::date                       as acquired_date
    , a.content:cost_basis::decimal(20 , 5)               as cost_basis
    , a.content:cost_per_share::decimal(20 , 5)           as cost_per_share
    , a.content:aggregate_lot_quantity::decimal(20 , 5)   as aggregate_lot_quantity
    , a.content:aggregate_asset_quantity::decimal(20 , 5) as aggregate_asset_quantity
    , a.content:aggregate_lot_value::decimal(20 , 2)      as aggregate_lot_value
    , a.content:aggregate_asset_value::decimal(20 , 2)    as aggregate_asset_value
    , a.content:is_quantity_match::int                    as is_quantity_match
    , a.content:is_value_match::int                       as is_value_match
    , a.content:product_id::int                           as product_id
    , a.content:asset_id::int                             as asset_id
    , a.content:lot_id::int                               as lot_id
    , a.content:fkalclient::int                           as fkalclient
    , a.content:last_recon_date::date                     as last_recon_date
    , a.content:expected_recon_date::date                 as expected_recon_date
    , a.content:createddate::timestamp_ntz                as createddate
    , a.content:_extracted_at::timestamp_tz               as _extracted_at
    , a._created_at                                       as _created_at
    , {{ col_is_head(
        reference=source('mis', 'orion_tax_lots'),
        source_date_col='a._created_at',
        reference_date_col='_created_at'
        ) }}
from {{ source('mis', 'orion_tax_lots') }} as a
