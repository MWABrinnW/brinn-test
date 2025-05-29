{{ config(
    materialized = 'incremental',
    unique_key = '_effective_at::date',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    tags = ['hourly']
) }}

select
      u.system_name::text                           as system_name
    , u.system_instance::text                       as system_instance
    , u.system_key::text                            as system_key
    , u.firm_source::text                           as firm_source
    , u.distinguishedname::text                     as distinguished_name
    , u.name::text                                  as name
    , u.canonicalname::text                         as canonical_name
    , u.employeenumber::text                        as employee_number
    , u.employeeid::text                            as employee_id
    , u.manager::text                               as manager
    , u.cn::text                                    as cn
    , u.sn::text                                    as sn
    , u.displayname::text                           as display_name
    , u.givenname::text                             as given_name
    , u.description::text                           as description
    , u.objectclass::text                           as object_class
    , u.instancetype::int                           as instance_type
    , u.admincount::int                             as admin_count
    , u.lockedout::int                              as is_locked_out
    , u.accountlockouttime::timestamp_tz            as account_lockout_time
    , u.lastlogon::timestamp_ntz                    as last_logon_at
    , u.enabled::int                                as is_enabled
    , u.deleted::int                                as is_deleted
    , u.company::text                               as company
    , u.office::text                                as office
    , u.division::text                              as division
    , u.department::text                            as department
    , u.title::text                                 as title
    , u.userprincipalname::text                     as email
    , u.ssosmtp::text                               as sso_smtp
    , u.officephone::text                           as office_phone
    , u.whenchanged::timestamp_tz                   as modified_at
    , u.mobilephone::text                           as mobile_phone
    , u.streetaddress::text                         as street_address
    , u.primarygroup::text                          as primary_group
    , u.primarygroupid::int                         as primary_group_id
    , u.organization::text                          as organization
    , u.passwordexpired::int                        as password_expired
    , u.badpwdcount::int                            as bad_pwd_count
    , u.badpasswordtime::timestamp_ntz              as bad_password_time
    , u.lastbadpasswordattempt::timestamp_tz        as last_bad_password_attempt_at
    , u.passwordlastset::timestamp_tz               as password_last_set_at
    , u.msexchwhenmailboxcreated::timestamp_tz      as msexchange_mailbox_created_at
    , u.iscriticalsystemobject::int                 as is_critical_system_object
    , u.memberof::variant                           as member_of
    , u.samaccountname::text                        as sam_account_name
    , u.samaccounttype::text                        as sam_account_type
    , u.physicaldeliveryofficename::text            as physical_delivery_office_name
    , u.city::text                                  as city
    , u.state::text                                 as state
    , u.postalcode::text                            as postal_code
    , u.othermobile::variant[0]::text               as other_mobile
    , try_to_date(u.dateofstart)                    as date_of_start
    , u.dateofbirth::text                           as date_of_birth
    , u.admindescription::text                      as admin_description
    , m.employeenumber::text                        as manager_employeenumber
    , m.emailaddress::text                          as manager_email
    , m.samaccountname::text                        as manager_samaccountname
    , m.distinguishedname::text                     as manager_distinguishedname

    , u._effective_at                               as _effective_at
    , u._created_at                                 as _created_at
    , u._source_file                                as _source_file
from {{ ref('active_directory__stg_users') }} u
left join {{ ref('active_directory__stg_users') }} m
    on u._effective_at = m._effective_at
    and u.manager = m.distinguishedname
where 1 = 1
    {{ incremental_date_filter(
        source_col_name='u._effective_at',
        target_col_name='_effective_at',
        do_lookback = false,
        do_new = false

    ) }}
qualify row_number() over (
        partition by u._effective_at::date , u.distinguishedname order by u._created_at desc
    ) = 1

union all

