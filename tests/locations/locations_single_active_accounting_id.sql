-- Import necessary macros
{{ config(
    materialized='test'
) }}

-- Define the test
select
    accounting_id
    , COUNT(*) as null_count
from
    {{ ref('int_locations') }}
where
    end_date is NULL
group by
    accounting_id
having
    null_count > 1
