with access_hist as (
    select
        obj.value:objectName::string
            as table_name
        , a.user_name
        , sum(
            case when a.user_name in ('SVC_DM') then 1 else 0 end
        )                            as svc_dm_count
        , sum(
            case when a.user_name in ('SVC_DBT') then 1 else 0 end
        )                            as svc_dbt_count
        , sum(
            case when a.user_name in ('SVC_ENG') then 1 else 0 end
        )                            as svc_eng_count
        , sum(
            case when a.user_name in ('GKILBER' , 'TDAVIS' , 'DHERITAGE' , 'ALANNING' , 'MWONG' , 'AJONES') then 1 else 0 end
        )                            as eng_count
        , sum(
            case
                when
                    a.user_name not in (
                        'SVC_DM' , 'SVC_DBT' , 'GKILBER' , 'TDAVIS' , 'DHERITAGE' , 'ALANNING' , 'MWONG' , 'AJONES'
                    )
                    then 1
                else 0
            end
        )                            as non_eng_count
        , sum(
            case when a.user_name in ('BBUCHINGER' , 'GHART' , 'KGROOMS' , 'RHAYNES') then 1 else 0 end
        )                            as dm_count
        , sum(
            case when a.user_name in ('KTODD') then 1 else 0 end
        )                            as hr_count
        , sum(
            case
                when
                    a.user_name in ('ASHAFERFARMER' , 'ASTUEVE' , 'ESTEINBECK' , 'JARMSTRONG' , 'SVC_REPORTING' , 'THILL')
                    then 1
                else 0
            end
        )                            as rptg_count
        , sum(
            case when a.user_name in ('ATHURMAN' , 'GYOUNGBERG' , 'MBENSON' , 'SVC_PLATFORMS') then 1 else 0 end
        )                            as pltfm_count
        , sum(
            case when a.user_name in ('BPERON') then 1 else 0 end
        )                            as operations_count
        , sum(
            case when a.user_name in ('RDUNN') then 1 else 0 end
        )                            as investments_count
        , count(
            *
        )                            as total_use_count
        , max(
            a.query_start_time
        )                            as last_query_time
    from snowflake.account_usage.access_history as a
    , table(flatten(direct_objects_accessed)) as obj
    where true
        and a.query_start_time >= (current_date - 90)::timestamp
        and a.user_name not in ('SVC_FIVETRAN')
        and obj.value:objectName::string ilike 'EDW.%'
    group by table_name , a.user_name
)

, tbl as (
    select
        table_catalog
        , table_schema
        , table_name
        , coalesce(table_catalog , '') || '.' || coalesce(table_schema , '') || '.' || coalesce(table_name , '') as table_name_fq
        , table_type
        , row_count
    from information_schema.tables
    where true
        and table_catalog = 'EDW'
        --         and table_catalog <> 'BUILD'
        and table_type in ('BASE TABLE' , 'VIEW')
)

select
    t.table_catalog
    , t.table_schema
    , t.table_name
    , t.table_type
    , ah.table_name                                             as table_name_fq
    , ah.user_name
    , ah.total_use_count
    , ah.svc_dm_count
    , ah.svc_dbt_count
    , ah.eng_count
    , ah.non_eng_count
    , ah.dm_count
    , ah.hr_count
    , ah.rptg_count
    , ah.pltfm_count
    , ah.operations_count
    , ah.investments_count
    , ah.last_query_time::date                                  as last_query_date
    , datediff(day , ah.last_query_time::date , current_date()) as days_since_last_query
    , t.row_count
from access_hist as ah
left join tbl as t
    on upper(ah.table_name) = upper(t.table_name_fq)

union all

select
    t.table_catalog
    , t.table_schema
    , t.table_name
    , t.table_type
    , t.table_name_fq
    , null::text as user_name
    , 0::int     as total_user_count
    , 0::int     as svc_dm_count
    , 0::int     as svc_dbt_count
    , 0::int     as eng_count
    , 0::int     as non_eng_count
    , 0::int     as dm_count
    , 0::int     as hr_count
    , 0::int     as rptg_count
    , 0::int     as pltfm_count
    , 0::int     as operations_count
    , 0::int     as investments_count
    , null::date as last_query_date
    , null::int  as days_since_last_query
    , t.row_count
from tbl as t
left join access_hist as ah
    on upper(t.table_name_fq) = upper(ah.table_name)
where ah.table_name is null

order by total_use_count desc
