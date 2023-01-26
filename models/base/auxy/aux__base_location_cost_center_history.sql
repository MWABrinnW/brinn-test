select
    case 
        when nvl(start_date,'1900-01-01') in ('1900-01-01','2199-12-31')
        then null
        else start_date
        end::date                as start_date
    ,case 
        when nvl(end_date,'1900-01-01') in ('1900-01-01','2199-12-31')
        then null
        else end_date
        end::date                as end_date
    ,old_code
    ,current_code                as current_code
    ,_created_at::timestamp      as _created_at
from {{ source('aux', 'location_cost_center_history') }}