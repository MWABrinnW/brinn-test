with cte_locations as
(
    select *
    from {{ ref('build__int_locations') }}
)
,cte_date_spine as
(
    select
      dateadd(day, '-' || seq4(), current_date()) as date_key
    from table(generator(rowcount => 20000))
    where date_key between 
        (select min(start_date) from cte_locations) and (select last_day(current_date(), 'year'))
)
select
    ds.date_key                     as effective_date
    ,l.location_name
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
    ,case 
        when ds.date_key = last_day(ds.date_key, 'month') 
            then 1 
            else 0 
            end                     as is_month_end
    ,last_day(ds.date_key, 'month') as month_end_date
from cte_locations l
cross join cte_date_spine ds
where true
    and ds.date_key between l.start_date and nvl(l.end_date, ds.date_key)
order by ds.date_key, l.location_code