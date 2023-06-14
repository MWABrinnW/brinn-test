select *
from {{ source('reporting_int', 'vw_locations_all_info') }}
