select
    content:AccountId::text                  as household_id
    , regexp_substr(
        content:"Contact.attributes.url"::text , '[^/]+$'
    )                                        as contact_id
    , content:"Contact.Name"::text(300)      as contact_name
    , content:"Contact.Name.type"::text      as contact_type
    , content:"Contact.attributes.url"::text as contact_url
    , content:Roles::text                    as roles
    , content:"attributes.type"::text        as roles__type
    , content:"attributes.url"::text         as roles__url
    , _created_at                            as _created_at
    , {{ col_is_head(reference=source('salesforce_mis', 'account_contact_relation'),
        source_date_col='_created_at',
        reference_date_col='_created_at') }}
from {{ source('salesforce_mis', 'account_contact_relation') }}
