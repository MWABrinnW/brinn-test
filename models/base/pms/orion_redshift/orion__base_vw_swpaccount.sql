select
    ci.clientname                                   as clientname
    , ci.system_name                                as system_name
    , ci.system_instance                            as system_instance
    , ci.system_key                                 as system_key
    , ci.firm_source                                as firm_source
    , a.content:fkalclient::integer                 as fkalclient
    , a.content:pkswpaccount::integer               as pkswpaccount
    , a.content:fkaccount::integer                  as fkaccount
    , a.content:isprorated::boolean::int            as isprorated
    , a.content:demeth::integer                     as demeth
    , a.content:swpfrequency::integer               as swpfrequency
    , a.content:swpcyclemonth::integer              as swpcyclemonth
    , a.content:startdate::date                     as startdate
    , a.content:transday::integer                   as transday
    , a.content:custodialswpdate::integer           as custodialswpdate
    , a.content:inactivedate::date                  as inactivedate
    , a.content:isactive::boolean::int              as isactive
    , a.content:swpamount::double precision         as swpamount
    , a.content:howtransfered::integer              as howtransfered
    , a.content:bankofrecord::varchar(100)          as bankofrecord
    , a.content:addressofrecord::varchar(150)       as addressofrecord
    , a.content:bankacctnum::varchar(60)            as bankacctnum
    , a.content:abanum::varchar(60)                 as abanum
    , a.content:taxeswithheld::double precision     as taxeswithheld
    , a.content:swpsource::integer                  as swpsource
    , a.content:swpacctnum::varchar(60)             as swpacctnum
    , a.content:notes::varchar(3000)                as notes
    , a.content:istaxwithtype::integer              as istaxwithtype
    , a.content:editeddate::timestamp               as editeddate
    , a.content:editedby::varchar(50)               as editedby
    , a.content:swpcreateddate::timestamp           as swpcreateddate
    , a.content:swpcreatedby::varchar(50)           as swpcreatedby
    , a.content:timestampswpaccount::varchar(200)   as timestampswpaccount
    , a.content:lifetype::integer                   as lifetype
    , a.content:isrecalc::boolean::int              as isrecalc
    , a.content:beneficiaryname::varchar(100)       as beneficiaryname
    , a.content:isspouse::boolean::int              as isspouse
    , a.content:beneficiarybday::date               as beneficiarybday
    , a.content:beneficiaryssn::varchar(30)         as beneficiaryssn
    , a.content:swptype::integer                    as swptype
    , a.content:iscfignored::boolean::int           as iscfignored
    , a.content:fkasset::integer                    as fkasset
    , a.content:enddate::date                       as enddate
    , a.content:statetax::double precision          as statetax
    , a.content:csdoublecheck::boolean::int         as csdoublecheck
    , a.content:csdoublecheckdate::date             as csdoublecheckdate
    , a.content:csdoublecheckby::varchar(50)        as csdoublecheckby
    , a.content:reconcilestatus::varchar(30)        as reconcilestatus
    , a.content:reconciledate::timestamp            as reconciledate
    , a.content:lastreconcile::date                 as lastreconcile
    , a.content:fkdistcode::integer                 as fkdistcode
    , a.content:importkey::varchar(30)              as importkey
    , a.content:custodialsystematicid::varchar(600) as custodialsystematicid
    , a.content:nextdate::date                      as nextdate
    , a.content:createddate::timestamp              as createddate
    , a.effective_at::date                          as effective_date
    , a._pk::varchar(200)                           as _pk

    , a._extracted_at::timestamp_ntz                as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_swpaccount'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                               as _is_full
    , a._created_at::timestamp_ntz                  as _created_at
    , a._source_file                                as _source_file
    , a._checksum                                   as _checksum
from {{ source('orion', 'vw_swpaccount') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
