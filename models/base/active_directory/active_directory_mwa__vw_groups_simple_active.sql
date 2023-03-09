select
    g.group_id
  , g.group_token
  , g.group_name
  , u.displayname
  , u.samaccountname
  , u.mail
  , g.record_date
  , g.record_datetime
from {{ ref('active_directory_mwa__vw_group_members_current') }}    g
left join {{ ref('active_directory_mwa__vw_user_current_active') }} u
          on g.user_id = u.dn
where samaccountname is not null
order by group_name, displayname