select
    ci.clientname                               as clientname
  , content:fkalclient::integer                 as fkalclient
  , content:pkswpaccount::integer               as pkswpaccount
  , content:fkaccount::integer                  as fkaccount
  , content:isprorated::boolean::int            as isprorated
  , content:demeth::integer                     as demeth
  , content:swpfrequency::integer               as swpfrequency
  , content:swpcyclemonth::integer              as swpcyclemonth
  , content:startdate::date                     as startdate
  , content:transday::integer                   as transday
  , content:custodialswpdate::integer           as custodialswpdate
  , content:inactivedate::date                  as inactivedate
  , content:isactive::boolean::int              as isactive
  , content:swpamount::double precision         as swpamount
  , content:howtransfered::integer              as howtransfered
  , content:bankofrecord::varchar(100)          as bankofrecord
  , content:addressofrecord::varchar(150)       as addressofrecord
  , content:bankacctnum::varchar(60)            as bankacctnum
  , content:abanum::varchar(60)                 as abanum
  , content:taxeswithheld::double precision     as taxeswithheld
  , content:swpsource::integer                  as swpsource
  , content:swpacctnum::varchar(60)             as swpacctnum
  , content:notes::varchar(3000)                as notes
  , content:istaxwithtype::integer              as istaxwithtype
  , content:editeddate::timestamp               as editeddate
  , content:editedby::varchar(50)               as editedby
  , content:swpcreateddate::timestamp           as swpcreateddate
  , content:swpcreatedby::varchar(50)           as swpcreatedby
  , content:timestampswpaccount::varchar(200)   as timestampswpaccount
  , content:lifetype::integer                   as lifetype
  , content:isrecalc::boolean::int              as isrecalc
  , content:beneficiaryname::varchar(100)       as beneficiaryname
  , content:isspouse::boolean::int              as isspouse
  , content:beneficiarybday::date               as beneficiarybday
  , content:beneficiaryssn::varchar(30)         as beneficiaryssn
  , content:swptype::integer                    as swptype
  , content:iscfignored::boolean::int           as iscfignored
  , content:fkasset::integer                    as fkasset
  , content:enddate::date                       as enddate
  , content:statetax::double precision          as statetax
  , content:csdoublecheck::boolean::int         as csdoublecheck
  , content:csdoublecheckdate::date             as csdoublecheckdate
  , content:csdoublecheckby::varchar(50)        as csdoublecheckby
  , content:reconcilestatus::varchar(30)        as reconcilestatus
  , content:reconciledate::timestamp            as reconciledate
  , content:lastreconcile::date                 as lastreconcile
  , content:fkdistcode::integer                 as fkdistcode
  , content:importkey::varchar(30)              as importkey
  , content:custodialsystematicid::varchar(600) as custodialsystematicid
  , content:nextdate::date                      as nextdate
  , content:createddate::timestamp              as createddate
  , a.effective_at::date                        as effective_date
  , a._pk::varchar(200)                         as _pk
  , a._client::int                              as _client
  , a._extracted_at                             as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_swpaccount'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                             as _is_full
  , a._created_at                               as _created_at
  , a._source_file                              as _source_file
  , a._checksum                                 as _checksum
from {{ source('orion', 'stg_vw_swpaccount') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
