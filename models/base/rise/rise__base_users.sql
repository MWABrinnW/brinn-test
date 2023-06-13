select a.content:email:: varchar(200)            as email
     , a.content:favoritesUrl:: varchar(200)     as favoritesUrl
     , a.content:firstName:: varchar(200)        as firstName
     , a.content:groupsUrl:: varchar(200)        as groupsUrl
     , a.content:id:: varchar(200)               as id
     , a.content:lastActiveAt:: varchar(200)     as lastActiveAt
     , a.content:lastName:: varchar(200)         as lastName
     , a.content:learnerReportUrl:: varchar(200) as learnerReportUrl
     , a.content:role:: varchar(200)             as role
     , a.content:url:: varchar(200)              as url
     , _source_file                              as _source_file
     , _created_at                               as _created_at
     , _extracted_at                             as _extracted_at
     , case 
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file = 'users') 
          then 1 else 0 
          end                                    as is_head
from {{ source('rise', 'api_data') }} a
where _source_file = 'users'
