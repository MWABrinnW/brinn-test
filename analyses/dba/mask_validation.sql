-- Show masking policy
SHOW MASKING POLICIES;

-- Describe masking policy
DESCRIBE MASKING POLICY <masking-policy-name>;

-- Show masking policy references
USE DATABASE <database-name>;

USE SCHEMA INFORMATION_SCHEMA;

SELECT *
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(POLICY_NAME => '<database-name>.<schema-name>.<masking-policy-name>'));

select *
from snowflake.account_usage.masking_policies
;
