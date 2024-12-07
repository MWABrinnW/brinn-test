select
    ci.clientname                                   as clientname
    , ci.system_name                                as system_name
    , ci.system_instance                            as system_instance
    , ci.system_key                                 as system_key
    , ci.firm_source                                as firm_source
    , cbr.content:acquireddate::date                as acquireddate
    , cbr.content:amortizationamt::double precision as amortizationamt
    , cbr.content:costamt::double precision         as costamt
    , cbr.content:createddate::datetime             as createddate
    , cbr.content:fkalclient::integer               as fkalclient
    , cbr.content:fkasset::integer                  as fkasset
    , cbr.content:fkassetcostbasis::bigint          as fkassetcostbasis
    , cbr.content:holdperioddate::date              as holdperioddate
    , cbr.content:islongterm::boolean::int          as islongterm
    , cbr.content:method::varchar(200)              as method
    , cbr.content:nounits::double precision         as nounits
    , cbr.content:proceedamt::double precision      as proceedamt
    , cbr.content:recordsource::varchar(5)          as recordsource
    , cbr.content:selldate::date                    as selldate
    , cbr.content:washsaleimpacted::boolean::int    as washsaleimpacted
    , cbr.effective_at::date                        as effective_date
    , {{
      col_is_head(reference=source('orion', 'vw_costbasisrealized'),
      source_date_col='cbr.effective_at',
      reference_date_col='effective_at')
    }}
    , {{
      col_is_current(date_col='cbr.effective_at::date')
    }}
    , cbr._pk::varchar(200)                         as _pk
    , cbr._client                                   as _client
    , cbr._is_full                                  as _is_full
    , cbr._extracted_at::timestamp_ntz              as _extracted_at
    , cbr._created_at::timestamp_ntz                as _created_at
    , cbr._source_file                              as _source_file
    , cbr._checksum                                 as _checksum
from {{ source('orion', 'vw_costbasisrealized') }} as cbr
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on cbr.content:fkalclient::int = ci.pkalclient
