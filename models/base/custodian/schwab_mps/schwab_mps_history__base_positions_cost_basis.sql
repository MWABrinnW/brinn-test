select
    recordtype                 as record_type
  , custodian                  as custodian
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
    ,case
        when right(master_account_number,8) = '08051423'
            then 'swag'
        when right(master_account_number,8) = '08355335'
            then 'mps'
        else 'mps'
        end                    as firm_source
  , effective_date::date       as effective_date
  , {{ col_is_head(reference=source('schwab_mps', 'positions_cost_basis')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime::timestamp as record_datetime
  , record_date::date          as record_date
  , record_datetime::timestamp as _source_loaded_at
from {{ source('schwab_mps', 'positions_cost_basis') }}