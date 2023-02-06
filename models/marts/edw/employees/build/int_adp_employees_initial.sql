{%- set ref_workers = ref('adp_history__workers') -%}

select
    w.associate_oid                                                                        as associate_id
  , w.employee_id                                                                          as employee_id
  , w.payroll_file_number                                                                  as payroll_file_number
  , w.position_id                                                                          as position_id
  , w.employee_status                                                                      as employment_status
  , w.job_function_code                                                                    as job_function_code
  , w.status_change_code                                                                   as change_reason_code
  , sc.description                                                                         as change_reason_description
  , sc.reason_type                                                                         as vol_invol
  , w.reporting_office                                                                     as reporting_office
  , trim(w.hire_details)                                                                   as hire_details
  , w.source                                                                               as source
  , w.title_change_reason                                                                  as title_change_reason
  , w.legal_name_first                                                                     as associate_legal_name_first
  , w.legal_name_middle                                                                    as associate_legal_name_middle
  , w.legal_name_last                                                                      as associate_legal_name_last
  , w.legal_name_full                                                                      as associate_legal_name_full
  , w.preferred_name                                                                       as associate_preferred_name
  , w.legal_name_suffix                                                                    as associate_legal_name_suffix
  , case when w.birth_date::date < '1/1/1920' then null else w.birth_date::date end::date  as associate_birth_date
  , w.gender_code                                                                          as associate_gender_code
  , w.gender_name                                                                          as associate_gender_name
  , w.personal_email                                                                       as associate_personal_email
  , w.personal_phone                                                                       as associate_personal_phone
  , w.personal_cell_phone                                                                  as associate_personal_cell_phone
  , w.legal_address_line1                                                                  as associate_legal_address_line1
  , w.legal_address_line2                                                                  as associate_legal_address_line2
  , w.legal_address_city                                                                   as associate_legal_address_city
  , w.legal_address_state_abb                                                              as associate_legal_address_state_abb
  , w.legal_address_state_name                                                             as associate_legal_address_state
  , w.legal_address_zip_code                                                               as associate_legal_address_zip_code
  , w.legal_address_country                                                                as associate_legal_address_country
  , w.other_address_line1                                                                  as associate_other_address_line1
  , w.other_address_line2                                                                  as associate_other_address_line2
  , w.other_address_city                                                                   as associate_other_address_city
  , w.other_address_state_abb                                                              as associate_other_address_state_abb
  , w.other_address_state_name                                                             as associate_other_address_state
  , w.other_address_zip_code                                                               as associate_other_address_zip_code
  , w.other_address_country                                                                as associate_other_address_country
  , w.eeo_ethnicity                                                                        as associate_eeo_ethnicity
  , w.eeo_identification_method                                                            as associate_eeo_identification_method
  , w.education                                                                            as associate_education
  , w.work_email                                                                           as associate_work_email
  , w.work_phone                                                                           as associate_work_phone
  , w.work_cell_phone                                                                      as associate_work_cell_phone
  , w.original_hire_date                                                                   as associate_original_hire_date
  , w.rehire_date                                                                          as associate_rehire_date
  , w.final_termination_date                                                               as associate_final_termination_date
  , w.position_company_code                                                                as position_company_code
  , w.position_status_code                                                                 as position_status_code
  , w.position_status                                                                      as position_status
  , w.position_seniority_hire_date                                                         as position_seniority_hire_date
  , w.position_start_date                                                                  as position_start_date
  , w.position_termination_date                                                            as position_termination_date
  , w.position_change_reason                                                               as position_change_reason
  , w.position_manager_position_id                                                         as position_manager_position_id
  , w.position_manager_name                                                                as position_manager_name
  , w.position_primary_job_indicator::int                                                  as position_primary_job_indicator
  , w.position_title_code                                                                  as position_title_code
  , w.position_title                                                                       as position_title
  , w.position_worker_type                                                                 as position_worker_type
  , w.position_benefits_group_code                                                         as position_benefits_group_code
  , w.position_benefits_group_class                                                        as position_benefits_group_class
  , w.position_flsa                                                                        as position_flsa
  , w.position_full_time_equivalent                                                        as position_full_time_equivalent
  , w.position_scheduled_hours                                                             as position_scheduled_hours
  , w.position_standard_hours                                                              as position_standard_hours
  , w.work_site_location_code                                                              as position_work_site_location_code
  , w.work_site_location_name                                                              as position_work_site_location_name
  , w.work_site_address_line1                                                              as position_work_site_address_line1
  , w.work_site_address_line2                                                              as position_work_site_address_line2
  , w.work_site_address_line3                                                              as position_work_site_address_line3
  , w.work_site_address_city                                                               as position_work_site_address_city
  , w.work_site_address_state_abb                                                          as position_work_site_address_state_abb
  , w.work_site_address_state                                                              as position_work_site_address_state
  , w.work_site_address_zip_code                                                           as position_work_site_address_zip_code
  , w.work_site_address_country                                                            as position_work_site_address_country
  , w.home_organizational_units                                                            as home_organizational_units
  , parse_json(w.home_organizational_units)[0]:nameCode:codeValue::varchar(100)            as home_organizational_units_market_code
  , parse_json(w.home_organizational_units)[0]:nameCode:longName::varchar(100)             as home_organizational_units_market_name_1
  , parse_json(w.home_organizational_units)[0]:nameCode:shortName::varchar(100)            as home_organizational_units_market_name_2
  , parse_json(w.home_organizational_units)[1]:nameCode:codeValue::varchar(100)            as home_organizational_units_department_code
  , parse_json(w.home_organizational_units)[1]:nameCode:longName::varchar(100)             as home_organizational_units_department_name_1
  , parse_json(w.home_organizational_units)[1]:nameCode:shortName::varchar(100)            as home_organizational_units_department_name_2
  , parse_json(w.home_organizational_units)[2]:nameCode:codeValue::varchar(100)            as home_organizational_units_cost_num
  , split_part(home_organizational_units_cost_num, '-', 1)                                 as position_cost_num_legal_code
  , split_part(home_organizational_units_cost_num, '-', 2)                                 as position_cost_num_region_code
  , split_part(home_organizational_units_cost_num, '-', 3)                                 as position_cost_num_market_code
  , split_part(home_organizational_units_cost_num, '-', 4)                                 as position_cost_num_location_code
  , split_part(home_organizational_units_cost_num, '-', 5)                                 as position_cost_num_team_code
  , split_part(home_organizational_units_cost_num, '-', 6)                                 as position_cost_num_natural_account
  , split_part(home_organizational_units_cost_num, '-', 7)                                 as position_cost_num_category
  , w.occupational_classifications                                                         as occupational_classifications
  , parse_json(occupational_classifications)[0]:classificationCode:codeValue::varchar(100) as occupational_classifications_eeo_code
  , parse_json(occupational_classifications)[0]:classificationCode:longName::varchar(100)  as occupational_classifications_eeo_class_p2
  , parse_json(occupational_classifications)[0]:classificationCode:shortName::varchar(100) as occupational_classifications_eeo_class_p1
  , parse_json(occupational_classifications)[1]:classificationCode:codeValue::varchar(100) as occupational_classifications_class_code
  , parse_json(occupational_classifications)[1]:classificationCode:shortName::varchar(100) as occupational_classifications_class
  , occupational_classifications_eeo_class_p1 || occupational_classifications_eeo_class_p2 as position_eeo_class
  , coalesce(w.position_region_name, w.position_region_description)                        as position_region_name
  , w.position_region_code                                                                 as position_region_code
  , w.position_region_description                                                          as position_region_description
  , coalesce(home_organizational_units_department_name_1,
      home_organizational_units_department_name_2)                                         as position_department_name
  , coalesce(home_organizational_units_market_name_1,
      home_organizational_units_market_name_2)                                             as position_market_name

  , w.effective_at                                                                         as effective_at
  , last_day(w.effective_at::date)                                                         as month_end_date
  , case when w.effective_at::date = last_day(w.effective_at::date) then 1 else 0 end      as is_month_end
  , w.is_head                                                                              as is_head
  , w._created_at                                                                          as _created_at
from {{ref_workers}}                             w
left join {{ ref('adp_status_change_reasons') }} sc
              on w.status_change_code = sc.code