select
    'active_directory'::text(200)                        as system_name
    , 'mwa'::text(200)                                   as system_instance
    , concat(system_name , '__' , system_instance)       as system_key
    , 'mwa'::text(200)                                   as firm_source
    , _data:"instanceType"::int                          as instancetype
    , _data:"ObjectClass"::text(500)                     as objectclass
    , _data:"Deleted"::text(500)                         as deleted
    , _data:"msExchModerationFlags"::int                 as msexchmoderationflags
    , _data:"uSNCreated"::int                            as usncreated
    , _data:"msExchGroupDepartRestriction"::int          as msexchgroupdepartrestriction
    , _data:"DistinguishedName"::text(500)               as distinguishedname
    , _data:"CN"::text(500)                              as cn
    , _data:"Name"::text(500)                            as name
    , _data:"msExchAddressBookFlags"::int                as msexchaddressbookflags
    , _data:"msExchMailboxAuditEnable"::boolean::int     as msexchmailboxauditenable
    , _data:"groupType"::int                             as grouptype
    , _data:"PropertyCount"::int                         as propertycount
    , _data:"whenCreated"::timestamp_tz                  as whencreated
    , _data:"msExchVersion"::int                         as msexchversion
    , _data:"SamAccountName"::text(500)                  as samaccountname
    , _data:"AddedProperties"::variant                   as addedproperties
    , _data:"sAMAccountType"::int                        as samaccounttype
    , _data:"ObjectCategory"::text(500)                  as objectcategory
    , _data:"msExchProvisioningFlags"::int               as msexchprovisioningflags
    , _data:"msExchMailboxAuditLogAgeLimit"::int         as msexchmailboxauditlogagelimit
    , _data:"MemberOf"::variant                          as memberof
    , _data:"Members"::variant                           as members
    , _data:"createTimeStamp"::timestamp_tz              as createtimestamp
    , _data:"ManagedBy"::text(500)                       as managedby
    , _data:"uSNChanged"::int                            as usnchanged
    , _data:"GroupScope"::int                            as groupscope
    , _data:"internetEncoding"::int                      as internetencoding
    , _data:"Modified"::timestamp_tz                     as modified
    , _data:"sDRightsEffective"::int                     as sdrightseffective
    , _data:"RemovedProperties"::variant                 as removedproperties
    , _data:"GroupCategory"::int                         as groupcategory
    , _data:"CanonicalName"::text(500)                   as canonicalname
    , _data:"LastKnownParent"::text(500)                 as lastknownparent
    , _data:"msExchGroupJoinRestriction"::int            as msexchgroupjoinrestriction
    , _data:"modifyTimeStamp"::timestamp_tz              as modifytimestamp
    , _data:"msExchTransportRecipientSettingsFlags"::int as msexchtransportrecipientsettingsflags
    , _data:"ModifiedProperties"::variant                as modifiedproperties
    , _data:"DisplayName"::text(500)                     as displayname
    , _data:"msExchBypassAudit"::boolean::int            as msexchbypassaudit
    , _data:"msExchRoleGroupType"::int                   as msexchrolegrouptype
    , _data:"ObjectGuid"::text(500)                      as objectguid
    , _data:"Created"::timestamp_tz                      as created
    , _data:"PropertyNames"::variant                     as propertynames
    , _data:"msExchRecipientTypeDetails"::int            as msexchrecipienttypedetails
    , _data:"whenChanged"::timestamp_tz                  as whenchanged
    , _data:"Description"::text(500)                     as description

    , {{ col_is_head(
      reference=source('active_directory', 'groups'),
      reference_date_col='_created_at',
      source_date_col='_created_at'
      ) }}
    , row_number() over (
        partition by _effective_at::date , distinguishedname order by _created_at desc
    )                                                    as rn_day

    , _data::variant                                     as _data
    , _created_at                                        as _created_at
    , _effective_at                                      as _effective_at
    , _source_file                                       as _source_file
from {{ source('active_directory', 'groups') }}
