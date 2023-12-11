with cte_relations as (
    select
        table_catalog
        , table_schema
        , table_name
        , COALESCE(table_catalog , '') || '.' || COALESCE(table_schema , '') || '.'
        || COALESCE(table_name , '') as table_name_fq
        , table_type
        , row_count
    from information_schema.tables
    where true
        and table_catalog = 'EDW'
        and table_type in ('BASE TABLE' , 'VIEW')
)

select
    qh.start_time::date          as query_date
    , r.table_catalog            as database
    , r.table_schema             as schema
    , obj.value:objectName::text as relation
    , qh.user_name               as user_name
    , qh.role_name               as role_name
    , qh.query_text              as query_text
    , qh.query_id                as query_id
from snowflake.account_usage.query_history as qh
inner join snowflake.account_usage.access_history as ah
    on qh.query_id = ah.query_id
, TABLE(FLATTEN(direct_objects_accessed)) as obj
inner join cte_relations as r
    on upper(replace(obj.value:objectName::text,'"','')) = upper(r.table_name_fq)
where 1 = 1
    and qh.query_type ilike 'SELECT'
    and qh.start_time::date >= CURRENT_DATE - 60
    and obj.value:objectName::text ilike '%custodian_holdings%'
    and qh.user_name ilike 'SVC_REPORTING'
limit 2000
