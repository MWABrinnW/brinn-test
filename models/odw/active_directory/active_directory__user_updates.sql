{{ config(materialized='view') }}

with cte_bld_associates as (
    select
        system_key                                                          as system_key
        , effective_at                                                      as effective_at
        , employee_num                                                      as employee_num
        , associate_legal_name_full                                         as full_name
        , employment_status                                                 as employment_status
        -- EmployeeID
        , case
            when system_key = 'adp__mwa'
                then _extra_fields:employee_id
            when system_key = 'oracle__mwa'
                then _extra_fields:employee_id
        end::text(200)                                                      as employee_id
        -- Division
        , division                                                          as division
        -- AdminDescription
        , location_name                                                     as admin_description
        -- Company
        , location_name                                                     as company
        -- Department
        , position_department_name                                          as department
        -- Title
        , position_title                                                    as title
        -- PhysicalDeliveryOfficeName
        , trim(position_work_site_location_name)                            as physical_delivery_office_name
        -- Manager
        , position_manager_ad_distinguished_name                            as manager
        , position_manager_position_id
            as manager_position_id
        , position_manager_email                                            as manager_email
        -- StreetAddress
        , array_to_string(array_construct_compact(
            position_work_site_address_line1
            , position_work_site_address_line2
            , position_work_site_address_line3
        ) , ' ')                                                            as street_address
        -- L | City
        , position_work_site_address_city                                   as city
        -- St | State
        , position_work_site_address_state_abb                              as state
        -- PostalCode
        , position_work_site_address_zip_code                               as postal_code

        -- TelephoneNumber
        , regexp_replace(associate_work_phone , '[^0-9]' , '')              as office_phone_clean
        , case
            when len(office_phone_clean) = 10
                then '1-'
                    || substr(office_phone_clean , 1 , 3)
                    || '-'
                    || substr(office_phone_clean , 4 , 3)
                    || '-'
                    || substr(office_phone_clean , 7 , 4)
            when len(office_phone_clean) = 11
                then substr(office_phone_clean , 1 , 1)
                    || '-'
                    || substr(office_phone_clean , 2 , 3)
                    || '-'
                    || substr(office_phone_clean , 5 , 3)
                    || '-'
                    || substr(office_phone_clean , 8 , 4)
            else office_phone_clean
        end::text                                                           as office_phone
        -- OtherNumber
        , regexp_replace(
            coalesce(associate_personal_phone , associate_personal_cell_phone)
            , '[^0-9]'
            , ''
        )                                                                   as other_mobile_clean
        , case
            when len(other_mobile_clean) = 10
                then substr(other_mobile_clean , 1 , 3)
                    || '-'
                    || substr(other_mobile_clean , 4 , 3)
                    || '-'
                    || substr(other_mobile_clean , 7 , 4)
            when len(other_mobile_clean) = 11
                then substr(other_mobile_clean , 1 , 1)
                    || '-'
                    || substr(other_mobile_clean , 2 , 3)
                    || '-'
                    || substr(other_mobile_clean , 5 , 3)
                    || '-'
                    || substr(other_mobile_clean , 8 , 4)
            else other_mobile_clean
        end::text                                                           as other_mobile
        -- dateOfStart
        -- should this be seniority date?
        , nullif(to_char(associate_original_hire_date , 'MM/DD/YYYY') , '') as date_of_start
        -- dateOfBirth
        , to_char(associate_birth_date , 'MM/DD')                           as date_of_birth

        , position_id                                                       as position_id
        , case
            when (person_source ilike 'Acquisition - Woodbridge' or position_department_name ilike 'Woodbridge')
                then 1
            else 0
        end::int                                                            as is_woodbridge
        , object_insert(_extra_fields , 'is_woodbridge' , is_woodbridge)    as _extra_fields
        , row_number() over (
            partition by employee_num
            order by
                position_primary_job_indicator desc
                , position_full_time_equivalent desc
                , position_manager_name asc
        )                                                                   as rn
    from {{ ref('nml_oracle_hcm_associates') }}
    where is_head = 1
        and rn_employee_num = 1
)

