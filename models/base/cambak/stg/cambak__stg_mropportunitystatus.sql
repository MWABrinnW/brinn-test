select
    assetvalue::text                   as asset_value
    , bidtypeid::integer               as bid_type_id
    , contractdate::timestamp_ntz      as contract_date
    , createddate::text                as created_date
    , createduserid::integer           as created_user_id
    , dealqualificationscore::integer  as deal_qualification_score
    , deletedate::text                 as delete_date
    , deleteduserid::integer           as deleted_user_id
    , discretionlevelid::text          as discretion_level_id
    , estimateannualfee::float         as estimate_annual_fee
    , feetypeid::integer               as fee_type_id
    , finalsdate::timestamp_ntz        as finals_date
    , firmid::integer                  as fir_id
    , to_boolean(isdeleted::text)::int as is_deleted
    , opportunitydetails::text         as opportunity_details
    , opportunityid::integer           as opportunity_id
    , opportunityname::text            as opportunity_name
    , opportunitytypeid::integer       as opportunity_type_id
    , regionid::text                   as region_id
    , revenuestartdate::timestamp_ntz  as revenue_start_date
    , sourceid::integer                as source_id
    , sourcesubtypeid::text            as source_subtype_id
    , stateid::text                    as state_id
    , statusdate::text                 as status_date
    , statusid::integer                as status_id
    , submittalduedate::text           as submittal_due_date
    , winnotificationdate::text        as win_notification_date
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                  as _extracted_at
    , file_type::text                  as file_type
    , _created_at::timestamp           as _created_at
    , _source_file::text               as _source_file
from {{ source('cambak', 'mropportunitystatus') }}
