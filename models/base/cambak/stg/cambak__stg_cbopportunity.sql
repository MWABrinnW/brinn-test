{% set src = source('cambak', 'cbopportunity') %}
select
    opportunityid::int                                                         as opportunity_id
    , firmid::int                                                              as firm_id
    , opportunityname::text                                                    as opportunity_name
    , opportunitytypeid::int                                                   as opportunity_type_id
    , dealqualificationscore::int                                              as deal_qualification_score
    , sourceid::int                                                            as source_id
    , sourcesubtypeid::int                                                     as source_subtype_id
    , bidtypeid::int                                                           as bid_type_id
    , feetypeid::int                                                           as fee_type_id
    , estimateannualfee::int                                                   as estimate_annual_fee
    , to_timestamp_ntz(submittalduedate::text , 'MM/DD/YYYY HH12:MI:SS AM')    as submittal_due_date
    , to_timestamp_ntz(finalsdate::text , 'MM/DD/YYYY HH12:MI:SS AM')          as finals_date
    , to_timestamp_ntz(winnotificationdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as win_notification_date
    , to_timestamp_ntz(revenuestartdate::text , 'MM/DD/YYYY HH12:MI:SS AM')    as revenue_start_date
    , to_timestamp_ntz(contractdate::text , 'MM/DD/YYYY HH12:MI:SS AM')        as contract_date
    , opportunitydetails::text                                                 as opportunity_details
    , createduserid::int                                                       as created_user_id
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM')         as created_date
    , to_boolean(isdeleted::text)::int                                         as is_deleted
    , deleteduserid::int                                                       as deleted_user_id
    , to_timestamp_ntz(deletedate::text , 'MM/DD/YYYY HH12:MI:SS AM')          as deleted_ate
    , stateid::int                                                             as state_id
    , regionid::int                                                            as region_id
    , discretionlevelid::int                                                   as discretion_level_id
    , assetvalue::int                                                          as asset_value
    , to_timestamp_ntz(lastrfpdate::text , 'MM/DD/YYYY HH12:MI:SS AM')         as last_rfp_date

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                          as _extracted_at
    , file_type::text                                                          as file_type
    , _created_at::timestamp                                                   as _created_at
    , _source_file::text                                                       as _source_file
from {{ src }}