, cte_active_directory as (
    select
        distinguished_name                                   as distinguished_name
        , _effective_at                                      as effective_at
        , employee_number                                    as employee_num

        -- EmployeeID
        , employee_id                                        as employee_id

        -- Division
        , division                                           as division

        -- AdminDescription
        , admin_description                                  as admin_description

        -- Company
        , company                                            as company

        -- Department
        , department                                         as department

        -- Title
        , title                                              as title

        -- PhysicalDeliveryOfficeName
        , physical_delivery_office_name                      as physical_delivery_office_name

        -- Manager [distinguished name]
        , manager                                            as manager

        -- StreetAddress
        , street_address                                     as street_address

        -- L | City
        , city                                               as city

        -- St | State
        , state                                              as state

        -- PostalCode
        , postal_code                                        as postal_code

        -- TelephoneNumber (work/zoom phone)
        , office_phone                                       as office_phone

        -- OtherNumber
        , other_mobile                                       as other_mobile

        -- dateOfStart
        , nullif(to_char(date_of_start , 'MM/DD/YYYY') , '') as date_of_start

        -- dateOfBirth
        , date_of_birth                                      as date_of_birth
    from {{ ref('active_directory__rpt_users') }}
    where is_head = 1
)

, cte_employee_nums as (
    select distinct employee_num from cte_bld_associates
    union distinct
    select distinct employee_num from cte_active_directory
)

, exclusions as (
    select
        employee_num                                as employee_num
        , exclude_entirely                          as exclude_entirely
        , split(trim(properties_to_exclude), ',')   as properties_to_exclude
        , notes                                     as notes
    from {{ ref('aux__active_directory_sync_exclusions') }}
)

, employee_nums_all as (
    select
        a.employee_num              as employee_num
        , b.exclude_entirely        as exclude_entirely
        , b.properties_to_exclude   as properties_to_exclude
        , b.notes                   as exclusion_notes
    from cte_employee_nums a
    left join exclusions b
        on a.employee_num = b.employee_num
)

