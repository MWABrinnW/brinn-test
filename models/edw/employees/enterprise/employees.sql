select
    iff(left(system_key , 6) = 'oracle' , 'Oracle HCM' , system_key) as source_system
    , employee_num                                                   as employee_num
    , position_id                                                    as position_id
    , employment_status                                              as employment_status
    , position_title                                                 as position_title
    , job_function_name                                              as job_function_code
    , advisor_nonadvisor                                             as advisor_nonadvisor
    , associate_work_email                                           as associate_work_email
    , associate_work_phone                                           as associate_work_phone
    , associate_work_cell_phone                                      as associate_work_cell_phone
    , associate_legal_name_first                                     as associate_legal_name_first
    , associate_legal_name_middle                                    as associate_legal_name_middle
    , associate_legal_name_last                                      as associate_legal_name_last
    , associate_legal_name_suffix                                    as associate_legal_name_suffix
    , associate_legal_name_full                                      as associate_legal_name_full
    , associate_preferred_name                                       as associate_preferred_name
    , to_date('1804-' || to_char(associate_birth_date , 'mm-dd'))    as associate_birth_date_masked
    , to_char(associate_birth_date , 'mon') || ' '
    || ltrim(to_char(associate_birth_date , 'dd') , '0')             as associate_birth_date
    , to_char(associate_birth_date , 'mon')                          as associate_birth_month
    , position_work_site_address_line1                               as position_work_site_address_line1
    , position_work_site_address_line2                               as position_work_site_address_line2
    , position_work_site_address_line3                               as position_work_site_address_line3
    , job_level                                                      as position_class
    , position_worker_type                                           as position_worker_type
    , _extra_fields:position_company_code                            as position_company_code
    , position_manager_name                                          as position_manager_name
    , position_manager_position_id                                   as position_manager_position_id
    , region_name                                                    as position_region_name
    , location_name                                                  as position_location_name
    , position_department_name                                       as position_department_name
    , position_work_site_location_name                               as position_work_site_location_name
    , position_work_site_address_city                                as position_work_site_address_city
    , position_work_site_address_state_abb                           as position_work_site_address_state_abb
    , position_work_site_address_zip_code                            as position_work_site_address_zip_code
    , location_code                                                  as location_code
    , cost_seg_1
    || '-' || cost_seg_2
    || '-' || cost_seg_6
    || '-' || cost_seg_3
    || '-' || cost_seg_4                                             as cost_num
    , null::text                                                     as reporting_office
    , associate_original_hire_date                                   as associate_original_hire_date
    , position_seniority_hire_date                                   as position_seniority_hire_date
    , associate_rehire_date                                          as associate_rehire_date
    , associate_final_termination_date                               as associate_final_termination_date
    , _created_at::date                                              as data_last_refreshed_date
    , accounting_id                                                  as accounting_id
    , person_source                                                  as source
    , position_start_date                                            as position_start_date
    , iff(vol_invol_code is null , change_reason_code , null)        as title_change_reason
    , job_id                                                         as job_id
    , null::text                                                     as bu_allocation
    , replace(_extra_fields:employee_num , '"' , '')                 as legacy_employee_num
from {{ ref('bld_associates') }}
where true
    and coalesce(right(lower(position_id) , 1) , 'a') <> 'n'
    and is_head = 1
    and effective_at::date >= '2024-06-23'
