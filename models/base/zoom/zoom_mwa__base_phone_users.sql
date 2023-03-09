SELECT
    json:id::varchar(100)                               as id
  , json:phone_user_id::varchar(100)                    as phone_user_id
  , json:email::varchar(100)                            as email
  , json:name::varchar(100)                             as name
  , json:extension_id::varchar(50)                      as extension_id
  , json:extension_number::varchar(10)                  as extension_number
  , json:status::varchar(50)                            as status
  , json:calling_plans::varchar(200)                    as calling_plans
  , json:site:id::varchar(100)                          as site_id
  , json:site:name::varchar(100)                        as site_name
  , effective_at::timestamp                             as effective_at
  , {{ col_is_head(reference=source('zoom_mwa', 'phone_users'), reference_date_col='_created_at', source_date_col='_created_at') }}
  , _created_at::timestamp                              as _created_at
  , _source_file                                        as _source_file
FROM {{ source('zoom_mwa', 'phone_users') }}