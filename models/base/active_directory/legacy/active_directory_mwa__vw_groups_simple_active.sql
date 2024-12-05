select
    g.group_id
    , g.group_token
    , g.group_name
    , u.displayname
    , u.samaccountname
    , u.mail
    , g.record_date
    , g.record_datetime
from {{ ref('active_directory_mwa__vw_group_members_current') }} as g
left join {{ ref('active_directory_mwa__vw_user_current_active') }} as u
    on g.user_id = u.dn
where u.samaccountname is not null
order by g.group_name , u.displayname
