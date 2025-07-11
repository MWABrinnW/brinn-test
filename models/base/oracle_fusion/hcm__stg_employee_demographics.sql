select
    effective_at                                                     as effective_at
    , nullif(trim(split(content , '|')[1]) , '')::varchar(200)       as oracle_employee_num
    , nullif(trim(split(content , '|')[2]) , '')::varchar(200)       as associate_id
    , nullif(trim(split(content , '|')[3]) , '')::varchar(200)       as employee_id
    , nullif(trim(split(content , '|')[4]) , '')::varchar(200)       as employee_num
    , nullif(trim(split(content , '|')[5]) , '')::varchar(200)       as employment_status
    , nullif(trim(split(content , '|')[6]) , '')::varchar(200)       as job_function_code
    , nullif(trim(split(content , '|')[7]) , '')::varchar(200)       as job_function_name
    , nullif(trim(split(content , '|')[8]) , '')::varchar(200)       as job_family
    , nullif(trim(split(content , '|')[9]) , '')::varchar(200)       as change_reason_code
    , nullif(trim(split(content , '|')[10]) , '')::varchar(200)      as change_reason_description
    , nullif(trim(split(content , '|')[11]) , '')::varchar(200)      as vol_invol_code
    , nullif(trim(split(content , '|')[12]) , '')::varchar(200)      as work_from_home
    , nullif(trim(split(content , '|')[13]) , '')::varchar(200)      as workplace
    , nullif(trim(split(content , '|')[14]) , '')::varchar(200)      as person_source
    , nullif(trim(split(content , '|')[15]) , '')::varchar(200)      as job_id
    , nullif(trim(split(content , '|')[16]) , '')::varchar(200)      as associate_legal_name_first
    , nullif(trim(split(content , '|')[17]) , '')::varchar(200)      as associate_legal_name_middle
    , nullif(trim(split(content , '|')[18]) , '')::varchar(200)      as associate_legal_name_last
    , nullif(trim(split(content , '|')[19]) , '')::varchar(200)      as associate_legal_name_full
    , nullif(trim(split(content , '|')[20]) , '')::varchar(200)      as associate_preferred_name
    , nullif(trim(split(content , '|')[21]) , '')::varchar(200)      as associate_legal_name_suffix
    , try_to_date(nullif(trim(split(content , '|')[22]) , ''))::date as associate_birth_date
    , nullif(trim(split(content , '|')[23]) , '')::varchar(200)      as associate_gender_code
    , nullif(trim(split(content , '|')[24]) , '')::varchar(200)      as associate_gender_name
    , nullif(trim(split(content , '|')[25]) , '')::varchar(200)      as associate_personal_email
    , nullif(trim(split(content , '|')[26]) , '')::varchar(200)      as associate_personal_phone
    , nullif(trim(split(content , '|')[27]) , '')::varchar(200)      as associate_personal_cell_phone
    , nullif(trim(split(content , '|')[28]) , '')::varchar(200)      as associate_legal_address_line1
    , nullif(trim(split(content , '|')[29]) , '')::varchar(200)      as associate_legal_address_line2
    , nullif(trim(split(content , '|')[30]) , '')::varchar(200)      as associate_legal_address_city
    , nullif(trim(split(content , '|')[31]) , '')::varchar(200)      as associate_legal_address_state_abb
    , nullif(trim(split(content , '|')[32]) , '')::varchar(200)      as associate_legal_address_state
    , nullif(trim(split(content , '|')[33]) , '')::varchar(200)      as associate_legal_address_zip_code
    , nullif(trim(split(content , '|')[34]) , '')::varchar(200)      as associate_legal_address_country
    , nullif(trim(split(content , '|')[35]) , '')::varchar(200)      as associate_other_address_line1
    , nullif(trim(split(content , '|')[36]) , '')::varchar(200)      as associate_other_address_line2
    , nullif(trim(split(content , '|')[37]) , '')::varchar(200)      as associate_other_address_city
    , nullif(trim(split(content , '|')[38]) , '')::varchar(200)      as associate_other_address_state_abb
    , nullif(trim(split(content , '|')[39]) , '')::varchar(200)      as associate_other_address_state
    , nullif(trim(split(content , '|')[40]) , '')::varchar(200)      as associate_other_address_zip_code
    , nullif(trim(split(content , '|')[41]) , '')::varchar(200)      as associate_other_address_country
    , nullif(trim(split(content , '|')[42]) , '')::varchar(200)      as associate_education
    , nullif(trim(split(content , '|')[43]) , '')::varchar(200)      as associate_work_email
    , nullif(trim(split(content , '|')[44]) , '')::varchar(200)      as associate_work_phone
    , nullif(trim(split(content , '|')[45]) , '')::varchar(200)      as associate_work_cell_phone
    , try_to_date(nullif(trim(split(content , '|')[46]) , ''))::date as associate_original_hire_date
    , try_to_date(nullif(trim(split(content , '|')[47]) , ''))::date as associate_rehire_date
    , try_to_date(nullif(trim(split(content , '|')[48]) , ''))::date as associate_final_termination_date
    , try_to_date(nullif(trim(split(content , '|')[49]) , ''))::date as position_seniority_hire_date
    , try_to_date(nullif(trim(split(content , '|')[50]) , ''))::date as position_start_date
    , nullif(trim(split(content , '|')[51]) , '')::varchar(200)      as position_manager_position_id
    , nullif(trim(split(content , '|')[52]) , '')::varchar(200)      as position_manager_name
    , nullif(trim(split(content , '|')[53]) , '')::varchar(200)      as position_primary_job_indicator
    , nullif(trim(split(content , '|')[54]) , '')::varchar(200)      as position_title_code
    , nullif(trim(split(content , '|')[55]) , '')::varchar(200)      as position_title
    , nullif(trim(split(content , '|')[56]) , '')::varchar(200)      as position_worker_type
    , nullif(trim(split(content , '|')[57]) , '')::varchar(200)      as advisor_nonadvisor
    , nullif(trim(split(content , '|')[58]) , '')::varchar(200)      as position_full_time_equivalent
    , nullif(trim(split(content , '|')[59]) , '')::varchar(200)      as position_work_site_location_code
    , nullif(trim(split(content , '|')[60]) , '')::varchar(200)      as position_work_site_location_name
    , nullif(trim(split(content , '|')[61]) , '')::varchar(200)      as position_work_site_location_real_estate_code
    , nullif(trim(split(content , '|')[62]) , '')::varchar(200)      as position_work_site_address_line1
    , nullif(trim(split(content , '|')[63]) , '')::varchar(200)      as position_work_site_address_line2
    , nullif(trim(split(content , '|')[64]) , '')::varchar(200)      as position_work_site_address_line3
    , nullif(trim(split(content , '|')[65]) , '')::varchar(200)      as position_work_site_address_city
    , nullif(trim(split(content , '|')[66]) , '')::varchar(200)      as position_work_site_address_state_abb
    , nullif(trim(split(content , '|')[67]) , '')::varchar(200)      as position_work_site_address_state
    , nullif(trim(split(content , '|')[68]) , '')::varchar(200)      as position_work_site_address_zip_code
    , nullif(trim(split(content , '|')[69]) , '')::varchar(200)      as position_work_site_address_country
    , nullif(trim(split(content , '|')[70]) , '')::varchar(200)      as cost_seg_1
    , nullif(trim(split(content , '|')[71]) , '')::varchar(200)      as cost_seg_2
    , nullif(trim(split(content , '|')[72]) , '')::varchar(200)      as cost_seg_3
    , nullif(trim(split(content , '|')[73]) , '')::varchar(200)      as cost_seg_4
    , nullif(trim(split(content , '|')[74]) , '')::varchar(200)      as cost_seg_6
    , nullif(trim(split(content , '|')[75]) , '')::varchar(200)      as job_level
    , nullif(trim(split(content , '|')[76]) , '')::varchar(200)      as position_department_name
    , nullif(trim(split(content , '|')[77]) , '')::varchar(200)      as ft_pt_temp
    , nullif(trim(split(content , '|')[78]) , '')::varchar(200)      as future_hire
    , {{ col_is_head(
        reference=source('oracle_hcm', 'hcm_employee_demographics'),
        source_date_col='effective_at',
        reference_date_col='effective_at'
        ) }}
    , case
        when dense_rank() over (
                partition by effective_at::date
                order by effective_at desc
            ) = 1
            then 1
        else 0
    end::int                                                         as is_head_for_day
    , _created_at                                                    as _created_at
    , _source_file                                                   as _source_file
from {{ source('oracle_hcm', 'hcm_employee_demographics') }}
where effective_at::date >= '2024-05-28'
