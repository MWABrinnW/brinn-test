{#
    Need to create a custom test that ensures no location is duplicated across a date or range
#}

select
     l.location_name
    ,l.start_date
    ,l.end_date
    ,l.location_code
    ,l.active
    ,l.office_name
    ,l.legal_name
    ,l.region_name
    ,l.market_name
    ,l.division
    ,l.general_access
    ,l.location_city
    ,l.location_state
    ,l.accounting_id
    ,l.accounting_id_description
    ,l.acquisition_name
    ,l.acquisition_type
    ,l._created_at
from {{ ref('aux__base_locations') }} l
where l.is_head = 1