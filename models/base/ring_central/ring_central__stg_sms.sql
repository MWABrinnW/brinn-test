select
    json:conversationId::string
    , recipients.value:name::string
    , recipients.value:phoneNumber::string
    , json:from.name::string
    , json:from.phoneNumber::string
    , json:id::string
    , json:subject::string
    , json:creationTime::timestampltz
    , json:lastModifiedTime::timestampltz
from {{ source('ring_central', 'sms') }}
, table(flatten(input => json:to)) as recipients
