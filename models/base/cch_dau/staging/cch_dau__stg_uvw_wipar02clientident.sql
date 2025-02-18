select
    'cch'::text(200)                                             as system_name
    , 'axcess'::text(200)                                        as system_instance
    , concat(system_name , '__' , system_instance)::text(200)    as system_key
    , wipident
    , clientident
    , servicecodeident
    , invoiceident
    , staffident
    , projectident
    , hours::decimal(19 , 2)                                     as hours
    , stdamount::decimal(19 , 2)                                 as stdamount
    , to_timestamp(transactiondate , 'MM/DD/YYYY HH12:MI:SS AM') as transactiondate
    , timeadjamount::decimal(19 , 2)                             as timeadjamount
    , expenseadjamount::decimal(19 , 2)                          as expenseadjamount
    , adjamount::decimal(19 , 2)                                 as adjamount
    , surchargeamount::decimal(19 , 2)                           as surchargeamount
    , timebilledamount::decimal(19 , 2)                          as timebilledamount
    , expensebilledamount::decimal(19 , 2)                       as expensebilledamount
    , billedamount::decimal(19 , 2)                              as billedamount
    , timecost::decimal(19 , 2)                                  as timecost
    , expensecost::decimal(19 , 2)                               as expensecost
    , cost::decimal(19 , 2)                                      as cost
    , invoicenumber
    , to_timestamp(invoicedatetime , 'MM/DD/YYYY HH12:MI:SS AM') as invoicedatetime
    , invoicestatuscode
    , _created_at
    , {{ col_is_head(reference=source('cch_dau', 'uvw_wipar02clientident')
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
from {{ source('cch_dau', 'uvw_wipar02clientident') }}
