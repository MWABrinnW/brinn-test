{#
    Need to create a custom test that ensures no location is duplicated across a date or range
#}

-- Test to ensure only one row has Active = 1 for each location_code
{{ config(
    materialized='view',
    tests=[
        "unique(case when active = 1 then location_code end)"
    ]
) }}

with unioned_data as (
    select
        location_code
        , start_date
        , coalesce(end_date, '2024-03-31')::date as end_date
        , active
        , null::text   as business_unit
        , null::text   as sector
        , division
        , region_name
        , market_name
        , location_name
        , office_name
        , null::text   as department
        , location_city
        , location_state
        , accounting_id
        , accounting_id_description
        , acquisition_name
        , acquisition_type
        , null::text   as leader_1
        , null::text   as leader_1_email
        , null::text   as leader_2
        , null::text   as leader_2_email
        , null::text   as hr_business_partner
        , null::text   as is_greenfield
        , null::text   as acquisition_start_month
        , null::text   as inception_date
        , null::text   as igo_segment
        , 'excel_file' as _source
        , _created_at
    from {{ ref('aux__base_locations') }}
    where is_head = 1
    union all
    select
        location_code
        , start_date
        , end_date
        , active
        , business_unit
        , sector
        , division
        , region     as region_name
        , market     as market_name
        , location   as location_name
        , department as office_name
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
        , 'edm_data' as _source
        , _created_at
    from {{ ref('edm__int_accounting_id') }}
    where is_head = 1
)

, ranked_data as (
    select
        *
        , row_number() over (partition by accounting_id order by start_date desc)            as rn
        , first_value(start_date) over (partition by accounting_id order by start_date desc) as start_date_of_rn_1
    from unioned_data
)

select
    location_code
    , start_date
    , iff(rn = 1 , end_date , coalesce(end_date , dateadd(day , -1 , start_date_of_rn_1))) as end_date
    , iff(rn = 1 , active , 0)                                                             as active
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
from ranked_data
