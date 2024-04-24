-- Import necessary macros
{{ config(
    materialized='test'
) }}

-- Define the test
select
    ACCOUNTING_ID
    , count(distinct LOCATION_CODE) as CNT
from {{ ref('int_locations') }}
where ACTIVE = 1
group by ACCOUNTING_ID
having CNT > 1
