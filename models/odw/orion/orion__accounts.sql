select
    effective_date
    , system_name
    , system_instance
    , system_key
    , firm_source
    , account_number_formatted
    , account_number
    , custodian
    , account_id
    , account_type
    , account_name
    , registration_id
    , registrant_name
    , household_id
    , household_name
    , client_open_date
    , is_active
    , created_date
    , opened_date
    , closed_date
    , closed_date_udf
    , account_value
    , representative_id
    , advisor
    , advisor_email
    , location_code
    , investment_strategy
    , fkalclient
    , bd_name
    , last_reconciled_date
    , is_in_balance
    , has_non_downloading_asset
    , trading_instructions
    , is_managed
    , custodian_account_restriction
    , subadvisor_id
    , subadvisor
    , fund_family
    , is_sma
    , sma_asset_id
    , sma_asset
    , download_source
    , is_trading_blocked
    , fee_schedule
    , eclipse_sma
    , eclipse_enabled
    , committed_amount_udf
    , is_qualified
    , is_discretionary
    , _created_at
    , _source_loaded_at
    , createddate
    , _source_file
    , {{ col_is_head(
        reference=ref('orion__bld_accounts'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
from {{ ref('orion__bld_accounts') }}
where 1 = 1
    -- Exclude Hayes
    and not (effective_date > '2024-09-30' and fkalclient = 1945)
    -- Exclude Cascadia
    and not (effective_date > '2024-08-30' and fkalclient = 2102)
    -- Exclude Arbor Wealth
    and not (effective_date > '2024-03-31' and fkalclient = 2623)
