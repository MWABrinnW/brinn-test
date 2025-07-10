select
    assetvalue::text                     as asset_value
    , bidtype::text                      as bid_type
    , bidtypeid::integer                 as bid_type_id
    , contractdate::timestamp_ntz        as contract_date
    , createdby::text                    as created_by
    , createdbyid::integer               as created_by_id
    , createddate::timestamp_ntz         as created_date
    , currentstatus::text                as current_status
    , currentstatusdate::timestamp_ntz   as current_status_date
    , currentstatusid::integer           as current_status_id
    , dealqualificationscore::integer    as deal_qualification_score
    , deletedate::timestamp_ntz          as delete_date
    , deletedby::text                    as deleted_by
    , deletedbyid::integer               as deleted_by_id
    , discretionlevel::text              as discretion_level
    , discretionlevelid::text            as discretion_level_id
    , estimateannualfee::float           as estimate_annual_fee
    , feetype::text                      as fee_type
    , feetypeid::integer                 as fee_type_id
    , finalsdate::timestamp_ntz          as finals_date
    , firmid::integer                    as firm_id
    , to_boolean(isdeleted::text)::int   as is_deleted
    , isregisteredprospect::integer      as is_registered_prospect
    , opportunitydetails::text           as opportunity_details
    , opportunityid::integer             as opportunity_id
    , opportunityname::text              as opportunity_name
    , opportunitytype::text              as opportunity_type
    , opportunitytypeid::integer         as opportunity_type_id
    , regionid::text                     as region_id
    , revenuestartdate::timestamp_ntz    as revenue_start_date
    , source::text                       as source
    , sourceid::integer                  as source_id
    , sourcesubtype::text                as source_subtype
    , sourcesubtypeid::text              as source_subtype_id
    , state::text                        as state
    , stateid::text                      as stateid
    , submittalduedate::timestamp_ntz    as submittal_due_date
    , winnotificationdate::timestamp_ntz as win_notification_date
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                    as _extracted_at
    , file_type::text                    as file_type
    , _created_at::timestamp             as _created_at
    , _source_file::text                 as _source_file
from {{ source('cambak', 'opportunityex') }}
