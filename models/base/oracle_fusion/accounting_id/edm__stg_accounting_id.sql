select
    name::text(200)             as name--noqa:RF04
    , description::text(200)    as description
    , parent::text(200)         as parent
    , level::int                as level
    , hierarchy_name::text(200) as hierarchy_name
    , enabled::int              as is_enabled
    , end_date::date            as end_date
    , attr_01::text(200)        as attr_01
    , attr_02::text(200)        as attr_02
    , attr_03::text(200)        as attr_03
    , attr_04::text(200)        as attr_04
    , attr_05::text(200)        as attr_05
    , attr_06::text(200)        as attr_06
    , attr_07::text(200)        as attr_07
    , attr_08::text(200)        as attr_08
    , attr_09::text(200)        as attr_09
    , attr_10::text(200)        as attr_10
    , attr_11::text(200)        as attr_11
    , attr_12::text(200)        as attr_12
    , attr_13::text(200)        as attr_13
    , attr_14::text(200)        as attr_14
    , attr_15::text(200)        as attr_15
    , attr_16::text(200)        as attr_16
    , attr_17::text(200)        as attr_17
    , attr_18::text(200)        as attr_18
    , attr_19::text(200)        as attr_19
    , attr_20::text(200)        as attr_20
    , attr_21::text(200)        as attr_21
    , attr_22::text(200)        as attr_22
    , attr_23::text(200)        as attr_23
    , attr_24::text(200)        as attr_24
    , attr_25::text(200)        as attr_25
    , attr_26::text(200)        as attr_26
    , attr_27::text(200)        as attr_27
    , attr_28::text(200)        as attr_28
    , attr_29::text(200)        as attr_29
    , attr_30::text(200)        as attr_30
    , effective_date::date      as effective_date
    , {{ col_is_head(reference=source('oracle_edm', 'edm_accounting_id')) }}
    , _created_at::timestamp    as _created_at
    , _source_file::text(200)   as _source_file
from {{ source('oracle_edm', 'edm_accounting_id') }}
