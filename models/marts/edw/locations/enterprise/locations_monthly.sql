select *
from {{ ref('locations_history') }}
where is_month_end = 1