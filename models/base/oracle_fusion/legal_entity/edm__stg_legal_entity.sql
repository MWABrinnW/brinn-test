select
    name::text(200)                as name--noqa: RF04
    , description::text(200)       as description
    , parent::text(200)            as parent
    , level::int                   as level
    , hierarchy_name::text(200)    as hierarchy_name
    , try_to_boolean(enabled)::int as is_enabled
    , end_date::date               as end_date
    , attr01::text(200)            as attr_01
    , attr02::text(200)            as attr_02
    , attr03::text(200)            as attr_03
    , attr04::text(200)            as attr_04
    , attr05::text(200)            as attr_05
    , attr06::text(200)            as attr_06
    , attr07::text(200)            as attr_07
    , attr08::text(200)            as attr_08
    , attr09::text(200)            as attr_09
    , attr10::text(200)            as attr_10
    , effective_date::date         as effective_date
    , {{ col_is_head(reference=source('oracle', 'edm_legal_entity')) }}
    , _created_at::timestamp       as _created_at
    , _source_file::text(200)      as _source_file
from {{ source('oracle', 'edm_legal_entity') }}
