{{ config(enabled=false) }}

select
    uuid_string()                          as record_id
    , e.position_company_code              as company_code
    , e.employee_num                       as file_number
    , e.associate_legal_name_first         as associate_first_name
    , e.associate_legal_name_last          as associate_last_name
    , e.associate_legal_name_full          as associate_full_name
    , e.position_worker_type               as worker_category_description
    , e.employment_status                  as position_status
    , hcm.position_work_site_location_name as business_unit_description
    , hcm.position_department_name         as home_department_description
    , e.cost_num                           as cost_number
    , hcm.position_work_site_location_code as location_accounting_id
    , concat(
        hcm.cost_seg_1
        , '-' , hcm.cost_seg_2
        , '-' , hcm.cost_seg_6
        , '-' , hcm.cost_seg_3
        , '-' , hcm.cost_seg_4
    )                                      as expense_coding
    , concat(
        hcm.cost_seg_1
        , '-' , hcm.cost_seg_2
        , '-' , hcm.cost_seg_6
        , '-' , hcm.cost_seg_3
        , '-' , hcm.cost_seg_4
    )                                      as revenue_coding
    , concat(
        '150-150'
        , '-' , hcm.cost_seg_6
        , '-' , hcm.cost_seg_3
        , '-' , hcm.cost_seg_4
    )                                      as mir_coding
    , hcm.effective_at::date               as effective_date
    , e.data_last_refreshed_date           as _created_at
from edw.enterprise.employees as e
left join {{ ref('nml_oracle_hcm_associates') }} as hcm
    on concat('1' , substring(e.employee_num , 2)) = hcm.employee_num
    and hcm.is_head = 1
{# left join {{ ref('edm__int_accounting_id') }} as a
    on e.location_code = a.location_code
    and a.is_head = 1 #}
