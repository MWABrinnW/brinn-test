select
    Wipident
    , ClientIdent
    , ServiceCodeIdent
    , InvoiceIdent
    , StaffIdent
    , ProjectIdent
    , Hours::decimal(19 , 2)                                     as Hours
    , StdAmount::decimal(19 , 2)                                 as StdAmount
    , TO_TIMESTAMP(TransactionDate , 'MM/DD/YYYY HH12:MI:SS AM') as TransactionDate
    , TimeAdjAmount::decimal(19 , 2)                             as TimeAdjAmount
    , ExpenseAdjAmount::decimal(19 , 2)                          as ExpenseAdjAmount
    , AdjAmount::decimal(19 , 2)                                 as AdjAmount
    , SurchargeAmount::decimal(19 , 2)                           as SurchargeAmount
    , TimeBilledAmount::decimal(19 , 2)                          as TimeBilledAmount
    , ExpenseBilledAmount::decimal(19 , 2)                       as ExpenseBilledAmount
    , BilledAmount::decimal(19 , 2)                              as BilledAmount
    , TimeCost::decimal(19 , 2)                                  as TimeCost
    , ExpenseCost::decimal(19 , 2)                               as ExpenseCost
    , Cost::decimal(19 , 2)                                      as Cost
    , InvoiceNumber
    , TO_TIMESTAMP(InvoiceDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as InvoiceDateTime
    , InvoiceStatusCode
    , _Created_At
from {{ source('cch_dau', 'uvw_wipar02clientident') }}
