select
    'orion' as pms
    , 'mwa' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , accountid
    , accountnumber
    , asofdate
    , assetid
    , firmid
    , navprice
    , nounits
    , productid
    , status
    , ticker
    , transactionid
    , transamount
    , transdate
    , transtype
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'transactions')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('orion_mwa_bulk', 'transactions') }}