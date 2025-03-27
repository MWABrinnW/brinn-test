select
    accounts::text                            as accounts
    , address1::text                          as address_1
    , city::text                              as city
    , contactentitylinkid::integer            as contact_entity_link_id
    , contactid::integer                      as contact_id
    , contactname::text                       as contact_name
    , contactuniqueidentifier::text           as contact_unique_identifier
    , email::text                             as email
    , entityid::integer                       as entity_id
    , entityname::text                        as entity_name
    , entitytypeid::integer                   as entity_type_id
    , firmid::integer                         as firm_id
    , givenname::text                         as given_name
    , id::integer                             as id
    , to_boolean(isclosed::text)::int         as is_closed
    , to_boolean(isdirect::text)::int         as is_direct
    , to_boolean(iseditable::text)::int       as is_editable
    , locationid::integer                     as location_id
    , locationname::text                      as location_name
    , locationtype::text                      as location_type
    , middlename::text                        as middle_name
    , note::text                              as note
    , parententityname::text                  as parent_entity_name
    , phonenumber::text                       as phone_number
    , phonenumbertype::text                   as phone_number_type
    , postalcode::text                        as postal_code
    , rolename::text                          as role_name
    , state::text                             as state
    , surname::text                           as surname
    , to_boolean(willingreference::text)::int as willing_reference
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                         as _extracted_at
    , file_type::text                         as file_type
    , _created_at::timestamp                  as _created_at
    , _source_file::text                      as _source_file
from {{ source('cambak', 'contactentityrelationinfo') }}
