select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , security_id
    , cusip
    , ticker_symbol
    , security_description
    , security_type
    , security_style
    , issue_type_multiplier
    , agency_factor
    , price_date
    , fidelity_price
    , pershing_price
    , schwab_price
    , beta_price
    , aggregrate_price
    , pacific_price
    , share_class
    , cdsc_fund_flag
    , fund_family_id
    , closed_flag
    , sp_rating
    , moody_rating_id
    , firm_eligbile
    , issue_date
    , matruity_date
    , call_date
    , call_price
    , sector
    , sub_sector_gics_code
    , last_modified_date
    , interest_rate
    , accural_method
    , state_taxable
    , federal_taxable
    , {{ col_is_head(reference=source('envestnet_mps', 'securitymaster_securities')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'securitymaster_securities') }}
