select
    _pk
    , json:"accountNumber"::string           as account_number
    , json:"firstName"::string               as first_name
    , json:"middleName"::string              as middle_name
    , json:"last_Entity_Name"::string        as last_name
    , json:"suffix"::string                  as suffix
    , json:"getFullName"::string             as full_name
    , json:"clientType"::string              as client_type
    , json:"phoneNumber"::string             as phone_number
    , json:"emailId"::string                 as email_id
    , json:"accountNumber"::string           as account_number
    , json:"originatingLocationName"::string as originating_location
    , json:"active"::string                  as active
    , json:"groupName"::string               as group_name
    , json:"groupNumber"::string             as group_number
    , json:"primaryTask"::string             as primary_task
    , json:"periodEndDate"::string           as period_end_date
    , _created_at
from
    {{ source('xcm', 'client_detail') }}
