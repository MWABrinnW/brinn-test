{#
    Need to create a custom test that ensures no location is duplicated across a date or range
#}

select
     location_code
    ,start_date
    ,end_date
    ,active
    ,division
    ,legal_name
    ,region_name
    ,market_name
    ,location_name
    ,office_name
    ,location_city
    ,location_state
    ,accounting_id
    ,accounting_id_description
    ,acquisition_name
    ,acquisition_type
    ,general_access
    ,_created_at
from {{ ref('aux__base_locations') }}
where is_head = 1