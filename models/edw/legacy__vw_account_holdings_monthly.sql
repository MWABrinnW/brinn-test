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
    , aum_classification_status
    , household_name
    , location_code
    , location_name
    , type_of_account
    , custodian
    , discretion_status
    , proxy_voting_status
    , model_investment_strategy
    , cusip
    , ticker
    , cusip_ticker
    , security_name as source_security_name
    , market_value
    , units_shares
    , price
    , cost_basis
    , as_of_date
    , source_of_truth_final
    , product_type
    , product_sub_type
    , product_class
    , product_description
    , product_category
    , product_category_name
    , product_iso_cfi_type
    , product_iso_cfi_code
    , product_cfi_category
    , product_cfi_attribute
    , product_name
    , security_type as source_security_type
    , effective_date
    , record_datetime
    , record_date
    , account_holdings_id
    , month_end_date
    , {{ col_is_head(reference=source('edw_mwa', 'account_holdings_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
from {{ source('edw_mwa', 'account_holdings_monthly') }}
where account_active = 1
qualify row_number() over (partition by effective_date , month_end_date , account_holdings_id order by effective_date desc) = 1
