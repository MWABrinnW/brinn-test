-- depends_on: {{ ref('int_adp_employees_initial') }}
-- depends_on: {{ ref('aux__base_employee_overrides') }}
-- depends_on: {{ ref('dates') }}
{{ config(materialized = 'table') }}

{#
  We should consider adding a field to the adp tables which indicates the date of the data (i.e. effective_date)
  and not just the time it was loaded (_created_at/record_datetime)
#}

{%- set src = ref('int_adp_employees_initial') -%}

{# Prepare the query we'll use to determine if new data from the source is available #}
{% set qry_check_for_new_data %}
select
    case
        when (select count(*) from {{ this }}) = 0
            then 1
        when (select top 1 1
              from {{ src }}
              where _created_at > (select max(_created_at) from {{ this }})
              ) = 1
            then 1
        else 0
        end
{% endset %}

{# Execute the query to determine if new data is ready. 1=yes 0=no#}
{% if execute %}
  {% set result = dbt_utils.get_single_value(qry_check_for_new_data) %}
{% else %}
  {{ dbt_utils.log_info('setting result from default')}}
  {% set result = 0 %}
{% endif %}

{# Log the result #}
{{ dbt_utils.log_info(result)}}

{% if result == 0 %}
  select *
  from {{ this }}
{% else %}
with cte_employees_all           as
    (
        select *
        from {{ src }}
    )
    , cte_employees              as
        (select
             employee_id
           , effective_at
           , max(effective_at) over (partition by employee_id) as max_effective_at
           , min(effective_at) over (partition by employee_id) as min_effective_at
         from cte_employees_all
         group by 1, 2
         order by 1, 2)
   , cte_loads                  as
    (
        /* Get all distinct effective dates represented in the source data */
        select distinct
            effective_at
        from cte_employees
        group by 1
        order by 1)
   , cte_dates                  as
    (
        /* Flag the most recent effective_at in the data in case there are duplicate loads for a day */
        select
            effective_at
        from (select
                  effective_at
                , row_number() over (partition by effective_at::date order by effective_at desc) as rn
              from cte_loads)
        where rn = 1)
   , cte_employee_by_date       as
    (
        /* If an employee_id has disappeared from the source data
           we'll add records for subsequent effective_at so that it
           can be represented in following dates as well */
        select distinct
            e.employee_id
          , t.effective_at
          , e.min_effective_at
          , e.max_effective_at
        from cte_employees e
        cross join cte_dates     t
        where t.effective_at >= e.min_effective_at)
   , cte_employees_exist_status as
    (
      /* flag each employee if they existed in the data for a date */
      select
         ebd.*
       , case when e.employee_id is not null then 1 else 0 end as is_exist
      from cte_employee_by_date ebd
      left join cte_employees   e
        on ebd.employee_id = e.employee_id
        and ebd.effective_at = e.effective_at)
   , cte_employees_final        as
    (
      /* Get the previous effective_at for each employee record.
         Handles possible scenarios where a record temporarily dissappeared. */
      select *
          , last_value(case when is_exist = 1 then effective_at end) ignore nulls
            over (partition by employee_id order by effective_at asc rows between unbounded preceding and 1 preceding)
            as prior_effective_at
      from cte_employees_exist_status)
   , cte_final                  as
    (
        /* Grab all the data for employees from adp history json data */
        select
            a.effective_at::timestamp            as effective_at
          , case
                when a.max_effective_at < a.effective_at
                    then a.max_effective_at
                else a.effective_at
                end::date                        as data_last_refreshed_date

          , w.associate_id
          , a.employee_id
          , w.payroll_file_number
          , w.position_id
          , w.employment_status
          , w.job_function_code
          , w.change_reason_code
          , w.change_reason_description
          , w.vol_invol
          , w.reporting_office
          , w.hire_details
          , w.source
          , w.associate_legal_name_first
          , w.associate_legal_name_middle
          , w.associate_legal_name_last
          , w.associate_legal_name_full
          , w.associate_preferred_name
          , w.associate_legal_name_suffix
          , w.associate_birth_date
          , w.associate_gender_code
          , w.associate_gender_name
          , w.associate_personal_email
          , w.associate_personal_phone
          , w.associate_personal_cell_phone
          , w.associate_legal_address_line1
          , w.associate_legal_address_line2
          , w.associate_legal_address_city
          , w.associate_legal_address_state_abb
          , w.associate_legal_address_state
          , w.associate_legal_address_zip_code
          , w.associate_legal_address_country
          , w.associate_other_address_line1
          , w.associate_other_address_line2
          , w.associate_other_address_city
          , w.associate_other_address_state_abb
          , w.associate_other_address_state
          , w.associate_other_address_zip_code
          , w.associate_other_address_country
          , w.associate_eeo_ethnicity
          , w.associate_eeo_identification_method
          , w.associate_education
          , w.associate_work_email
          , w.associate_work_phone
          , w.associate_work_cell_phone
          , w.associate_original_hire_date
          , w.associate_rehire_date
          , w.associate_final_termination_date
          , w.position_company_code
          , w.position_status_code
          , w.position_status
          , w.position_seniority_hire_date
          , w.position_start_date
          , w.position_termination_date
          , w.position_change_reason
          , w.position_manager_position_id
          , w.position_manager_name
          , w.position_primary_job_indicator
          , w.position_title_code
          , w.position_title
          , w.position_worker_type
          , w.position_benefits_group_code
          , w.position_benefits_group_class
          , w.position_flsa
          , w.position_full_time_equivalent
          , w.position_scheduled_hours
          , w.position_standard_hours
          , w.position_work_site_location_code
          , w.position_work_site_location_name
          , w.position_work_site_address_line1
          , w.position_work_site_address_line2
          , w.position_work_site_address_line3
          , w.position_work_site_address_city
          , w.position_work_site_address_state_abb
          , w.position_work_site_address_state
          , w.position_work_site_address_zip_code
          , w.position_work_site_address_country
          , w.home_organizational_units
          , w.home_organizational_units_market_code
          , w.home_organizational_units_market_name_1
          , w.home_organizational_units_market_name_2
          , w.home_organizational_units_department_code
          , w.home_organizational_units_department_name_1
          , w.home_organizational_units_department_name_2
          , w.home_organizational_units_cost_num
          , w.position_cost_num_legal_code
          , w.position_cost_num_region_code
          , w.position_cost_num_market_code
          , w.position_cost_num_location_code
          , w.position_cost_num_team_code
          , w.position_cost_num_natural_account
          , w.position_cost_num_category
          , w.occupational_classifications
          , w.occupational_classifications_eeo_code
          , w.occupational_classifications_eeo_class_p2
          , w.occupational_classifications_eeo_class_p1
          , w.occupational_classifications_class_code
          , w.occupational_classifications_class
          , w.position_eeo_class
          , w.position_region_name
          , w.position_region_code
          , w.position_region_description
          , w.position_department_name
          , w.position_market_name
          , 0::int                               as is_deleted
        from cte_employees_final a
        join cte_employees_all     w
                 on a.employee_id = w.employee_id
                 and a.effective_at = w.effective_at
        where true
          and a.is_exist = 1

        union all

        /* Add employee records which are no longer in the source data
           but that we want to see in subsequent datasets. See the
           data_last_refreshed_date field. This also accounts for records
           that only temporarily disappeared. */

        select
            a.effective_at::timestamp            as effective_at
          , a.prior_effective_at::date           as data_last_refreshed_date

          , w.associate_id
          , a.employee_id
          , w.payroll_file_number
          , w.position_id
          , w.employment_status
          , w.job_function_code
          , w.change_reason_code
          , w.change_reason_description
          , w.vol_invol
          , w.reporting_office
          , w.hire_details
          , w.source
          , w.associate_legal_name_first
          , w.associate_legal_name_middle
          , w.associate_legal_name_last
          , w.associate_legal_name_full
          , w.associate_preferred_name
          , w.associate_legal_name_suffix
          , w.associate_birth_date
          , w.associate_gender_code
          , w.associate_gender_name
          , w.associate_personal_email
          , w.associate_personal_phone
          , w.associate_personal_cell_phone
          , w.associate_legal_address_line1
          , w.associate_legal_address_line2
          , w.associate_legal_address_city
          , w.associate_legal_address_state_abb
          , w.associate_legal_address_state
          , w.associate_legal_address_zip_code
          , w.associate_legal_address_country
          , w.associate_other_address_line1
          , w.associate_other_address_line2
          , w.associate_other_address_city
          , w.associate_other_address_state_abb
          , w.associate_other_address_state
          , w.associate_other_address_zip_code
          , w.associate_other_address_country
          , w.associate_eeo_ethnicity
          , w.associate_eeo_identification_method
          , w.associate_education
          , w.associate_work_email
          , w.associate_work_phone
          , w.associate_work_cell_phone
          , w.associate_original_hire_date
          , w.associate_rehire_date
          , w.associate_final_termination_date
          , w.position_company_code
          , w.position_status_code
          , w.position_status
          , w.position_seniority_hire_date
          , w.position_start_date
          , w.position_termination_date
          , w.position_change_reason
          , w.position_manager_position_id
          , w.position_manager_name
          , w.position_primary_job_indicator
          , w.position_title_code
          , w.position_title
          , w.position_worker_type
          , w.position_benefits_group_code
          , w.position_benefits_group_class
          , w.position_flsa
          , w.position_full_time_equivalent
          , w.position_scheduled_hours
          , w.position_standard_hours
          , w.position_work_site_location_code
          , w.position_work_site_location_name
          , w.position_work_site_address_line1
          , w.position_work_site_address_line2
          , w.position_work_site_address_line3
          , w.position_work_site_address_city
          , w.position_work_site_address_state_abb
          , w.position_work_site_address_state
          , w.position_work_site_address_zip_code
          , w.position_work_site_address_country
          , w.home_organizational_units
          , w.home_organizational_units_market_code
          , w.home_organizational_units_market_name_1
          , w.home_organizational_units_market_name_2
          , w.home_organizational_units_department_code
          , w.home_organizational_units_department_name_1
          , w.home_organizational_units_department_name_2
          , w.home_organizational_units_cost_num
          , w.position_cost_num_legal_code
          , w.position_cost_num_region_code
          , w.position_cost_num_market_code
          , w.position_cost_num_location_code
          , w.position_cost_num_team_code
          , w.position_cost_num_natural_account
          , w.position_cost_num_category
          , w.occupational_classifications
          , w.occupational_classifications_eeo_code
          , w.occupational_classifications_eeo_class_p2
          , w.occupational_classifications_eeo_class_p1
          , w.occupational_classifications_class_code
          , w.occupational_classifications_class
          , w.position_eeo_class
          , w.position_region_name
          , w.position_region_code
          , w.position_region_description
          , w.position_department_name
          , w.position_market_name
          , 0::int                               as is_deleted
        from cte_employees_final  a
        left join cte_employees_all w
          on a.employee_id = w.employee_id
          and a.prior_effective_at = w.effective_at
        where true
          and a.is_exist = 0
)
,cte_final_with_manual as
(
  /* All records from adp history json data.
     Layers any overrides provided by HR via box file. */
    select
        e.effective_at

      , e.associate_id
      , e.employee_id
      -- There are a few cases where employee_num is not populated even though there is a position_id. Parse that id if necessary.
      , case
            when lower(eo.employee_num) = 'null' then null
            else coalesce(eo.employee_num, e.payroll_file_number, right(left(e.position_id, 9),6)) end                                                   as employee_num
      , e.position_id
      , e.data_last_refreshed_date
      , case when lower(eo.employment_status) = 'null' then null else coalesce(eo.employment_status::text, e.employment_status) end as employment_status
      , case when lower(eo.job_function_code) = 'null' then null else coalesce(eo.job_function_code::text, e.job_function_code) end as job_function_code
      , case when lower(eo.change_reason_code) = 'null' then null else coalesce(eo.change_reason_code::text, e.change_reason_code) end as change_reason_code
      , case when lower(eo.change_reason_description) = 'null' then null else coalesce(eo.change_reason_description::text, e.change_reason_description) end as change_reason_description
      , case when lower(eo.vol_invol) = 'null' then null else coalesce(eo.vol_invol::text, e.vol_invol) end as vol_invol
      , case when lower(eo.reporting_office) = 'null' then null else coalesce(eo.reporting_office::text, e.reporting_office) end as reporting_office
      , case when lower(eo.hire_details) = 'null' then null else coalesce(eo.hire_details::text, e.hire_details) end as hire_details
      , case when lower(eo.source) = 'null' then null else coalesce(eo.source::text, e.source) end as source
      , case when lower(eo.associate_legal_name_first) = 'null' then null else coalesce(eo.associate_legal_name_first::text, e.associate_legal_name_first) end as associate_legal_name_first
      , case when lower(eo.associate_legal_name_middle) = 'null' then null else coalesce(eo.associate_legal_name_middle::text, e.associate_legal_name_middle) end as associate_legal_name_middle
      , case when lower(eo.associate_legal_name_last) = 'null' then null else coalesce(eo.associate_legal_name_last::text, e.associate_legal_name_last) end as associate_legal_name_last
      , case when lower(eo.associate_legal_name_full) = 'null' then null else coalesce(eo.associate_legal_name_full::text, e.associate_legal_name_full) end as associate_legal_name_full
      , case when lower(eo.associate_preferred_name) = 'null' then null else coalesce(eo.associate_preferred_name::text, e.associate_preferred_name) end as associate_preferred_name
      , case when lower(eo.associate_legal_name_suffix) = 'null' then null else coalesce(eo.associate_legal_name_suffix::text, e.associate_legal_name_suffix) end as associate_legal_name_suffix
      , case when lower(eo.associate_birth_date) = 'null' then null else coalesce(eo.associate_birth_date::text, max(e.associate_birth_date) over(partition by e.employee_id)) end::date as associate_birth_date
      , case when lower(eo.associate_gender_code) = 'null' then null else coalesce(eo.associate_gender_code::text, e.associate_gender_code) end as associate_gender_code
      , case when lower(eo.associate_gender_name) = 'null' then null else coalesce(eo.associate_gender_name::text, e.associate_gender_name) end as associate_gender_name
      , case when lower(eo.associate_personal_email) = 'null' then null else coalesce(eo.associate_personal_email::text, e.associate_personal_email) end as associate_personal_email
      , case when lower(eo.associate_personal_phone) = 'null' then null else coalesce(eo.associate_personal_phone::text, e.associate_personal_phone) end as associate_personal_phone
      , case when lower(eo.associate_personal_cell_phone) = 'null' then null else coalesce(eo.associate_personal_cell_phone::text, e.associate_personal_cell_phone) end as associate_personal_cell_phone
      , case when lower(eo.associate_legal_address_line1) = 'null' then null else coalesce(eo.associate_legal_address_line1::text, e.associate_legal_address_line1) end as associate_legal_address_line1
      , case when lower(eo.associate_legal_address_line2) = 'null' then null else coalesce(eo.associate_legal_address_line2::text, e.associate_legal_address_line2) end as associate_legal_address_line2
      , case when lower(eo.associate_legal_address_city) = 'null' then null else coalesce(eo.associate_legal_address_city::text, e.associate_legal_address_city) end as associate_legal_address_city
      , case when lower(eo.associate_legal_address_state_abb) = 'null' then null else coalesce(eo.associate_legal_address_state_abb::text, e.associate_legal_address_state_abb) end as associate_legal_address_state_abb
      , case when lower(eo.associate_legal_address_state) = 'null' then null else coalesce(eo.associate_legal_address_state::text, e.associate_legal_address_state) end as associate_legal_address_state
      , case when lower(eo.associate_legal_address_zip_code) = 'null' then null else coalesce(eo.associate_legal_address_zip_code::text, e.associate_legal_address_zip_code) end as associate_legal_address_zip_code
      , case when lower(eo.associate_legal_address_country) = 'null' then null else coalesce(eo.associate_legal_address_country::text, e.associate_legal_address_country) end as associate_legal_address_country
      , case when lower(eo.associate_other_address_line1) = 'null' then null else coalesce(eo.associate_other_address_line1::text, e.associate_other_address_line1) end as associate_other_address_line1
      , case when lower(eo.associate_other_address_line2) = 'null' then null else coalesce(eo.associate_other_address_line2::text, e.associate_other_address_line2) end as associate_other_address_line2
      , case when lower(eo.associate_other_address_city) = 'null' then null else coalesce(eo.associate_other_address_city::text, e.associate_other_address_city) end as associate_other_address_city
      , case when lower(eo.associate_other_address_state_abb) = 'null' then null else coalesce(eo.associate_other_address_state_abb::text, e.associate_other_address_state_abb) end as associate_other_address_state_abb
      , case when lower(eo.associate_other_address_state) = 'null' then null else coalesce(eo.associate_other_address_state::text, e.associate_other_address_state) end as associate_other_address_state
      , case when lower(eo.associate_other_address_zip_code) = 'null' then null else coalesce(eo.associate_other_address_zip_code::text, e.associate_other_address_zip_code) end as associate_other_address_zip_code
      , case when lower(eo.associate_other_address_country) = 'null' then null else coalesce(eo.associate_other_address_country::text, e.associate_other_address_country) end as associate_other_address_country
      , case when lower(eo.associate_eeo_ethnicity) = 'null' then null else coalesce(eo.associate_eeo_ethnicity::text, e.associate_eeo_ethnicity) end as associate_eeo_ethnicity
      , case when lower(eo.associate_eeo_identification_method) = 'null' then null else coalesce(eo.associate_eeo_identification_method::text, e.associate_eeo_identification_method) end as associate_eeo_identification_method
      , case when lower(eo.associate_education) = 'null' then null else coalesce(eo.associate_education::text, e.associate_education) end as associate_education
      , case when lower(eo.associate_work_email) = 'null' then null else coalesce(eo.associate_work_email::text, e.associate_work_email) end as associate_work_email
      , case when lower(eo.associate_work_phone) = 'null' then null else coalesce(eo.associate_work_phone::text, e.associate_work_phone) end as associate_work_phone
      , case when lower(eo.associate_work_cell_phone) = 'null' then null else coalesce(eo.associate_work_cell_phone::text, e.associate_work_cell_phone) end as associate_work_cell_phone
      , case when lower(eo.associate_original_hire_date) = 'null' then null else coalesce(eo.associate_original_hire_date::text, e.associate_original_hire_date) end::date as associate_original_hire_date
      , case when lower(eo.associate_rehire_date) = 'null' then null else coalesce(eo.associate_rehire_date::text, e.associate_rehire_date) end::date as associate_rehire_date
      , case when lower(eo.associate_final_termination_date) = 'null' then null else coalesce(eo.associate_final_termination_date::text, e.associate_final_termination_date) end::date as associate_final_termination_date
      , case when lower(eo.position_company_code) = 'null' then null else coalesce(eo.position_company_code::text, e.position_company_code) end as position_company_code
      , case when lower(eo.position_status_code) = 'null' then null else coalesce(eo.position_status_code::text, e.position_status_code) end as position_status_code
      , case when lower(eo.position_status) = 'null' then null else coalesce(eo.position_status::text, e.position_status) end as position_status
      , case when lower(eo.position_seniority_hire_date) = 'null' then null else coalesce(eo.position_seniority_hire_date::text, e.position_seniority_hire_date) end::date as position_seniority_hire_date
      , case when lower(eo.position_start_date) = 'null' then null else coalesce(eo.position_start_date::text, e.position_start_date) end::date as position_start_date
      , case when lower(eo.position_termination_date) = 'null' then null else coalesce(eo.position_termination_date::text, e.position_termination_date) end::date as position_termination_date
      , case when lower(eo.position_change_reason) = 'null' then null else coalesce(eo.position_change_reason::text, e.position_change_reason) end as position_change_reason
      , case when lower(eo.position_manager_position_id) = 'null' then null else coalesce(eo.position_manager_position_id::text, e.position_manager_position_id) end as position_manager_position_id
      , case when lower(eo.position_manager_name) = 'null' then null else coalesce(eo.position_manager_name::text, e.position_manager_name) end as position_manager_name
      , case when lower(eo.position_primary_job_indicator) = 'null' then null else coalesce(eo.position_primary_job_indicator::text, e.position_primary_job_indicator) end::int as position_primary_job_indicator
      , case when lower(eo.position_title_code) = 'null' then null else coalesce(eo.position_title_code::text, e.position_title_code) end as position_title_code
      , case when lower(eo.position_title) = 'null' then null else coalesce(eo.position_title::text, e.position_title) end as position_title
      , case when lower(eo.position_worker_type) = 'null' then null else coalesce(eo.position_worker_type::text, e.position_worker_type) end as position_worker_type
      , case when lower(eo.position_benefits_group_code) = 'null' then null else coalesce(eo.position_benefits_group_code::text, e.position_benefits_group_code) end as position_benefits_group_code
      , case when lower(eo.position_benefits_group_class) = 'null' then null else coalesce(eo.position_benefits_group_class::text, e.position_benefits_group_class) end as position_benefits_group_class
      , case when lower(eo.position_flsa) = 'null' then null else coalesce(eo.position_flsa::text, e.position_flsa) end as position_flsa
      , case when lower(eo.position_full_time_equivalent) = 'null' then null else coalesce(eo.position_full_time_equivalent::text, e.position_full_time_equivalent) end as position_full_time_equivalent
      , case when lower(eo.position_scheduled_hours) = 'null' then null else coalesce(eo.position_scheduled_hours::text, e.position_scheduled_hours) end as position_scheduled_hours
      , case when lower(eo.position_standard_hours) = 'null' then null else coalesce(eo.position_standard_hours::text, e.position_standard_hours) end as position_standard_hours
      , case when lower(eo.position_work_site_location_code) = 'null' then null else coalesce(eo.position_work_site_location_code::text, e.position_work_site_location_code) end as position_work_site_location_code
      , case when lower(eo.position_work_site_location_name) = 'null' then null else coalesce(eo.position_work_site_location_name::text, e.position_work_site_location_name) end as position_work_site_location_name
      , case when lower(eo.position_work_site_address_line1) = 'null' then null else coalesce(eo.position_work_site_address_line1::text, e.position_work_site_address_line1) end as position_work_site_address_line1
      , case when lower(eo.position_work_site_address_line2) = 'null' then null else coalesce(eo.position_work_site_address_line2::text, e.position_work_site_address_line2) end as position_work_site_address_line2
      , case when lower(eo.position_work_site_address_line3) = 'null' then null else coalesce(eo.position_work_site_address_line3::text, e.position_work_site_address_line3) end as position_work_site_address_line3
      , case when lower(eo.position_work_site_address_city) = 'null' then null else coalesce(eo.position_work_site_address_city::text, e.position_work_site_address_city) end as position_work_site_address_city
      , case when lower(eo.position_work_site_address_state_abb) = 'null' then null else coalesce(eo.position_work_site_address_state_abb::text, e.position_work_site_address_state_abb) end as position_work_site_address_state_abb
      , case when lower(eo.position_work_site_address_state) = 'null' then null else coalesce(eo.position_work_site_address_state::text, e.position_work_site_address_state) end as position_work_site_address_state
      , case when lower(eo.position_work_site_address_zip_code) = 'null' then null else coalesce(eo.position_work_site_address_zip_code::text, e.position_work_site_address_zip_code) end as position_work_site_address_zip_code
      , case when lower(eo.position_work_site_address_country) = 'null' then null else coalesce(eo.position_work_site_address_country::text, e.position_work_site_address_country) end as position_work_site_address_country
      , case when lower(eo.home_organizational_units) = 'null' then null else coalesce(eo.home_organizational_units::text, e.home_organizational_units) end as home_organizational_units
      , case when lower(eo.home_organizational_units_market_code) = 'null' then null else coalesce(eo.home_organizational_units_market_code::text, e.home_organizational_units_market_code) end as home_organizational_units_market_code
      , case when lower(eo.home_organizational_units_market_name_1) = 'null' then null else coalesce(eo.home_organizational_units_market_name_1::text, e.home_organizational_units_market_name_1) end as home_organizational_units_market_name_1
      , case when lower(eo.home_organizational_units_market_name_2) = 'null' then null else coalesce(eo.home_organizational_units_market_name_2::text, e.home_organizational_units_market_name_2) end as home_organizational_units_market_name_2
      , case when lower(eo.home_organizational_units_department_code) = 'null' then null else coalesce(eo.home_organizational_units_department_code::text, e.home_organizational_units_department_code) end as home_organizational_units_department_code
      , case when lower(eo.home_organizational_units_department_name_1) = 'null' then null else coalesce(eo.home_organizational_units_department_name_1::text, e.home_organizational_units_department_name_1) end as home_organizational_units_department_name_1
      , case when lower(eo.home_organizational_units_department_name_2) = 'null' then null else coalesce(eo.home_organizational_units_department_name_2::text, e.home_organizational_units_department_name_2) end as home_organizational_units_department_name_2
      , case when lower(eo.home_organizational_units_cost_num) = 'null' then null else coalesce(eo.home_organizational_units_cost_num::text, e.home_organizational_units_cost_num) end as home_organizational_units_cost_num
      , case when lower(eo.position_cost_num_legal_code) = 'null' then null else coalesce(eo.position_cost_num_legal_code::text, e.position_cost_num_legal_code) end as position_cost_num_legal_code
      , case when lower(eo.position_cost_num_region_code) = 'null' then null else coalesce(eo.position_cost_num_region_code::text, e.position_cost_num_region_code) end as position_cost_num_region_code
      , case when lower(eo.position_cost_num_market_code) = 'null' then null else coalesce(eo.position_cost_num_market_code::text, e.position_cost_num_market_code) end as position_cost_num_market_code
      , case when lower(eo.position_cost_num_location_code) = 'null' then null else coalesce(eo.position_cost_num_location_code::text, e.position_cost_num_location_code) end as position_cost_num_location_code
      , case when lower(eo.position_cost_num_team_code) = 'null' then null else coalesce(eo.position_cost_num_team_code::text, e.position_cost_num_team_code) end as position_cost_num_team_code
      , case when lower(eo.position_cost_num_natural_account) = 'null' then null else coalesce(eo.position_cost_num_natural_account::text, e.position_cost_num_natural_account) end as position_cost_num_natural_account
      , case when lower(eo.position_cost_num_category) = 'null' then null else coalesce(eo.position_cost_num_category::text, e.position_cost_num_category) end as position_cost_num_category
      , case when lower(eo.occupational_classifications) = 'null' then null else coalesce(eo.occupational_classifications::text, e.occupational_classifications) end as occupational_classifications
      , case when lower(eo.occupational_classifications_eeo_code) = 'null' then null else coalesce(eo.occupational_classifications_eeo_code::text, e.occupational_classifications_eeo_code) end as occupational_classifications_eeo_code
      , case when lower(eo.occupational_classifications_eeo_class_p2) = 'null' then null else coalesce(eo.occupational_classifications_eeo_class_p2::text, e.occupational_classifications_eeo_class_p2) end as occupational_classifications_eeo_class_p2
      , case when lower(eo.occupational_classifications_eeo_class_p1) = 'null' then null else coalesce(eo.occupational_classifications_eeo_class_p1::text, e.occupational_classifications_eeo_class_p1) end as occupational_classifications_eeo_class_p1
      , case when lower(eo.occupational_classifications_class_code) = 'null' then null else coalesce(eo.occupational_classifications_class_code::text, e.occupational_classifications_class_code) end as occupational_classifications_class_code
      , case when lower(eo.occupational_classifications_class) = 'null' then null else coalesce(eo.occupational_classifications_class::text, e.occupational_classifications_class) end as occupational_classifications_class
      , case when lower(eo.position_eeo_class) = 'null' then null else coalesce(eo.position_eeo_class::text, e.position_eeo_class) end as position_eeo_class
      , case when lower(eo.position_region_name) = 'null' then null else coalesce(eo.position_region_name::text, e.position_region_name) end as position_region_name
      , case when lower(eo.position_region_code) = 'null' then null else coalesce(eo.position_region_code::text, e.position_region_code) end as position_region_code
      , case when lower(eo.position_region_description) = 'null' then null else coalesce(eo.position_region_description::text, e.position_region_description) end as position_region_description
      , case when lower(eo.position_department_name) = 'null' then null else coalesce(eo.position_department_name::text, e.position_department_name) end as position_department_name
      , case when lower(eo.position_market_name) = 'null' then null else coalesce(eo.position_market_name::text, e.position_market_name) end as position_market_name
      , coalesce(eo.is_deleted::int, e.is_deleted)                                                                      as is_deleted
      , 'adp'                                                                                                           as record_source
      , null as overrides
    from cte_final                                        e
    left join {{ ref('aux__base_employee_overrides') }} eo
        on e.position_id = eo.position_id
        and e.effective_at::date between nvl(eo.start_date::text::date, e.effective_at::date) and nvl(eo.end_date::text::date, e.effective_at::date)

    union all

    /* Adds manual records provided by HR via box file. */
    select
         d.effective_at
        , eo.associate_id::varchar(40)          as associate_id
        , eo.employee_id::varchar(40)           as employee_id
        , eo.employee_num
        , eo.position_id::varchar(40)           as position_id
        , current_date() as  data_last_refreshed_date
        , eo.employment_status
        , eo.job_function_code
        , eo.change_reason_code
        , eo.change_reason_description
        , eo.vol_invol
        , eo.reporting_office
        , eo.hire_details
        , eo.source
        , eo.associate_legal_name_first
        , eo.associate_legal_name_middle
        , eo.associate_legal_name_last
        , eo.associate_legal_name_full
        , eo.associate_preferred_name
        , eo.associate_legal_name_suffix
        , eo.associate_birth_date
        , eo.associate_gender_code
        , eo.associate_gender_name
        , eo.associate_personal_email
        , eo.associate_personal_phone
        , eo.associate_personal_cell_phone
        , eo.associate_legal_address_line1
        , eo.associate_legal_address_line2
        , eo.associate_legal_address_city
        , eo.associate_legal_address_state_abb
        , eo.associate_legal_address_state
        , eo.associate_legal_address_zip_code
        , eo.associate_legal_address_country
        , eo.associate_other_address_line1
        , eo.associate_other_address_line2
        , eo.associate_other_address_city
        , eo.associate_other_address_state_abb
        , eo.associate_other_address_state
        , eo.associate_other_address_zip_code
        , eo.associate_other_address_country
        , eo.associate_eeo_ethnicity
        , eo.associate_eeo_identification_method
        , eo.associate_education
        , eo.associate_work_email
        , eo.associate_work_phone
        , eo.associate_work_cell_phone
        , eo.associate_original_hire_date
        , eo.associate_rehire_date
        , eo.associate_final_termination_date
        , eo.position_company_code
        , eo.position_status_code
        , eo.position_status
        , eo.position_seniority_hire_date
        , eo.position_start_date
        , eo.position_termination_date
        , eo.position_change_reason
        , eo.position_manager_position_id
        , eo.position_manager_name
        , eo.position_primary_job_indicator
        , eo.position_title_code
        , eo.position_title
        , eo.position_worker_type
        , eo.position_benefits_group_code
        , eo.position_benefits_group_class
        , eo.position_flsa
        , eo.position_full_time_equivalent
        , eo.position_scheduled_hours
        , eo.position_standard_hours
        , eo.position_work_site_location_code
        , eo.position_work_site_location_name
        , eo.position_work_site_address_line1
        , eo.position_work_site_address_line2
        , eo.position_work_site_address_line3
        , eo.position_work_site_address_city
        , eo.position_work_site_address_state_abb
        , eo.position_work_site_address_state
        , eo.position_work_site_address_zip_code
        , eo.position_work_site_address_country
        , eo.home_organizational_units
        , eo.home_organizational_units_market_code
        , eo.home_organizational_units_market_name_1
        , eo.home_organizational_units_market_name_2
        , eo.home_organizational_units_department_code
        , eo.home_organizational_units_department_name_1
        , eo.home_organizational_units_department_name_2
        , eo.home_organizational_units_cost_num
        , eo.position_cost_num_legal_code
        , eo.position_cost_num_region_code
        , eo.position_cost_num_market_code
        , eo.position_cost_num_location_code
        , eo.position_cost_num_team_code
        , eo.position_cost_num_natural_account
        , eo.position_cost_num_category
        , eo.occupational_classifications
        , eo.occupational_classifications_eeo_code
        , eo.occupational_classifications_eeo_class_p2
        , eo.occupational_classifications_eeo_class_p1
        , eo.occupational_classifications_class_code
        , eo.occupational_classifications_class
        , eo.position_eeo_class
        , eo.position_department_name
        , eo.position_market_name
        , eo.position_region_code
        , eo.position_region_description
        , eo.position_region_name
        , 0::int                               as is_deleted
        , 'manual'                             as record_source
        , null as overrides
    from {{ ref('aux__base_employee_overrides') }} eo
    left join cte_final e
        on eo.position_id = e.position_id
    cross join cte_dates d
    where true
        and e.employee_id is null
        and d.effective_at::date between nvl(eo.start_date::date, (select min(effective_at::date) from cte_dates)) and nvl(eo.end_date::date, (select max(effective_at::date) from cte_dates))


    --{# union all #}
    /* Add records from historical sql server that don't exist in adp data anymore.
       We'll use the replicated data from sql server to determine which ones are missing. */

)

/* Get all the dates that are missing from the data because we didn't load from ADP that day.
   We want to fill in the dates using the latest available data. */
,cte_missing_dates as
(
    select distinct d.date_key
    from {{ ref('dates') }} d
    left join (
        select effective_at::date as effective_date
        from cte_final_with_manual
        group by 1
        ) e
        on d.date_key = e.effective_date
    where true
        and e.effective_date is null
        and d.date_key = last_day(d.date_key) -- limit to month end dates for now
        and d.date_key between (select min(effective_at::date) from cte_dates) and (select max(effective_at::date) from cte_dates)
)

/* Get the most recent available dataset for each missing month end date */
,cte_missing_dates_mapped as
(
    select
        d.date_key, e.effective_at, row_number() over(partition by d.date_key order by e.effective_at desc) as rn
    from cte_dates e
    cross join cte_missing_dates d
    where e.effective_at::date < d.date_key
    order by d.date_key, e.effective_at desc
)
,cte_final_with_manual_and_missing_dates as
(
    select *
    from cte_final_with_manual

    union all

    select
        d.date_key::timestamp       as effective_at
        , e.associate_id
        , e.employee_id
        , e.employee_num
        , e.position_id
        , e.data_last_refreshed_date
        , e.employment_status
        , e.job_function_code
        , e.change_reason_code
        , e.change_reason_description
        , e.vol_invol
        , e.reporting_office
        , e.hire_details
        , e.source
        , e.associate_legal_name_first
        , e.associate_legal_name_middle
        , e.associate_legal_name_last
        , e.associate_legal_name_full
        , e.associate_preferred_name
        , e.associate_legal_name_suffix
        , e.associate_birth_date
        , e.associate_gender_code
        , e.associate_gender_name
        , e.associate_personal_email
        , e.associate_personal_phone
        , e.associate_personal_cell_phone
        , e.associate_legal_address_line1
        , e.associate_legal_address_line2
        , e.associate_legal_address_city
        , e.associate_legal_address_state_abb
        , e.associate_legal_address_state
        , e.associate_legal_address_zip_code
        , e.associate_legal_address_country
        , e.associate_other_address_line1
        , e.associate_other_address_line2
        , e.associate_other_address_city
        , e.associate_other_address_state_abb
        , e.associate_other_address_state
        , e.associate_other_address_zip_code
        , e.associate_other_address_country
        , e.associate_eeo_ethnicity
        , e.associate_eeo_identification_method
        , e.associate_education
        , e.associate_work_email
        , e.associate_work_phone
        , e.associate_work_cell_phone
        , e.associate_original_hire_date
        , e.associate_rehire_date
        , e.associate_final_termination_date
        , e.position_company_code
        , e.position_status_code
        , e.position_status
        , e.position_seniority_hire_date
        , e.position_start_date
        , e.position_termination_date
        , e.position_change_reason
        , e.position_manager_position_id
        , e.position_manager_name
        , e.position_primary_job_indicator
        , e.position_title_code
        , e.position_title
        , e.position_worker_type
        , e.position_benefits_group_code
        , e.position_benefits_group_class
        , e.position_flsa
        , e.position_full_time_equivalent
        , e.position_scheduled_hours
        , e.position_standard_hours
        , e.position_work_site_location_code
        , e.position_work_site_location_name
        , e.position_work_site_address_line1
        , e.position_work_site_address_line2
        , e.position_work_site_address_line3
        , e.position_work_site_address_city
        , e.position_work_site_address_state_abb
        , e.position_work_site_address_state
        , e.position_work_site_address_zip_code
        , e.position_work_site_address_country
        , e.home_organizational_units
        , e.home_organizational_units_market_code
        , e.home_organizational_units_market_name_1
        , e.home_organizational_units_market_name_2
        , e.home_organizational_units_department_code
        , e.home_organizational_units_department_name_1
        , e.home_organizational_units_department_name_2
        , e.home_organizational_units_cost_num
        , e.position_cost_num_legal_code
        , e.position_cost_num_region_code
        , e.position_cost_num_market_code
        , e.position_cost_num_location_code
        , e.position_cost_num_team_code
        , e.position_cost_num_natural_account
        , e.position_cost_num_category
        , e.occupational_classifications
        , e.occupational_classifications_eeo_code
        , e.occupational_classifications_eeo_class_p2
        , e.occupational_classifications_eeo_class_p1
        , e.occupational_classifications_class_code
        , e.occupational_classifications_class
        , e.position_eeo_class
        , e.position_department_name
        , e.position_market_name
        , e.position_region_code
        , e.position_region_description
        , e.position_region_name
        , is_deleted
        , 'missing_filled_from_prior'                             as record_source
        , overrides
    from cte_final_with_manual         e
    join cte_missing_dates_mapped d
        on e.effective_at::date = d.effective_at::date
        and d.rn = 1
)

/* Bring it all together */
select
    'adp' as source_system
  , case when position_id is not null then last_day(effective_at) || '-' || position_id end as employee_reporting_id
  , case when lower(employment_status) = 'active' then 1 else 0 end::int                    as is_active
  , *
  , last_day(effective_at::date)                                                            as month_end_date
  , case
        when effective_at::date = last_day(effective_at::date) then 1
        else 0 end                                                                          as is_month_end
  , case
        when effective_at = (select max(effective_at) from cte_dates) then 1
        else 0 end                                                                          as is_head
  , current_timestamp()                                                                     as _created_at
from cte_final_with_manual_and_missing_dates
order by effective_at, employee_num

{% endif %}