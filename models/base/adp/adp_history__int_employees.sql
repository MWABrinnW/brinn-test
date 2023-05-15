select
    w.associate_oid
  , w.employee_id
  , last_day(w._created_at::date) || '-' || w.position_id                                  as employee_reporting_id
  , case when lower(w.position_status) = 'active' then 1 else 0 end                        as is_active
  , w.employee_status                                                                      as employment_status
  , w.payroll_file_number
  , w.legal_name_first                                                                     as legal_name_first
  , w.legal_name_middle                                                                    as legal_name_middle
  , w.legal_name_last                                                                      as legal_name_last
  , w.legal_name_full                                                                      as legal_name_full
  , w.preferred_name
  , w.legal_name_suffix
  , w.birth_date
  , w.gender_code
  , w.gender_name
  , w.personal_email
  , w.personal_phone
  , w.personal_cell_phone
  , w.legal_address_line1
  , w.legal_address_line2
  , w.legal_address_city
  , w.legal_address_state_abb
  , w.legal_address_state_name
  , w.legal_address_zip_code
  , w.legal_address_country
  , w.other_address_line1
  , w.other_address_line2
  , w.other_address_city
  , w.other_address_state_abb
  , w.other_address_state_name                                                             as other_address_state
  , w.other_address_zip_code
  , w.other_address_country
  , w.eeo_ethnicity
  , w.eeo_identification_method
  , w.education
  , w.work_email
  , w.work_phone
  , w.work_cell_phone
  , w.original_hire_date
  , w.rehire_date
  , w.final_termination_date
  , w.reporting_office
  , trim(w.hire_details)                                                                    as hire_details
  , w.source
  , w.title_change_reason
  , w.position_company_code
  , w.position_id
  , w.position_status_code
  , w.position_status
  , w.position_seniority_hire_date                                                         as seniority_hire_date
  , w.position_start_date
  , w.position_termination_date
  -- , w.position_change_reason
  , w.position_region_code
  , w.position_region_description
  , w.home_organizational_units
  , w.position_manager_position_id
  , w.position_manager_name
  , w.position_primary_job_indicator
  , w.position_title_code
  , w.position_title
  , w.job_function_code
  , w.position_worker_type
  , w.position_benefits_group_code
  , w.position_benefits_group_class
  , w.position_flsa
  , w.occupational_classifications
  , w.position_full_time_equivalent
  , w.position_scheduled_hours
  , w.position_standard_hours
  , w.work_site_location_code
  , w.work_site_location_name
  , w.work_site_address_line1
  , w.work_site_address_line2
  , w.work_site_address_line3
  , w.work_site_address_city
  , w.work_site_address_state_abb
  , w.work_site_address_state
  , w.work_site_address_zip_code
  , w.work_site_address_country
  , w.status_change_code
  , sc.description                                                                         as position_change_reason
  , sc.reason_type                                                                         as vol_invol

  , parse_json(home_organizational_units)[0]:nameCode:codeValue::varchar(100)              as position_market_code
  , parse_json(home_organizational_units)[0]:nameCode:longName::varchar(100)               as position_market_name_1
  , parse_json(home_organizational_units)[0]:nameCode:shortName::varchar(100)              as position_market_name_2
  , parse_json(home_organizational_units)[1]:nameCode:codeValue::varchar(100)              as position_department_code
  , parse_json(home_organizational_units)[1]:nameCode:longName::varchar(100)               as position_department_name_1
  , parse_json(home_organizational_units)[1]:nameCode:shortName::varchar(100)              as position_department_name_2
  , parse_json(home_organizational_units)[2]:nameCode:codeValue::varchar(100)              as position_cost_number
  , split_part(position_cost_number, '-', 1)                                               as legal_code
  , split_part(position_cost_number, '-', 2)                                               as region_code
  , split_part(position_cost_number, '-', 3)                                               as market_code
  , split_part(position_cost_number, '-', 4)                                               as location_code
  , split_part(position_cost_number, '-', 5)                                               as team_code
  , split_part(position_cost_number, '-', 6)                                               as natural_account
  , split_part(position_cost_number, '-', 7)                                               as category

  , parse_json(occupational_classifications)[0]:classificationCode:codeValue::varchar(100) as position_eeo_code
  , parse_json(occupational_classifications)[0]:classificationCode:longName::varchar(100)  as position_eeo_class_p2
  , parse_json(occupational_classifications)[0]:classificationCode:shortName::varchar(100) as position_eeo_class_p1
  , parse_json(occupational_classifications)[1]:classificationCode:codeValue::varchar(100) as position_class_code
  , parse_json(occupational_classifications)[1]:classificationCode:shortName::varchar(100) as position_class
  , position_eeo_class_p1 || position_eeo_class_p2                                         as position_eeo_class
  , coalesce(position_department_name_1, position_department_name_2)                       as position_department_name
  , coalesce(position_market_name_1, position_market_name_2)                               as position_market_name
  , coalesce(position_region_name, position_region_description)                            as position_region_name

  , last_day(w._created_at::date) as month_end_date
  , case when w._created_at::date = last_day(w._created_at::date) then 1 else 0 end as is_month_end
  , w.is_head
  , w._created_at
from {{ ref('adp_history__workers') }}           w
left join {{ ref('adp_status_change_reasons') }} sc
    on w.status_change_code = sc.code
where true