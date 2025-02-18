select
    'cch'::text(200)                                             as system_name
    , 'axcess'::text(200)                                        as system_instance
    , concat(system_name , '__' , system_instance)::text(200)    as system_key
    , clientident
    , staffident
    , servicecodeident
    , projectident
    , workstepident
    , to_timestamp(transactiondate , 'MM/DD/YYYY HH12:MI:SS AM') as transactiondate
    , allhours::decimal(19 , 4)                                  as allhours
    , billablehours::decimal(19 , 2)                             as billablehours
    , nonbillablehours::decimal(19 , 4)                          as nonbillablehours
    , timeamount::decimal(19 , 4)                                as timeamount
    , expenseamount::decimal(19 , 4)                             as expenseamount
    , surchargeamount::decimal(19 , 4)                           as surchargeamount
    , staffstatus
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'uvw_productivity')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'uvw_productivity') }}
