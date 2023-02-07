
with cte_max_load_per_day as
(
    select
        _created_at::date as _created_date
        ,max(_created_at) as max_created_at
    from {{ ref('aux__base_locations') }}
    group by 1
    order by 1
)

select
    min(l._created_at) as min_created_at
    ,max(l._created_at) as max_created_at
    ,l.location_code
    ,l.start_date
    ,l.end_date
    ,l.active
    ,l.division
    ,l.legal_name
    ,l.region_name
    ,l.market_name
    ,l.location_name
    ,l.office_name
    ,l.location_city
    ,l.location_state
    ,l.accounting_id
    ,l.accounting_id_description
    ,l.acquisition_name
    ,l.acquisition_type
    ,l.general_access
from {{ ref('aux__base_locations') }} l
join cte_max_load_per_day m
    on l._created_at = m.max_created_at
group by
     l.location_code
    ,l.start_date
    ,l.end_date
    ,l.active
    ,l.division
    ,l.legal_name
    ,l.region_name
    ,l.market_name
    ,l.location_name
    ,l.office_name
    ,l.location_city
    ,l.location_state
    ,l.accounting_id
    ,l.accounting_id_description
    ,l.acquisition_name
    ,l.acquisition_type
    ,l.general_access
order by l.location_code, min_created_at, l.start_date

