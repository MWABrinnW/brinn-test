select
    ci.clientname                                     as clientname
    , ci.system_name                                  as system_name
    , ci.system_instance                              as system_instance
    , ci.system_key                                   as system_key
    , ci.firm_source                                  as firm_source
    , a.content:fkalclient::integer                   as fkalclient
    , a.content:pkbillinstance::integer               as pkbillinstance
    , a.content:binstancecreateddate::timestamp       as binstancecreateddate
    , a.content:binstancecreatedby::varchar(40)       as binstancecreatedby
    , a.content:status::varchar(200)                  as status
    , a.content:perccomplete::integer                 as perccomplete
    , a.content:billtype::integer                     as billtype
    , a.content:fkblobpayablereport::integer          as fkblobpayablereport
    , a.content:ismockbill::boolean::int              as ismockbill
    , a.content:runfor::integer                       as runfor
    , a.content:runforkeylist::varchar(65535)         as runforkeylist
    , a.content:asofdate::date                        as asofdate
    , a.content:billfrequency::integer                as billfrequency
    , a.content:billstyle::integer                    as billstyle
    , a.content:enddateoverride::date                 as enddateoverride
    , a.content:valuedateoverride::date               as valuedateoverride
    , a.content:hangfirejobid::varchar(65535)         as hangfirejobid
    , a.content:hangfirejobtype::integer              as hangfirejobtype
    , a.content:entityoptions::varchar(65535)         as entityoptions
    , a.content:statusvalue::integer                  as statusvalue
    , a.content:correlationid::varchar(60)            as correlationid
    , a.content:fktrinstancefee::integer              as fktrinstancefee
    , a.content:nickname::varchar(300)                as nickname
    , a.content:includecashflows::boolean::int        as includecashflows
    , a.content:allowduplicatemockbills::boolean::int as allowduplicatemockbills
    , a.content:isfinalbill::boolean::int             as isfinalbill
    , a.content:excludeadjustments::boolean::int      as excludeadjustments
    , a.content:runforaccounts::integer               as runforaccounts
    , a.content:createddate::timestamp                as createddate
    , a.effective_at::date                            as effective_date
    , a._pk::varchar(200)                             as _pk

    , a._extracted_at::timestamp_ntz                  as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billinstance'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                 as _is_full
    , a._created_at::timestamp_ntz                    as _created_at
    , a._source_file                                  as _source_file
    , a._checksum                                     as _checksum
from {{ source('orion', 'vw_billinstance') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
