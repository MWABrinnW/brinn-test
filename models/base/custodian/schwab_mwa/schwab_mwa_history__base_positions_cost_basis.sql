select
    recordtype                 as record_type
  , 'schwab'                   as custodian
  , 'mwa'                      as firm_source
  , null::text(200)            as firm
  , custodian                  as custodian_id
  , right(mstracctnumber,8)    as master_account_number
  , masteraccountname          as master_account_name
  , businessdate               as business_date
  , accountid                  as account_number
  , securitytype               as security_type
  , prodcode                   as prod_code
  , prodcatgcode               as prod_category_code
  , taxcode                    as tax_code
  , tickersymbol               as ticker_symbol
  , cusip                      as cusip
  , schwabsecnbr               as schwab_sec_nbr
  , itemissueid                as item_issue_id
  , isin                       as isin
  , sedol                      as sedol
  , optionsdisplaysymbol       as option_display_symbol
  , underlyingtickersymbol     as underlying_ticker_symbol
  , underlyingcusip            as underlying_cusip
  , underlyingschwabnbr        as underlying_schwab_nbr
  , underlyingitmissid         as underlying_itmissid
  , underlyingisin             as underlying_isin
  , underlyingsedol            as underlying_sedol
  , currentquantity            as current_quantity
  , ls                         as ls
  , currentmarketvalue         as current_market_value
  , accruedinterest            as accrued_interest
  , costbasisunamortized       as cost_basis_unamortized
  , costpershare               as costpershare
  , adjcostbasisamortized      as adj_cost_basis_amortized
  , adjcostpershare            as adj_cost_per_share
  , urgl                       as unrealized_gain_loss
  , cb                         as cost_basis
  , ct                         as ct
  , at                         as at
  , cf                         as cf
  , originalface               as original_face
  , dflottselct                as df_lott_select
  , cm                         as cm
  , princpaydownfactor         as princ_pay_down_factor
  , right(mstracctnumber,8)    as master_number
  , effective_date::date       as effective_date
  , {{ col_is_head(reference=source('schwab_mwa', 'positions_cost_basis')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime::timestamp as _source_loaded_at
  , null::text(200)            as _source_file
from {{ source('schwab_mwa', 'positions_cost_basis') }}
where 1=1
    and effective_date < (select min(effective_date) from {{ ref('schwab__base_cost_basis') }})

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
  , security_type
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
  , current_market_value
  , accrued_interest_fixed_income
  , cost_basis_unamortized_cost_basis_amount
  , cost_per_share_share_cost_amount
  , adjusted_cost_basis_amortized_cost_basis_amount
  , adjusted_cost_per_share
  , unrealized_gain_loss_ugl
  , cost_basis_fully_known
  , cost_basis_type
  , account_taxable_indicator
  , certified_indicator
  , original_face
  , account_lot_selection_method_default
  , cost_method
  , principal_paydown_factor
  , master_number
  , effective_date
  , is_head
  , is_current
  , _source_loaded_at
  , _source_file
from {{ ref('schwab__base_cost_basis') }}
where 1=1
    and firm_source = 'mwa'
    and rn = 1
    and (
        (nvl(is_from_tda_migration,0) in (0,1) and effective_date >= '9/1/2023')
        or
        (nvl(is_from_tda_migration,0) = 0 and effective_date < '9/1/2023')
    )
