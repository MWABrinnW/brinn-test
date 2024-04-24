-- Import necessary macros
{{ config(
    materialized='test'
) }}

-- Define the test
with overlapping_dates as (
    select
        accounting_id
        , location_code
        , start_date
        , end_date
        , LEAD(start_date) over (partition by accounting_id , location_code order by start_date) as next_start_date
    from
        {{ ref('int_locations') }}
)

select IFF(end_date >= next_start_date , 1 , 0) as check_date_overlap_test
from overlapping_dates
where next_start_date is not NULL
    and start_date >= '2020-01-01'
having check_date_overlap_test = 1
