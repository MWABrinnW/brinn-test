select *
from {{ source('snowflake_internal', 'policy_references') }}
