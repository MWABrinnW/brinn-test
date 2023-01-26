{#
    Need to create a custom test that ensures no location is duplicated across a date or range
#}

with acquisition_names as
(
    select
        sfl.name
        ,sfa.name as acquisition_name
        ,sfl.city_c
        ,sfl.finance_code_c
        ,sfl.accounting_id_c
        ,sfl.region_c
        ,sfl.market_c
        ,sfl.office_c
        ,sfl.acquisition_date_c
    from {{ ref('salesforce_compass__base_mh_location_c') }} sfl
    join (select *
                    , row_number() over (partition by mhlocation_c order by created_date desc) as rn
            from {{ ref('salesforce_compass__base_mhacquisition_c') }}
            where is_deleted = false
                and type_c ilike '%firm purchase%') sfa
        on sfl.id = sfa.mhlocation_c
        and sfa.rn = 1
    where true
        and sfl.is_deleted = false
        and sfl.active_c = true
)

select
    l.location_name
    ,acq.acquisition_name
    ,l.start_date
    ,l.end_date
    ,l.active
    ,l.general_access
    ,l.location_code
    ,l.category
    ,l.legal_name
    ,l.region_name
    ,l.market_name
    ,l.location_city
    ,l.location_state
    ,l.division_2
    ,l.region_name_2
    ,l.market_name_2
    ,l.division_3
    ,l.region_name_3
    ,l.market_name_3
    ,l.accounting_id_description
    ,l.accounting_id
    ,l._created_at
from {{ ref('aux__base_locations') }} l
left join acquisition_names acq
    on l.accounting_id = acq.accounting_id_c