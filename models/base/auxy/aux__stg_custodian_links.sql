select
    json:CUSTODIAN::text(200)           as custodian
  , json:FIRM_SOURCE::text(200)         as firm_source
  , json:LINK::text(200)                as link
  , json:LINK_TYPE::text(200)           as link_type
  , json:LINK_SUBTYPE::text(200)        as link_subtype
  , json:LINK_DESCRIPTION::text(200)    as link_description
  , json:LINK_SUBTYPE_DETAIL::text(200) as link_subtype_detail
  , json:DESCRIPTION::text(1000)        as description
  , json:NOTES::text(1000)              as notes
  , json:LOCATION_CODE::text(200)       as location_code
  , json:LOCATION_CODE_NOTES::text(200) as location_code_notes
  , json:ADVISOR_EMAIL::text(200)       as advisor_email
  , nvl(json:IS_DECEASED::int,0)        as is_deceased
  , json:HAS_TRADING_AUTHORITY::int     as has_trading_authority
  , json:DEACTIVATED_DATE::date         as deactivated_date
  , json:_box_file_id::text(100)        as _box_file_id
  , null::text(100)                     as _box_sheet_name
  , _created_at::timestamp              as _source_loaded_at
from {{ source('aux', 'custodian_links') }}
qualify row_number() over(partition by custodian, link order by _created_at::timestamp desc) = 1
