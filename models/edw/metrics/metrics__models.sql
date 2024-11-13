{% set schemas = ['EDW', 'ODW', 'REPORTING', 'FINANCE', 'DATALAKE', 'INVESTMENTS'
                    , 'ORACLE_FUSION', 'FIVETRAN_ORACLE', 'FIVETRAN'] %}

select
    database_name as database_name
    , schema_name as schema_name
    , table_name  as table_name
    , fq_name     as fq_name
    , table_type  as table_type
from {{ ref('stg_snowflake_tables') }}
where 1 = 1
    and upper(
        database_name) in (
        'EDW' , 'ODW' , 'REPORTING' , 'FINANCE' , 'DATALAKE' , 'INVESTMENTS'
        , 'ORACLE_FUSION' , 'FIVETRAN_ORACLE' , 'FIVETRAN'
    )
