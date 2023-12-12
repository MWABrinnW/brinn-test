select
    ClientIdent
    , StaffIdent
    , ServiceCodeIdent
    , ProjectIdent
    , WorkstepIdent
    , TO_TIMESTAMP(TransactionDate , 'MM/DD/YYYY HH12:MI:SS AM') as TransactionDate
    , AllHours::decimal(19 , 4)                                  as AllHours
    , BillableHours::decimal(19 , 2)                             as BillableHours
    , NonbillableHours::decimal(19 , 4)                          as NonbillableHours
    , TimeAmount::decimal(19 , 4)                                as TimeAmount
    , ExpenseAmount::decimal(19 , 4)                             as ExpenseAmount
    , SurchargeAmount::decimal(19 , 4)                           as SurchargeAmount
    , StaffStatus
    , _Created_At
from {{ source('cch_dau', 'uvw_productivity') }}
