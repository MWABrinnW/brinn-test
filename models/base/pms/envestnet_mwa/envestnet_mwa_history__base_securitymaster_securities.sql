select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , security_id
    , cusip
    , ticker
    , security_description
    , security_type
    , security_style
    , issue_type_multiplier
    , agency_factor
    , share_class
    , cdsc_fund_flag
    , fund_family_id
    , closed_flag
    , s_and_p_rating_id
    , moody_rating_id
    , firm_eligible
    , issue_date
    , maturity_date
    , call_date
    , call_price
    , sector
    , sub_sector_gics_code
    , last_modified_date
    , interest_rate
    , accural_method
    , state_taxable
    , federal_taxable
    , exchange_id
    , trade_currency
    , frequency
    , isin
    , sedol
    , first_coupon_date
    , last_coupon_date
    , minimum_purchase
    , income_currency
    , dummy_flag
    , valor_number
    , issuer_name
    , fund_code
    , broadridge_sec_number
    , status_code
    , product_type_id
    , created_date
    , {{ col_is_head(reference=source('envestnet_mwa', 'securitymaster_securities')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'securitymaster_securities') }}


