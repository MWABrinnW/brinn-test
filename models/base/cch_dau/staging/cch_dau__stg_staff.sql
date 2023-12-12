select
    StaffIdent
    , StaffOfficeName
    , StaffRegionName
    , StaffBusinessUnitName
    , StaffDescription
    , StaffIdentifier
    , StaffName
    , StaffDepartment
    , StaffPosition
    , StaffReportingManagerName
    , ReportName
    , FirmIdent
    , FirmName
    , StaffStatus
    , DeleteFlag
    , TO_TIMESTAMP(CreatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')      as CreatedDateTime
    , TO_TIMESTAMP(LastUpdatedDateTime , 'MM/DD/YYYY HH12:MI:SS AM')  as LastUpdatedDateTime
    , TO_TIMESTAMP(LastInactiveDateTime , 'MM/DD/YYYY HH12:MI:SS AM') as LastInactiveDateTime
    , StaffFirstName
    , StaffMiddleName
    , StaffLastName
    , StaffSuffixCode
    , EmergencyContactName
    , EmergencyContactRelationship
    , EmergencyContactPhone
    , EmployeeNumber
    , TO_TIMESTAMP(ReviewDate , 'MM/DD/YYYY HH12:MI:SS AM')           as ReviewDate
    , HireSalary::decimal(19 , 4)                                     as HireSalary
    , TO_TIMESTAMP(HireDate , 'MM/DD/YYYY HH12:MI:SS AM')             as HireDate
    , CurrentSalary::decimal(19 , 4)                                  as CurrentSalary
    , StaffUserID
    , UserLoginEnabledFlag
    , HiredTypeName
    , PayTypeName
    , HonorificCode
    , TO_TIMESTAMP(LastActiveDateTime , 'MM/DD/YYYY HH12:MI:SS AM')   as LastActiveDateTime
    , _Created_At
from {{ source('cch_dau', 'staff') }}
