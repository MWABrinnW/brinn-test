select
    u.system_name
    , u.system_instance
    , u.system_key
    , u.firm_source
    , u.distinguished_name
    , u.name
    , u.canonical_name
    , u.employee_number
    , u.employee_id
    , u.manager
    , u.cn
    , u.sn
    , u.display_name
    , u.given_name
    , u.description
    , u.object_class
    , u.instance_type
    , u.admin_count
    , u.is_locked_out
    , u.account_lockout_time
    , u.last_logon_at
    , u.is_enabled
    , u.is_deleted
    , u.company
    , u.office
    , u.division
    , u.department
    , u.title
    , u.email
    , u.sso_smtp
    , u.street_address
    , u.office_phone
    , u.modified_at
    , u.mobile_phone
    , u.primary_group
    , u.primary_group_id
    , u.organization
    , u.password_expired
    , u.bad_pwd_count
    , u.bad_password_time
    , u.last_bad_password_attempt_at
    , u.password_last_set_at
    , u.msexchange_mailbox_created_at
    , u.is_critical_system_object
    , u.member_of
    , u.sam_account_name
    , u.sam_account_type
    , u.physical_delivery_office_name
    , u.city
    , u.state
    , u.postal_code

    , u.other_mobile[0]::text(200) as other_mobile
    , u.date_of_start              as date_of_start
    , u.date_of_birth              as date_of_birth
    , u.admin_description          as admin_description

    , m.employee_number            as manager_employeenumber
    , m.email                      as manager_email
    , m.sam_account_name           as manager_samaccountname
    , m.distinguished_name         as manager_distinguishedname

    , u.is_head
    , u._effective_at
    , u._created_at
    , u._source_file
from {{ ref('active_directory__int_users') }} as u
left join {{ ref('active_directory__int_users') }} as m
    on u._effective_at::date = m._effective_at::date
    and u.manager = m.distinguished_name

union all

select
    u.system_name                   as system_name
    , u.system_instance             as system_instance
    , u.system_key                  as system_key
    , u.firm_source                 as firm_source
    , u.distinguishedname           as distinguished_name
    , u.name                        as name
    , u.canonicalname               as canonical_name
    , u.employeenumber              as employee_number
    , u.employeeid                  as employee_id
    , u.manager                     as manager
    , u.cn                          as cn
    , u.sn                          as sn
    , u.displayname                 as display_name
    , u.givenname                   as given_name
    , u.description                 as description
    , u.objectclass                 as object_class
    , u.instancetype                as instance_type
    , u.admincount                  as admin_count
    , null::int                     as is_locked_out
    , u.lockouttime                 as account_lockout_time
    , u.lastlogon                   as last_logon_at
    , null::int                     as is_enabled
    , u.isdeleted::int              as is_deleted
    , u.company                     as company
    , null::text(200)               as office
    , u.division                    as division
    , u.department                  as department
    , u.title                       as title
    , u.userprincipalname           as email
    , null::text(200)               as sso_smtp
    , u.streetaddress               as street_address
    , u.telephonenumber             as office_phone
    , u.whenchanged                 as modified_at
    , null::text(200)               as mobile_phone
    , null::text(200)               as primary_group
    , u.primarygroupid              as primary_group_id
    , null::text(200)               as organization
    , null::text(200)               as password_expired
    , u.badpwdcount                 as bad_pwd_count
    , u.badpasswordtime             as bad_password_time
    , null::timestamp               as last_bad_password_attempt_at
    , u.pwdlastset                  as password_last_set_at
    , null::text(200)               as msexchange_mailbox_created_at
    , u.iscriticalsystemobject::int as is_critical_system_object
    , null::variant                 as member_of
    , u.samaccountname              as sam_account_name
    , u.samaccounttype              as sam_account_type
    , u.physicaldeliveryofficename  as physical_delivery_office_name

    , u.othermobile                 as other_mobile
    , null::text(200)               as date_of_start
    , null::text(200)               as date_of_birth
    , u.admindescription            as admin_description

    , m.employeenumber              as manager_employeenumber
    , m.userprincipalname           as manager_email
    , m.samaccountname              as manager_samaccountname
    , m.distinguishedname           as manager_distinguishedname
    , u.l                           as city
    , u.st                          as state
    , u.postalcode                  as postal_code

    , u.is_head                     as is_head
    , u._created_at                 as _effective_at
    , u._created_at                 as _created_at
    , null::text(200)               as _source_file
from {{ ref('active_directory_mwa__stg_users') }} as u
left join {{ ref('active_directory_mwa__stg_users') }} as m
    on u._created_at::date = m._created_at::date
    and u.manager = m.dn
    and m.rn_day = 1
where 1 = 1
    and u.rn_day = 1
    and u._created_at::date < (select min(_effective_at::date) from {{ ref('active_directory__stg_users') }})
