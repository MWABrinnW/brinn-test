select
    archargesident::text                                             as archargesident
    , clientident::text                                              as clientident
    , postedbystaffident::text                                       as postedbystaffident
    , to_timestamp(transactiondatetime , 'MM/DD/YYYY HH12:MI:SS AM') as transactiondatetime
    , to_timestamp(posteddatetime , 'MM/DD/YYYY HH12:MI:SS AM')      as posteddatetime
    , to_timestamp(referencedatetime , 'MM/DD/YYYY HH12:MI:SS AM')   as referencedatetime
    , arentrytypecode::int                                           as arentrytypecode
    , archargesamount::number(20 , 2)                                as archargesamount
    , referencenumber::text                                          as referencenumber
    , correctionstatuscode::int                                      as correctionstatuscode
    , cashappliedamount::number(20 , 2)                              as cashappliedamount
    , creditsappliedamount::number(20 , 2)                           as creditsappliedamount
    , debitsappliedamount::number(20 , 2)                            as debitsappliedamount
    , to_timestamp(createddatetime , 'MM/DD/YYYY HH12:MI:SS AM')     as createddatetime
    , to_timestamp(lastupdateddatetime , 'MM/DD/YYYY HH12:MI:SS AM') as lastupdateddatetime
    , description::text                                              as description
    , createdbyident::text                                           as createdbyident
    , lastupdatedbyident::text                                       as lastupdatedbyident
    , archargesoriginalident::text                                   as archargesoriginalident
    , reasonname::text                                               as reasonname
    , _created_at::datetime                                          as _created_at
    , _extracted_at::datetime                                        as _extracted_at
    , {{ col_is_head(reference=source('cch_dau', 'archarges')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'archarges') }}
