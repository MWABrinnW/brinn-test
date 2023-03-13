select
     ADVISORID
    ,FIRSTNAME
    ,LASTNAME
    ,COMPANYNAME
    ,ADDRESS1
    ,ADDRESS2
    ,CITY
    ,STATEORPROVINCE
    ,POSTALCODE
    ,BUSINESSPHONE
    ,CELLPHONE
    ,EMAIL
    ,ADVISORNAME
    ,OFFICEID
    ,FILENAME
    ,ACCOUNTID
    ,EFFECTIVE_DATE
    ,RECORD_DATETIME
    ,RECORD_DATE
    ,{{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_advisors'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_advisors') }}