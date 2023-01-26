select
    account_code
    ,location_code
from {{ ref('aux__base_location_accounts') }}