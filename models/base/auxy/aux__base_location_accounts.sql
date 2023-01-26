select
    account_code
    ,location_code          as location_code
    ,_created_at::timestamp as _created_at
from {{ source('aux', 'location_accounts') }}