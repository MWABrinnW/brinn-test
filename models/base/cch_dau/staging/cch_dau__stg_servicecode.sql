select
    ServiceCodeIdent
    , CategoryIdent
    , CategoryName
    , SubCategoryIdent
    , SubCategoryName
    , ServiceCodeID
    , ServiceCodeName
    , CategoryId
    , SubCategoryId
    , BillableTypeFlag
    , Taxable
    , InactiveFlag::boolean                                          as InactiveFlag
    , DeleteFlag::boolean                                            as DeleteFlag
    , ServiceCodeTypeFlag
    , MileageUnitFlag::boolean                                       as MileageUnitFlag
    , IncludeInBillablePercentageFlag::boolean                       as IncludeInBillablePercentageFlag
    , BillRateType
    , SurchargeType
    , SurchargeRate::decimal(19 , 4)                                 as SurchargeRate
    , SurchargeFlatAmount::decimal(19 , 4)                           as SurchargeFlatAmount
    , SurchargePercent::decimal(8 , 4)                               as SurchargePercent
    , CreatedByIdent
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as CreatedDateTime
    , LastUpdatedByIdent
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as LastUpdatedDateTime
    , ServiceCodeDescription
    , ServiceClass
    , StaffBillRate
    , AlternateStaffBillRate
    , _Created_At
from {{ source('cch_dau', 'servicecode') }}
