select
    'addepar'                                     as system_name
    , 'corbenic'                                  as system_instance
    , concat(system_name , '_' , system_instance) as system_key
    , 'mwa'                                       as firm_source
    , effective_date
    , position_id
    , holding_account_number
    , holding_account
    , holding_account_entity_id
    , cwm_custodian
    , top_level_holding_account
    , top_level_holding_account_entity_id
    , top_level_account_number
    , top_level_owner
    , top_level_owner_entity_id
    , top_level_owner_id
    , ticker_symbol
    , cusip
    , security
    , security_entity_id
    , display_name
    , cwm_asset_class
    , asset_class
    , actual_security_type
    , gics_security_description_internal_only
    , price_usd
    , quantity
    , valuation_date
    , value
    , accrued_income
    , original_cost_basis_usd
    , cwm_non_discretionary
    , cfi_voting_right
    , cfi_assets
    , view_id
    , job_id
    , source_file
    , {{ col_is_head(reference=source('addepar_corbenic', 'holdings')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _id                                         as _id
    , record_datetime                             as _created_at
    , source_file                                 as _source_file
from {{ source('addepar_corbenic', 'holdings') }}
