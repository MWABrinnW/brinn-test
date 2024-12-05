{{ config(
    materialized = 'incremental',
    unique_key='system_key',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_rnk as (
    select
        record_datetime::date as record_date
        , record_datetime     as record_datetime
        , dense_rank() over (
            partition by record_datetime::date
            order by record_datetime desc
        )                     as rn_day
    from {{ source('active_directory_mwa', 'user_history') }}
    group by 1 , 2
    order by 1 , 2
)

select
    'active_directory'::text(200)       as system_name
    , 'mwa'::text(200)                  as system_instance
    , concat(
        system_name , '__' , system_instance
    )                                   as system_key
    , 'mwa'::text(200)                  as firm_source
    , u.id                              as id
    , u.dn                              as dn
    , u.rdn                             as rdn
    , u.basedn                          as basedn
    , u.instancetype::int               as instancetype
    , u.ntsecuritydescriptor            as ntsecuritydescriptor
    , u.objectcategory                  as objectcategory
    , u.objectclass                     as objectclass
    , u.samaccountname                  as samaccountname
    , u.accountexpires                  as accountexpires
    , u.accountnamehistory              as accountnamehistory
    , u.acspolicyname                   as acspolicyname
    , u.streetaddress                   as streetaddress
    , u.homepostaladdress               as homepostaladdress
    , u.admincount                      as admincount
    , u.admindescription                as admindescription
    , u.admindisplayname                as admindisplayname
    , u.allowedattributes               as allowedattributes
    , u.allowedattributeseffective      as allowedattributeseffective
    , u.allowedchildclasses             as allowedchildclasses
    , u.allowedchildclasseseffective    as allowedchildclasseseffective
    , u.altsecurityidentities           as altsecurityidentities
    , u.assistant                       as assistant
    , u.badpasswordtime                 as badpasswordtime
    , u.badpwdcount::int                as badpwdcount
    , u.bridgeheadserverlistbl          as bridgeheadserverlistbl
    , u.canonicalname                   as canonicalname
    , u.codepage::int                   as codepage
    , u.info                            as info
    , u.cn                              as cn
    , u.company                         as company
    , u.controlaccessrights             as controlaccessrights
    , u.countrycode                     as countrycode
    , u.c                               as c
    , u.createtimestamp::timestamp      as createtimestamp
    , u.dbcspwd                         as dbcspwd
    , u.defaultclassstore               as defaultclassstore
    , u.department                      as department
    , u.description                     as description
    , u.desktopprofile                  as desktopprofile
    , u.destinationindicator            as destinationindicator
    , u.displayname                     as displayname
    , u.displaynameprintable            as displaynameprintable
    , u.division                        as division
    , u.dsasignature                    as dsasignature
    , u.dscorepropagationdata           as dscorepropagationdata
    , u.dynamicldapserver               as dynamicldapserver
    , u.mail                            as mail
    , u.employeeid                      as employeeid
    , u.employeenumber                  as employeenumber
    , u.employeetype                    as employeetype
    , u.extensionname                   as extensionname
    , u.facsimiletelephonenumber        as facsimiletelephonenumber
    , u.flags                           as flags
    , u.fromentry                       as fromentry
    , u.frscomputerreferencebl          as frscomputerreferencebl
    , u.frsmemberreferencebl            as frsmemberreferencebl
    , u.fsmoroleowner                   as fsmoroleowner
    , u.garbagecollperiod               as garbagecollperiod
    , u.generationqualifier             as generationqualifier
    , u.givenname                       as givenname
    , u.groupmembershipsam              as groupmembershipsam
    , u.grouppriority                   as grouppriority
    , u.groupstoignore                  as groupstoignore
    , u.homedirectory                   as homedirectory
    , u.homedrive                       as homedrive
    , u.initials                        as initials
    , u.internationalisdnnumber         as internationalisdnnumber
    , u.iscriticalsystemobject::boolean as iscriticalsystemobject
    , u.isdeleted::boolean              as isdeleted
    , u.isprivilegeholder::boolean      as isprivilegeholder
    , u.lastknownparent                 as lastknownparent
    , u.lastlogoff                      as lastlogoff
    , u.lastlogon                       as lastlogon
    , u.lmpwdhistory                    as lmpwdhistory
    , u.localeid                        as localeid
    , u.l                               as l
    , u.lockouttime                     as lockouttime
    , u.thumbnaillogo                   as thumbnaillogo
    , u.logoncount                      as logoncount
    , u.logonhours                      as logonhours
    , u.logonworkstation                as logonworkstation
    , u.managedobjects                  as managedobjects
    , u.manager                         as manager
    , u.masteredby                      as masteredby
    , u.maxstorage                      as maxstorage
    , u.mhsoraddress                    as mhsoraddress
    , u.modifytimestamp::timestamp      as modifytimestamp
    , u."MS-DS-CONSISTENCYCHILDCOUNT"   as "MS-DS-CONSISTENCYCHILDCOUNT"--noqa:RF05
    , u."MS-DS-CONSISTENCYGUID"         as "MS-DS-CONSISTENCYGUID"--noqa:RF05
    , u."MS-DS-CREATORSID"              as "MS-DS-CREATORSID"--noqa:RF05
    , u.msmqdigests                     as msmqdigests
    , u.msmqdigestsmig                  as msmqdigestsmig
    , u.msmqsigncertificates            as msmqsigncertificates
    , u.msmqsigncertificatesmig         as msmqsigncertificatesmig
    , u.msnpallowdialin                 as msnpallowdialin
    , u.msnpcallingstationid            as msnpcallingstationid
    , u.msnpsavedcallingstationid       as msnpsavedcallingstationid
    , u.msradiuscallbacknumber          as msradiuscallbacknumber
    , u.msradiusframedipaddress         as msradiusframedipaddress
    , u.msradiusframedroute             as msradiusframedroute
    , u.msradiusservicetype             as msradiusservicetype
    , u.msrassavedcallbacknumber        as msrassavedcallbacknumber
    , u.msrassavedframedipaddress       as msrassavedframedipaddress
    , u.msrassavedframedroute           as msrassavedframedroute
    , u.netbootscpbl                    as netbootscpbl
    , u.networkaddress                  as networkaddress
    , u.nonsecuritymemberbl             as nonsecuritymemberbl
    , u.ntpwdhistory                    as ntpwdhistory
    , u.distinguishedname               as distinguishedname
    , u.objectguid                      as objectguid
    , u.objectsid                       as objectsid
    , u.objectversion                   as objectversion
    , u.operatorcount                   as operatorcount
    , u.ou                              as ou
    , u.o                               as o
    , u.otherloginworkstations          as otherloginworkstations
    , u.othermailbox                    as othermailbox
    , u.middlename                      as middlename
    , u.otherwellknownobjects           as otherwellknownobjects
    , u.partialattributedeletionlist    as partialattributedeletionlist
    , u.partialattributeset             as partialattributeset
    , u.personaltitle                   as personaltitle
    , u.otherfacsimiletelephonenumber   as otherfacsimiletelephonenumber
    , u.otherhomephone                  as otherhomephone
    , u.homephone                       as homephone
    , u.otheripphone                    as otheripphone
    , u.ipphone                         as ipphone
    , u.primaryinternationalisdnnumber  as primaryinternationalisdnnumber
    , u.othermobile                     as othermobile
    , u.mobile                          as mobile
    , u.othertelephone                  as othertelephone
    , u.otherpager                      as otherpager
    , u.pager                           as pager
    , u.physicaldeliveryofficename      as physicaldeliveryofficename
    , u.thumbnailphoto                  as thumbnailphoto
    , u.possibleinferiors               as possibleinferiors
    , u.postaladdress                   as postaladdress
    , u.postalcode                      as postalcode
    , u.postofficebox                   as postofficebox
    , u.preferreddeliverymethod         as preferreddeliverymethod
    , u.preferredou                     as preferredou
    , u.primarygroupid                  as primarygroupid
    , u.profilepath                     as profilepath
    , u.proxiedobjectname               as proxiedobjectname
    , u.proxyaddresses                  as proxyaddresses
    , u.pwdlastset                      as pwdlastset
    , u.querypolicybl                   as querypolicybl
    , u.name                            as name
    , u.registeredaddress               as registeredaddress
    , u.repluptodatevector              as repluptodatevector
    , u.directreports                   as directreports
    , u.repsfrom                        as repsfrom
    , u.repsto                          as repsto
    , u.revision                        as revision
    , u.rid                             as rid
    , u.samaccounttype                  as samaccounttype
    , u.scriptpath                      as scriptpath
    , u.sdrightseffective               as sdrightseffective
    , u.securityidentifier              as securityidentifier
    , u.seealso                         as seealso
    , u.serverreferencebl               as serverreferencebl
    , u.serviceprincipalname            as serviceprincipalname
    , u.showinaddressbook               as showinaddressbook
    , u.showinadvancedviewonly          as showinadvancedviewonly
    , u.sidhistory                      as sidhistory
    , u.siteobjectbl                    as siteobjectbl
    , u.st                              as st
    , u.street                          as street
    , u.subrefs                         as subrefs
    , u.subschemasubentry               as subschemasubentry
    , u.supplementalcredentials         as supplementalcredentials
    , u.sn                              as sn
    , u.systemflags                     as systemflags
    , u.telephonenumber                 as telephonenumber
    , u.teletexterminalidentifier       as teletexterminalidentifier
    , u.telexnumber                     as telexnumber
    , u.primarytelexnumber              as primarytelexnumber
    , u.terminalserver                  as terminalserver
    , u.co                              as co
    , u.textencodedoraddress            as textencodedoraddress
    , u.title                           as title
    , u.unicodepwd                      as unicodepwd
    , u.useraccountcontrol              as useraccountcontrol
    , u.usercert                        as usercert
    , u.comment                         as comment
    , u.userparameters                  as userparameters
    , u.userpassword                    as userpassword
    , u.userprincipalname               as userprincipalname
    , u.usersharedfolder                as usersharedfolder
    , u.usersharedfolderother           as usersharedfolderother
    , u.usersmimecertificate            as usersmimecertificate
    , u.userworkstations                as userworkstations
    , u.usnchanged                      as usnchanged
    , u.usncreated                      as usncreated
    , u.usndsalastobjremoved            as usndsalastobjremoved
    , u.usnintersite                    as usnintersite
    , u.usnlastobjrem                   as usnlastobjrem
    , u.usnsource                       as usnsource
    , u.wbempath                        as wbempath
    , u.wellknownobjects                as wellknownobjects
    , u.whenchanged::timestamp          as whenchanged
    , u.whencreated::timestamp          as whencreated
    , u.wwwhomepage                     as wwwhomepage
    , u.url                             as url
    , u.x121address                     as x121address
    , u.usercertificate                 as usercertificate
    , u.record_datetime::timestamp      as _created_at
    , u.record_date::date               as record_date
    , case
        when useraccountcontrol = '512' then 1
        else 0
    end                                 as is_active
    -- We need this to de-duplicate AD records on the supposedly unique distinguishedname
    , row_number()
        over (
            partition by u.record_datetime::date , u.distinguishedname
            order by u.whenchanged::timestamp desc , u.record_datetime::timestamp desc
        )                               as rn
    -- we need this to de-duplicate AD records that happen to share the same
    -- employee_num.
    , row_number()
        over (
            partition by u.record_datetime::date , employeenumber
            order by
                iff(u.distinguishedname ilike '%ou=mariner%' , 0 , 1)
                , u.whenchanged::timestamp desc , u.record_datetime::timestamp desc
        )                               as rn_employee_number
    , {{ col_is_head(
      reference=source('active_directory_mwa', 'user_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='u.record_datetime::timestamp'
      ) }}
    , rnk.rn_day                        as rn_day
from {{ source('active_directory_mwa', 'user_history') }} as u
inner join cte_rnk as rnk
    on u.record_datetime = rnk.record_datetime
where 1 = 1
{{ incremental_date_filter(
    source_col_name='u.record_datetime',
    target_col_name='_created_at',
    do_lookback = false,
    do_new = false
) }}
