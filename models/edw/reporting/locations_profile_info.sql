select *
from {{ source('reporting_int', 'vw_testing_locations_all_info') }}
