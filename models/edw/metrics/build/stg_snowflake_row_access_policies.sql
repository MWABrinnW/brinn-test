select *
from {{ source('snowflake_internal', 'row_access_policies') }}
