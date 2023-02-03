select
    id
  , dn                           as group_id
  , rdn
  , basedn
  , grouptype
  , instancetype::int as instancetype
  , ntsecuritydescriptor
  , objectcategory
  , objectclass
  , samaccountname
  , accountnamehistory
  , admincount::int              as admincount
  , admindescription
  , admindisplayname
  , allowedattributes
  , allowedattributeseffective
  , allowedchildclasses
  , allowedchildclasseseffective
  , altsecurityidentities
  , bridgeheadserverlistbl
  , canonicalname
  , info
  , cn
  , controlaccessrights
  , createtimestamp::timestamp   as createtimestamp
  , description
  , desktopprofile
  , displayname
  , displaynameprintable
  , dsasignature
  , dscorepropagationdata
  , mail
  , extensionname
  , flags
  , fromentry
  , frscomputerreferencebl
  , frsmemberreferencebl
  , fsmoroleowner
  , garbagecollperiod
  , groupattributes
  , groupmembershipsam
  , iscriticalsystemobject
  , isdeleted
  , isprivilegeholder
  , lastknownparent
  , legacyexchangedn
  , managedby
  , managedobjects
  , masteredby
  , member
  , modifytimestamp::timestamp   as modifytimestamp
  , "MS-DS-CONSISTENCYCHILDCOUNT" as ms_ds_consistency_child_count
  , "MS-DS-CONSISTENCYGUID" as ms_ds_consistency_guid
  , netbootscpbl
  , nonsecuritymember
  , nonsecuritymemberbl
  , ntgroupmembers
  , distinguishedname
  , objectguid
  , objectsid
  , objectversion
  , operatorcount
  , otherwellknownobjects
  , partialattributedeletionlist
  , partialattributeset
  , possibleinferiors
  , primarygrouptoken            as group_token
  , proxiedobjectname
  , proxyaddresses
  , querypolicybl
  , name                         as group_name
  , repluptodatevector
  , directreports
  , repsfrom
  , repsto
  , revision
  , rid
  , samaccounttype
  , sdrightseffective
  , securityidentifier
  , serverreferencebl
  , showinaddressbook
  , showinadvancedviewonly
  , sidhistory
  , siteobjectbl
  , subrefs
  , subschemasubentry
  , supplementalcredentials
  , systemflags
  , telephonenumber
  , textencodedoraddress
  , usercert
  , usersmimecertificate
  , usnchanged
  , usncreated
  , usndsalastobjremoved
  , usnintersite
  , usnlastobjrem
  , usnsource
  , wbempath
  , wellknownobjects
  , whenchanged::timestamp       as whenchanged
  , whencreated::timestamp       as whencreated
  , wwwhomepage
  , url
  , usercertificate
  , record_datetime::timestamp   as record_datetime
  , record_date::date            as record_date
  , case
        when record_datetime::timestamp =
             (select max(record_datetime::timestamp) from {{ source('active_directory', 'groups_history') }})
            then 1
        else 0 end               as is_current
from {{ source('active_directory', 'groups_history') }}
