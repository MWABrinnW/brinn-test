
select
    json:id::int                                                         as id
  , to_timestamp(json:updateddate::varchar(50), 'yyyy-mm-dd hh12:mi am') as updated_date
  , json:updatedby:value::varchar(100)                                   as updated_by
  , json:updatedby:id::int                                               as updated_by_id
  , json:sourcedevice::varchar(100)                                      as source_device
  , json:associatedprofile:value::varchar(100)                           as associated_profile
  , json:associatedprofile:id::int                                       as associated_profile_id
  , json:baseprofile:value::varchar(100)                                 as base_profile
  , json:baseprofile:id::int                                             as base_profile_id
  , json:source::varchar(100)                                            as source
  , json:portal::int                                                     as portal_id
  , json:sourceorigin:value::varchar(100)                                as source_origin
  , json:sourceorigin:id::varchar(100)                                   as source_origin_id
  , json:sourcechannel::varchar(100)                                     as source_channel
  , json:status:value::varchar(100)                                      as status
  , json:status:id::varchar(100)                                         as status_id
  , record_datetime
from {{ source('icims', 'json_data') }}
where 1 = 1
  and object_type = 'applicantworkflows'
