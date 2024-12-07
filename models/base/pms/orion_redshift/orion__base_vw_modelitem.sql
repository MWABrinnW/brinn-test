select
    ci.clientname                               as clientname
    , ci.system_name                            as system_name
    , ci.system_instance                        as system_instance
    , ci.system_key                             as system_key
    , ci.firm_source                            as firm_source
    , a.content:fkalclient::integer             as fkalclient
    , a.content:pkmodelitem::integer            as pkmodelitem
    , a.content:fkmodel::integer                as fkmodel
    , a.content:fkproduct::integer              as fkproduct
    , a.content:percbe::double precision        as percbe
    , a.content:itemtol::integer                as itemtol
    , a.content:isdeleted::boolean::int         as isdeleted
    , a.content:itemtolupper::double precision  as itemtolupper
    , a.content:itemtollower::double precision  as itemtollower
    , a.content:oub::double precision           as oub
    , a.content:dynamicshares::double precision as dynamicshares
    , a.content:createddate::timestamp          as createddate
    , a.effective_at::date                      as effective_date
    , a._pk::varchar(200)                       as _pk

    , a._extracted_at::timestamp_ntz            as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_modelitem'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                           as _is_full
    , a._created_at::timestamp_ntz              as _created_at
    , a._source_file                            as _source_file
    , a._checksum                               as _checksum
from {{ source('orion', 'vw_modelitem') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
