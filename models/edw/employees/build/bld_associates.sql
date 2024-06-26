{{ config(
    grants = {'select': ['engineering', 'security', 'datamanagement']}
) }}

{%- set effective_date_switchover = '2024-07-01' -%}

/*
employee_num vs oracle_employee_num
001234 > 101234

We are loading in the historical IDs into Oracle to help with the transition,
all 3 of them, but any new hires added to only oracle won't have those,
so it will eventually wane in usefulness.
*/

select
    system_name
    , system_instance
    , system_key
    , effective_at
    , employee_num_source
    , employee_num
    , employee_num_legacy
    , employment_status
    , job_function_code
    , job_function_name
    , job_family
    , change_reason_code
    , change_reason_description
    , vol_invol_code
    , work_from_home
    , workplace
    , person_source
    , job_id
    , associate_legal_name_first
    , associate_legal_name_middle
    , associate_legal_name_last
    , associate_legal_name_full
    , associate_preferred_name
    , associate_legal_name_suffix
    , associate_birth_date
    , associate_gender_code
    , associate_gender_name
    , associate_personal_email
    , associate_personal_phone
    , associate_personal_cell_phone
    , associate_legal_address_line1
    , associate_legal_address_line2
    , associate_legal_address_city
    , associate_legal_address_state_abb
    , associate_legal_address_state
    , associate_legal_address_zip_code
    , associate_legal_address_country
    , associate_other_address_line1
    , associate_other_address_line2
    , associate_other_address_city
    , associate_other_address_state_abb
    , associate_other_address_state
    , associate_other_address_zip_code
    , associate_other_address_country
    , associate_education
    , associate_work_email
    , associate_work_phone
    , associate_work_cell_phone
    , associate_original_hire_date
    , associate_rehire_date
    , associate_final_termination_date
    , position_id
    , position_seniority_hire_date
    , position_start_date
    , position_manager_position_id
    , position_manager_name
    , position_manager_email
    , position_manager_ad_distinguished_name
    , position_manager_employee_num
    , position_primary_job_indicator::text as position_primary_job_indicator
    , position_title_code
    , position_title
    , position_worker_type
    , advisor_nonadvisor
    , position_full_time_equivalent
    , position_work_site_location_code
    , position_work_site_location_name
    , position_work_site_location_real_estate_code
    , position_work_site_address_line1
    , position_work_site_address_line2
    , position_work_site_address_line3
    , position_work_site_address_city
    , position_work_site_address_state_abb
    , position_work_site_address_state
    , position_work_site_address_zip_code
    , position_work_site_address_country
    , cost_seg_1
    , cost_seg_2
    , cost_seg_3
    , cost_seg_4
    , cost_seg_6
    , job_level
    , position_department_name
    , ft_pt_temp
    , future_hire
    , accounting_id
    , location_code
    , office_name
    , location_name
    , department
    , region_name
    , division
    , is_ad_linked
    , ad_distinguished_name
    --, ad_other_mobile
    , ad_email
    , ad_sam_account_name
    , ad_manager_employee_number
    , ad_manager_email
    , ad_manager_distinguishedname
    , _created_at
    , _source_file
    , is_head
    , _extra_fields
from {{ ref('nml_adp_associates') }}
where effective_at::date < '{{ effective_date_switchover }}'
    and right(lower(position_id) , 1) <> 'n'
    and position_primary_job_indicator = 1

union all

select
    system_name
    , system_instance
    , system_key
    , effective_at
    , employee_num_source
    , employee_num
    , employee_num_legacy
    , employment_status
    , job_function_code
    , job_function_name
    , job_family
    , change_reason_code
    , change_reason_description
    , vol_invol_code
    , work_from_home
    , workplace
    , person_source
    , job_id
    , associate_legal_name_first
    , associate_legal_name_middle
    , associate_legal_name_last
    , associate_legal_name_full
    , associate_preferred_name
    , associate_legal_name_suffix
    , associate_birth_date
    , associate_gender_code
    , associate_gender_name
    , associate_personal_email
    , associate_personal_phone
    , associate_personal_cell_phone
    , associate_legal_address_line1
    , associate_legal_address_line2
    , associate_legal_address_city
    , associate_legal_address_state_abb
    , associate_legal_address_state
    , associate_legal_address_zip_code
    , associate_legal_address_country
    , associate_other_address_line1
    , associate_other_address_line2
    , associate_other_address_city
    , associate_other_address_state_abb
    , associate_other_address_state
    , associate_other_address_zip_code
    , associate_other_address_country
    , associate_education
    , associate_work_email
    , associate_work_phone
    , associate_work_cell_phone
    , associate_original_hire_date
    , associate_rehire_date
    , associate_final_termination_date
    , position_id
    , position_seniority_hire_date
    , position_start_date
    , position_manager_position_id
    , position_manager_name
    , position_manager_email
    , position_manager_ad_distinguished_name
    , position_manager_employee_num
    , position_primary_job_indicator
    , position_title_code
    , position_title
    , position_worker_type
    , advisor_nonadvisor
    , position_full_time_equivalent
    , position_work_site_location_code
    , position_work_site_location_name
    , position_work_site_location_real_estate_code
    , position_work_site_address_line1
    , position_work_site_address_line2
    , position_work_site_address_line3
    , position_work_site_address_city
    , position_work_site_address_state_abb
    , position_work_site_address_state
    , position_work_site_address_zip_code
    , position_work_site_address_country
    , cost_seg_1
    , cost_seg_2
    , cost_seg_3
    , cost_seg_4
    , cost_seg_6
    , job_level
    , position_department_name
    , ft_pt_temp
    , future_hire
    , accounting_id
    , location_code
    , office_name
    , location_name
    , department
    , region_name
    , division
    , is_ad_linked
    , ad_distinguished_name
    --, ad_other_mobile
    , ad_email
    , ad_sam_account_name
    , ad_manager_employee_number
    , ad_manager_email
    , ad_manager_distinguishedname
    , _created_at
    , _source_file
    , is_head
    , _extra_fields
from {{ ref('nml_oracle_hcm_associates') }}
where effective_at::date >= '{{ effective_date_switchover }}'
