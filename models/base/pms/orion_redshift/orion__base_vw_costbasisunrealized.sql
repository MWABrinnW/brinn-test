select
    ci.clientname                                  as clientname
  , content:fkalclient::integer                    as fkalclient
  , content:recordsource::varchar(5)               as recordsource
  , content:fkasset::integer                       as fkasset
  , content:fkassetcostbasis::bigint               as fkassetcostbasis
  , content:asofdate::date                         as asofdate
  , content:longtermcost::double precision         as longtermcost
  , content:shorttermcost::double precision        as shorttermcost
  , content:longtermunits::double precision        as longtermunits
  , content:shorttermunits::double precision       as shorttermunits
  , content:acquireddate::date                     as acquireddate
  , content:amortizationamt::double precision      as amortizationamt
  , content:originalcostpershare::double precision as originalcostpershare
  , content:checksum_current::integer              as checksum_current
  , content:createddate::timestamp                 as createddate
  , a.effective_at::date                           as effective_date
  , a._pk::varchar(200)                            as _pk
  , a._client::int                                 as _client
  , a._extracted_at                                as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_costbasisunrealized'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                as _is_full
  , a._created_at                                  as _created_at
  , a._source_file                                 as _source_file
  , a._checksum                                    as _checksum
from {{ source('orion', 'vw_costbasisunrealized') }} a
join {{ ref('orion__base_vw_clientinfo') }}              ci
     on a._client::int = ci.pkalclient
