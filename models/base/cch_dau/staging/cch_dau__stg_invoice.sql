select
    InvoiceIdent
    , ClientIdent
    , TO_TIMESTAMP(AcctPerDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as AcctPerDateTime
    , TO_TIMESTAMP(InvoiceDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as InvoiceDateTime
    , TO_TIMESTAMP(ReversedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')    as ReversedDateTime
    , InvoiceNumber
    , StdWIPAmount::decimal(19 , 4)                                  as StdWIPAmount
    , AdjustmentAmount::decimal(19 , 4)                              as AdjustmentAmount
    , TaxAmount::decimal(19 , 4)                                     as TaxAmount
    , Hours::decimal(19 , 4)                                         as Hours
    , TaxAppAmount::decimal(19 , 4)                                  as TaxAppAmount
    , ProgressBilledAmount::decimal(19 , 4)                          as ProgressBilledAmount
    , ProgressApplyAmount::decimal(19 , 4)                           as ProgressApplyAmount
    , ProgressTaxAmount::decimal(19 , 4)                             as ProgressTaxAmount
    , ProgressTaxAppAmount::decimal(19 , 4)                          as ProgressTaxAppAmount
    , StatusCode
    , InvoiceTypeCode
    , PaidInFullFlag
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as CreatedDateTime
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as LastUpdatedDateTime
    , CreatedByIdent
    , LastUpdatedByIdent
    , ReasonName
    , InvoiceStatusName
    , InvoiceStatusDescription
    , InvoiceNumberCode
    , InvoiceOfficeCode
    , TO_TIMESTAMP(BillThruDate , 'MM/DD/YYYY HH12:MI:SS AM')        as BillThruDate
    , ClientBillingFeeAgreementName
    , InvoiceTemplateName
    , InvoiceTitle
    , BillingGroupName
    , SubsidiaryClientIdent
    , ProjectIdent
    , InvoiceOfficeName
    , _Created_At
from {{ source('cch_dau', 'invoice') }}
