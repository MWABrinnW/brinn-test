select
    ci.clientname                                   as clientname
    , ci.system_name                                as system_name
    , ci.system_instance                            as system_instance
    , ci.system_key                                 as system_key
    , ci.firm_source                                as firm_source
    , a.content:fkalclient::integer                 as fkalclient
    , a.content:pkfundfamily::integer               as pkfundfamily
    , a.content:fkpersonal::integer                 as fkpersonal
    , a.content:entityname::varchar(255)            as entityname
    , a.content:isannuity::boolean::int             as isannuity
    , a.content:iscanbedownload::boolean::int       as iscanbedownload
    , a.content:oldgroup::varchar(10)               as oldgroup
    , a.content:oldff_id::integer                   as oldff_id
    , a.content:fkperscontact::integer              as fkperscontact
    , a.content:fkpersovernt::integer               as fkpersovernt
    , a.content:speeddial::varchar(20)              as speeddial
    , a.content:tradeinstr::varchar(300)            as tradeinstr
    , a.content:isactive::boolean::int              as isactive
    , a.content:ffcreateddate::date                 as ffcreateddate
    , a.content:ffcreatedby::varchar(30)            as ffcreatedby
    , a.content:editeddate::date                    as editeddate
    , a.content:editedby::varchar(30)               as editedby
    , a.content:timestampfundfamily::varchar(200)   as timestampfundfamily
    , a.content:vendor::varchar(60)                 as vendor
    , a.content:status::varchar(60)                 as status
    , a.content:restrictionnotes::varchar(600)      as restrictionnotes
    , a.content:reregistrationnotes::varchar(600)   as reregistrationnotes
    , a.content:cstoperationhours::varchar(30)      as cstoperationhours
    , a.content:isphonetrade::boolean::int          as isphonetrade
    , a.content:isfaxtrade::boolean::int            as isfaxtrade
    , a.content:isuploadtrade::boolean::int         as isuploadtrade
    , a.content:isconfirmphone::boolean::int        as isconfirmphone
    , a.content:isconfirminternet::boolean::int     as isconfirminternet
    , a.content:isconfirmfundserv::boolean::int     as isconfirmfundserv
    , a.content:isconfirmaps::boolean::int          as isconfirmaps
    , a.content:isconfirmother::boolean::int        as isconfirmother
    , a.content:confirmnotes::varchar(600)          as confirmnotes
    , a.content:downloadmethod::varchar(20)         as downloadmethod
    , a.content:downloadnotes::varchar(600)         as downloadnotes
    , a.content:custfundserve::varchar(30)          as custfundserve
    , a.content:directfundserve::varchar(30)        as directfundserve
    , a.content:trader::varchar(30)                 as trader
    , a.content:unitbalancescale::integer           as unitbalancescale
    , a.content:pricescale::integer                 as pricescale
    , a.content:isacctnumunique::boolean::int       as isacctnumunique
    , a.content:isnetworkingeligible::boolean::int  as isnetworkingeligible
    , a.content:isshareclasssensitive::boolean::int as isshareclasssensitive
    , a.content:sungardbrokerid::integer            as sungardbrokerid
    , a.content:isdefault::boolean::int             as isdefault
    , a.content:iscreatedistribution::boolean::int  as iscreatedistribution
    , a.content:fkblobsignature::integer            as fkblobsignature
    , a.content:createddate::timestamp              as createddate
    , a.effective_at::date                          as effective_date
    , a._pk::varchar(200)                           as _pk

    , a._extracted_at::timestamp_ntz                as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_fundfamily'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                               as _is_full
    , a._created_at::timestamp_ntz                  as _created_at
    , a._source_file                                as _source_file
    , a._checksum                                   as _checksum
from {{ source('orion', 'vw_fundfamily') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
