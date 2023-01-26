select
    start_date
    ,end_date
    ,old_code
    ,current_code
from {{ ref('aux__base_location_cost_center_history') }}