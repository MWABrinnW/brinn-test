{{ config(materialized='view') }}

select *
from {{ ref('base_model') }}
