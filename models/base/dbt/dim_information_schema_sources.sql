{{ config(enabled = true) }}

with cte_all_table_sources as
(
    select *
    from datalake.information_schema.tables
    where table_type = 'BASE TABLE'
    union all
    select *
    from edw.information_schema.tables
    where table_type = 'BASE TABLE'
    union all
    select *
    from odw.information_schema.tables
    where table_type = 'BASE TABLE'
    union all
    select *
    from raw.information_schema.tables
    where table_type = 'BASE TABLE'
)
,cte_dbt_sources as
(
    select *
    from dbt.elementary.dbt_sources
)

select ats.*
from cte_all_table_sources ats
join cte_dbt_sources dbt
    on ats.table_catalog = upper(dbt.database_name)
    and ats.table_schema = upper(dbt.schema_name)
    and ats.table_name = upper(dbt.name)