, cte_comparison as (
    select
        a.employee_num                                                 as employee_num
        , ba.system_key                                                as system_key
        , ba.full_name                                                 as full_name
        , ba.employment_status                                         as employment_status

        , (ba.employee_num is not null)::int                           as exists_in_source
        , (ad.employee_num is not null)::int                           as exists_in_ad
        , (exists_in_source = 1 and exists_in_ad = 1)::int             as exists_in_both
        , (ba.manager_position_id is not null)::int                    as has_manager_in_source

        -- This is useful for quickly seeing the fields that will be updated,
        -- but includes old and new values.
        , object_construct(
            'EmployeeID'
            , iff(
                coalesce(ba.employee_id , '') <> coalesce(ad.employee_id , '') and not array_contains('EmployeeID'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.employee_id , 'ad' , ad.employee_id)
                , null
            )
            , 'Company'
            , iff(
                coalesce(ba.company , '') <> coalesce(ad.company , '') and not array_contains('Company'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.company , 'ad' , ad.company)
                , null
            )
            , 'Division' , iff(
                coalesce(ba.division , '') <> coalesce(ad.division , '') and not array_contains('Division'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.division , 'ad' , ad.division)
                , null
            )
            , 'AdminDescription'
            , iff(
                coalesce(ba.admin_description , '') <> coalesce(ad.admin_description , '') and not array_contains('AdminDescription'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.admin_description , 'ad' , ad.admin_description)
                , null
            )
            , 'Department'
            , iff(
                coalesce(ba.department , '') <> coalesce(ad.department , '') and not array_contains('Department'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.department , 'ad' , ad.department)
                , null
            )
            , 'Title'
            , iff(
                coalesce(ba.title , '') <> coalesce(ad.title , '') and not array_contains('Title'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.title , 'ad' , ad.title)
                , null
            )
            , 'PhysicalDeliveryOfficeName'
            , iff(
                coalesce(ba.physical_delivery_office_name , '') <> coalesce(ad.physical_delivery_office_name , '') and not array_contains('PhysicalDeliveryOfficeName'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null(
                    'source' , ba.physical_delivery_office_name , 'ad' , ad.physical_delivery_office_name
                )
                , null
            )
            , 'Manager'
            , iff(
                coalesce(ba.manager , '') <> coalesce(ad.manager , '') and not array_contains('Manager'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.manager , 'ad' , ad.manager)
                , null
            )
            , 'StreetAddress'
            , iff(
                coalesce(ba.street_address , '') <> coalesce(ad.street_address , '') and not array_contains('StreetAddress'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.street_address , 'ad' , ad.street_address)
                , null
            )
            , 'L'
            , iff(
                coalesce(ba.city , '') <> coalesce(ad.city , '') and not array_contains('L'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.city , 'ad' , ad.city)
                , null
            )
            , 'st'
            , iff(
                coalesce(ba.state , '') <> coalesce(ad.state , '') and not array_contains('st'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.state , 'ad' , ad.state)
                , null
            )
            , 'PostalCode'
            , iff(
                coalesce(ba.postal_code , '') <> coalesce(ad.postal_code , '') and not array_contains('PostalCode'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.postal_code , 'ad' , ad.postal_code)
                , null
            )
            , 'TelephoneNumber'
            , iff(
                coalesce(ba.office_phone , '') <> coalesce(ad.office_phone , '') and not array_contains('TelephoneNumber'::variant, nvl(a.properties_to_exclude, [])) and nvl(ba.is_woodbridge , 0) = 0
                , object_construct_keep_null('source' , ba.office_phone , 'ad' , ad.office_phone)
                , null
            )
            , 'otherMobile'
            , iff(
                coalesce(ba.other_mobile , '') <> coalesce(ad.other_mobile , '') and not array_contains('otherMobile'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.other_mobile , 'ad' , ad.other_mobile)
                , null
            )
            , 'dateOfStart'
            , iff(
                coalesce(ba.date_of_start , '') <> coalesce(ad.date_of_start , '') and not array_contains('dateOfStart'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.date_of_start , 'ad' , ad.date_of_start)
                , null
            )
            , 'dateOfBirth'
            , iff(
                coalesce(ba.date_of_birth , '') <> coalesce(ad.date_of_birth , '') and not array_contains('dateOfBirth'::variant, nvl(a.properties_to_exclude, []))
                , object_construct_keep_null('source' , ba.date_of_birth , 'ad' , ad.date_of_birth)
                , null
            )
        )
            as update_payload_detail

        -- This is used for applying updates by the receiving application (powershell Set-ADUser)
        -- !! Should we be clearing values? Maybe only certain ones? !!
        , object_construct(
            'EmployeeID' , iff(coalesce(ba.employee_id , '') <> coalesce(ad.employee_id , '') and not array_contains('EmployeeID'::variant, nvl(a.properties_to_exclude, [])) , ba.employee_id , null)
            , 'Company' , iff(coalesce(ba.company , '') <> coalesce(ad.company , '') and not array_contains('Company'::variant, nvl(a.properties_to_exclude, [])) , ba.company , null)
            , 'Division' , iff(coalesce(ba.division , '') <> coalesce(ad.division , '') and not array_contains('Division'::variant, nvl(a.properties_to_exclude, [])) , ba.division , null)
            , 'AdminDescription'
            , iff(coalesce(ba.admin_description , '') <> coalesce(ad.admin_description , '') and not array_contains('AdminDescription'::variant, nvl(a.properties_to_exclude, [])) , ba.admin_description , null)
            , 'Department' , iff(coalesce(ba.department , '') <> coalesce(ad.department , '') and not array_contains('Department'::variant, nvl(a.properties_to_exclude, [])) , ba.department , null)
            , 'Title' , iff(coalesce(ba.title , '') <> coalesce(ad.title , '') and not array_contains('Title'::variant, nvl(a.properties_to_exclude, [])) , ba.title , null)
            , 'PhysicalDeliveryOfficeName'
            , iff(
                coalesce(ba.physical_delivery_office_name , '') <> coalesce(ad.physical_delivery_office_name , '') and not array_contains('PhysicalDeliveryOfficeName'::variant, nvl(a.properties_to_exclude, []))
                , ba.physical_delivery_office_name
                , null
            )
            , 'Manager' , iff(coalesce(ba.manager , '') <> coalesce(ad.manager , '') and not array_contains('Manager'::variant, nvl(a.properties_to_exclude, [])) , ba.manager , null)
            , 'StreetAddress'
            , iff(coalesce(ba.street_address , '') <> coalesce(ad.street_address , '') and not array_contains('StreetAddress'::variant, nvl(a.properties_to_exclude, [])) , ba.street_address , null)
            , 'L' , iff(coalesce(ba.city , '') <> coalesce(ad.city , '') and not array_contains('L'::variant, nvl(a.properties_to_exclude, [])) , ba.city , null)
            , 'st' , iff(coalesce(ba.state , '') <> coalesce(ad.state , '') and not array_contains('st'::variant, nvl(a.properties_to_exclude, [])) , ba.state , null)
            , 'PostalCode' , iff(coalesce(ba.postal_code , '') <> coalesce(ad.postal_code , '') and not array_contains('PostalCode'::variant, nvl(a.properties_to_exclude, [])) , ba.postal_code , null)
            , 'TelephoneNumber'
            , iff(coalesce(ba.office_phone , '') <> coalesce(ad.office_phone , '') and not array_contains('TelephoneNumber'::variant, nvl(a.properties_to_exclude, [])) and nvl(ba.is_woodbridge , 0) = 0 , ba.office_phone , null)
            , 'otherMobile' , iff(coalesce(ba.other_mobile , '') <> coalesce(ad.other_mobile , '') and not array_contains('otherMobile'::variant, nvl(a.properties_to_exclude, [])) , ba.other_mobile , null)
            , 'dateOfStart' , iff(coalesce(ba.date_of_start , '') <> coalesce(ad.date_of_start , '') and not array_contains('dateOfStart'::variant, nvl(a.properties_to_exclude, [])) , ba.date_of_start , null)
            , 'dateOfBirth' , iff(coalesce(ba.date_of_birth , '') <> coalesce(ad.date_of_birth , '') and not array_contains('dateOfBirth'::variant, nvl(a.properties_to_exclude, [])) , ba.date_of_birth , null)
        )                                                              as update_payload

        -- This includes a full accounting of value comparisons.
        , object_construct(
            'EmployeeID' , object_construct_keep_null('source' , ba.employee_id , 'ad' , ad.employee_id)
            , 'Company' , object_construct_keep_null('source' , ba.company , 'ad' , ad.company)
            , 'Division' , object_construct_keep_null('source' , ba.division , 'ad' , ad.division)
            , 'AdminDescription' , object_construct_keep_null('source' , ba.admin_description , 'ad' , ad.admin_description)
            , 'Department' , object_construct_keep_null('source' , ba.department , 'ad' , ad.department)
            , 'Title' , object_construct_keep_null('source' , ba.title , 'ad' , ad.title)
            , 'PhysicalDeliveryOfficeName'
            , object_construct_keep_null('source' , ba.physical_delivery_office_name , 'ad' , ad.physical_delivery_office_name)
            , 'Manager' , object_construct_keep_null('source' , ba.manager , 'ad' , ad.manager)
            , 'StreetAddress' , object_construct_keep_null('source' , ba.street_address , 'ad' , ad.street_address)
            , 'L' , object_construct_keep_null('source' , ba.city , 'ad' , ad.city)
            , 'st' , object_construct_keep_null('source' , ba.state , 'ad' , ad.state)
            , 'PostalCode' , object_construct_keep_null('source' , ba.postal_code , 'ad' , ad.postal_code)
            , 'TelephoneNumber' , object_construct_keep_null('source' , ba.office_phone , 'ad' , ad.office_phone)
            , 'otherMobile' , object_construct_keep_null('source' , ba.other_mobile , 'ad' , ad.other_mobile)
            , 'dateOfStart' , object_construct_keep_null('source' , ba.date_of_start , 'ad' , ad.date_of_start)
            , 'dateOfBirth' , object_construct_keep_null('source' , ba.date_of_birth , 'ad' , ad.date_of_birth)
        )                                                              as field_comparison

        -- Shows list of field names that are to be updated
        , object_keys(update_payload)                                  as fields_to_update

        , array_size(fields_to_update)                                 as cnt_fields_to_update

        , (update_payload:EmployeeID is not null)::int                 as is_employee_id_diff
        , (update_payload:Company is not null)::int                    as is_company_diff
        , (update_payload:Division is not null)::int                   as is_division_diff
        , (update_payload:AdminDescription is not null)::int           as is_admin_description_diff
        , (update_payload:Department is not null)::int                 as is_department_diff
        , (update_payload:Title is not null)::int                      as is_title_diff
        , (update_payload:PhysicalDeliveryOfficeName is not null)::int as is_physical_delivery_office_name_diff
        , (update_payload:Manager is not null)::int                    as is_manager_diff
        , (update_payload:StreetAddress is not null)::int              as is_street_address_diff
        , (update_payload:L is not null)::int                          as is_city_diff
        , (update_payload:st is not null)::int                         as is_state_diff
        , (update_payload:PostalCode is not null)::int                 as is_postal_code_diff
        , (update_payload:TelephoneNumber is not null)::int            as is_telephone_number_diff
        , (update_payload:otherMobile is not null)::int                as is_other_mobile_diff
        , (update_payload:dateOfStart is not null)::int                as is_date_of_start_diff
        , (update_payload:dateOfBirth is not null)::int                as is_date_of_birth_diff

        , nullif(
            ''::text(500)
            || case when ba.admin_description ilike '%1248%'
                    or ad.admin_description ilike '%1248%'
                    or ba.company ilike '%1248%'
                    or ad.company ilike '%1248%'
                    then '1248;'
                else ''
            end
            || case when ba.system_key = 'adp__mwa' and not (
                        ba._extra_fields:position_status_code ilike any ('A' , 'L')
                        and ba._extra_fields:position_company_code ilike any ('67L' , '67A')
                    ) then 'adp position out of scope;'
                else ''
            end
            || case
                when ba.system_key = 'adp__mwa' and left(ba.position_id , 1) = '9' then 'position_id starts with 9;' else ''
            end
            || case when coalesce(lower(ba.employment_status) , '') not in ('active' , 'leave')
                    then 'source record not active;'
                else ''
            end
            || case when a.employee_num = '000940' then 'marty;' else '' end
            -- AD records for Oracle line items with a future start date typically
            -- aren't ready for a sync. AD will throw permission errors.
            || case when try_to_date(ba.date_of_start) > current_date() then 'hire date in future;' else '' end
            -- Exclude users who have been flagged to be excluded entirely via manual file.
            || case when a.exclude_entirely = 1 then 'exclude user - instruction from manual file;' else '' end
            , ''
        )                                                              as excluded_reasons
        , (excluded_reasons is not null)::int                          as is_excluded
        , case
            when exists_in_both = 1 and cnt_fields_to_update > 0 and is_excluded = 0
                then 1
            else 0
        end::int                                                       as needs_updated

        , ba.effective_at                                              as erp_effective_at
        , ad.effective_at                                              as ad_effective_at
        , ba._extra_fields                                             as _extra_fields
    from employee_nums_all as a
    left join cte_bld_associates as ba
        on a.employee_num = ba.employee_num
    left join cte_active_directory as ad
        on a.employee_num = ad.employee_num
    where ba.rn = 1
    order by ba.full_name
)

select *
from cte_comparison
