select
    _pk::int                                                 as _pk
    , json:"clientId"::int                                   as client_id
    , NULLIF(json:"accountNumber"::text(200) , '')           as account_number
    , NULLIF(json:"firstName"::text(200) , '')               as first_name
    , NULLIF(json:"middleName"::text(200) , '')              as middle_name
    , NULLIF(json:"last_Entity_Name"::text(200) , '')        as last_name
    , NULLIF(json:"suffix"::text(200) , '')                  as suffix
    , NULLIF(json:"getFullName"::text(200) , '')             as full_name
    , NULLIF(json:"clientType"::text(200) , '')              as client_type
    , NULLIF(json:"phoneNumber"::text(200) , '')             as phone_number
    , NULLIF(json:"emailId"::text(200) , '')                 as email_id
    , NULLIF(json:"accountNumber"::text(200) , '')           as account_number
    , NULLIF(json:"originatingLocationName"::text(200) , '') as originating_location
    , NULLIF(json:"active"::text(200) , '')                  as active
    , NULLIF(json:"groupName"::text(200) , '')               as group_name
    , NULLIF(json:"groupNumber"::text(200) , '')             as group_number
    , NULLIF(json:"primaryTask"::text(200) , '')             as primary_task
    -- period end date is left as a string, date is not complete - no year
    , NULLIF(json:"periodEndDate"::text(200) , '')           as period_end_date
    , _created_at                                            as _created_at
from
    {{ source('xcm', 'client_detail') }}
