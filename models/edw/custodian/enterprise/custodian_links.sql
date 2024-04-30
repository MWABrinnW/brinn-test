select
    custodian               as custodian
    , link                  as link
    , effective_start_date  as effective_start_date
    , effective_end_date    as effective_end_date
    , firm_source           as firm_source
    , link_type             as link_type
    , link_subtype          as link_subtype
    , null::text(200)       as link_description
    , null::text(200)       as link_subtype_detail
    , description           as description
    , notes                 as notes
    , location_code         as location_code
    , location_code_notes   as location_code_notes
    , advisor_email         as advisor_email
    , is_deceased           as is_deceased
    , has_trading_authority as has_trading_authority
    , deactivated_date      as deactivated_date
    , is_from_tda_migration as is_from_tda_migration
    , added_date            as added_date
    , added_notes           as added_notes
    , _box_file_id          as _box_file_id
    , _box_sheet_name       as _box_sheet_name
    , _source_loaded_at     as _source_loaded_at
from {{ ref('aux__stg_custodian_links') }}
order by custodian , link , effective_start_date
