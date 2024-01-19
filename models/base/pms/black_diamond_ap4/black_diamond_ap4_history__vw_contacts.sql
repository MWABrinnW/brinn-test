select
    effective_date                                       as effective_date
    , json:Relationship.ID::string                       as relationship_id
    , json:Relationship.Name::string                     as relationship_name
    , contacts.value:ContactId::int                      as contact_id
    , contacts.value:FirstName::varchar(100)             as contact_first_name
    , contacts.value:LastName::varchar(100)              as contact_last_name
    , contacts.value:EmailAddress[0]:email::varchar(100) as email_address_1
    , contacts.value:EmailAddress[0]:label::varchar(100) as email_address_1_label
    , contacts.value:EmailAddress[0]:type::varchar(100)  as email_address_1_type
    , contacts.value:EmailAddress[1]:email::varchar(100) as email_address_2
    , contacts.value:EmailAddress[1]:label::varchar(100) as email_address_2_label
    , contacts.value:EmailAddress[1]:type::varchar(100)  as email_address_2_type
    , record_datetime                                    as _source_loaded_at
, {{ col_is_head(reference=source('black_diamond_ap4', 'relationship'), reference_date_col='effective_date', source_date_col='a.effective_date') }}    
, {{ col_is_current(date_col='a.effective_date') }}
from {{ source('black_diamond_ap4', 'relationship') }} as a
, table(flatten(json , 'ReferencedEntities.Contacts')) as contacts
where true
