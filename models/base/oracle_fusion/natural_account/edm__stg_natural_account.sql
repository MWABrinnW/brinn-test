select
    name::text(200)                as name
    , description::text(200)       as description
    , parent::text(200)            as parent
    , level::int                   as level
    , hierarchy_name::text(200)    as hierarchy_name
    , try_to_boolean(enabled)::int as is_enabled
    , end_date::date               as end_date
    , account_type::text(200)      as account_type
    , attr_01::text(200)           as attr_01
    , attr_02::text(200)           as attr_02
    , attr_03::text(200)           as attr_03
    , attr_04::text(200)           as attr_04
    , attr_05::text(200)           as attr_05
    , attr_06::text(200)           as attr_06
    , attr_07::text(200)           as attr_07
    , attr_08::text(200)           as attr_08
    , attr_09::text(200)           as attr_09
    , attr_10::text(200)           as attr_10
    , effective_date::date         as effective_date
    , {{ col_is_head(reference=source('oracle', 'edm_natural_account')) }}
    , _created_at::timestamp       as _created_at
    , _source_file::text(200)      as _source_file
from {{ source('oracle', 'edm_natural_account') }}
