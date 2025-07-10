{% set src = source('cambak', 'cbopportunity') %}
select
    opportunityid::int                   as opportunity_id
    , firmid::int                        as firm_id
    , opportunityname::text              as opportunity_name
    , opportunitytypeid::int             as opportunity_type_id
    , dealqualificationscore::int        as deal_qualification_score
    , sourceid::int                      as source_id
    , sourcesubtypeid::int               as source_subtype_id
    , bidtypeid::int                     as bid_type_id
    , feetypeid::int                     as fee_type_id
    , estimateannualfee::int             as estimate_annual_fee
    , submittalduedate::timestamp_ntz    as submittal_due_date
    , finalsdate::timestamp_ntz          as finals_date
    , winnotificationdate::timestamp_ntz as win_notification_date
    , revenuestartdate::timestamp_ntz    as revenue_start_date
    , contractdate::timestamp_ntz        as contract_date
    , opportunitydetails::text           as opportunity_details
    , createduserid::int                 as created_user_id
    , createddate::timestamp_ntz         as created_date
    , to_boolean(isdeleted::text)::int   as is_deleted
    , deleteduserid::int                 as deleted_user_id
    , deletedate::timestamp_ntz          as deleted_ate
    , stateid::int                       as state_id
    , regionid::int                      as region_id
    , discretionlevelid::int             as discretion_level_id
    , assetvalue::int                    as asset_value
    , lastrfpdate::timestamp_ntz         as last_rfp_date

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                    as _extracted_at
    , file_type::text                    as file_type
    , _created_at::timestamp             as _created_at
    , _source_file::text                 as _source_file
from {{ src }}
