select
    'addepar'                                      as system_name
    , 'corbenic'                                   as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date::date                         as effective_date
    , position_id
    , upper(holding_account_number)                as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(holding_account_number) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                   as account_number
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
    , security                                     as security
    , security_entity_id
    , display_name
    , cwm_asset_class
    , asset_class
    , actual_security_type
    , gics_security_description_internal_only
    , price_usd::number(19 , 9)                    as price_usd
    , quantity::number(19 , 9)                     as quantity
    , valuation_date
    , value::number(19 , 9)                        as value
    , accrued_income
    , original_cost_basis_usd::number(19 , 9)      as original_cost_basis_usd
    , cwm_non_discretionary
    , cfi_voting_right
    , cfi_assets
    , view_id
    , job_id
    , source_file
    , {{ col_is_head(reference=source('addepar_corbenic', 'holdings')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _id                                          as _id
    , record_datetime                              as _created_at
    , source_file                                  as _source_file
    -- remove after Alteryx workflows are retired for accounts and holdings masters
    , holding_account_number
from {{ source('addepar_corbenic', 'holdings') }}
