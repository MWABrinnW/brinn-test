select
    ci.clientname                                                         as clientname
    , ci.system_name                                                      as system_name
    , ci.system_instance                                                  as system_instance
    , ci.system_key                                                       as system_key
    , ci.firm_source                                                      as firm_source
    , a.content:fkalclient::integer                                       as fkalclient
    , a.content:fkaccount::integer                                        as fkaccount
    , a.content:rmdamount::double precision                               as rmdamount
    , a.content:ytdtotal::double precision                                as ytdtotal
    , a.content:endofpreviousyearaccountvalue::double precision           as endofpreviousyearaccountvalue
    , a.content:endofpreviousyearaccountvalueiscalculated::boolean::int   as endofpreviousyearaccountvalueiscalculated
    , a.content:calculatedendofpreviousyearaccountvalue::double precision as calculatedendofpreviousyearaccountvalue
    , a.content:amtremaining::double precision                            as amtremaining
    , a.content:investorage::double precision                             as investorage
    , a.content:primarybeneficiaryname::varchar(300)                      as primarybeneficiaryname
    , a.content:primarybeneficiaryage::double precision                   as primarybeneficiaryage
    , a.content:primarybeneficiaryrelation::varchar(50)                   as primarybeneficiaryrelation
    , a.content:ontrack::boolean::int                                     as ontrack
    , a.content:rmdeligible::boolean::int                                 as rmdeligible
    , a.content:irstable::varchar(50)                                     as irstable
    , a.content:factor::double precision                                  as factor
    , a.content:rmdsatisfied::boolean::int                                as rmdsatisfied
    , a.content:rmdsatisfiediscalculated::boolean::int                    as rmdsatisfiediscalculated
    , a.content:amtremaininggroup::double precision                       as amtremaininggroup
    , a.content:amtremaininggroupapplied::double precision                as amtremaininggroupapplied
    , a.content:iscustodial::boolean::int                                 as iscustodial
    , a.content:factortype::integer                                       as factortype
    , a.content:mtdtotal::double precision                                as mtdtotal
    , a.content:qtdtotal::double precision                                as qtdtotal
    , a.content:isrecalculated::boolean::int                              as isrecalculated
    , a.content:secureactrule::integer                                    as secureactrule
    , a.content:createddate::timestamp                                    as createddate
    , a.effective_at::date                                                as effective_date
    , a._pk::varchar(200)                                                 as _pk

    , a._extracted_at::timestamp_ntz                                      as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_rmdaccount'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                                     as _is_full
    , a._created_at::timestamp_ntz                                        as _created_at
    , a._source_file                                                      as _source_file
    , a._checksum                                                         as _checksum
from {{ source('orion', 'vw_rmdaccount') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
