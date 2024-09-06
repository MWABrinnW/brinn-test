--depends_on: {{ ref('adp_history__workers') }}
{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = ['effective_at::date'],
    cluster_by = ['effective_at::date']
) }}

with cte_check as (
    {%- if is_incremental() -%}
        select
            case
                when (select max(_created_at) from {{ ref('adp_history__workers') }}) > (select max(_created_at) from {{ this }})
                    then 1
                when (select max(_created_at) from {{ ref('int_adp_employees_initial_supplemented') }})
                    > (select max(_created_at) from {{ this }})
                    then 1
                else 0
            end::int as needs_update
    {%- else -%}
  select 0::int as needs_update
  {%- endif -%}
)

select
    e.*
    exclude associate_work_phone
    rename home_organizational_units_cost_num as cost_num
    , coalesce(replace(zoom.number , '+1' , '') , e.associate_work_phone)           as associate_work_phone
    , coalesce(lm_old.location_code , lm_new.location_code)                         as location_code
    , coalesce(lm_old.accounting_id , lm_new.accounting_id)                         as accounting_id
    , coalesce(lm_old.accounting_id_description , lm_new.accounting_id_description) as accounting_id_description
    , coalesce(lm_old.location_name , lm_new.location_name)                         as location_name
    , null                                                                          as location_legal_name
    , coalesce(lm_old.location_city , lm_new.location_city)                         as location_city
    , coalesce(lm_old.location_state , lm_new.location_state)                       as location_state
    , coalesce(lm_old.region_name , lm_new.region_name)                             as location_region_name
    , coalesce(lm_old.market_name , lm_new.market_name)                             as location_market_name
    , coalesce(lm_old.division , lm_new.division)                                   as location_division
    , coalesce(lm_old.acquisition_name , lm_new.acquisition_name)                   as location_acquisition_name
    , coalesce(lm_old.acquisition_type , lm_new.acquisition_type)                   as location_acquisition_type

    , case
        when e.occupational_classifications_class ilike '%advisor%'
            then 'Advisor'
        else 'Non-Advisor'
    end
        as advisor_nonadvisor

    , case
        when
            coalesce(e.associate_legal_name_full , '') <> 'Bicknell, Gene'
            and (
                (
                    {# e.position_primary_job_indicator = 1 #}
                    right(coalesce(lower(e.position_id) , '') , 1) <> 'n'
                    and (
                        coalesce(e.position_company_code , '') ilike '%67a%'
                        or coalesce(e.position_company_code , '') ilike '%67l%'
                        or coalesce(e.position_company_code , '') ilike '%7ip%'
                    )
                )
                or
                (
                    /* Special case employees */
                    e.employee_id in (
                        'G3AEPWXFXM5AM4ND'
                        , 'G3ME0KEYDC9DGSJV'
                        , 'G3MDPX4029YHZRF1'
                        , 'G3KXC94FK8AWWN4J'
                        , 'G3MDPX4029YH51G9'
                        , 'G3AEPWXFXM5A1TG2'
                        , 'G3AEPWXFXM5AM464'
                    )
                    and lower(e.position_company_code) like '%67l%'
                    and lower(e.position_status_code) = 'a'
                )
            )
            then 1
        else 0
    end
        as is_employee
    , case
        when
            is_employee = 1
            and (
                coalesce(
                    e.associate_final_termination_date , e.effective_at::date
                ) >= date_trunc(month , e.effective_at::date)
            )
            and coalesce(
                e.position_termination_date , e.effective_at::date
            ) between date_trunc(month , e.effective_at::date) and last_day(
                e.effective_at::date
            )
            and lower(e.position_company_code) in ('67l' , '7ip')
            and coalesce(
                e.associate_rehire_date , e.associate_original_hire_date
            ) <= e.month_end_date
            and coalesce(e.hire_details , '') <> 'Don''t Include/Never Started'
            then 1
        else 0
    end
        as is_census

    -- Standardize the type of employee based on benefit code.
    , case
        when e.position_benefits_group_code in ('FT' , 'K1')
            then 'FT'
        when e.position_benefits_group_code in ('PTE' , 'PTN')
            then 'PT'
        else 'TEMP'
    end
        as ft_pt_temp
    , (
        floor(
            datediff(
                month
                , coalesce(
                    e.associate_rehire_date , e.associate_original_hire_date
                )
                , e.effective_at::date
            )
            / 12
        )::string
        || ' years, '
        || (
            datediff(
                month
                , coalesce(
                    e.associate_rehire_date , e.associate_original_hire_date
                )
                , current_date()
            )
            % 12
        )::string || ' months'
    )                                                                               as years_of_service
    , case
        when floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            < 30
            then '< 30yrs'
        when floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            >= 30
            and floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            < 40
            then '30 - 39yrs'
        when floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            >= 40
            and floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            < 50
            then '40 - 49yrs'
        when floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            >= 50
            and floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            < 60
            then '50 - 59yrs'
        when floor(
                (
                    datediff(
                        month
                        , coalesce(
                            e.associate_birth_date
                            , e.associate_original_hire_date
                        )
                        , e.effective_at::date
                    )
                )
                / 12
            )
            >= 60
            then '> 60yrs'
        else 'UNKNOWN'
    end
        as age_band

    , case
        when coalesce(e.associate_rehire_date , e.associate_original_hire_date) between date_trunc(
                month , e.effective_at::date
            ) and last_day(e.effective_at::date)
            then 1
        else 0
    end                                                                             as is_new
    , case
        when e.associate_final_termination_date between date_trunc(month , e.effective_at::date) and last_day(
                e.effective_at::date
            )
            then 1
        else 0
    end                                                                             as is_term
    , case
        when is_term = 1 and e.vol_invol ilike '%invol%' then 1
        else 0
    end                                                                             as is_invol_term
    , case
        when is_term = 1 and e.vol_invol ilike 'vol%' then 1
        else 0
    end                                                                             as is_vol_term
    , case
        when e.is_deleted = 0
            and (is_term = 1 or is_new = 1 or e.associate_final_termination_date is null)
            and coalesce(e.associate_rehire_date , e.associate_original_hire_date) is not null
            then 1
        else 0
    end                                                                             as is_current
    -- If the employee did not terminate prior to this month then set to 1 else 0.
    , case
        when e.associate_final_termination_date
            >= date_trunc(month , e.effective_at::date)
            and coalesce(
                e.associate_rehire_date , e.associate_original_hire_date
            )
            < date_trunc(month , e.effective_at::date)
            then 1
        when e.associate_final_termination_date is null
            and coalesce(
                e.associate_rehire_date , e.associate_original_hire_date
            )
            < date_trunc(month , e.effective_at::date)
            then 1
        else 0
    end
        as is_start
    -- If the employee doesn't hae a terminate date in the month then set 1 else 0.
    , case
        when e.associate_final_termination_date > e.month_end_date
            and coalesce(
                e.associate_rehire_date , e.associate_original_hire_date
            )
            <= e.month_end_date
            then 1
        when e.associate_final_termination_date is null
            and coalesce(
                e.associate_rehire_date , e.associate_original_hire_date
            )
            <= e.month_end_date
            then 1
        else 0
    end
        as is_end

{# What are the start and end fields used for?? #}
from {{ ref('int_adp_employees_initial_supplemented') }} as e
left join {{ ref('locations_cost_center_history') }} as lh
    on e.position_cost_num_location_code = lh.old_code
    and e.effective_at::date between coalesce(
        lh.start_date
        , coalesce(e.associate_final_termination_date , e.effective_at::date)
    ) and coalesce(
        lh.end_date
        , coalesce(e.associate_final_termination_date , e.effective_at::date)
    )
left join {{ ref('locations') }} as lm_old
    on coalesce(lh.current_code , e.position_cost_num_location_code)
    = lm_old.location_code
    and lm_old.active = 1
left join {{ ref('locations') }} as lm_new
    on coalesce(lh.current_code , e.position_cost_num_location_code)
    = lm_new.accounting_id
    and lm_new.active = 1
left join {{ ref('zoom_mwa__base_user_phone_assignments') }} as zoom
    on lower(e.associate_work_email) = lower(zoom.email)
    and zoom.rn = 1
where true
    and coalesce(e.is_deleted , 0) = 0
    {%- if is_incremental() %}
        and 1 = (select max(needs_update) from cte_check)
    {%- endif -%}
order by e.effective_at
