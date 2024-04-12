select
    'active_directory'                                                                          as system_name
    , 'mwa'                                                                                     as system_instance
    , concat(system_name , '__' , system_instance)                                              as system_key
    , 'mwa'                                                                                     as firm_source
    , _data:"LastLogonDate"::timestamp_tz                                                       as lastlogondate
    , _data:"userAccountControl"::int                                                           as useraccountcontrol
    , _data:"Certificates"::variant                                                             as certificates
    , _data:"OperatingSystem"::text(500)                                                        as operatingsystem
    , _data:"whenCreated"::timestamp_tz                                                         as whencreated
    , _data:"IPv4Address"::text(500)                                                            as ipv4address
    , _data:"SamAccountName"::text(500)                                                         as samaccountname
    , _data:"DoesNotRequirePreAuth"::boolean::int                                               as doesnotrequirepreauth
    , _data:"PrimaryGroup"::text(500)                                                           as primarygroup
    , _data:"sAMAccountType"::int                                                               as samaccounttype
    , to_timestamp_ntz((_data:"lastLogon"::integer - 116444736000000000) / 10000000.0)          as lastlogon
    , _data:"ObjectCategory"::text(500)                                                         as objectcategory
    , _data:"MemberOf"::variant                                                                 as memberof
    , _data:"localPolicyFlags"::int                                                             as localpolicyflags
    , _data:"rIDSetReferences"::variant                                                         as ridsetreferences
    , _data:"UseDESKeyOnly"::boolean::int                                                       as usedeskeyonly
    , _data:"LastBadPasswordAttempt"::timestamp_tz                                              as lastbadpasswordattempt
    , _data:"instanceType"::int                                                                 as instancetype
    , _data:"accountExpires"::int                                                               as accountexpires
    , _data:"LockedOut"::boolean::int                                                           as lockedout
    , _data:"ObjectClass"::text(500)                                                            as objectclass
    , _data:"Deleted"::text(500)                                                                as deleted
    , _data:"uSNCreated"::integer                                                               as usncreated
    , _data:"DistinguishedName"::text(500)                                                      as distinguishedname
    , _data:"TrustedForDelegation"::boolean::int                                                as trustedfordelegation
    , _data:"serverReferenceBL"::variant                                                        as serverreferencebl
    , _data:"AccountLockoutTime"::timestamp_tz                                                  as accountlockouttime
    , _data:"DNSHostName"::text(500)                                                            as dnshostname
    , _data:"CN"::text(500)                                                                     as cn
    , _data:"AuthenticationPolicySilo"::variant                                                 as authenticationpolicysilo
    , to_timestamp_ntz((_data:"badPasswordTime"::integer - 116444736000000000) / 10000000.0)    as badpasswordtime
    , _data:"AccountExpirationDate"::timestamp_tz                                               as accountexpirationdate
    , _data:"PasswordExpired"::boolean::int                                                     as passwordexpired
    , _data:"Name"::text(500)                                                                   as name
    , _data:"MNSLogonAccount"::boolean::int                                                     as mnslogonaccount
    , _data:"CannotChangePassword"::boolean::int                                                as cannotchangepassword
    , _data:"KerberosEncryptionType"::variant                                                   as kerberosencryptiontype
    , _data:"UserPrincipalName"::text(500)                                                      as userprincipalname
    , _data:"PrincipalsAllowedToDelegateToAccount"::variant
        as principalsallowedtodelegatetoaccount
    , _data:"createTimeStamp"::timestamp_tz                                                     as createtimestamp
    , _data:"OperatingSystemHotfix"::text(500)                                                  as operatingsystemhotfix
    , _data:"AuthenticationPolicy"::variant                                                     as authenticationpolicy
    , _data:"PasswordLastSet"::timestamp_tz                                                     as passwordlastset
    , _data:"ManagedBy"::text(500)                                                              as managedby
    , to_timestamp_ntz((_data:"lastLogoff"::integer - 116444736000000000) / 10000000.0)         as lastlogoff
    , _data:"uSNChanged"::int                                                                   as usnchanged
    , _data:"SIDHistory"::variant                                                               as sidhistory
    , _data:"Enabled"::boolean::int                                                             as enabled
    , _data:"ServicePrincipalNames"::variant                                                    as serviceprincipalnames
    , _data:"OperatingSystemServicePack"::text(500)                                             as operatingsystemservicepack
    , _data:"badPwdCount"::int                                                                  as badpwdcount
    , _data:"ProtectedFromAccidentalDeletion"::boolean::int
        as protectedfromaccidentaldeletion
    , _data:"AllowReversiblePasswordEncryption"::boolean::int
        as allowreversiblepasswordencryption
    , _data:"dSCorePropagationData"::variant                                                    as dscorepropagationdata
    , _data:"PasswordNeverExpires"::boolean::int                                                as passwordneverexpires
    , _data:"BadLogonCount"::int                                                                as badlogoncount
    , _data:"servicePrincipalName"::variant                                                     as serviceprincipalname
    , _data:"Modified"::timestamp_tz                                                            as modified
    , _data:"countryCode"::int                                                                  as countrycode
    , _data:"sDRightsEffective"::int                                                            as sdrightseffective
    , to_timestamp_ntz((_data:"lastLogonTimestamp"::integer - 116444736000000000) / 10000000.0) as lastlogontimestamp
    , _data:"HomedirRequired"::boolean::int                                                     as homedirrequired
    , to_timestamp_ntz((_data:"pwdLastSet"::integer - 116444736000000000) / 10000000.0)         as pwdlastset
    , _data:"CanonicalName"::text(500)                                                          as canonicalname
    , _data:"LastKnownParent"::text(500)                                                        as lastknownparent
    , _data:"PasswordNotRequired"::boolean::int                                                 as passwordnotrequired
    , _data:"modifyTimeStamp"::timestamp_tz                                                     as modifytimestamp
    , _data:"isDeleted"::int                                                                    as isdeleted
    , _data:"DisplayName"::text(500)                                                            as displayname
    , _data:"frsComputerReferenceBL"::variant                                                   as frscomputerreferencebl
    , _data:"TrustedToAuthForDelegation"::boolean::int                                          as trustedtoauthfordelegation
    , _data:"Created"::timestamp_tz                                                             as created
    , _data:"HomePage"::text(500)                                                               as homepage
    , _data:"Location"::text(500)                                                               as location
    , _data:"isCriticalSystemObject"::boolean::int                                              as iscriticalsystemobject
    , _data:"ServiceAccount"::variant                                                           as serviceaccount
    , _data:"logonCount"::int                                                                   as logoncount
    , _data:"userCertificate"::variant                                                          as usercertificate
    , _data:"primaryGroupID"::int                                                               as primarygroupid
    , _data:"IPv6Address"::text(500)                                                            as ipv6address
    , _data:"whenChanged"::timestamp_tz                                                         as whenchanged
    , _data:"Description"::text(500)                                                            as description
    , _data:"OperatingSystemVersion"::text(500)                                                 as operatingsystemversion
    , _data:"ObjectGUID"::text(500)                                                             as objectguid
    , _data:"AccountNotDelegated"::boolean::int                                                 as accountnotdelegated
    , _data:"codePage"::int                                                                     as codepage
    , _data:"CompoundIdentitySupported"::variant                                                as compoundidentitysupported

    , {{ col_is_head(
      reference=source('active_directory', 'computers'),
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
from {{ source('active_directory', 'computers') }}
