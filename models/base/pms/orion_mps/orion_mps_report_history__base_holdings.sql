select
    'orion'                                        as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mps'                                        as firm_source
    , effective_date
    , lname
    , asofdate
    , client_id
    , rep_name
    , rep_company_name
    , broker_dealer
    , reg_name
    , regtype
    , product_name
    , product_id
    , ticker
    , share_class
    , dsymbol
    , category
    , accountstatus
    , accountisactive
    , outsideid
    , mgmt_style
    , account_id
    , planname
    , producttype
    , assetclass
    , description
    , risk_category
    , acctcode
    , asset_id
    , assetisactive
    , isfeeexcluded
    , assetvalue
    , unitbalance
    , navprice
    , fund_name
    , custodian
    , ssn
    , include_in_qpe
    , include_in_twr
    , assetlevelstrategy
    , inceptiondate
    , lastttransdate
    , account_ismanaged
    , asset_ismanaged
    , product_ismanaged
    , businessline
    , subadvisor_name
    , dividends_reinvested
    , company
    , clientfullname
    , accountnumber
    , shares
    , costbasis
    , fee_schedule
    , exclude_from_rebalance
    , model_name
    , cusip
    , {{ col_is_head(reference=source('orion_mps', 'asset_query_1809_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mps', 'asset_query_1809_history') }}
