with ranked_dates as (
    select
        location_code
        , is_enabled
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
        , effective_date
        , is_head
        , _created_at
        , _source_file
        , ROW_NUMBER() over (partition by accounting_id order by effective_date desc) as row_num
        , MAX(effective_date) over ()                                                 as max_effective_date_across_all
        , MIN(effective_date) over (partition by accounting_id)                       as start_date
    from {{ ref('edm__base_accounting_id') }}
)

select
    location_code
    , start_date
    , IFF(effective_date = max_effective_date_across_all , NULL , effective_date) as end_date
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
    , effective_date
    , is_head
    , _created_at
    , _source_file
from ranked_dates
where row_num = 1
    and business_unit != 'Unmapped'
    and accounting_id != '9000'
