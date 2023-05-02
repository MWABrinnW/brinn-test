select
    'orion' as pms
    , 'mwa' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , accountid
    , accountnumber
    , accountvalue
    , asofdate
    , assetclass
    , assetid
    , assetpercentofaccount
    , assetstrategy
    , assetstrategyid
    , assetvalue
    , bondmaturitydate
    , bondrate
    , createdby
    , createddate
    , cusip
    , editedby
    , editeddate
    , excludefromrebal
    , externalid
    , firmid
    , fundfamilyname
    , ismanaged
    , price
    , pricedate
    , productcategory
    , productcategorycode
    , productclasscode
    , productid
    , productname
    , producttype
    , riskcategory
    , secondaryacctcode
    , ticker
    , unitbalance
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'assets')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('orion_mwa_bulk', 'assets') }}