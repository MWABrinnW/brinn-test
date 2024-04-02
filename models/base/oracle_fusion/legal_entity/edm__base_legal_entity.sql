select
    level6.name             as legal_entity_id
    , level6.description    as description
    , level6.is_enabled     as is_enabled
    , level6.end_date       as end_date
    , level6.name           as level6_name
    , level5.name           as level5_name
    , level4.name           as level4_name
    , level3.name           as level3_name
    , level2.name           as level2_name
    , level1.name           as level1_name
    , level6.effective_date as effective_date
    , level6.is_head        as is_head
    , level6._created_at    as _created_at
    , level6._source_file   as _source_file
from {{ ref('edm__stg_legal_entity_level6') }} as level6
left join {{ ref('edm__stg_legal_entity_level5') }} as level5
    on level6.parent = level5.name
    and level6.effective_date = level5.effective_date
left join {{ ref('edm__stg_legal_entity_level4') }} as level4
    on level5.parent = level4.name
    and level6.effective_date = level4.effective_date
left join {{ ref('edm__stg_legal_entity_level3') }} as level3
    on level4.parent = level3.name
    and level6.effective_date = level3.effective_date
left join {{ ref('edm__stg_legal_entity_level2') }} as level2
    on level3.parent = level2.name
    and level6.effective_date = level2.effective_date
left join {{ ref('edm__stg_legal_entity_level1') }} as level1
    on level2.parent = level1.name
    and level6.effective_date = level1.effective_date
