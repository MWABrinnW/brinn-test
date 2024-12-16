select
    regexp_substr(
        content:"Contact__r.attributes.url"::text , '[^/]+$'
    )                                            as contact_id
    , content:"Contact__r.Name"::text            as contact_name
    , content:"Contact__r.attributes.type"::text as contact_type
    , content:"Contact__r.attributes.url"::text  as contact_url
    , content:Estate_Item__c::text               as estate_item_id
    , content:Role__c::text                      as role
    , content:"attributes.type"::text            as role_type
    , content:"attributes.url"::text             as role_url
    , _created_at                                as _created_at
    , {{ col_is_head(reference=source('salesforce_mis', 'estate_item_contact_link'),
        source_date_col='_created_at',
        reference_date_col='_created_at') }}
from {{ source('salesforce_mis', 'estate_item_contact_link') }}
