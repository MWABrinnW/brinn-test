with fmv_cte as (
    select
        f.*
        , last_day(try_to_date((f.year || f.month) , 'YYYYMM') , 'month') as start_dt
        , row_number() over (
            partition by f.plan_id
            order by f.plan_id asc , f.year desc , f.month desc
        )                                                                 as rn
        , case
            when row_number()
                    over (
                        partition by f.plan_id
                        order by f.plan_id asc , f.year desc , f.month desc
                    )
                = 1 then null
            else lag(
                    dateadd('day' , -1 , last_day(try_to_date((f.year || f.month) , 'YYYYMM') , 'month'))
                    , 1
                ) over (
                    order by f.plan_id asc , f.year desc , f.month desc
                )
        end                                                               as end_dt
    from {{ ref('cambak__stg_latestfmventry') }} as f
    where true

)

, plan_with_fmv_cte as (
    select
        dt.date_key        as date_key
        , dt.is_market_day as is_market_day
        , f.fmv            as fmv
        , f.start_dt       as start_dt
        , f.end_dt         as end_dt
        , f.created_date   as fmv_created_date
        , f.rn             as rn
        , p.*
    from {{ ref('cambak__stg_cbplan') }} as p
    left join fmv_cte as f
        on p.plan_id = f.plan_id
    left join {{ ref('dates') }} as dt
        on coalesce(f.start_dt , '2024-01-01') <= dt.date_key
        and coalesce(f.end_dt , current_date()) >= dt.date_key
    -- filters out data prior to acquisition of cambak__andco
    where true
        and dt.date_key::date between '2024-04-01' and current_date()
        and coalesce(f.end_dt , current_date()) >= '2024-04-01'

)

, custodians_cte as (
    select
        plan_id                                   as plan_id
        , plan_name                               as plan_name
        , listagg(distinct custodian_name , '; ') as cust_list
    from {{ ref('cambak__stg_custodialrelationshipex') }}
    group by all
)

, target_return_cte as (
    select
        to_varchar(target_return) || '%' || iff(notes is null , '' , ' (' || notes || ')') as target_return_str
        , *
    from {{ ref('cambak__stg_cbplantargetreturn') }}
    qualify row_number() over (
        partition by plan_id
        order by plan_id asc , effective_date desc
    ) = 1
)

, team_member_cte as (
    select
        ctm.plan_id                                                       as plan_id
        , listagg(distinct usr.first_name || ' ' || usr.last_name , '; ') as user_full_names
        , listagg(distinct to_varchar(usr.oracle_person_id) , '; ')       as emp_nums
    from {{ ref('cambak__stg_cbclientteammember') }} as ctm
    inner join {{ ref('cambak__stg_cbuser') }} as usr
        on ctm.userid = usr.userid
        and usr.is_active = 1
    inner join {{ ref('cambak__stg_cbpickliststring') }} as pls
        on ctm.role_id = pls.picklist_string_id
        and pls.picklist_id = 7000
        and lower(pls.picklist_string_value) like any ('%senior advisor%' , '%primary consultant%')
    group by 1
)

