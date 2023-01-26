select
    location_name
    ,acquisition_name
    ,start_date
    ,end_date
    ,active
    ,general_access
    ,location_code
    ,category
    ,legal_name
    ,region_name
    ,market_name
    ,location_city
    ,location_state
    ,division_2
    ,region_name_2
    ,market_name_2
    ,division_3
    ,region_name_3
    ,market_name_3
    ,accounting_id_description
    ,accounting_id
    ,_created_at
from {{ref('build__int_locations')}}
where active = 1 and general_access = 1