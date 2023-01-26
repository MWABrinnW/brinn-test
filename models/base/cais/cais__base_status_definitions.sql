select
    transaction_status
    ,definitions
from {{ source('cais', 'status_definitions') }}