select a.content:id:: varchar(200)                     as id
     , a.content:isManagedByIdentityProvider:: boolean as isManagedByIdentityProvider
     , a.content:membersUrl:: varchar(200)             as membersUrl
     , a.content:name:: varchar(200)                   as name
     , a.content:reportersUrl:: varchar(200)           as reportersUrl
     , a.content:url:: varchar(200)                    as url
     , _source_file                                    as _source_file
     , _created_at                                     as _created_at
     , _extracted_at                                   as _extracted_at
     , case 
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file = 'groups') 
          then 1 else 0 
          end                                   as is_head
from {{ source('rise', 'api_data') }} a
where _source_file = 'groups'
