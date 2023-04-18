select
    'orion' as pms
    , 'mwa' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , accountid
    , accountnumber
    , accountstatus
    , accounttype
    , accountvalue
    , asofdate
    , businesslineid
    , cashvalue
    , closeddate
    , custodian
    , custodianid
    , firmid
    , fundfamilyid
    , fundfamilyname
    , groupnumber
    , historicalaccountid
    , householdid
    , inceptiondate
    , isactive
    , ismanaged
    , isoutsidemodel
    , istradeblocked
    , managementstyle
    , managementstyleid
    , minimumcashbalance
    , minimumcashbalancetype
    , modelid
    , modelname
    , opendate
    , openvalue
    , outsideid
    , performanceasofdate
    , performanceasofdate_asutcdate
    , performanceday
    , performancemtd
    , performanceoneyear
    , performanceqtd
    , performancethreeyear
    , performanceytd
    , planid
    , realizedgainloss_previousyear
    , realizedgainloss_ytd
    , registrationid
    , repid
    , replenishminimumcash
    , shareclassid
    , subadvisorid
    , tradinginstructions
    , unrealizedgainloss
    , file_date
    , {{ col_is_head(reference=source('orion_mwa_bulk', 'financial_accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('orion_mwa_bulk', 'financial_accounts') }}