select
    pln.date_key::date                             as effective_date
    , 'cambak'::text                               as system_name
    , 'andco'::text                                as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'inst'                                       as firm_source
    , pln.plan_id                                  as account_number_formatted
    , pln.plan_id                                  as account_number
    , pln.fmv                                      as account_value
    , pln.plan_id                                  as account_id_crm
    , pln.plan_id                                  as account_id_pms
    , pln.plan_name                                as account_name
    , clt.client_id                                as client_id_crm
    , clt.client_id                                as client_id_pms
    , clt.client_name                              as client_name
    , clt.legal_name                               as registrant_name
    , cst.cust_list                                as custodian
    , pl1.picklist_string_value                    as account_type
    , case
        when pln.discretion_level_id = 2561 then 'AUM - Assets Under Management'
        when pln.is_prospect = 1 or clt.is_prospect = 1 then 'Data Aggregation / Reporting Only'
        else 'AUA - Assets Under Advisory'
    end                                            as aum_classification
    , trg.target_return_str                        as model_investment_strategy
    , mem.user_full_names                          as advisor
    , mem.emp_nums                                 as advisor_id
    , case when mem.emp_nums is not null
            then 'oracle__hcm'
    end::text                                      as advisor_id_source
    -- converts to integers to be normalized in 'nml_accounts'; 0=non-discretionary, 1=discretionary, 2=partial
    , case lower(pl2.picklist_string_value)
        when 'full' then 1
        when 'none' then 0
    end::int                                       as discretion_status
    , case
        when pln.is_closed = 1
            or pln.is_explicit_close = 1
            or pln.is_prospect = 1
            or clt.is_closed = 1
            or clt.is_prospect = 1
            then 0
        when pln.relationship_end_date is not null then 0
        when clt.relationship_end_date is not null then 0
        else 1
    end                                            as is_active
    , case
        when pl3.picklist_string_value = 'Integration' and pl4.picklist_string_value = 'RPS'
            then
                date(pln.relationship_start_date)
        when pln.relationship_start_date::date <= '2025-04-01'
            and pl3.picklist_string_value = 'Acquisition'
            and pl4.picklist_string_value = 'Cardinal Investment Advisors'
            then '2025-04-01'-- cardinal acquisition date
        when pln.relationship_start_date::date <= '2024-04-01' and clt.firm_id = 2
            then '2024-04-01'-- andco acquisition date
        else
            date(pln.relationship_start_date)
    end::date                                      as opened_date
    , pln.relationship_end_date::date              as closed_date
    , case
        when pl3.picklist_string_value = 'Integration' and pl4.picklist_string_value = 'RPS'
            then
                '301'-- Legacy RPS
        when pl3.picklist_string_value = 'Acquisition' and pl4.picklist_string_value = 'Cardinal Investment Advisors'
            then
                'L-10130'-- Cardinal
        else
            'L-10101'--AndCo

    end::text                                      as location_code
    , loc.office_name                              as office_name
    , null::text                                   as link
    , null::text                                   as link_type
    , null::text                                   as link_subtype
    , 1::int                                       as is_institutional
    , null::int                                    as is_erisa
    , convert_timezone(
        'America/Chicago'
        , to_timestamp_tz(
            replace(pln.fmv_created_date , ' ' , '') || '+00:00' , 'MM/DD/YYYYHH12:MI:SSAM +TZH:TZM'
        )
    )                                              as _created_at
    , object_construct_keep_null(
        'plan_open_date' , pln.relationship_start_date
        , 'plan_close_status' , pln.is_closed
        , 'plan_explicit_close_status' , pln.is_explicit_close
        , 'plan_prospect_status' , pln.is_prospect
        , 'client_closed_status' , clt.is_closed
        , 'client_prospect_status' , clt.is_prospect
        , 'plan_source_type_id' , pln.source_type_id
        , 'plan_source_subtype_id' , pln.source_subtype_id
        , 'plan_source_type' , pl3.picklist_string_value
        , 'plan_source_subtype' , pl4.picklist_string_value
    )::variant                                     as _extra_fields
from plan_with_fmv_cte as pln
inner join {{ ref('cambak__stg_cbclient') }} as clt
    on pln.client_id = clt.client_id
left join custodians_cte as cst
    on pln.plan_id = cst.plan_id
-- returns the type of account
left join {{ ref('cambak__stg_cbpickliststring') }} as pl1
    on pln.plan_type_id = pl1.picklist_string_id
    and pl1.picklist_id = 1020
-- returns discretion status
left join {{ ref('cambak__stg_cbpickliststring') }} as pl2
    on pln.discretion_level_id = pl2.picklist_string_id
    and pl2.picklist_id = 1040
-- returns status of business; i.e., acquisition, integration
left join {{ ref('cambak__stg_cbpickliststring') }} as pl3
    on pln.source_type_id = pl3.picklist_string_id
    and pl3.picklist_id = 13010
-- returns the business unit/name
left join {{ ref('cambak__stg_cbpickliststring') }} as pl4
    on pln.source_subtype_id = pl4.picklist_string_id
    and pl4.picklist_id = 13020
left join target_return_cte as trg
    on pln.plan_id = trg.plan_id
left join team_member_cte as mem
    on pln.plan_id = mem.plan_id
left join {{ ref('locations_active') }} as loc--gwh updated 2025.04.25 per jerry for cardinal/rps
    on
    (
        case
            when pl3.picklist_string_value = 'Integration' and pl4.picklist_string_value = 'RPS'
                then
                    '301'-- Legacy RPS
            when pl3.picklist_string_value = 'Acquisition' and pl4.picklist_string_value = 'Cardinal Investment Advisors'
                then
                    'L-10130'-- Cardinal
            else
                'L-10101'--AndCo

        end
    )
    = loc.location_code
where clt.firm_id in (2)-- 2 = AndCo (Mariner Inst)
order by effective_date , account_number--noqa:AM06
