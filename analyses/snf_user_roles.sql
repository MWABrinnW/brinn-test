-- The data returned by both queries is in the
-- SNOWFLAKE database, which has latency of up
-- to 3 hours to reflect changes

-- Get the effective role hierarchy for each user.
with
-- CTE gets all the roles each role is granted
ROLE_MEMBERSHIPS (ROLE_GRANTEE , ROLE_GRANTED_THROUGH_ROLE) as (
    select
        GRANTEE_NAME
        , "NAME"
    from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
    where GRANTED_TO = 'ROLE'
        and GRANTED_ON = 'ROLE'
        and DELETED_ON is null
)

-- CTE gets all roles a user is granted
, USER_MEMBERSHIPS (ROLE_GRANTED_TO_USER , USER_GRANTEE , GRANTED_BY) as (
    select
        ROLE
        , GRANTEE_NAME
        , GRANTED_BY
    from SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS
    where DELETED_ON is null
)

--
select
    USER_GRANTEE
    , coalesce (ROLE_GRANTED_THROUGH_ROLE , ROLE_GRANTED_TO_USER)
        as EFFECTIVE_ROLE
    , GRANTED_BY
    , ROLE_GRANTEE
    , ROLE_GRANTED_TO_USER
    , ROLE_GRANTED_THROUGH_ROLE
from USER_MEMBERSHIPS as U
left join ROLE_MEMBERSHIPS as R
    on U.ROLE_GRANTED_TO_USER = R.ROLE_GRANTEE;
