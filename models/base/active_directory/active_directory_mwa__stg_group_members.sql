
select
    g.dn                                as group_id
  , g.primarygrouptoken                 as group_token
  , g.name                              as group_name
  , regexp_replace(regexp_replace(c.value::string, ',.*'), 'cn=') as user_name
  , regexp_replace(c.value::string, '"\".*\""') as user_id
  , g.record_date::date                 as record_date
  , g.record_datetime::timestamp        as _created_at
  , {{ col_is_head(
      reference=source('active_directory_mwa', 'groups_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='record_datetime::timestamp'
      ) }}
from {{ source('active_directory_mwa', 'groups_history') }} g
   , lateral flatten(input =>split(member, ';')) c

