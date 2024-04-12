with cte_rnk as (
    select
        record_datetime::date as record_date
        , record_datetime
        , dense_rank() over (
            partition by record_datetime::date order by record_datetime desc
        )                     as rn_day
    from {{ source('active_directory_mwa', 'user_history') }}
    group by 1 , 2
    order by 1 , 2
)

select
    'active_directory'::text(200)     as system_name
    , 'mwa'::text(200)                as system_instance
    , concat(
        system_name , '__' , system_instance
    )                                 as system_key
    , 'mwa'::text(200)                as firm_source
    , id
    , dn
    , rdn
    , basedn
    , instancetype::int               as instancetype
    , ntsecuritydescriptor
    , objectcategory
    , objectclass
    , samaccountname
    , accountexpires
    , accountnamehistory
    , acspolicyname
    , streetaddress
    , homepostaladdress
    , admincount
    , admindescription
    , admindisplayname
    , allowedattributes
    , allowedattributeseffective
    , allowedchildclasses
    , allowedchildclasseseffective
    , altsecurityidentities
    , assistant
    , badpasswordtime
    , badpwdcount::int                as badpwdcount
    , bridgeheadserverlistbl
    , canonicalname
    , codepage::int                   as codepage
    , info
    , cn
    , company
    , controlaccessrights
    , countrycode
    , c
    , createtimestamp::timestamp      as createtimestamp
    , dbcspwd
    , defaultclassstore
    , department
    , description
    , desktopprofile
    , destinationindicator
    , displayname
    , displaynameprintable
    , division
    , dsasignature
    , dscorepropagationdata
    , dynamicldapserver
    , mail
    , employeeid
    , employeenumber
    , employeetype
    , extensionname
    , facsimiletelephonenumber
    , flags
    , fromentry
    , frscomputerreferencebl
    , frsmemberreferencebl
    , fsmoroleowner
    , garbagecollperiod
    , generationqualifier
    , givenname
    , groupmembershipsam
    , grouppriority
    , groupstoignore
    , homedirectory
    , homedrive
    , initials
    , internationalisdnnumber
    , iscriticalsystemobject::boolean as iscriticalsystemobject
    , isdeleted::boolean              as isdeleted
    , isprivilegeholder::boolean      as isprivilegeholder
    , lastknownparent
    , lastlogoff
    , lastlogon
    , lmpwdhistory
    , localeid
    , l
    , lockouttime
    , thumbnaillogo
    , logoncount
    , logonhours
    , logonworkstation
    , managedobjects
    , manager
    , masteredby
    , maxstorage
    , mhsoraddress
    , modifytimestamp::timestamp      as modifytimestamp
    , "MS-DS-CONSISTENCYCHILDCOUNT"
    , "MS-DS-CONSISTENCYGUID"
    , "MS-DS-CREATORSID"
    , msmqdigests
    , msmqdigestsmig
    , msmqsigncertificates
    , msmqsigncertificatesmig
    , msnpallowdialin
    , msnpcallingstationid
    , msnpsavedcallingstationid
    , msradiuscallbacknumber
    , msradiusframedipaddress
    , msradiusframedroute
    , msradiusservicetype
    , msrassavedcallbacknumber
    , msrassavedframedipaddress
    , msrassavedframedroute
    , netbootscpbl
    , networkaddress
    , nonsecuritymemberbl
    , ntpwdhistory
    , distinguishedname
    , objectguid
    , objectsid
    , objectversion
    , operatorcount
    , ou
    , o
    , otherloginworkstations
    , othermailbox
    , middlename
    , otherwellknownobjects
    , partialattributedeletionlist
    , partialattributeset
    , personaltitle
    , otherfacsimiletelephonenumber
    , otherhomephone
    , homephone
    , otheripphone
    , ipphone
    , primaryinternationalisdnnumber
    , othermobile
    , mobile
    , othertelephone
    , otherpager
    , pager
    , physicaldeliveryofficename
    , thumbnailphoto
    , possibleinferiors
    , postaladdress
    , postalcode
    , postofficebox
    , preferreddeliverymethod
    , preferredou
    , primarygroupid
    , profilepath
    , proxiedobjectname
    , proxyaddresses
    , pwdlastset
    , querypolicybl
    , name
    , registeredaddress
    , repluptodatevector
    , directreports
    , repsfrom
    , repsto
    , revision
    , rid
    , samaccounttype
    , scriptpath
    , sdrightseffective
    , securityidentifier
    , seealso
    , serverreferencebl
    , serviceprincipalname
    , showinaddressbook
    , showinadvancedviewonly
    , sidhistory
    , siteobjectbl
    , st
    , street
    , subrefs
    , subschemasubentry
    , supplementalcredentials
    , sn
    , systemflags
    , telephonenumber
    , teletexterminalidentifier
    , telexnumber
    , primarytelexnumber
    , terminalserver
    , co
    , textencodedoraddress
    , title
    , unicodepwd
    , useraccountcontrol
    , usercert
    , comment
    , userparameters
    , userpassword
    , userprincipalname
    , usersharedfolder
    , usersharedfolderother
    , usersmimecertificate
    , userworkstations
    , usnchanged
    , usncreated
    , usndsalastobjremoved
    , usnintersite
    , usnlastobjrem
    , usnsource
    , wbempath
    , wellknownobjects
    , whenchanged::timestamp          as whenchanged
    , whencreated::timestamp          as whencreated
    , wwwhomepage
    , url
    , x121address
    , usercertificate
    , u.record_datetime::timestamp    as _created_at
    , u.record_date::date             as record_date
    , case
        when useraccountcontrol = '512' then 1
        else 0
    end                               as is_active
    , row_number()
        over (
            partition by u.record_datetime::date , distinguishedname
            order by whenchanged::timestamp desc , u.record_datetime::timestamp desc
        )                             as rn
    , {{ col_is_head(
      reference=source('active_directory_mwa', 'user_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='u.record_datetime::timestamp'
      ) }}
    , rnk.rn_day                      as rn_day
from {{ source('active_directory_mwa', 'user_history') }} as u
inner join cte_rnk as rnk
    on u.record_datetime = rnk.record_datetime
