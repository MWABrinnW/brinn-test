select
    json:_office_location::text(100)              as office_location
  , json:_custodian::text(100)                    as custodian
  , json:_advisor_code::text(100)                 as advisor_code
  , json:_type::text(100)                         as type
  , json:_status::text(100)                       as status
  , json:_description::text(500)                  as description
  , json:_notes::text(500)                        as notes
  , json:_hq_master_code::text(100)               as hq_master_code
  , json:_data_feed::text(100)                    as data_feed
  , json:_pricing::text(100)                      as pricing
  , json:_1mariner_transition::varchar(100)       as one_mariner_transition
  , json:_3rd_party_managed::text(100)            as third_party_managed
  , json:_trading_authority::text(100)            as trading_authority
  , json:_rpp_was_or_san::text(100)               as rpp_wa_or_san
  , json:_open_date::text(100)                    as open_date
  , json:_old_rep_code::text(100)                 as old_rep_code
  , json:vendor_transmission::text(100)           as vendor_transmission
  , json:options_level_approval::text(100)        as options_level_approval
  , json:prime_broker::text(100)                  as prime_broker
  , json:standing_linking_instructions::text(100) as standing_linking_instructions
  , json:statement_preferences::text(100)         as statement_preferences
  , json:__box_file_id::text(100)                 as _box_file_id
  , json:__box_sheet_name::text(100)              as _box_sheet_name
  , _created_at::timestamp                        as _created_at
from {{ source('aux', 'custodian_codes_master_list') }}