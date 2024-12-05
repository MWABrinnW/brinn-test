select
    'active_directory'::text(200)                                                               as system_name
    , 'mwa'::text(200)                                                                          as system_instance
    , concat(system_name , '__' , system_instance)                                              as system_key
    , 'mwa'::text(200)                                                                          as firm_source
    , _data:"AccountExpirationDate"::int                                                        as accountexpirationdate
    , _data:"AccountLockoutTime"::timestamp_tz                                                  as accountlockouttime
    , _data:"AccountNotDelegated"::boolean::int                                                 as accountnotdelegated
    , _data:"AllowReversiblePasswordEncryption"::boolean::int
        as allowreversiblepasswordencryption
    , _data:"AuthenticationPolicySilo"::variant                                                 as authenticationpolicysilo
    , _data:"BadLogonCount"::int                                                                as badlogoncount
    , _data:"CN"::text(500)                                                                     as cn
    , _data:"CannotChangePassword"::boolean::int                                                as cannotchangepassword
    , _data:"Certificates"::variant                                                             as certificates
    , _data:"CompoundIdentitySupported"::variant                                                as compoundidentitysupported
    , _data:"Count"::variant                                                                    as count
    , _data:"Created"::timestamp_tz                                                             as created
    , _data:"DNSHostName"::text(500)                                                            as dnshostname
    , _data:"Deleted"::text(500)                                                                as deleted
    , _data:"Description"::text(500)                                                            as description
    , _data:"DistinguishedName"::text(500)                                                      as distinguishedname
    , _data:"HostComputers"::variant                                                            as hostcomputers
    , _data:"LastKnownParent"::text(500)                                                        as lastknownparent
    , _data:"LockedOut"::boolean::int                                                           as lockedout
    , _data:"MemberOf"::variant                                                                 as memberof
    , _data:"Name"::text(500)                                                                   as name
    , _data:"ObjectCategory"::text(500)                                                         as objectcategory
    , _data:"ObjectClass"::text(500)                                                            as objectclass
    , _data:"ObjectGUID"::text(500)                                                             as objectguid
    , _data:"PasswordLastSet"::timestamp_tz                                                     as passwordlastset
    , _data:"PasswordNeverExpires"::boolean::int                                                as passwordneverexpires
    , _data:"PasswordNotRequired"::boolean::int                                                 as passwordnotrequired
    , _data:"PrimaryGroup"::text(500)                                                           as primarygroup
    , _data:"PrincipalsAllowedToDelegateToAccount"::variant
        as principalsallowedtodelegatetoaccount
    , _data:"PrincipalsAllowedToRetrieveManagedPassword"::variant
        as principalsallowedtoretrievemanagedpassword
    , _data:"badPwdCount"::int                                                                  as badpwdcount
    , _data:"isCriticalSystemObject"::boolean::int                                              as iscriticalsystemobject
    , to_timestamp_ntz((_data:"lastLogonTimestamp"::integer - 116444736000000000) / 10000000.0) as lastlogontimestamp
    , _data:"modifyTimeStamp"::timestamp_tz                                                     as modifytimestamp
    , _data:"sDRightsEffective"::int                                                            as sdrightseffective
    , _data:"HomedirRequired"::boolean::int                                                     as homedirrequired
    , _data:"MNSLogonAccount"::boolean::int                                                     as mnslogonaccount
    , _data:"ServicePrincipalNames"::text(500)                                                  as serviceprincipalnames
    , _data:"TrustedToAuthForDelegation"::boolean::int                                          as trustedtoauthfordelegation
    , to_timestamp_ntz((_data:"badPasswordTime"::integer - 116444736000000000) / 10000000.0)    as badpasswordtime
    , _data:"dSCorePropagationData"::variant                                                    as dscorepropagationdata
    , _data:"sAMAccountType"::int                                                               as samaccounttype
    , _data:"whenChanged"::timestamp_tz                                                         as whenchanged
    , _data:"whenCreated"::timestamp_tz                                                         as whencreated
    , _data:"UseDESKeyOnly"::boolean::int                                                       as usedeskeyonly
    , _data:"codePage"::int                                                                     as codepage
    , _data:"LastBadPasswordAttempt"::timestamp_tz                                              as lastbadpasswordattempt
    , _data:"primaryGroupID"::int                                                               as primarygroupid
    , _data:"CanonicalName"::text(500)                                                          as canonicalname
    , _data:"Enabled"::boolean::int                                                             as enabled
    , _data:"HomePage"::text(500)                                                               as homepage
    , _data:"KerberosEncryptionType"::variant                                                   as kerberosencryptiontype
    , _data:"LastLogonDate"::timestamp_tz                                                       as lastlogondate
    , _data:"SamAccountName"::text(500)                                                         as samaccountname
    , _data:"TrustedForDelegation"::boolean::int                                                as trustedfordelegation
    , _data:"countryCode"::int                                                                  as countrycode
    , to_timestamp_ntz((_data:"pwdLastSet"::integer - 116444736000000000) / 10000000.0)         as pwdlastset
    , _data:"uSNChanged"::int                                                                   as usnchanged
    , _data:"userCertificate"::variant                                                          as usercertificate
    , _data:"AuthenticationPolicy"::variant                                                     as authenticationpolicy
    , _data:"DisplayName"::text(500)                                                            as displayname
    , _data:"DoesNotRequirePreAuth"::boolean::int                                               as doesnotrequirepreauth
    , _data:"ManagedPasswordIntervalInDays"::variant                                            as managedpasswordintervalindays
    , _data:"Modified"::timestamp_tz                                                            as modified
    , _data:"ProtectedFromAccidentalDeletion"::boolean::int
        as protectedfromaccidentaldeletion
    , _data:"SIDHistory"::variant                                                               as sidhistory
    , _data:"UserPrincipalName"::text(500)                                                      as userprincipalname
    , _data:"lastLogoff"::timestamp_tz                                                          as lastlogoff
    , to_timestamp_ntz((_data:"lastLogon"::integer - 116444736000000000) / 10000000.0)          as lastlogon
    , _data:"localPolicyFlags"::int                                                             as localpolicyflags
    , _data:"uSNCreated"::int                                                                   as usncreated
    , _data:"userAccountControl"::int                                                           as useraccountcontrol
    , _data:"logonCount"::int                                                                   as logoncount
    , _data:"PasswordExpired"::boolean::int                                                     as passwordexpired
    , _data:"createTimeStamp"::timestamp_tz                                                     as createtimestamp
    , _data:"accountExpires"::int                                                               as accountexpires
    , _data:"isDeleted"::int                                                                    as isdeleted
    , _data:"instanceType"::int                                                                 as instancetype

    , _data:"otherMobile"::variant                                                              as othermobile
    , _data:"dateOfStart"::text(200)                                                            as dateofstart
    , _data:"dateOfBirth"::text(200)                                                            as dateofbirth
    , _data:"AdminDescription"::text(200)                                                       as admindescription

    , {{ col_is_head(
      reference=source('active_directory', 'serviceaccounts'),
      reference_date_col='_created_at',
      source_date_col='_created_at'
      ) }}

    , _data::variant                                                                            as _data
    , _created_at                                                                               as _created_at
    , _effective_at                                                                             as _effective_at
    , _source_file                                                                              as _source_file
from {{ source('active_directory', 'serviceaccounts') }}
