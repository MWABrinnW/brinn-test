with cte_locations as (
    select *
    from {{ ref('int_locations') }}
)

, cte_date_spine as (
    select dateadd(day , '-' || seq4() , current_date()) as date_key
    from table(generator(rowcount => 20000))
    where date_key between
        (select min(start_date) from cte_locations
        ) and (select last_day(current_date() , 'year'))
)

select
    ds.date_key                       as effective_date
    , l.location_code
    , l.start_date
    , l.end_date
    , l.active
    , l.business_unit
    , l.sector
    , l.division
    , l.region_name
    , l.market_name
    , l.location_name
    , l.office_name
    , l.department
    , l.location_city
    , l.location_state
    , l.accounting_id
    , l.accounting_id_description
    , l.acquisition_name
    , l.acquisition_type
    , l.leader_1
    , l.leader_1_email
    , l.leader_2
    , l.leader_2_email
    , l.hr_business_partner
    , l.is_greenfield
    , l.acquisition_start_month
    , l.inception_date
    , l._source
    , case
        when ds.date_key = last_day(ds.date_key , 'month')
            then 1
        else 0
    end                               as is_month_end
    , last_day(ds.date_key , 'month') as month_end_date
from cte_locations as l
cross join cte_date_spine as ds
where true
    and ds.date_key between l.start_date and coalesce(l.end_date , ds.date_key)
order by ds.date_key , l.location_code
