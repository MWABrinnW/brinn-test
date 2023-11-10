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
  , record_datetime::timestamp   as _created_at
  , record_date::date            as record_date
  , {{ col_is_head(
      reference=source('active_directory_mwa', 'groups_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='record_datetime::timestamp'
      ) }}
from {{ source('active_directory_mwa', 'groups_history') }}
qualify row_number() over(partition by record_date::date, distinguishedname, dn order by whenchanged::timestamp desc, record_datetime::timestamp desc) = 1
