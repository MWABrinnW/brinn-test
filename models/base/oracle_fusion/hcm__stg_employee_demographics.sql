select
    nullif(replace(split(content , '|')[0] , '' , '') , '')::timestamp_ntz   as effective_at
    , nullif(replace(split(content , '|')[1] , '' , '') , '')::varchar(200)  as oracle_employee_num
    , nullif(replace(split(content , '|')[2] , '' , '') , '')::varchar(200)  as associate_id
    , nullif(replace(split(content , '|')[3] , '' , '') , '')::varchar(200)  as employee_id
    , nullif(replace(split(content , '|')[4] , '' , '') , '')::varchar(200)  as employee_num
    , nullif(replace(split(content , '|')[5] , '' , '') , '')::varchar(200)  as employment_status
    , nullif(replace(split(content , '|')[6] , '' , '') , '')::varchar(200)  as job_function_code
    , nullif(replace(split(content , '|')[7] , '' , '') , '')::varchar(200)  as job_function_name
    , nullif(replace(split(content , '|')[8] , '' , '') , '')::varchar(200)  as job_family
    , nullif(replace(split(content , '|')[9] , '' , '') , '')::varchar(200)  as change_reason_code
    , nullif(replace(split(content , '|')[10] , '' , '') , '')::varchar(200) as change_reason_description
    , nullif(replace(split(content , '|')[11] , '' , '') , '')::varchar(200) as vol_invol_code
    , nullif(replace(split(content , '|')[12] , '' , '') , '')::varchar(200) as work_from_home
    , nullif(replace(split(content , '|')[13] , '' , '') , '')::varchar(200) as workplace
    , nullif(replace(split(content , '|')[14] , '' , '') , '')::varchar(200) as person_source
    , nullif(replace(split(content , '|')[15] , '' , '') , '')::varchar(200) as job_id
    , nullif(replace(split(content , '|')[16] , '' , '') , '')::varchar(200) as associate_legal_name_first
    , nullif(replace(split(content , '|')[17] , '' , '') , '')::varchar(200) as associate_legal_name_middle
    , nullif(replace(split(content , '|')[18] , '' , '') , '')::varchar(200) as associate_legal_name_last
    , nullif(replace(split(content , '|')[19] , '' , '') , '')::varchar(200) as associate_legal_name_full
    , nullif(replace(split(content , '|')[20] , '' , '') , '')::varchar(200) as associate_preferred_name
    , nullif(replace(split(content , '|')[21] , '' , '') , '')::varchar(200) as associate_legal_name_suffix
    , nullif(replace(split(content , '|')[22] , '' , '') , '')::date         as associate_birth_date
    , nullif(replace(split(content , '|')[23] , '' , '') , '')::varchar(200) as associate_gender_code
    , nullif(replace(split(content , '|')[24] , '' , '') , '')::varchar(200) as associate_gender_name
    , nullif(replace(split(content , '|')[25] , '' , '') , '')::varchar(200) as associate_personal_email
    , nullif(replace(split(content , '|')[26] , '' , '') , '')::varchar(200) as associate_personal_phone
    , nullif(replace(split(content , '|')[27] , '' , '') , '')::varchar(200) as associate_personal_cell_phone
    , nullif(replace(split(content , '|')[28] , '' , '') , '')::varchar(200) as associate_legal_address_line1
    , nullif(replace(split(content , '|')[29] , '' , '') , '')::varchar(200) as associate_legal_address_line2
    , nullif(replace(split(content , '|')[30] , '' , '') , '')::varchar(200) as associate_legal_address_city
    , nullif(replace(split(content , '|')[31] , '' , '') , '')::varchar(200) as associate_legal_address_state_abb
    , nullif(replace(split(content , '|')[32] , '' , '') , '')::varchar(200) as associate_legal_address_state
    , nullif(replace(split(content , '|')[33] , '' , '') , '')::varchar(200) as associate_legal_address_zip_code
    , nullif(replace(split(content , '|')[34] , '' , '') , '')::varchar(200) as associate_legal_address_country
    , nullif(replace(split(content , '|')[35] , '' , '') , '')::varchar(200) as associate_other_address_line1
    , nullif(replace(split(content , '|')[36] , '' , '') , '')::varchar(200) as associate_other_address_line2
    , nullif(replace(split(content , '|')[37] , '' , '') , '')::varchar(200) as associate_other_address_city
    , nullif(replace(split(content , '|')[38] , '' , '') , '')::varchar(200) as associate_other_address_state_abb
    , nullif(replace(split(content , '|')[39] , '' , '') , '')::varchar(200) as associate_other_address_state
    , nullif(replace(split(content , '|')[40] , '' , '') , '')::varchar(200) as associate_other_address_zip_code
    , nullif(replace(split(content , '|')[41] , '' , '') , '')::varchar(200) as associate_other_address_country
    , nullif(replace(split(content , '|')[42] , '' , '') , '')::varchar(200) as associate_education
    , nullif(replace(split(content , '|')[43] , '' , '') , '')::varchar(200) as associate_work_email
    , nullif(replace(split(content , '|')[44] , '' , '') , '')::varchar(200) as associate_work_phone
    , nullif(replace(split(content , '|')[45] , '' , '') , '')::varchar(200) as associate_work_cell_phone
    , nullif(replace(split(content , '|')[46] , '' , '') , '')::date         as associate_original_hire_date
    , nullif(replace(split(content , '|')[47] , '' , '') , '')::date         as associate_rehire_date
    , nullif(replace(split(content , '|')[48] , '' , '') , '')::date         as associate_final_termination_date
    , nullif(replace(split(content , '|')[49] , '' , '') , '')::date         as position_seniority_hire_date
    , nullif(replace(split(content , '|')[50] , '' , '') , '')::date         as position_start_date
    , nullif(replace(split(content , '|')[51] , '' , '') , '')::varchar(200) as position_manager_position_id
    , nullif(replace(split(content , '|')[52] , '' , '') , '')::varchar(200) as position_manager_name
    , nullif(replace(split(content , '|')[53] , '' , '') , '')::varchar(200) as position_primary_job_indicator
    , nullif(replace(split(content , '|')[54] , '' , '') , '')::varchar(200) as position_title_code
    , nullif(replace(split(content , '|')[55] , '' , '') , '')::varchar(200) as position_title
    , nullif(replace(split(content , '|')[56] , '' , '') , '')::varchar(200) as position_worker_type
    , nullif(replace(split(content , '|')[57] , '' , '') , '')::varchar(200) as advisor_nonadvisor
    , nullif(replace(split(content , '|')[58] , '' , '') , '')::varchar(200) as position_full_time_equivalent
    , nullif(replace(split(content , '|')[59] , '' , '') , '')::varchar(200) as position_work_site_location_code
    , nullif(replace(split(content , '|')[60] , '' , '') , '')::varchar(200) as position_work_site_location_name
    , nullif(replace(split(content , '|')[61] , '' , '') , '')::varchar(200) as position_work_site_location_real_estate_code
    , nullif(replace(split(content , '|')[62] , '' , '') , '')::varchar(200) as position_work_site_address_line1
    , nullif(replace(split(content , '|')[63] , '' , '') , '')::varchar(200) as position_work_site_address_line2
    , nullif(replace(split(content , '|')[64] , '' , '') , '')::varchar(200) as position_work_site_address_line3
    , nullif(replace(split(content , '|')[65] , '' , '') , '')::varchar(200) as position_work_site_address_city
    , nullif(replace(split(content , '|')[66] , '' , '') , '')::varchar(200) as position_work_site_address_state_abb
    , nullif(replace(split(content , '|')[67] , '' , '') , '')::varchar(200) as position_work_site_address_state
    , nullif(replace(split(content , '|')[68] , '' , '') , '')::varchar(200) as position_work_site_address_zip_code
    , nullif(replace(split(content , '|')[69] , '' , '') , '')::varchar(200) as position_work_site_address_country
    , nullif(replace(split(content , '|')[70] , '' , '') , '')::varchar(200) as cost_seg_1
    , nullif(replace(split(content , '|')[71] , '' , '') , '')::varchar(200) as cost_seg_2
    , nullif(replace(split(content , '|')[72] , '' , '') , '')::varchar(200) as cost_seg_3
    , nullif(replace(split(content , '|')[73] , '' , '') , '')::varchar(200) as cost_seg_4
    , nullif(replace(split(content , '|')[74] , '' , '') , '')::varchar(200) as cost_seg_6
    , nullif(replace(split(content , '|')[75] , '' , '') , '')::varchar(200) as job_level
    , nullif(replace(split(content , '|')[76] , '' , '') , '')::varchar(200) as position_department_name
    , nullif(replace(split(content , '|')[77] , '' , '') , '')::varchar(200) as ft_pt_temp
    , nullif(replace(split(content , '|')[78] , '' , '') , '')::varchar(200) as future_hire
    --, effective_date                                                         as effective_date
    , {{ col_is_head(
        reference=source('oracle_hcm', 'hcm_employee_demographics'),
        source_date_col='effective_at',
        reference_date_col="nullif(replace(split(content , '|')[0] , '' , '') , '')::timestamp_ntz"
        ) }}
    , _created_at                                                            as _created_at
    , _source_file                                                           as _source_file
from {{ source('oracle_hcm', 'hcm_employee_demographics') }}
where effective_date >= '2024-05-28'
