select
    case 
        when nvl(start_date,'1900-01-01') in ('1900-01-01','2199-12-31')
        then null
        else start_date
        end::date                   as start_date
    ,case 
        when nvl(end_date,'1900-01-01') in ('1900-01-01','2199-12-31')
        then null
        else end_date
        end::date                   as end_date
    ,active::int                    as active
    ,general_access::int            as general_access
    ,location_code                  as location_code
    ,category
    ,legal_name
    ,region_name
    ,market_name
    ,location_name
    ,location_city
    ,location_state
    ,division_2
    ,region_name_2
    ,market_name_2
    ,division_3
    ,region_name_3
    ,market_name_3
    ,accounting_id_description
    ,accounting_id                  as accounting_id
    ,_created_at::timestamp         as _created_at
from {{ source('aux', 'locations') }}