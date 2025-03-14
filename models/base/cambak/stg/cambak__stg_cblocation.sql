{% set src = source('cambak', 'cblocation') %}
select
    locationid::int                     as location_id
    , firmid::int                       as firm_id
    , locationname::text                as location_name
    , locationtypeid::int               as location_type_id
    , address1::text                    as address_1
    , address2::text                    as address_2
    , address3::text                    as address_3
    , city::text                        as city
    , state::text                       as state
    , postalcode::text                  as postal_code
    , country::text                     as country
    , websiteurl::text                  as website_url
    , locationnote::text                as location_note
    , entityid::int                     as entity_id
    , entitytypeid::int                 as entity_type_id
    , to_boolean(ispersonal::text)::int as is_personal

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                   as _extracted_at
    , file_type::text                   as file_type
    , _created_at::timestamp            as _created_at
    , _source_file::text                as _source_file
from {{ src }}
