select
    ci.clientname                                                     as clientname
  , content:fkalclient::integer                                       as fkalclient
  , content:fkaccount::integer                                        as fkaccount
  , content:rmdamount::double precision                               as rmdamount
  , content:ytdtotal::double precision                                as ytdtotal
  , content:endofpreviousyearaccountvalue::double precision           as endofpreviousyearaccountvalue
  , content:endofpreviousyearaccountvalueiscalculated::boolean::int   as endofpreviousyearaccountvalueiscalculated
  , content:calculatedendofpreviousyearaccountvalue::double precision as calculatedendofpreviousyearaccountvalue
  , content:amtremaining::double precision                            as amtremaining
  , content:investorage::double precision                             as investorage
  , content:primarybeneficiaryname::varchar(300)                      as primarybeneficiaryname
  , content:primarybeneficiaryage::double precision                   as primarybeneficiaryage
  , content:primarybeneficiaryrelation::varchar(50)                   as primarybeneficiaryrelation
  , content:ontrack::boolean::int                                     as ontrack
  , content:rmdeligible::boolean::int                                 as rmdeligible
  , content:irstable::varchar(50)                                     as irstable
  , content:factor::double precision                                  as factor
  , content:rmdsatisfied::boolean::int                                as rmdsatisfied
  , content:rmdsatisfiediscalculated::boolean::int                    as rmdsatisfiediscalculated
  , content:amtremaininggroup::double precision                       as amtremaininggroup
  , content:amtremaininggroupapplied::double precision                as amtremaininggroupapplied
  , content:iscustodial::boolean::int                                 as iscustodial
  , content:factortype::integer                                       as factortype
  , content:mtdtotal::double precision                                as mtdtotal
  , content:qtdtotal::double precision                                as qtdtotal
  , content:isrecalculated::boolean::int                              as isrecalculated
  , content:secureactrule::integer                                    as secureactrule
  , content:createddate::timestamp                                    as createddate
  , a.effective_at::date                                              as effective_date
  , a._pk::varchar(200)                                               as _pk
  , a._client::int                                                    as _client
  , a._extracted_at                                                   as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_rmdaccount'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                                   as _is_full
  , a._created_at                                                     as _created_at
  , a._source_file                                                    as _source_file
  , a._checksum                                                       as _checksum
from {{ source('orion', 'stg_vw_rmdaccount') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
