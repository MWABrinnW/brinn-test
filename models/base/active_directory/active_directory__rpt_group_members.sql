select
    g.system_name              as system_name
    , g.system_instance        as system_instance
    , g.system_key             as system_key
    , g.firm_source            as firm_source

    , g.group_name             as group_name
    , g.group_dn               as group_dn
    , g.group_description      as group_description
    , g.group_created_at       as group_created_at
    , g.group_modified_at      as group_modified_at
    , g.group_category         as group_category
    , g.group_object_category  as group_object_category
    , g.group_sam_account_name as group_sam_account_name
    , g.group_sam_account_type as group_sam_account_type
    , g.group_canonical_name   as group_canonical_name

    , g.member_dn              as member_dn
    , gm.name                  as member_name
    , gm.canonical_name        as member_canonical_name
    , gm.object_class          as member_object_class
    , gm.employee_number       as member_employee_number
    , gm.employee_id           as member_employee_id

    , g.is_head                as is_head
    , g._effective_at          as _effective_at
    , g._created_at            as _created_at
    , g._source_file           as _source_file
from {{ ref('active_directory__int_group_members') }} as g
left join {{ ref('active_directory__rpt_users') }} as gm
    on g._effective_at::date = gm._effective_at::date
    and g.member_dn = gm.distinguished_name

union all

select
    gm.system_name                as system_name
    , gm.system_instance          as system_instance
    , gm.system_key               as system_key
    , gm.firm_source              as firm_source

    , gm.group_name               as group_name
    , gm.group_dn                 as group_dn
    , gm.group_description        as group_description
    , gm.group_created_at         as group_created_at
    , gm.group_modified_at        as group_modified_at
    , gm.group_category           as group_category
    , gm.group_object_category    as group_object_category
    , gm.group_sam_account_name   as group_sam_account_name
    , gm.group_sam_account_type   as group_sam_account_type
    , gm.group_canonical_name     as group_canonical_name

    , gm.member_dn                as member_dn
    , u.name                      as member_name
    , u.canonicalname             as member_canonical_name
    , u.objectclass               as member_object_class
    , u.employeenumber::text(200) as member_employee_number
    , u.employeeid::text(200)     as member_employee_id

    , 0::int                      as is_head
    , u._created_at               as _effective_at
    , u._created_at               as _created_at
    , null::text(200)             as _source_file
from {{ ref('active_directory_mwa__stg_group_members') }} as gm
left join {{ ref('active_directory_mwa__stg_users') }} as u
    on gm._created_at::date = u._created_at::date
    and gm.member_dn = u.distinguishedname
    and u.rn_day = 1
where 1 = 1
    and gm.rn_day = 1
    and gm._created_at::date < (select min(_effective_at::date) from {{ ref('active_directory__stg_users') }})
