select
     clientid
    ,factid
    ,type
    ,typecode
    ,subtype
    ,name
    ,amount
    ,amountasof
    ,costbasis
    ,country
    ,remcapitalcommitment
    ,valuationdate
    ,initialinvestmentdate
    ,capitalcommitment
    ,capitalcalled
    ,nonrecallablecapitaldistributed
    ,recallablecapitaldistributed
    ,totalcapitaldistributed
    ,effective_date
    ,record_datetime
    ,{{ col_is_head(reference=source('emoney_mwa', 'emoney_mwa_businesses'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('emoney_mwa', 'emoney_mwa_businesses') }}