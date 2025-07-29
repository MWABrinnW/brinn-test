{{ config(
    materialized='view',
)}}


{{ dbt_date.get_date_dimension("2000-01-01", "2040-12-31") }}