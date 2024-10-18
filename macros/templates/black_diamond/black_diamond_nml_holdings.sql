{%- macro black_diamond_nml_holdings(instance) -%}

select
    effective_date                                           as effective_date
    , system_name                                            as pms
    , system_instance                                        as pms_instance_location
    , system_key                                             as pms_key
    , firm_source                                            as firm_source
    -- PMS ---------------------------------------------------------------------
    , account_id                                             as pms_account_id
    , upper(account_number)                                  as account_number_formatted
    , replace(ltrim(upper(account_number) , '0') , '-' , '') as account_number
    , null::varchar(200)                                     as pms_household_id
    , null::varchar(200)                                     as pms_household_name
    , custodian                                              as pms_custodian
    , asset_id::varchar(200)                                 as pms_security_id
    , cusip                                                  as pms_cusip
    , ticker                                                 as pms_ticker
    , null::int                                              as is_ticker_cusip
    , asset_name                                             as pms_security_name
    , issue_type                                             as pms_security_type
    , class_name                                             as pms_asset_class
    , market_value                                           as pms_market_value
    , units                                                  as pms_units_shares
    , price                                                  as pms_price
    , null::decimal(19 , 9)                                  as pms_price_unfactored
    , null::decimal(19 , 9)                                  as pms_factor
    , null::varchar(200)                                     as pms_cost_basis
    -- META ---------------------------------------------------------------------
    , is_head                                                as is_head
    , is_current                                             as is_current
    , _source_loaded_at                                      as _source_loaded_at
    , null::varchar(200)                                     as _source_file
from {{ ref('black_diamond_' ~ instance ~ '__base_holdings') }}

{%- endmacro -%}
