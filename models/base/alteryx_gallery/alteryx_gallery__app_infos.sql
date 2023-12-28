select
    bu.display_name as created_by_display_name
    , bu.email      as created_by_email
    , ai.*
from {{ ref('alteryx_gallery__base_app_infos') }} as ai
left join {{ ref('alteryx_gallery__base_users') }} as bu
    on ai.created_by = bu.id
