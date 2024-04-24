select
    location_code
    , start_date
    , end_date
    , active
    , business_unit
    , sector
    , division
    , region_name
    , market_name
    , location_name
    , office_name
    , department
    , location_city
    , location_state
    , accounting_id
    , accounting_id_description
    , acquisition_name
    , acquisition_type
    , leader_1
    , leader_1_email
    , leader_2
    , leader_2_email
    , hr_business_partner
    , is_greenfield
    , acquisition_start_month
    , inception_date
    , igo_segment
    , _source
    , _created_at
from {{ ref('int_locations') }}
where (
    coalesce(sector , 'placeholder') != 'Historical Only'
    and coalesce(end_date , '2100-01-01') >= start_date
)
