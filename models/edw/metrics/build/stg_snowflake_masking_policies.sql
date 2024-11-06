select *
from {{ source('snowflake_internal', 'masking_policies') }}
