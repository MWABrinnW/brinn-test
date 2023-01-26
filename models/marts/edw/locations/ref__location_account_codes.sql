SELECT
    ac.account_code
  , ac.location_code
  , loc.start_date
  , loc.end_date
  , active              as is_active
  , general_access      as is_general_access
  , loc.legal_name
  , loc.region_name
  , loc.market_name
  , loc.location_name
  , loc.location_city
  , loc.location_state
from {{ ref('aux__base_location_accounts') }} ac
left join {{ ref('build__int_locations') }} loc
    on ac.location_code::string = loc.location_code::string