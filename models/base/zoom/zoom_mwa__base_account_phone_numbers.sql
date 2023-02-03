select
    json:id::varchar(100)                              as id
  , json:number::varchar(50)                           as number
  , json:source::varchar(50)                           as source
  , json:status::varchar(50)                           as status
  , json:number_type::varchar(50)                      as number_type
  , json:capability::varchar(50)                       as capability
  , json:location::varchar(100)                        as location
  , json:assignee:id::varchar(50)                      as assignee_id
  , json:assignee:name::varchar(100)                   as assignee_name
  , json:assignee:extension_number::varchar(50)        as assignee_ext_number
  , json:assignee:type::varchar(50)                    as assignee_type
  , json:site:id::varchar(100)                         as site_id
  , json:site:name::varchar(100)                       as site_name
  , json:emergency_address:country::varchar(50)        as emerg_address_country
  , json:emergency_address:address_line1::varchar(100) as emerg_address_line1
  , json:emergency_address:address_line2::varchar(100) as emerg_address_line2
  , json:emergency_address:city::varchar(50)           as emerg_address_city
  , json:emergency_address:state_code::varchar(10)     as emerg_address_state_code
  , json:emergency_address:zip::varchar(10)            as emerg_address_zip
  , effective_at::timestamp                            as effective_at
  , _created_at::timestamp                             as _created_at
  , _source_file                                       as _source_file
from {{ source('zoom_mwa', 'account_phone_numbers') }}