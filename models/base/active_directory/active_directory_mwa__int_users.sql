select
    u.*
    , m.employeenumber    as manager_employeenumber
    , m.userprincipalname as manager_email
    , m.userprincipalname as manager_userprincipalname
    , m.samaccountname    as manager_samaccountname
    , m.distinguishedname as manager_distinguishedname
from {{ ref('active_directory_mwa__stg_users') }} as u
left join {{ ref('active_directory_mwa__stg_users') }} as m
    on u._created_at = m._created_at
    and u.manager = m.dn
    and m.rn = 1
