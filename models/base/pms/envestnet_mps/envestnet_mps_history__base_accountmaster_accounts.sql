select
    'envestnet' as pms
    , 'mps' as pms_location
    , 'mwa' as firm_source
    , effective_date
    , account_id
    , account_number
    , account_name
    , product_name
    , product_type
    , advisor_name
    , advisor_branch_name
    , rep_code
    , custodian
    , start_date
    , mailing_label
    , registration_type
    , state
    , name_and_address_1
    , name_and_address_2
    , name_and_address_3
    , name_and_address_4
    , ssn_tax_id
    , ssn_tax_id_flag
    , close_date
    , accounting_method_of_equities
    , accounting_method_of_mutual_funds
    , master_account_number
    , proposal_group_id
    , customer_registration_id
    , reconciled_status
    , last_reconciled_date
    , nscc_networking_level
    , swp_indicator
    , ach_indicator
    , pac_spp_indicator
    , check_writing
    , fund_family_id
    , import_account
    , cross_fund_reinvest
    , account_number_indicator
    , nf_transfer_eligibility_flag
    , custodian_id
    , account_status
    , registration_type_id
    , primary_member_first_name
    , primary_member_middle_name
    , primary_member_last_name
    , partner_code
    , branch_code
    , alternate_rep_code
    , advisor_rep_number
    , product_id
    , proposal_risk_rating
    , as_of_close_date
    , un_supervised_assets
    , total_cash
    , total_market_value
    , last_updated_by_custodian
    , account_created_date
    , tax_status
    , advisor_id
    , benchmark
    , {{ col_is_head(reference=source('envestnet_mps', 'accountmaster_accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mps', 'accountmaster_accounts') }}


