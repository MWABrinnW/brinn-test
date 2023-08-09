select
    ci.clientname                             as clientname
  , content:fkalclient::integer               as fkalclient
  , content:fkproduct::integer                as fkproduct
  , content:pkbondrate::integer               as pkbondrate
  , content:dateddate::date                   as dateddate
  , content:couponrate::double precision      as couponrate
  , content:maturitydate::date                as maturitydate
  , content:parvalue::double precision        as parvalue
  , content:paymentfrequency::integer         as paymentfrequency
  , content:paymentfrequencydesc::varchar(50) as paymentfrequencydesc
  , content:iscompounding::boolean::int       as iscompounding
  , content:editeddate::date                  as editeddate
  , content:editedby::varchar(100)            as editedby
  , content:bondratecreateddate::date         as bondratecreateddate
  , content:bondratecreatedby::varchar(100)   as bondratecreatedby
  , content:issuedate::date                   as issuedate
  , content:interestaccrualdate::date         as interestaccrualdate
  , content:isfederallytaxable::boolean::int  as isfederallytaxable
  , content:isstatetaxable::boolean::int      as isstatetaxable
  , content:daycount::integer                 as daycount
  , content:isvariablerate::boolean::int      as isvariablerate
  , content:isindefault::boolean::int         as isindefault
  , content:calldate::date                    as calldate
  , content:callprice::double precision       as callprice
  , content:initialcoupondate::date           as initialcoupondate
  , content:isoid::boolean::int               as isoid
  , content:isamt::boolean::int               as isamt
  , content:indefaultdate::date               as indefaultdate
  , content:alternatematuritydate::date       as alternatematuritydate
  , content:fkstate::integer                  as fkstate
  , content:state::varchar(5)                 as state
  , content:full_state_name::varchar(40)      as full_state_name
  , content:teamno::integer                   as teamno
  , content:fordom::varchar(5)                as fordom
  , content:hamptoneligible::boolean::int     as hamptoneligible
  , content:createddate::timestamp            as createddate
  , a.effective_at::date                      as effective_date
  , a._pk::varchar(200)                       as _pk
  , a._client::int                            as _client
  , a._extracted_at                           as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_bondrate'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'stg_vw_bondrate') }} a
join {{ ref('orion__base_vw_clientinfo') }}   ci
     on a._client::int = ci.pkalclient
