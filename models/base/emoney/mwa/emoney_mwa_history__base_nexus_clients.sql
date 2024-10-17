{% set src = source('emoney_mwa', 'nexus_clients') %}
select
    _data:"businessphone"::text(200)     as business_phone
    , _data:"clientid"::text(200)        as client_id
    , _data:"postalcode"::text(200)      as postal_code
    , _data:"stateorprovince"::text(200) as state_or_province
    , _data:"address2"::text(200)        as address_2
    , _data:"firstname"::text(200)       as first_name
    , _data:"address1"::text(200)        as address_1
    , _data:"advisorid"::text(200)       as advisor_id
    , _data:"lastname"::text(200)        as last_name
    , _data:"email"::text(200)           as email
    , _data:"fax"::text(200)             as fax
    , _data:"city"::text(200)            as city
    , _data:"office"::text(200)          as office

    , effective_date::date               as effective_date
    , _created_at::timestamp             as _created_at
    , _source_file::text(200)            as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
