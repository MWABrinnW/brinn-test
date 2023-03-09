select
    dn                                                             as group_id
  , primarygrouptoken                                              as group_token
  , name                                                           as group_name
  , regexp_replace(regexp_replace(c.value::string, ',.*'), 'CN=')  as user_name
  , regexp_replace(c.value::string, '"\".*\""')                    as user_id
  , record_date                                                    as record_date
  , record_datetime                                                as record_datetime
  , {{ col_is_head(reference=source('active_directory_mwa', 'groups_history'), reference_date_col='record_datetime', source_date_col='record_datetime') }}
from {{ source('active_directory_mwa', 'groups_history') }}
   , lateral flatten(input =>split(member, ';')) c