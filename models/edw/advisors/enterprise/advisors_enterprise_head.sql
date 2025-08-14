{{ config(
    materialized='table',
    grants={'select': ['engineering']}
)}}

select *
from {{ ref('advisors_enterprise') }}
where 1 = 1
    and is_head = 1
