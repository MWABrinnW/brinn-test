select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:fkalclient::integer               as fkalclient
    , a.content:fkproduct::integer                as fkproduct
    , a.content:pkbondrate::integer               as pkbondrate
    , a.content:dateddate::date                   as dateddate
    , a.content:couponrate::double precision      as couponrate
    , a.content:maturitydate::date                as maturitydate
    , a.content:parvalue::double precision        as parvalue
    , a.content:paymentfrequency::integer         as paymentfrequency
    , a.content:paymentfrequencydesc::varchar(50) as paymentfrequencydesc
    , a.content:iscompounding::boolean::int       as iscompounding
    , a.content:editeddate::date                  as editeddate
    , a.content:editedby::varchar(100)            as editedby
    , a.content:bondratecreateddate::date         as bondratecreateddate
    , a.content:bondratecreatedby::varchar(100)   as bondratecreatedby
    , a.content:issuedate::date                   as issuedate
    , a.content:interestaccrualdate::date         as interestaccrualdate
    , a.content:isfederallytaxable::boolean::int  as isfederallytaxable
    , a.content:isstatetaxable::boolean::int      as isstatetaxable
    , a.content:daycount::integer                 as daycount
    , a.content:isvariablerate::boolean::int      as isvariablerate
    , a.content:isindefault::boolean::int         as isindefault
    , a.content:calldate::date                    as calldate
    , a.content:callprice::double precision       as callprice
    , a.content:initialcoupondate::date           as initialcoupondate
    , a.content:isoid::boolean::int               as isoid
    , a.content:isamt::boolean::int               as isamt
    , a.content:indefaultdate::date               as indefaultdate
    , a.content:alternatematuritydate::date       as alternatematuritydate
    , a.content:fkstate::integer                  as fkstate
    , a.content:state::varchar(5)                 as state
    , a.content:full_state_name::varchar(40)      as full_state_name
    , a.content:teamno::integer                   as teamno
    , a.content:fordom::varchar(5)                as fordom
    , a.content:hamptoneligible::boolean::int     as hamptoneligible
    , a.content:createddate::timestamp            as createddate
    , a.effective_at::date                        as effective_date
    , a._pk::varchar(200)                         as _pk

    , a._extracted_at::timestamp_ntz              as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_bondrate'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                             as _is_full
    , a._created_at::timestamp_ntz                as _created_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_bondrate') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
