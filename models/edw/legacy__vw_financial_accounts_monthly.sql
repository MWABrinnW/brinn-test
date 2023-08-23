{{ config(
  grants = {'+select': ['db_edw_client_mwa_r', 'reporting']}
) }}

select
    system_name
  , system_details
  , financial_account_number
  , financial_account_number_clean
  , internal_financial_account_number
  , internal_household_number
  , registrant_name
  , financial_account_name
  , household_name
  , location_code
  , location_name
  , type_of_account
  , custodian
  , model_investment_strategy
  , client_manager
  , fee_schedule
  , erisa
  , account_active
  , aum_classification_status
  , discretion_status
  , proxy_voting_status
  , cost_basis_disposal_method
  , prime_broker_enabled
  , current_value
  , account_open_date
  , closed_date
  , as_of_date
  , effective_date
  , month_end_date
  , source_of_truth_final
  , id
  , record_date
  , record_datetime
  , hh_sf_18_digit_id
  , sf_18_digit_id as fa_sf_18_digit_id
  , {{ col_is_head(reference=source('edw_mwa', 'financial_account_monthly')) }}
  , {{ col_is_current(date_col='effective_date') }}
from {{ source('edw_mwa', 'financial_account_monthly') }}
