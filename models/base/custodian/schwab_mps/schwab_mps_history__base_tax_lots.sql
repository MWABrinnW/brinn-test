select
    recordtype                   as record_type
  , 'schwab'                     as custodian
  , 'mps'                        as firm_source
  , null::text(200)              as firm
  , custodian                    as custodian_id
  , right(mstracctnumber, 8)     as master_account_number
  , masteraccountname            as master_account_name
  , businessdate                 as business_date
  , accountid                    as account_number
  , prodcode                     as product_code
  , prodcatgcode                 as product_category_code
  , taxcode                      as tax_code
  , tickersymbol                 as ticker_symbol
  , cusip                        as cusip
  , schwabsecnbr                 as schwab_security_number
  , itemissueid                  as item_issue_id
  , isin                         as isin
  , sedol                        as sedol
  , optionsdisplaysymbol         as option_display_symbol
  , underlyingtickersymbol       as underlying_ticker_symbol
  , underlyingcusip              as underlying_cusip
  , underlyingschwabnbr          as underlying_schwab_number
  , underlyingitmissid           as underlying_item_issue_id
  , underlyingisin               as underlying_isin
  , underlyingsedol              as underlying_sedol
  , currentquantity              as current_quantity
  , ls                           as long_short_indicator
  , transcode                    as transaction_code
  , currentmarketvalue           as current_market_value
  , accruedinterest              as accrued_interest
  , acquireddate                 as acquired_date
  , origpurchasedate             as original_purchase_date
  , orgpurchaseprice             as original_purchase_price
  , yieldtomaturity              as yield_to_maturity
  , costbasisunamortized         as cost_basis_unamortized
  , costpershare                 as cost_per_share
  , adjustedcostbasisamortized   as adjusted_cost_basisi_amortized
  , adjustedcostpershare         as adjusted_cost_per_share
  , urgl                         as unrealized_gain_loss
  , daysheld                     as days_held
  , ht                           as ht
  , cb                           as cost_basis_fully_known
  , ct                           as cost_basis_type
  , at                           as account_taxable_indicator
  , cf                           as certified_indicator
  , originalface                 as original_face
  , dflotselct                   as account_lot_selection_method_default
  , ws                           as cost_method
  --, versionmrkr1                 as version_marker_1
  , disallowedlossamount         as disallowed_loss_amount
  , transactioncost              as transaction_cost
  , transactioncostpershare      as transaction_cost_per_share
  --, versmrkr2                    as version_marker_2
  , gi                           as gi
  , originalcostbasis            as original_cost_basis
  --, versmrkr3                    as version_marker_3
  , adjustedcostincludgunpdamort as adjusted_cost_included_gunp_amortized
  , right(mstracctnumber, 8)     as master_number
  , effective_date::date         as effective_date
  , {{ col_is_head(reference=source('schwab_mps', 'tax_lots')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime::timestamp   as _source_loaded_at
  , null::text(200)              as _source_file
from {{ source('schwab_mps', 'tax_lots') }}
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_tax_lots') }})

union all

select
    record_type
  , custodian
  , firm_source
  , firm
  , custodian_id
  , master_account_number
  , master_account_name
  , business_date
  , account_number
  , product_code
  , product_category_code
  , tax_code
  , symbol_ticker
  , cusip
  , schwab_internal_id
  , item_issue_id
  , isin
  , sedol
  , options_display_symbol
  , underlying_ticker_symbol
  , underlying_cusip
  , underlying_schwab_internal_id
  , underlying_item_issue_id
  , underlying_isin
  , underlying_sedol
  , current_quantity
  , long_short_indicator
  , transaction_code
  , current_market_value
  , accrued_interest_fixed_income
  , acquired_date
  , original_purchase_date
  , original_purchase_price
  , yield_to_maturity_fixed_income
  , cost_basis_unamortized_cost_basis_amount
  , cost_per_share_share_cost_amount
  , adjusted_cost_basis_amortized_cost_basis_amount
  , adjusted_cost_per_share
  , unrealized_gain_loss_ugl
  , number_of_days_held
  , holding_period_term
  , cost_basis_fully_known
  , cost_basis_type
  , account_taxable_indicator
  , certified_indicator
  , original_face
  , account_lot_selection_method_default
  , wash_sale_impacted
  --, version_marker_1
  , disallowed_loss
  , transaction_cost
  , transaction_cost_per_share
  --, version_marker_2
  , acquisition_type_gift_or_inherited
  , original_cost_basis
  --, version_marker_3
  , adjusted_cost_including_unpaid_amortization
  , master_number
  , effective_date
  , is_head
  , is_current
  , _source_loaded_at
  , _source_file
from {{ ref('schwab__base_tax_lots') }}
where 1=1
    and firm_source = 'mps'
    and rn = 1
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
