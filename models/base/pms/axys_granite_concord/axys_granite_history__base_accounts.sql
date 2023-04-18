select
    'axys' as pms
    , 'granite' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , portfoliocode
    , acctstatus
    , beginmgmt
    , initialvalue
    , covoff
    , closedate
    , closevalue
    , reportdate
    , aum
    , discretion
    , type
    , acctname
    , custodian
    , accountnumber
    , crmid
    , goal
    , primeenabled
    , proxyvote
    , flatfee
    , rate1
    , break1
    , rate2
    , break2
    , rate3
    , break3
    , rate4
    , break4
    , {{ col_is_head(reference=source('axys_granite', 'financial_accounts_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('axys_granite', 'financial_accounts_monthly') }}