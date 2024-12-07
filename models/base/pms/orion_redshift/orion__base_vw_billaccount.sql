select
    ci.clientname                                    as clientname
    , ci.system_name                                 as system_name
    , ci.system_instance                             as system_instance
    , ci.system_key                                  as system_key
    , ci.firm_source                                 as firm_source
    , a.content:fkalclient::integer                  as fkalclient
    , a.content:pkbillaccount::integer               as pkbillaccount
    , a.content:fkbillregistration::integer          as fkbillregistration
    , a.content:fkbillpaymethod::integer             as fkbillpaymethod
    , a.content:fkbillfeeschedule::integer           as fkbillfeeschedule
    , a.content:fkaccount::integer                   as fkaccount
    , a.content:fkbillpayoutschedule::integer        as fkbillpayoutschedule
    , a.content:editeddate::date                     as editeddate
    , a.content:editedby::varchar(150)               as editedby
    , a.content:billacctcreateddate::date            as billacctcreateddate
    , a.content:billacctcreatedby::varchar(150)      as billacctcreatedby
    , a.content:scustodialacctnum::varchar(60)       as scustodialacctnum
    , a.content:sabanumber::varchar(30)              as sabanumber
    , a.content:sbankacctnum::varchar(30)            as sbankacctnum
    , a.content:sbankname::varchar(60)               as sbankname
    , a.content:snameonacct::varchar(60)             as snameonacct
    , a.content:screditcardnumber::varchar(300)      as screditcardnumber
    , a.content:icyclemonth::integer                 as icyclemonth
    , a.content:ibillfrequency::integer              as ibillfrequency
    , a.content:sexpdate::varchar(20)                as sexpdate
    , a.content:snameoncard::varchar(60)             as snameoncard
    , a.content:scardtype::varchar(30)               as scardtype
    , a.content:snmacctnum::varchar(60)              as snmacctnum
    , a.content:snmacctname::varchar(60)             as snmacctname
    , a.content:snmclientname::varchar(60)           as snmclientname
    , a.content:isactive::boolean::int               as isactive
    , a.content:ibillingstyle::integer               as ibillingstyle
    , a.content:fkbillmasterpayoutschedule::integer  as fkbillmasterpayoutschedule
    , a.content:acceptslist::boolean::int            as acceptslist
    , a.content:feeformcount::integer                as feeformcount
    , a.content:lastperfbilldate::date               as lastperfbilldate
    , a.content:isperformancebilled::boolean::int    as isperformancebilled
    , a.content:fkperffeeschedule::integer           as fkperffeeschedule
    , a.content:fkperfmasterpayoutschedule::integer  as fkperfmasterpayoutschedule
    , a.content:billstartdate::date                  as billstartdate
    , a.content:useminfee::boolean::int              as useminfee
    , a.content:valuemethod::integer                 as valuemethod
    , a.content:addlannualamt::double                as addlannualamt
    , a.content:addlannualamttype::integer           as addlannualamttype
    , a.content:fkbilladjtype::integer               as fkbilladjtype
    , a.content:fkbillentity::integer                as fkbillentity
    , a.content:creditcardnoencryption::varchar(300) as creditcardnoencryption
    , a.content:addr1::varchar(300)                  as addr1
    , a.content:addr2::varchar(300)                  as addr2
    , a.content:addr3::varchar(300)                  as addr3
    , a.content:city::varchar(50)                    as city
    , a.content:state::varchar(3)                    as state
    , a.content:zip::varchar(20)                     as zip
    , a.content:includeinaggregate::boolean::int     as includeinaggregate
    , a.content:fkbillaccountstatus::integer         as fkbillaccountstatus
    , a.content:tieredfeepriority::integer           as tieredfeepriority
    , a.content:usefeehierarchy::boolean::int        as usefeehierarchy
    , a.content:createddate::timestamp               as createddate
    , a.effective_at::date                           as effective_date
    , a._pk::varchar(200)                            as _pk

    , a._extracted_at::timestamp_ntz                 as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billaccount'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                as _is_full
    , a._created_at::timestamp_ntz                   as _created_at
    , a._source_file                                 as _source_file
    , a._checksum                                    as _checksum
from {{ source('orion', 'vw_billaccount') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
