select
    'active_directory'::text(200)                                                               as system_name
    , 'mwa'::text(200)                                                                          as system_instance
    , concat(system_name , '__' , system_instance)                                              as system_key
    , 'mwa'::text(200)                                                                          as firm_source
    , _data:"instanceType"::int                                                                 as instancetype
    , _data:"ObjectClass"::text(500)                                                            as objectclass
    , _data:"adminCount"::int                                                                   as admincount
    , _data:"Office"::text(500)                                                                 as office
    , _data:"AccountLockoutTime"::timestamp_tz                                                  as accountlockouttime
    , _data:"AuthenticationPolicySilo"::variant                                                 as authenticationpolicysilo
    , _data:"Fax"::text(500)                                                                    as fax
    , to_timestamp_ntz((_data:"badPasswordTime"::integer - 116444736000000000) / 10000000.0)    as badpasswordtime
    , _data:"AccountExpirationDate"::timestamp_tz                                               as accountexpirationdate
    , _data:"ssoSMTP"::text(500)                                                                as ssosmtp
    , _data:"ScriptPath"::text(500)                                                             as scriptpath
    , _data:"MNSLogonAccount"::boolean::int                                                     as mnslogonaccount
    , _data:"State"::text(500)                                                                  as state
    , to_timestamp_ntz((_data:"accountExpires"::integer - 116444736000000000) / 10000000.0)     as accountexpires
    , _data:"LockedOut"::boolean::int                                                           as lockedout
    , _data:"Deleted"::text(500)                                                                as deleted
    , _data:"uSNCreated"::int                                                                   as usncreated
    , _data:"DistinguishedName"::text(500)                                                      as distinguishedname
    , _data:"msExchWhenMailboxCreated"::timestamp_tz                                            as msexchwhenmailboxcreated
    , _data:"TrustedForDelegation"::boolean::int                                                as trustedfordelegation
    , _data:"Manager"::text(500)                                                                as manager
    , _data:"CN"::text(500)                                                                     as cn
    , _data:"physicalDeliveryOfficeName"::text(500)                                             as physicaldeliveryofficename
    , _data:"HomeDrive"::text(500)                                                              as homedrive
    , to_timestamp_ntz((_data:"lockoutTime"::integer - 116444736000000000) / 10000000.0)        as lockouttime
    , _data:"PasswordExpired"::boolean::int                                                     as passwordexpired
    , _data:"Name"::text(500)                                                                   as name
    , _data:"HomeDirectory"::text(500)                                                          as homedirectory
    , _data:"logonHours"::variant                                                               as logonhours
    , _data:"Company"::text(500)                                                                as company
    , _data:"CannotChangePassword"::boolean::int                                                as cannotchangepassword
    , _data:"UserPrincipalName"::text(500)                                                      as userprincipalname
    , _data:"createTimeStamp"::timestamp_tz                                                     as createtimestamp
    , _data:"GivenName"::text(500)                                                              as givenname
    , _data:"EmailAddress"::text(500)                                                           as emailaddress
    , _data:"msTSLicenseVersion"::text(500)                                                     as mstslicenseversion
    , _data:"uSNChanged"::int                                                                   as usnchanged
    , _data:"msExchRecipientSoftDeletedStatus"::int
        as msexchrecipientsoftdeletedstatus
    , _data:"msTSLicenseVersion2"::text(500)                                                    as mstslicenseversion2
    , _data:"ServicePrincipalNames"::variant                                                    as serviceprincipalnames
    , _data:"HomePhone"::text(500)                                                              as homephone
    , _data:"msTSLicenseVersion3"::text(500)                                                    as mstslicenseversion3
    , _data:"badPwdCount"::int                                                                  as badpwdcount
    , _data:"City"::text(500)                                                                   as city
    , _data:"AllowReversiblePasswordEncryption"::boolean::int
        as allowreversiblepasswordencryption
    , _data:"PasswordNeverExpires"::boolean::int                                                as passwordneverexpires
    , _data:"countryCode"::text(500)                                                            as countrycode
    , _data:"sDRightsEffective"::int                                                            as sdrightseffective
    , _data:"Title"::text(500)                                                                  as title
    , _data:"KerberosEncryptionType"::variant                                                   as kerberosencryptiontype
    , _data:"PrincipalsAllowedToDelegateToAccount"::variant
        as principalsallowedtodelegatetoaccount
    , _data:"LogonWorkstations"::text(500)                                                      as logonworkstations
    , _data:"AuthenticationPolicy"::variant                                                     as authenticationpolicy
    , _data:"PasswordLastSet"::timestamp_tz                                                     as passwordlastset
    , to_timestamp_ntz((_data:"lastLogoff"::integer - 116444736000000000) / 10000000.0)         as lastlogoff
    , _data:"SIDHistory"::variant                                                               as sidhistory
    , _data:"Enabled"::boolean::int                                                             as enabled
    , _data:"msTSManagingLS"::text(500)                                                         as mstsmanagingls
    , _data:"ProtectedFromAccidentalDeletion"::boolean::int
        as protectedfromaccidentaldeletion
    , _data:"dSCorePropagationData"::variant                                                    as dscorepropagationdata
    , _data:"BadLogonCount"::int                                                                as badlogoncount
    , _data:"Modified"::timestamp_tz                                                            as modified
    , to_timestamp_ntz((_data:"lastLogonTimestamp"::integer - 116444736000000000) / 10000000.0) as lastlogontimestamp
    , _data:"HomedirRequired"::boolean::int                                                     as homedirrequired
    , to_timestamp_ntz((_data:"pwdLastSet"::integer - 116444736000000000) / 10000000.0)         as pwdlastset
    , _data:"CanonicalName"::text(500)                                                          as canonicalname
    , _data:"LastKnownParent"::text(500)                                                        as lastknownparent
    , _data:"modifyTimeStamp"::timestamp_tz                                                     as modifytimestamp
    , _data:"isDeleted"::int                                                                    as isdeleted
    , _data:"msExchPreviousRecipientTypeDetails"::int
        as msexchpreviousrecipienttypedetails
    , _data:"OtherName"::text(500)                                                              as othername
    , _data:"sn"::text(500)                                                                     as sn
    , _data:"managedObjects"::variant                                                           as managedobjects
    , _data:"Department"::text(500)                                                             as department
    , _data:"MobilePhone"::text(500)                                                            as mobilephone
    , _data:"Initials"::text(500)                                                               as initials
    , _data:"Surname"::text(500)                                                                as surname
    , _data:"userCertificate"::variant                                                          as usercertificate
    , _data:"msExchUMDtmfMap"::variant                                                          as msexchumdtmfmap
    , _data:"whenChanged"::timestamp_tz                                                         as whenchanged
    , _data:"ObjectGUID"::text(500)                                                             as objectguid
    , _data:"PostalCode"::text(500)                                                             as postalcode
    , _data:"CompoundIdentitySupported"::variant                                                as compoundidentitysupported
    , _data:"LastLogonDate"::timestamp_tz                                                       as lastlogondate
    , _data:"whenCreated"::timestamp_tz                                                         as whencreated
    , _data:"SamAccountName"::text(500)                                                         as samaccountname
    , _data:"PrimaryGroup"::text(500)                                                           as primarygroup
    , _data:"sAMAccountType"::int                                                               as samaccounttype
    , to_timestamp_ntz((_data:"lastLogon"::integer - 116444736000000000) / 10000000.0)          as lastlogon
    , _data:"MemberOf"::variant                                                                 as memberof
    , _data:"LastBadPasswordAttempt"::timestamp_tz                                              as lastbadpasswordattempt
    , _data:"ProfilePath"::text(500)                                                            as profilepath
    , _data:"userAccountControl"::int                                                           as useraccountcontrol
    , _data:"SmartcardLogonRequired"::boolean::int                                              as smartcardlogonrequired
    , _data:"Certificates"::variant                                                             as certificates
    , _data:"POBox"::text(500)                                                                  as pobox
    , _data:"msExchALObjectVersion"::int                                                        as msexchalobjectversion
    , _data:"msExchDelegateListBL"::variant                                                     as msexchdelegatelistbl
    , _data:"DoesNotRequirePreAuth"::boolean::int                                               as doesnotrequirepreauth
    , _data:"EmployeeNumber"::text(500)                                                         as employeenumber
    , _data:"OfficePhone"::text(500)                                                            as officephone
    , _data:"ObjectCategory"::text(500)                                                         as objectcategory
    , _data:"protocolSettings"::variant                                                         as protocolsettings
    , _data:"UseDESKeyOnly"::boolean::int                                                       as usedeskeyonly
    , _data:"msExchCoManagedObjectsBL"::variant                                                 as msexchcomanagedobjectsbl
    , _data:"msTSExpireDate"::timestamp_tz                                                      as mstsexpiredate
    , _data:"PasswordNotRequired"::boolean::int                                                 as passwordnotrequired
    , _data:"DisplayName"::text(500)                                                            as displayname
    , _data:"TrustedToAuthForDelegation"::boolean::int                                          as trustedtoauthfordelegation
    , _data:"Created"::timestamp_tz                                                             as created
    , _data:"HomePage"::text(500)                                                               as homepage
    , _data:"EmployeeID"::text(500)                                                             as employeeid
    , _data:"Division"::text(500)                                                               as division
    , _data:"StreetAddress"::text(500)                                                          as streetaddress
    , _data:"isCriticalSystemObject"::boolean::int                                              as iscriticalsystemobject
    , _data:"logonCount"::int                                                                   as logoncount
    , _data:"Country"::text(500)                                                                as country
    , _data:"primaryGroupID"::int                                                               as primarygroupid
    , _data:"Organization"::text(500)                                                           as organization
    , _data:"Description"::text(500)                                                            as description
    , _data:"AccountNotDelegated"::boolean::int                                                 as accountnotdelegated
    , _data:"codePage"::int                                                                     as codepage

    , _data:"otherMobile"::variant                                                              as othermobile
    , _data:"dateOfStart"::text(200)                                                            as dateofstart
    , _data:"dateOfBirth"::text(200)                                                            as dateofbirth
    , _data:"AdminDescription"::text(200)                                                       as admindescription

    , {{ col_is_head(
      reference=source('active_directory', 'users'),
      reference_date_col='_created_at',
      source_date_col='_created_at'
      ) }}
    , row_number() over (
        partition by _effective_at::date , distinguishedname order by _created_at desc
    )                                                                                           as rn_day

    , _data::variant                                                                            as _data
    , _created_at                                                                               as _created_at
    , _effective_at                                                                             as _effective_at
    , _source_file                                                                              as _source_file
from {{ source('active_directory', 'users') }}
