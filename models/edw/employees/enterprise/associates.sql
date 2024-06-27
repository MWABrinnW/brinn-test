select
    employee_num                                                         as associate_id
    , employee_num_legacy                                                as legacy_employee_num
    , employment_status                                                  as employment_status
    , job_function_name                                                  as job_function_name
    , job_family                                                         as job_family
    , work_from_home                                                     as work_from_home
    , workplace                                                          as workplace
    , person_source                                                      as person_source
    , job_id                                                             as job_id
    , associate_legal_name_first                                         as associate_legal_name_first
    , associate_legal_name_middle                                        as associate_legal_name_middle
    , associate_legal_name_last                                          as associate_legal_name_last
    , associate_legal_name_full                                          as associate_legal_name_full
    , associate_preferred_name                                           as associate_preferred_name
    , associate_legal_name_suffix                                        as associate_legal_name_suffix
    , associate_work_email                                               as associate_work_email
    , associate_work_phone                                               as associate_work_phone
    , associate_work_cell_phone                                          as associate_work_cell_phone
    , associate_original_hire_date                                       as associate_original_hire_date
    , associate_rehire_date                                              as associate_rehire_date
    , associate_final_termination_date                                   as associate_final_termination_date
    , position_seniority_hire_date                                       as associate_seniority_hire_date
    , position_start_date                                                as associate_start_date
    , position_manager_position_id                                       as associate_manager_assignment_id
    , position_manager_name                                              as associate_manager_name
    , position_title                                                     as associate_title
    , position_worker_type                                               as associate_worker_type
    , advisor_nonadvisor                                                 as advisor_nonadvisor
    , position_work_site_location_name                                   as associate_work_site_location_name
    , position_work_site_location_real_estate_code                       as associate_work_site_location_real_estate_code
    , position_work_site_address_line1                                   as associate_work_site_address_line1
    , position_work_site_address_line2                                   as associate_work_site_address_line2
    , position_work_site_address_line3                                   as associate_work_site_address_line3
    , position_work_site_address_city                                    as associate_work_site_address_city
    , position_work_site_address_state_abb                               as associate_work_site_address_state_abb
    , position_work_site_address_zip_code                                as associate_work_site_address_zip_code
    , cost_seg_1                                                         as _1_legal_entity_id
    , cost_seg_2                                                         as _2_product_id
    , cost_seg_3                                                         as _3_accounting_id
    , cost_seg_4                                                         as _4_team_id
    , cost_seg_6                                                         as _6_initiative_id
    , job_level                                                          as job_level
    , position_department_name                                           as associate_department_name
    , ft_pt_temp                                                         as ft_pt_temp
    , iff(vol_invol_code is null , change_reason_code , null)            as title_change_reason
    , to_date('1804-' || to_char(associate_birth_date , 'mm-dd'))        as associate_birth_date_masked
    , to_char(associate_birth_date , 'mon') || ' '
    || ltrim(to_char(associate_birth_date , 'dd') , '0')                 as associate_birth_date
    , to_char(associate_birth_date , 'mon')                              as associate_birth_month
    , location_code                                                      as location_code
    , region_name                                                        as region_name
    , location_name                                                      as location_name
    , _created_at::date                                                  as data_last_refreshed_date
    , iff(left(system_name , 6) = 'oracle' , 'Oracle HCM' , system_name) as system_name
    , _created_at                                                        as _created_at
    , _source_file                                                       as _source_file
    , is_head                                                            as is_head
from {{ ref('bld_associates') }}
where 1 = 1
    and is_head = 1
