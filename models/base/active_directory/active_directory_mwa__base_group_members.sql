
select
    g.dn as group_id
  , g.primarygrouptoken as group_token
  , g.name as group_name
  , regexp_replace(regexp_replace(c.value::string, ',.*'), 'cn=') as user_name
  , regexp_replace(c.value::string, '"\".*\""') as user_id
  , g.record_date::date as record_date
  , g.record_datetime::timestamp as record_datetime
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('active_directory_mwa', 'groups_history') }})
            then 1
        else 0 end             as is_current
from {{ source('active_directory_mwa', 'groups_history') }} g
   , lateral flatten(input =>split(member, ';')) c

