with cte_existing_relations as
(
    select
        upper(table_catalog) as database_name
      , upper(table_schema)  as schema_name
      , upper(table_name)    as ref_name
      , case
            when table_type = 'VIEW'
                then 'view'
            when table_type = 'BASE TABLE'
                then 'table'
            else null
            end              as ref_type
    from datalake.information_schema.tables
    where table_schema not in ( 'INFORMATION_SCHEMA' )

    union all
    select
        upper(table_catalog) as database_name
      , upper(table_schema)  as schema_name
      , upper(table_name)    as ref_name
      , case
            when table_type = 'VIEW'
                then 'view'
            when table_type = 'BASE TABLE'
                then 'table'
            else null
            end              as ref_type
    from devops.information_schema.tables
    where table_schema not in ( 'INFORMATION_SCHEMA' )

    union all
    select
        upper(table_catalog) as database_name
      , upper(table_schema)  as schema_name
      , upper(table_name)    as ref_name
      , case
            when table_type = 'VIEW'
                then 'view'
            when table_type = 'BASE TABLE'
                then 'table'
            else null
            end              as ref_type
    from edw.information_schema.tables
    where table_schema not in ( 'INFORMATION_SCHEMA' )

    union all
    select
        upper(table_catalog) as database_name
      , upper(table_schema)  as schema_name
      , upper(table_name)    as ref_name
      , case
            when table_type = 'VIEW'
                then 'view'
            when table_type = 'BASE TABLE'
                then 'table'
            else null
            end              as ref_type
    from dbt.information_schema.tables
    where table_schema not in ( 'INFORMATION_SCHEMA' )
        and table_schema not ilike 'dbt_%'

--     union all
--     select
--         upper(table_catalog) as database_name
--       , upper(table_schema)  as schema_name
--       , upper(table_name)    as ref_name
--       , case
--             when table_type = 'VIEW'
--                 then 'view'
--             when table_type = 'BASE TABLE'
--                 then 'table'
--             else null
--             end              as ref_type
--     from fivetran.information_schema.tables
--     where table_schema not in ( 'INFORMATION_SCHEMA' )
)
,cte_dbt_relations as
(
    select
        upper(database_name) as database_name
        , upper(schema_name) as schema_name
        , upper(alias) as ref_name
        , materialization
    from dbt.elementary.dbt_models

    union all

    select
        upper(database_name) as database_name
        , upper(schema_name) as schema_name
        , upper(alias) as ref_name
        , null::text as materialization
    from dbt.elementary.dbt_seeds

    union all

    select
        upper(database_name) as database_name
        , upper(schema_name) as schema_name
        , upper(name) as ref_name
        , null::text as materialization
    from dbt.elementary.dbt_sources
)

SELECT   c.database_name as database_name
        ,c.schema_name   as schema_name
        ,c.ref_name      as ref_name
        ,c.ref_type      as ref_type
FROM cte_existing_relations c
LEFT JOIN cte_dbt_relations desired
    on c.database_name = desired.database_name
    and c.schema_name = desired.schema_name
    and c.ref_name = desired.ref_name
WHERE desired.ref_name is null
ORDER BY c.database_name, c.schema_name, c.ref_name
