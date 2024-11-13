select
    a.start_at::date                  as query_date
    , a.database_name                 as database_name
    , a.schema_name                   as schema_name
    , a.table_name                    as table_name
    , a.fq_name                       as fq_name
    , a.table_type                    as table_type
    , count(distinct a.query_id)      as total_query_count
    , count(distinct a.user_name)     as total_user_count
    , count(distinct a.role_name)     as total_role_count
    , array_agg(distinct a.user_name) as users
    , array_agg(distinct a.role_name) as roles
from {{ ref('stg_snowflake_query_tables') }} as a
where 1 = 1
    and a.fq_name is not null
    and a.table_type not in ('stage')
    and a.query_type ilike 'select'
group by all
order by a.fq_name asc , query_date asc
