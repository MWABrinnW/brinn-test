select
    a.start_at::date             as query_date
    , a.database_name            as database_name
    , a.schema_name              as schema_name
    , a.table_name               as table_name
    , a.fq_name                  as fq_name
    , a.table_type               as table_type
    , a.user_name                as user_name
    , u.default_role             as default_role
    , count(distinct a.query_id) as total_query_count
from {{ ref('stg_snowflake_query_tables') }} as a
left join {{ ref('stg_snowflake_users') }} as u
    on lower(a.user_name) = lower(u.user_name)
where 1 = 1
    and fq_name is not null
    and table_type not in ('stage')
    and a.query_type ilike 'select'
group by all
order by a.fq_name asc
