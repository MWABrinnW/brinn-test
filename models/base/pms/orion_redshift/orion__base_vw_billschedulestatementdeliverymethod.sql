select
    ci.clientname                                              as clientname
    , ci.system_name                                           as system_name
    , ci.system_instance                                       as system_instance
    , ci.system_key                                            as system_key
    , ci.firm_source                                           as firm_source
    , a.content:fkalclient::integer                            as fkalclient
    , a.content:pkbillschedulestatementdeliverymethod::integer as pkbillschedulestatementdeliverymethod
    , a.content:fkbillschedule::integer                        as fkbillschedule
    , a.content:fkdeliverymethodaccounttype::integer           as fkdeliverymethodaccounttype
    , a.content:deliverymethodaccounttypename::varchar(50)     as deliverymethodaccounttypename
    , a.content:bboth::boolean::int                            as bboth
    , a.content:mail::boolean::int                             as mail
    , a.content:email::boolean::int                            as email
    , a.content:nostatement::boolean::int                      as nostatement
    , a.content:websiteonly::boolean::int                      as websiteonly
    , a.content:createddate::timestamp                         as createddate
    , a.effective_at::date                                     as effective_date
    , a._pk::varchar(200)                                      as _pk

    , a._extracted_at::timestamp_ntz                           as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billschedulestatementdeliverymethod'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                          as _is_full
    , a._created_at::timestamp_ntz                             as _created_at
    , a._source_file                                           as _source_file
    , a._checksum                                              as _checksum
from {{ source('orion', 'vw_billschedulestatementdeliverymethod') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
