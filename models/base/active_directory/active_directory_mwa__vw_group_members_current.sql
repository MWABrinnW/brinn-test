select *
from {{ ref('active_directory_mwa__vw_group_members_history') }}
where is_head = 1