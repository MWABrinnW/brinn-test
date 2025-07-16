{{ config(
    materialized='view',
    schema='enterprise',
    tags=['edw','snowflake'],    
    grants={'select': ['db_edw_general_r']}
) }}

select
    user_id
    , user_name
    , login_name
    , display_name
    , first_name
    , last_name
    , email
    , owner
    , default_role
    , default_warehouse
    , disabled
    , last_success_login
from {{ ref('stg_snowflake_users') }}
