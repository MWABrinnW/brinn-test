select
    level2.name             as product_id
    , level2.description    as description
    , level2.is_enabled     as is_enabled
    , level2.end_date       as end_date
    , level2.effective_date as effective_date
    , level2.is_head        as is_head
    , level2._created_at    as _created_at
    , level2._source_file   as _source_file
from {{ ref('edm__stg_product_level2_product') }} as level2
left join {{ ref('edm__stg_product_level1_total_product') }} as level1
    on level2.parent = level1.name
    and level2.effective_date = level1.effective_date
