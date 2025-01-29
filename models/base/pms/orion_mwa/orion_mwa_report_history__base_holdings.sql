select
    'orion'                                        as system_name
    , 'mwa'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , account_id
    , account_ismanaged
    , accountisactive
    , accountstatus
    , acctcode
    , acctstartdate
    , asofdate
    , asset_id
    , asset_ismanaged
    , assetclass
    , assetisactive
    , assetvalue
    , businessline
    , capital_gains_reinvested
    , category
    , client_id
    , cusip
    , custodian
    , description
    , dividends_reinvested
    , downloadsymbol
    , exclude_from_rebalance
    , fee_schedule
    , fidelity_transaction_fee
    , fund_name
    , include_in_gain_loss
    , include_in_qpe
    , include_in_twr
    , isfeeexcluded
    , last_transaction_date
    , lname
    , lt_capital_gains_reinvested
    , mgmt_style
    , model_name
    , navprice
    , outside_id_household
    , outsideid
    , planname
    , product_id
    , product_name
    , productcategory
    , producttype
    , reg_description
    , reg_name
    , rep_name
    , schwab_transaction_fee
    , ssn_taxid
    , ticker
    , unitbalance
    , cost_basis
    , {{ col_is_head(reference=source('orion_mwa', 'asset_query_mwa_5896_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mwa', 'asset_query_mwa_5896_history') }}
