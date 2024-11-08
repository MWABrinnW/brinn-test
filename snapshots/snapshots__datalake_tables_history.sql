{% snapshot snapshots__datalake_tables_history %}
{{
    config(
        enabled=false,
        target_schema=target.schema,
        unique_key='unique_key',
        strategy='check',
        check_cols='all',
        invalidate_hard_deletes=True
    )
}}

select *
    , table_schema||table_name as unique_key
from {{ ref('dim_information_schema_sources') }}

{%- endsnapshot -%}