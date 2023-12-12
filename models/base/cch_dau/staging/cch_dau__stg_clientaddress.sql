select
    AddressIdent
    , AddressIdentCategoryType
    , EmployeePlanSubEntityTypeCode
    , ReferenceIdent
    , ReferenceIdentType
    , FirmAddressTypeLabelName
    , FirmAddressTypeDescription
    , AddressLine1
    , AddressLine2
    , AddressLine3
    , CityName
    , PostalCode
    , CountryCode
    , PrimaryAddressFlag
    , MailingAddressFlag
    , AptOrSuiteNumber
    , StateProvinceCode
    , CreatedByIdent
    , LastUpdatedByIdent
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')     as CreatedDateTime
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as LastUpdatedDateTime
    , InvoiceFlag::boolean                                           as InvoiceFlag
    , StatementFlag::boolean                                         as StatementFlag
    , IsClientContactBillingAddressFlag::boolean                     as IsClientContactBillingAddressFlag
    , _Created_At
from {{ source('cch_dau', 'clientaddress') }}
