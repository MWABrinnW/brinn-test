{{ config(
  enabled=false
) }}

select * from {{ ref('subledger') }}
where coalesce(is_excluded , 0) <> 1
