select
    ci.clientname                                as clientname
    , ci.system_name                             as system_name
    , ci.system_instance                         as system_instance
    , ci.system_key                              as system_key
    , ci.firm_source                             as firm_source
    , a.content:fkalclient::integer              as fkalclient
    , a.content:pktranstype::int                 as pktranstype
    , a.content:type::text(500)                  as type
    , a.content:source::text(500)                as source
    , a.content:name::text(500)                  as name
    , a.content:description::text(500)           as description
    , a.content:valueeffect::int                 as valueeffect
    , a.content:shareeffect::int                 as shareeffect
    , a.content:tranclassification::text(500)    as tranclassification
    , a.content:isbreak::boolean::int            as isbreak
    , a.content:qsclassification::text(500)      as qsclassification
    , a.content:nettransfer::boolean::int        as nettransfer
    , a.content:transrpt::int                    as transrpt
    , a.content:is1099b::boolean::int            as is1099b
    , a.content:is1099r::boolean::int            as is1099r
    , a.content:is1099div::boolean::int          as is1099div
    , a.content:is1099int::boolean::int          as is1099int
    , a.content:isbshare::boolean::int           as isbshare
    , a.content:signfield::text(500)             as signfield
    , a.content:isvalid::boolean::int            as isvalid
    , a.content:distribclassification::text(500) as distribclassification
    , a.content:payoutoption::text(500)          as payoutoption
    , a.content:isnounits::boolean::int          as isnounits
    , a.content:isnoprice::boolean::int          as isnoprice
    , a.content:isnoamount::boolean::int         as isnoamount
    , a.content:isbillable::boolean::int         as isbillable
    , a.content:twrtype::int                     as twrtype
    , a.content:financialtype::int               as financialtype
    , a.content:isrmddistribution::boolean::int  as isrmddistribution
    , a.content:sleeveconfirmmethod::int         as sleeveconfirmmethod
    , a.content:usagepriority::int               as usagepriority
    , a.content:fktranstype_cashoffset::int      as fktranstype_cashoffset
    , a.content:trancreateddate::date            as trancreateddate

    , a._pk::varchar(200)                        as _pk
    , a._extracted_at::timestamp_ntz             as _extracted_at
    , 1::int                                     as is_head
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                            as _is_full
    , a._created_at::timestamp_ntz               as _created_at
    , a._source_file                             as _source_file
    , a._checksum                                as _checksum
from {{ source('orion', 'vw_transactiontype') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
