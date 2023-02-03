select
    id
  , opportunity_id
  , user_id
  , name
  , photo_url
  , title
  , team_member_role
  , opportunity_access_level
  , created_date
  , created_by_id
  , last_modified_date
  , last_modified_by_id
  , system_modstamp
  , is_deleted
  , _fivetran_synced
from {{ source('salesforce_compass', 'opportunity_team_member') }}