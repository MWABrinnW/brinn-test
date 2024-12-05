{{ config(
    materialized = 'incremental',
    unique_key='system_key',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_rnk as (
    select
        record_datetime::date as record_date
        , record_datetime
        , dense_rank() over (
            partition by record_datetime::date order by record_datetime desc
        )                     as rn_day
    from {{ source('active_directory_mwa', 'groups_history') }}
    group by 1 , 2
)

select
    'active_directory'::text(200)                  as system_name
    , 'mwa'::text(200)                             as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'::text(200)                             as firm_source
    --, id
    , dn                                           as group_id
    , rdn
    , basedn
    , grouptype
    , instancetype::int                            as instancetype
    , ntsecuritydescriptor
    , objectcategory
    , objectclass
    , samaccountname
    , accountnamehistory
    , admincount::int                              as admincount
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
    , createtimestamp::timestamp                   as createtimestamp
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
    --, member
    , modifytimestamp::timestamp                   as modifytimestamp
    , "MS-DS-CONSISTENCYCHILDCOUNT"                as ms_ds_consistency_child_count
    , "MS-DS-CONSISTENCYGUID"                      as ms_ds_consistency_guid
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
    , primarygrouptoken                            as group_token
    , proxiedobjectname
    , proxyaddresses
    , querypolicybl
    , name                                         as group_name
    , repluptodatevector
    , directreports
    , repsfrom
    , repsto
    , revision
    , rid
    , samaccounttype::int                          as samaccounttype
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
    , whenchanged::timestamp                       as whenchanged
    , whencreated::timestamp                       as whencreated
    , wwwhomepage
    , url
    , usercertificate
    , g.record_datetime::timestamp                 as _created_at
    , g.record_date::date                          as record_date
    , {{ col_is_head(
      reference=source('active_directory_mwa', 'groups_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='g.record_datetime::timestamp'
      ) }}
    , rnk.rn_day                                   as rn_day
from {{ source('active_directory_mwa', 'groups_history') }} as g
inner join cte_rnk as rnk
    on g.record_datetime = rnk.record_datetime
where 1 = 1
{{ incremental_date_filter(
    source_col_name='g.record_datetime',
    target_col_name='_created_at',
    do_lookback = false,
    do_new = false
) }}
group by all
