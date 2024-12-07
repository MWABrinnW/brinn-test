select
    ci.clientname                                        as clientname
    , ci.system_name                                     as system_name
    , ci.system_instance                                 as system_instance
    , ci.system_key                                      as system_key
    , ci.firm_source                                     as firm_source
    , a.content:fkalclient::integer                      as fkalclient
    , a.content:fkmodel::integer                         as fkmodel
    , a.content:fkfundfamily::integer                    as fkfundfamily
    , a.content:fkshareclass::integer                    as fkshareclass
    , a.content:fkplatform::integer                      as fkplatform
    , a.content:modelnum::integer                        as modelnum
    , a.content:percequity::integer                      as percequity
    , a.content:modelname::varchar(300)                  as modelname
    , a.content:modeltype::varchar(30)                   as modeltype
    , a.content:fundlist::varchar(30)                    as fundlist
    , a.content:modeltol::integer                        as modeltol
    , a.content:cashperc::integer                        as cashperc
    , a.content:cashtol::integer                         as cashtol
    , a.content:isactive::boolean::int                   as isactive
    , a.content:lastediteddate::date                     as lastediteddate
    , a.content:lasteditedby::varchar(50)                as lasteditedby
    , a.content:oldmodelid::integer                      as oldmodelid
    , a.content:islisttraded::boolean::int               as islisttraded
    , a.content:groupnum::varchar(50)                    as groupnum
    , a.content:fksubadvisor::integer                    as fksubadvisor
    , a.content:modnotes::varchar(1050)                  as modnotes
    , a.content:fkrep::integer                           as fkrep
    , a.content:fkrulesmgmt::integer                     as fkrulesmgmt
    , a.content:sequence::integer                        as sequence
    , a.content:modelcode::varchar(60)                   as modelcode
    , a.content:entityenum::integer                      as entityenum
    , a.content:fkparent::integer                        as fkparent
    , a.content:lastrebalanced::date                     as lastrebalanced
    , a.content:changereason::varchar(300)               as changereason
    , a.content:lastchangereason::varchar(300)           as lastchangereason
    , a.content:modellevels::integer                     as modellevels
    , a.content:userestrictions::boolean::int            as userestrictions
    , a.content:isdynamic::boolean::int                  as isdynamic
    , a.content:fkcustodian::integer                     as fkcustodian
    , a.content:dynamiceffectivedate::date               as dynamiceffectivedate
    , a.content:issma::boolean::int                      as issma
    , a.content:fkproductclass::integer                  as fkproductclass
    , a.content:fkriskcategory::integer                  as fkriskcategory
    , a.content:modelcreateddate::date                   as modelcreateddate
    , a.content:modelcreatedby::varchar(300)             as modelcreatedby
    , a.content:editeddate::date                         as editeddate
    , a.content:editedby::varchar(300)                   as editedby
    , a.content:communitymodelid::bigint                 as communitymodelid
    , a.content:targetriskupper::double precision        as targetriskupper
    , a.content:targetrisklower::double precision        as targetrisklower
    , a.content:style::varchar(150)                      as style
    , a.content:advisorfee::double precision             as advisorfee
    , a.content:weightedavgnetexpenses::double precision as weightedavgnetexpenses
    , a.content:currentrisk::double precision            as currentrisk
    , a.content:minimumamount::double precision          as minimumamount
    , a.content:daterebalancerequested::date             as daterebalancerequested
    , a.content:lastrebalancedate::date                  as lastrebalancedate
    , a.content:fkstrategist::integer                    as fkstrategist
    , a.content:fkmodelmanager::integer                  as fkmodelmanager
    , a.content:fkindexblend::integer                    as fkindexblend
    , a.content:benchmarkinceptiondate::date             as benchmarkinceptiondate
    , a.content:astrousage::integer                      as astrousage
    , a.content:daterebalanceexecutionrequested::date    as daterebalanceexecutionrequested
    , a.content:createddate::timestamp                   as createddate
    , a.effective_at::date                               as effective_date
    , a._pk::varchar(200)                                as _pk

    , a._extracted_at::timestamp_ntz                     as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_model'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                    as _is_full
    , a._created_at::timestamp_ntz                       as _created_at
    , a._source_file                                     as _source_file
    , a._checksum                                        as _checksum
from {{ source('orion', 'vw_model') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
