select
    content:"CaseNumber"::text                                                      as case_num
    , content:"Id"::text                                                            as case_id
    , content:"ContactId"::text                                                     as contact_id
    , content:"AccountId"::text                                                     as account_id
    , convert_timezone('America/Chicago' , to_timestamp_tz(
        content:"LastModifiedDate"::text
        , 'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM'
    ))                                                                              as modified_at
    , convert_timezone(
        'America/Chicago'
        , to_timestamp_tz(content:"CreatedDate"::text , 'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')
    )                                                                               as created_at
    , content:"Type"::text                                                          as type
    , content:"Status"::text                                                        as status
    , content:"Estate_Item__c"::text                                                as estate_item_id
    , content:"LastModifiedById"::text                                              as last_modified_by_id
    , content:"CreatedById"::text                                                   as created_by_id
    , content:"OwnerId"::text                                                       as owner_id
    , content:"Description"::text                                                   as description
    , content:"Subject"::text                                                       as subject
    , _created_at                                                                   as _created_at
    , dense_rank() over (partition by content:"Id"::text order by _created_at desc) as rn
    , iff(rn = 1 , 1 , 0)                                                           as is_head
    , _id                                                                           as _id
from {{ source('salesforce_mis', 'case') }}
