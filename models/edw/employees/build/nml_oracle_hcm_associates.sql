{{ config(
    grants = {'select': ['engineering', 'security', 'datamanagement']}
) }}

select
    'oracle'                                                              as system_name
    , 'mwa'                                                               as system_instance
    , concat('oracle' , '__' , 'mwa')                                     as system_key
    , e.effective_at                                                      as effective_at
    , e.oracle_employee_num                                               as employee_num_source
    , e.oracle_employee_num                                               as employee_num
    , e.employee_num                                                      as employee_num_legacy
    , case
        when e.employment_status ilike 'inactive'
            then 'TERMINATED'
        when e.employment_status ilike 'suspended'
            then 'LEAVE'
        else upper(e.employment_status)
    end::text(200)                                                        as employment_status
    , e.job_function_code                                                 as job_function_code
    , e.job_function_name                                                 as job_function_name
    , e.job_family                                                        as job_family
    , e.change_reason_code                                                as change_reason_code
    , e.change_reason_description                                         as change_reason_description
    , e.vol_invol_code                                                    as vol_invol_code
    , e.work_from_home                                                    as work_from_home
    , e.workplace                                                         as workplace
    , e.person_source                                                     as person_source
    , e.job_id                                                            as job_id
    , e.associate_legal_name_first                                        as associate_legal_name_first
    , e.associate_legal_name_middle                                       as associate_legal_name_middle
    , e.associate_legal_name_last                                         as associate_legal_name_last
    , e.associate_legal_name_full                                         as associate_legal_name_full
    , e.associate_preferred_name                                          as associate_preferred_name
    , e.associate_legal_name_suffix                                       as associate_legal_name_suffix
    , e.associate_birth_date::date                                        as associate_birth_date
    , e.associate_gender_code                                             as associate_gender_code
    , e.associate_gender_name                                             as associate_gender_name
    , e.associate_personal_email                                          as associate_personal_email
    , e.associate_personal_phone                                          as associate_personal_phone
    , e.associate_personal_cell_phone                                     as associate_personal_cell_phone
    , e.associate_legal_address_line1                                     as associate_legal_address_line1
    , e.associate_legal_address_line2                                     as associate_legal_address_line2
    , e.associate_legal_address_city                                      as associate_legal_address_city
    , e.associate_legal_address_state_abb                                 as associate_legal_address_state_abb
    , e.associate_legal_address_state                                     as associate_legal_address_state
    , e.associate_legal_address_zip_code                                  as associate_legal_address_zip_code
    , e.associate_legal_address_country                                   as associate_legal_address_country
    , e.associate_other_address_line1                                     as associate_other_address_line1
    , e.associate_other_address_line2                                     as associate_other_address_line2
    , e.associate_other_address_city                                      as associate_other_address_city
    , e.associate_other_address_state_abb                                 as associate_other_address_state_abb
    , e.associate_other_address_state                                     as associate_other_address_state
    , e.associate_other_address_zip_code                                  as associate_other_address_zip_code
    , e.associate_other_address_country                                   as associate_other_address_country
    , e.associate_education                                               as associate_education
    , e.associate_work_email                                              as associate_work_email
    , coalesce(replace(zoom.number , '+1' , '') , e.associate_work_phone) as associate_work_phone
    , e.associate_work_cell_phone                                         as associate_work_cell_phone
    , e.associate_original_hire_date::date                                as associate_original_hire_date
    , e.associate_rehire_date::date                                       as associate_rehire_date
    , e.associate_final_termination_date::date                            as associate_final_termination_date
    , null::text(200)                                                     as position_id
    , e.position_seniority_hire_date::date                                as position_seniority_hire_date
    , e.position_start_date::date                                         as position_start_date
    , e.position_manager_position_id                                      as position_manager_position_id
    , e.position_manager_name                                             as position_manager_name
    -- These are manager assignments as reflected by the source ERP system.
    , man_e.associate_work_email                                          as position_manager_email
    , man_ad.distinguished_name                                           as position_manager_ad_distinguished_name
    , man_e.employee_num                                                  as position_manager_employee_num
    , e.position_primary_job_indicator                                    as position_primary_job_indicator
    , e.position_title_code                                               as position_title_code
    , e.position_title                                                    as position_title
    , e.position_worker_type                                              as position_worker_type
    , e.advisor_nonadvisor                                                as advisor_nonadvisor
    , e.position_full_time_equivalent                                     as position_full_time_equivalent
    , e.position_work_site_location_code                                  as position_work_site_location_code
    , e.position_work_site_location_name                                  as position_work_site_location_name
    , e.position_work_site_location_real_estate_code                      as position_work_site_location_real_estate_code
    , e.position_work_site_address_line1                                  as position_work_site_address_line1
    , e.position_work_site_address_line2                                  as position_work_site_address_line2
    , e.position_work_site_address_line3                                  as position_work_site_address_line3
    , e.position_work_site_address_city                                   as position_work_site_address_city
    , e.position_work_site_address_state_abb                              as position_work_site_address_state_abb
    , e.position_work_site_address_state                                  as position_work_site_address_state
    , e.position_work_site_address_zip_code                               as position_work_site_address_zip_code
    , e.position_work_site_address_country                                as position_work_site_address_country
    , e.cost_seg_1                                                        as cost_seg_1
    , e.cost_seg_2                                                        as cost_seg_2
    , e.cost_seg_3                                                        as cost_seg_3
    , e.cost_seg_4                                                        as cost_seg_4
    , e.cost_seg_6                                                        as cost_seg_6
    , e.job_level                                                         as job_level
    , e.position_department_name                                          as position_department_name
    , e.ft_pt_temp                                                        as ft_pt_temp
    , e.future_hire                                                       as future_hire

    , l.accounting_id                                                     as accounting_id
    , l.location_code                                                     as location_code
    , l.office_name                                                       as office_name
    , l.location_name                                                     as location_name
    , l.department                                                        as department
    , l.region_name                                                       as region_name
    , l.division                                                          as division

    -- [Active Directory]
    , case when ad.employee_number is not null then 1 else 0 end::int     as is_ad_linked
    , ad.distinguished_name                                               as ad_distinguished_name
    --, ad.othermobile                                                 as ad_other_mobile
    , ad.email                                                            as ad_email
    , ad.sam_account_name                                                 as ad_sam_account_name
    -- These are manager fields as currently reflected by the AD manager linking.
    , ad.manager_employeenumber                                           as ad_manager_employee_number
    , ad.manager_email                                                    as ad_manager_email
    , ad.manager_distinguishedname                                        as ad_manager_distinguishedname

    , e._created_at                                                       as _created_at
    , e._source_file                                                      as _source_file
    , e.is_head                                                           as is_head

    , object_construct_keep_null(
        'associate_id' , e.associate_id
        , 'employee_id' , e.employee_id
        , 'employee_num' , e.employee_num
    )                                                                     as _extra_fields
from {{ ref('hcm__stg_employee_demographics') }} as e
left join {{ ref('active_directory__rpt_users') }} as ad
    on upper(e.employee_num) = upper(ad.employee_number)
    and e.effective_at::date = ad._effective_at::date
left join {{ ref('zoom_mwa__base_user_phone_assignments') }} as zoom
    on lower(e.associate_work_email) = lower(zoom.email)
    and zoom.rn = 1
left join {{ ref('hcm__stg_employee_demographics') }} as man_e
    on e.effective_at = man_e.effective_at
    and e.position_manager_position_id = man_e.oracle_employee_num
left join {{ ref('active_directory__rpt_users') }} as man_ad
    on upper(man_e.oracle_employee_num) = upper(man_ad.employee_number)
    and man_e.effective_at::date = man_ad._effective_at::date
left join {{ ref('locations') }} as l
    on e.cost_seg_3 = l.accounting_id
    and e.effective_at::date between coalesce(l.start_date , e.effective_at::date) and coalesce(l.end_date , e.effective_at::date)
