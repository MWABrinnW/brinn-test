select
    ci.clientname                                    as clientname
  , content:fkalclient::integer                      as fkalclient
  , content:fkmodel::integer                         as fkmodel
  , content:fkfundfamily::integer                    as fkfundfamily
  , content:fkshareclass::integer                    as fkshareclass
  , content:fkplatform::integer                      as fkplatform
  , content:modelnum::integer                        as modelnum
  , content:percequity::integer                      as percequity
  , content:modelname::varchar(300)                  as modelname
  , content:modeltype::varchar(30)                   as modeltype
  , content:fundlist::varchar(30)                    as fundlist
  , content:modeltol::integer                        as modeltol
  , content:cashperc::integer                        as cashperc
  , content:cashtol::integer                         as cashtol
  , content:isactive::boolean::int                   as isactive
  , content:lastediteddate::date                     as lastediteddate
  , content:lasteditedby::varchar(50)                as lasteditedby
  , content:oldmodelid::integer                      as oldmodelid
  , content:islisttraded::boolean::int               as islisttraded
  , content:groupnum::varchar(50)                    as groupnum
  , content:fksubadvisor::integer                    as fksubadvisor
  , content:modnotes::varchar(1050)                  as modnotes
  , content:fkrep::integer                           as fkrep
  , content:fkrulesmgmt::integer                     as fkrulesmgmt
  , content:sequence::integer                        as sequence
  , content:modelcode::varchar(60)                   as modelcode
  , content:entityenum::integer                      as entityenum
  , content:fkparent::integer                        as fkparent
  , content:lastrebalanced::date                     as lastrebalanced
  , content:changereason::varchar(300)               as changereason
  , content:lastchangereason::varchar(300)           as lastchangereason
  , content:modellevels::integer                     as modellevels
  , content:userestrictions::boolean::int            as userestrictions
  , content:isdynamic::boolean::int                  as isdynamic
  , content:fkcustodian::integer                     as fkcustodian
  , content:dynamiceffectivedate::date               as dynamiceffectivedate
  , content:issma::boolean::int                      as issma
  , content:fkproductclass::integer                  as fkproductclass
  , content:fkriskcategory::integer                  as fkriskcategory
  , content:modelcreateddate::date                   as modelcreateddate
  , content:modelcreatedby::varchar(300)             as modelcreatedby
  , content:editeddate::date                         as editeddate
  , content:editedby::varchar(300)                   as editedby
  , content:communitymodelid::bigint                 as communitymodelid
  , content:targetriskupper::double precision        as targetriskupper
  , content:targetrisklower::double precision        as targetrisklower
  , content:style::varchar(150)                      as style
  , content:advisorfee::double precision             as advisorfee
  , content:weightedavgnetexpenses::double precision as weightedavgnetexpenses
  , content:currentrisk::double precision            as currentrisk
  , content:minimumamount::double precision          as minimumamount
  , content:daterebalancerequested::date             as daterebalancerequested
  , content:lastrebalancedate::date                  as lastrebalancedate
  , content:fkstrategist::integer                    as fkstrategist
  , content:fkmodelmanager::integer                  as fkmodelmanager
  , content:fkindexblend::integer                    as fkindexblend
  , content:benchmarkinceptiondate::date             as benchmarkinceptiondate
  , content:astrousage::integer                      as astrousage
  , content:daterebalanceexecutionrequested::date    as daterebalanceexecutionrequested
  , content:createddate::timestamp                   as createddate
  , a.effective_at::date                             as effective_date
  , a._pk::varchar(200)                              as _pk
  , a._client::int                                   as _client
  , a._extracted_at                                  as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_model'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                  as _is_full
  , a._created_at                                    as _created_at
  , a._source_file                                   as _source_file
  , a._checksum                                      as _checksum
from {{ source('orion', 'vw_model') }}      a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
