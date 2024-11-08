{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'associate_id_oracle',
    cluster_by = ['effective_date']
) }}

with cte_check as (
    {%- if is_incremental() %}
        select
            case
                when (
                    select max(_created_at)
                    from {{ source('reporting_raw', 'master_employee_coding') }}
                ) > coalesce((select max(_created_at) from {{ this }}) , '1900-01-01'::date::timestamp)
                    then 1
                else 0
            end::int as needs_update
    {%- else -%}
  select 1::int as needs_update
  {%- endif %}
)

, cte_rev_coding_stg_1 as (
    select
        a.json:data:SOURCE_FILE_YEAR::string as source_file_year
        , a.json:data:FILE_ID::string        as source_file_id
        , a.json:data:SHEET_NAME::string     as sheet_name
        , a.json:data:EFF_DT_HC::date        as effective_date
        , max(a.json:data:EFF_DT_HC)::date   as max_eff_dt
        , row_number() over (
            partition by effective_date
            order by 1 , 2 , 3 , 4
        )                                    as rn_1
    from {{ source('reporting_raw', 'master_employee_coding') }} as a
    where 1 = (select max(needs_update) from cte_check)
    group by 1 , 2 , 3 , 4
)

, cte_rev_coding_stg_2 as (
    select
        effective_date
        , max(rn_1) as max_sheet_num
    from cte_rev_coding_stg_1
    where 1 = (select max(needs_update) from cte_check)
    group by 1
    order by 1
)

, cte_rev_coding_stg_3 as (
    select
        a.json:data:ASSOC_ID_HC::string    as assoc_id_hc_01
        , b.associate_id                   as associate_id_oracle
        , b.legacy_employee_num            as associate_id_adp
        , b.associate_legal_name_full      as associate_name_legal
        , max(a.json:data:EFF_DT_HC)::date as max_eff_dt_temp
    from {{ source('reporting_raw', 'master_employee_coding') }} as a
    left join {{ ref('associates') }} as b
        on (
            a.json:data:ASSOC_ID_HC = b.associate_id
            or a.json:data:ASSOC_ID_HC = b.legacy_employee_num
        )
    where 1 = (select max(needs_update) from cte_check)
    group by 1 , 2 , 3 , 4
    order by 1 , 2 , 3 , 4
)

, cte_rev_coding_stg_4 as (
    select
        associate_id_oracle
        , associate_id_adp
        , max(max_eff_dt_temp) as max_eff_dt_final
    from cte_rev_coding_stg_3
    where 1 = (select max(needs_update) from cte_check)
    group by 1 , 2
)

select
    a.json:data:SOURCE_FILE_YEAR::string                       as source_file_year
    , a.json:data:FILE_ID::string                              as source_file_id
    , a.json:data:SHEET_NAME::string                           as sheet_name
    , a.json:data:EFF_DT_HC::date                              as effective_date

    , case
        when a.json:data:EFF_DT_HC = (
                select min(a.json:data:EFF_DT_HC)
                from reporting.raw.master_employee_coding as a
            )
            then '1900-01-01'
        when a.json:data:EFF_DT_HC = (
                select max(a.json:data:EFF_DT_HC)
                from reporting.raw.master_employee_coding as a
            )
            then date_trunc('month' , to_date(a.json:data:EFF_DT_HC))
        when month(to_date(a.json:data:EFF_DT_HC)) = 1
            and day(to_date(a.json:data:EFF_DT_HC)) != 1
            then
                dateadd('day' , 1 , date_trunc('month' , to_date(a.json:data:EFF_DT_HC)))
        else
            dateadd('day' , 0 , date_trunc('month' , to_date(a.json:data:EFF_DT_HC)))
    end::date                                                  as start_date

    , case
        when a.json:data:EFF_DT_HC = (
                select max(a.json:data:EFF_DT_HC)
                from reporting.raw.master_employee_coding as a
            )
            then '2099-12-31'
        when a.json:data:EFF_DT_HC = w.max_eff_dt_final
            then '2099-12-31'
        else
            a.json:data:EFF_DT_HC
    end::date                                                  as end_date
    , a.json:data:ASSOC_ID_HC::string                          as assoc_id_hc
    , coalesce(a.json:data:NAME , a.json:data:EE_NAME)::string as assoc_name_hc
    , x.associate_id_oracle                                    as associate_id_oracle
    , x.associate_id_adp                                       as associate_id_adp
    , x.associate_name_legal                                   as associate_name_legal
    , coalesce(
        a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
        , a.json:data:REVENUE_CODING
    )                                                          as associate_revenue_coding

    --[SEGMENTS]
    , case
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 30
            then substr(a.json:data:REVENUE_CODING_1 , 0 , 3)
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 19
            then substr(a.json:data:REVENUE_CODING , 0 , 2) || '0'
    end::string                                                as seg_1
    , case
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 30
            then
                substr(a.json:data:REVENUE_CODING_1 , 5 , 3)
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 19
            then
                substr(a.json:data:REVENUE_CODING , 4 , 2) || '0'
    end::string                                                as seg_2
    , case
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 30
            then
                substr(a.json:data:REVENUE_CODING_1 , 9 , 4)
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 19
            then
                substr(a.json:data:REVENUE_CODING , 10 , 4)
    end::string                                                as seg_3
    , case
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 30
            then substr(a.json:data:REVENUE_CODING_1 , 14 , 4)
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 19
            then substr(a.json:data:REVENUE_CODING , 15 , 4)
    end::string                                                as seg_4
    --natural account, to be added in the mastering
    , '00000'                                                  as seg_5
    , case
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 30
            then substr(a.json:data:REVENUE_CODING_2 , 2 , 3)
        when length(
                coalesce(
                    a.json:data:REVENUE_CODING_1 || a.json:data:REVENUE_CODING_2
                    , a.json:data:REVENUE_CODING
                )
            )
            = 19
            then
                substr(a.json:data:REVENUE_CODING , 7 , 1)
                || '0'
                || substr(a.json:data:REVENUE_CODING , 8 , 1)
    end::string
        as seg_6
    , '000'::text(200)                                         as seg_7
    , '000'::text(200)                                         as seg_8

    , a.json:_ID::string                                       as _id
    , a._created_at                                            as _created_at
    , case
        when z.rn_1 = y.max_sheet_num then 1
        else 0
    end::int                                                   as is_latest
    , case
        when a.json:data:EFF_DT_HC::date = (
                select max(a.json:data:EFF_DT_HC)::date
                from reporting.raw.master_employee_coding as a
            ) then 1
        else 0
    end::int                                                   as is_head
from {{ source('reporting_raw', 'master_employee_coding') }} as a
inner join cte_rev_coding_stg_1 as z
    on a.json:data:SOURCE_FILE_YEAR = z.source_file_year
    and a.json:data:FILE_ID = z.source_file_id
    and a.json:data:SHEET_NAME = z.sheet_name
    and a.json:data:EFF_DT_HC = z.effective_date
inner join cte_rev_coding_stg_2 as y
    on z.effective_date = y.effective_date
left join cte_rev_coding_stg_3 as x
    on (a.json:data:ASSOC_ID_HC = x.assoc_id_hc_01)
inner join cte_rev_coding_stg_4 as w
    on (
        a.json:data:ASSOC_ID_HC = w.associate_id_oracle
        or a.json:data:ASSOC_ID_HC = w.associate_id_adp
    )
where true
    and 1 = (select max(needs_update) from cte_check)
order by source_file_year , source_file_id , sheet_name , effective_date , assoc_id_hc-- noqa: AM06
