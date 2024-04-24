with ranked_dates as (
    select
        location_code
        , is_enabled
        , end_date
        , business_unit
        , sector
        , division
        , region
        , market
        , location
        , department
        , city
        , state
        , accounting_id
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
        , effective_date
        , is_head
        , _created_at
        , _source_file
        , ROW_NUMBER() over (partition by accounting_id order by effective_date desc) as row_num
        , MAX(effective_date) over ()                                                 as max_effective_date_across_all
        , MIN(inception_date) over (partition by accounting_id)                       as min_inception_date
        , MAX(org_effective_date) over (partition by accounting_id)                   as max_org_effective_date
    from {{ ref('edm__base_accounting_id') }}
)

select
    location_code
    , nullif(greatest(coalesce(min_inception_date, '1900-01-01'), coalesce(max_org_effective_date, '1900-01-01')), '1900-01-01') as start_date
    , end_date
    , is_enabled                                                                  as active
    , business_unit
    , sector
    , division
    , region
    , market
    , location
    , department
    , city                                                                        as location_city
    , state                                                                       as location_state
    , accounting_id
    , department                                                                  as accounting_id_description
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
    , effective_date
    , is_head
    , _created_at
    , _source_file
from ranked_dates
where row_num = 1
    and business_unit != 'Unmapped'
    and accounting_id != '9000'