select
    system_name::text                      as system_name
    , system_instance::text                as system_instance
    , system_key::text                     as system_key
    , firm_source::text                    as firm_source
    , distinguishedname::text              as distinguished_name
    , name::text                           as name
    , canonicalname::text                  as canonical_name
    , null::text(200)                      as employee_number
    , null::text(200)                      as employee_id
    , null::text(200)                      as manager
    , cn::text                             as cn
    , null::text(200)                      as sn
    , displayname::text                    as display_name
    , null::text(200)                      as given_name
    , description                          as description
    , objectclass::text                    as object_class
    , instancetype::int                    as instance_type
    , null::int                            as admin_count
    , lockedout::int                       as is_locked_out
    , accountlockouttime::timestamp_tz     as account_lockout_time
    , lastlogon::timestamp_ntz             as last_logon_at
    , enabled::int                         as is_enabled
    , deleted::int                         as is_deleted
    , null::text(200)                      as company
    , null::text(200)                      as office
    , null::text(200)                      as division
    , null::text(200)                      as department
    , null::text(200)                      as title
    , userprincipalname                    as email
    , null::text(200)                      as sso_smtp
    , null::text(200)                      as office_phone
    , whenchanged::timestamp_tz            as modified_at
    , null::text(200)                      as mobile_phone
    , null::text(200)                      as street_address
    , primarygroup::text                   as primary_group
    , primarygroupid::int                  as primary_group_id
    , null::text(200)                      as organization
    , passwordexpired::int                 as password_expired
    , badpwdcount::int                     as bad_pwd_count
    , badpasswordtime::timestamp_ntz       as bad_password_time
    , lastbadpasswordattempt::timestamp_tz as last_bad_password_attempt_at
    , passwordlastset::timestamp_tz        as password_last_set_at
    , null::timestamp_tz                   as msexchange_mailbox_created_at
    , iscriticalsystemobject::int          as is_critical_system_object
    , memberof::variant                    as member_of
    , samaccountname::text                 as sam_account_name
    , samaccounttype::text                 as sam_account_type
    , null::text(200)                      as physical_delivery_office_name
    , null::text(200)                      as city
    , null::text(200)                      as state
    , null::text(200)                      as postal_code
    , othermobile::variant[0]::text        as other_mobile
    , null::date                           as date_of_start
    , null::text                           as date_of_birth
    , admindescription::text               as admin_description
    , null::text                           as manager_employeenumber
    , null::text                           as manager_email
    , null::text                           as manager_samaccountname
    , null::text                           as manager_distinguishedname

    , _effective_at                        as _effective_at
    , _created_at                          as _created_at
    , _source_file                         as _source_file
from {{ ref('active_directory__stg_service_accounts') }}
where 1 = 1
    {{ incremental_date_filter(
        source_col_name='_effective_at',
        target_col_name='_effective_at',
        do_lookback = false,
        do_new = false

    ) }}
qualify row_number() over (
        partition by _effective_at::date , distinguishedname order by _created_at desc
    ) = 1

union all

select
    system_name::text                      as system_name
    , system_instance::text                as system_instance
    , system_key::text                     as system_key
    , firm_source::text                    as firm_source
    , distinguishedname::text              as distinguished_name
    , name::text                           as name
    , canonicalname::text                  as canonical_name
    , null::text(200)                      as employee_number
    , null::text(200)                      as employee_id
    , null::text(200)                      as manager
    , cn::text                             as cn
    , null::text(200)                      as sn
    , displayname::text                    as display_name
    , null::text(200)                      as given_name
    , description                          as description
    , objectclass::text                    as object_class
    , instancetype::int                    as instance_type
    , null::int                            as admin_count
    , lockedout::int                       as is_locked_out
    , accountlockouttime::timestamp_tz     as account_lockout_time
    , lastlogon::timestamp_ntz             as last_logon_at
    , enabled::int                         as is_enabled
    , deleted::int                         as is_deleted
    , null::text(200)                      as company
    , null::text(200)                      as office
    , null::text(200)                      as division
    , null::text(200)                      as department
    , null::text(200)                      as title
    , userprincipalname                    as email
    , null::text(200)                      as sso_smtp
    , null::text(200)                      as office_phone
    , whenchanged::timestamp_tz            as modified_at
    , null::text(200)                      as mobile_phone
    , null::text(200)                      as street_address
    , primarygroup::text                   as primary_group
    , primarygroupid::int                  as primary_group_id
    , null::text(200)                      as organization
    , passwordexpired::int                 as password_expired
    , badpwdcount::int                     as bad_pwd_count
    , badpasswordtime::timestamp_ntz       as bad_password_time
    , lastbadpasswordattempt::timestamp_tz as last_bad_password_attempt_at
    , passwordlastset::timestamp_tz        as password_last_set_at
    , null::timestamp_tz                   as msexchange_mailbox_created_at
    , iscriticalsystemobject::int          as is_critical_system_object
    , memberof::variant                    as member_of
    , samaccountname::text                 as sam_account_name
    , samaccounttype::text                 as sam_account_type
    , null::text(200)                      as physical_delivery_office_name
    , null::text(200)                      as city
    , null::text(200)                      as state
    , null::text(200)                      as postal_code
    , othermobile::variant[0]::text        as other_mobile
    , null::date                           as date_of_start
    , null::text                           as date_of_birth
    , admindescription::text               as admin_description
    , null::text                           as manager_employeenumber
    , null::text                           as manager_email
    , null::text                           as manager_samaccountname
    , null::text                           as manager_distinguishedname

    , _effective_at          as _effective_at
    , _created_at            as _created_at
    , _source_file           as _source_file
from {{ ref('active_directory__stg_computers') }}
where 1 = 1
    {{ incremental_date_filter(
        source_col_name='_effective_at',
        target_col_name='_effective_at',
        do_lookback = false,
        do_new = false
    ) }}
qualify row_number() over (
        partition by _effective_at::date , distinguishedname order by _created_at desc
    ) = 1
