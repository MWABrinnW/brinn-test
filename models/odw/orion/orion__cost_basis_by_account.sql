select
    a.effective_date                        as effective_date
    , a.system_name                         as system_name
    , a.system_instance                     as system_instance
    , a.system_key                          as system_key
    , a.firm_source                         as firm_source
    , a.fkalclient                          as fkalclient
    , a.fkasset                             as fkasset
    , sum(a.longtermcost + a.shorttermcost) as cost_basis
    , {{ col_is_head(
        reference=ref('orion__base_vw_costbasisunrealized'),
        source_date_col='a.effective_date',
        reference_date_col='effective_date'
        ) }}
    , max(a._extracted_at)                  as _extracted_at
    , max(a._created_at)                    as _created_at
    , max(a._source_loaded_at)              as _source_loaded_at
from {{ ref('orion__base_vw_costbasisunrealized') }} as a
group by all
