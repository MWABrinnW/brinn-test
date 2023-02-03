select
    engagement_id
    , body
    , subject
    , status
    , for_object_type
    , task_type
    , completion_date
    , priority
    , _fivetran_synced
    , is_all_day
    , template_id
    , sequence_step_enrollment_id
    , sequence_step_order
from {{ source('hubspot_network', 'engagement_task') }}