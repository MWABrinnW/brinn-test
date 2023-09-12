with schwab as
(
    select
        'schwab'                    as custodian
        , effective_date            as effective_date
        , max(_created_at)          as _source_loaded_at
    from {{ source('schwab', 'rps') }}
    group by all
)
,fidelity as
(
    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_mwa', 'positd') }}
    group by all

    union all

    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_mps', 'positd') }}
    group by all

    union all

    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_swag', 'positd') }}
    group by all

    union all

    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_mwa', 'tlaopen_tax_accounting') }}
    group by all

    union all

    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_mps', 'tlaopen_tax_accounting') }}
    group by all

    union all

    select
        'fidelity'                  as custodian
        , effective_date            as effective_date
        , max(record_datetime)      as _source_loaded_at
    from {{ source('fidelity_swag', 'tlaopen_tax_accounting') }}
    group by all
)
,fidelity_cgf as
(
    select
        'fidelitycgf'               as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('fidelity_mwa_history__vw_cgf_pos') }}
    group by all

    union all

    select
        'fidelitycgf'               as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('fidelity_mps_history__vw_cgf_pos') }}
    group by all
)
,pershing as
(
    select
          'pershing'                as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('pershing_mwa__potl_a_aggregated_total_position_quantity_holdings') }}
    group by all

    union all

    select
          'pershing'                as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('pershing_mps__potl_a_aggregated_total_position_quantity_holdings') }}
    group by all
)
,tda as
(
    select
          'tda'                     as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('tda__int_positions') }}
    group by all
)
,lpl as
(
    select
          'lpl'                     as custodian
        , effective_date            as effective_date
        , max(_source_loaded_at)    as _source_loaded_at
    from {{ ref('lpl_network__base_position') }}
    group by all
)
,final as
(
    select * from schwab
    union all
    select * from fidelity
    union all
    select * from fidelity_cgf
    union all
    select * from tda
    union all
    select * from pershing
    union all
    select * from lpl
)

select
    custodian
    ,effective_date
    ,max(_source_loaded_at) as _source_loaded_at
from final
group by all
order by custodian effective_date

