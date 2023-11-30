select
    json:ID::text(200)                             as id
  , json:OWNER_ID::text(200)                       as owner_id
  , json:IS_DELETED::text(200)                     as is_deleted
  , json:NAME::text(200)                           as name
  , json:RECORD_TYPE_ID::text(200)                 as record_type_id
  , json:CREATED_DATE::timestamp_tz                as created_date
  , json:CREATED_BY_ID::text(200)                  as created_by_id
  , json:LAST_MODIFIED_DATE::timestamp_tz          as last_modified_date
  , json:LAST_MODIFIED_BY_ID::text(200)            as last_modified_by_id
  , json:SYSTEM_MODSTAMP::timestamp_tz             as system_modstamp
  , json:LAST_ACTIVITY_DATE::timestamp_tz          as last_activity_date
  , json:LAST_VIEWED_DATE::timestamp_tz            as last_viewed_date
  , json:LAST_REFERENCED_DATE::timestamp_tz        as last_referenced_date
  , json:ESTATE_ITEM_C::text(200)                  as estate_item_c
  , json:MHSERVICE_C::text(200)                    as mhservice_c
  , json:RECIPIENT_C::text(200)                    as recipient_c
  , json:PAYOUT_RATE_NEW_C::text(200)              as payout_rate_new_c
  , json:CHANGE_YEAR_C::text(200)                  as change_year_c
  , json:INITIAL_CHANGE_DATE_C::date               as initial_change_date_c
  , json:CLIENT_C::text(200)                       as client_c
  , json:BILLING_ACCOUNT_C::text(200)              as billing_account_c
  , json:NET_FEE_C::text(200)                      as net_fee_c
  , json:GROSS_REVENUE_NO_ADJUSTMENTS_C::text(200) as gross_revenue_no_adjustments_c
  , json:DISCOUNT_RATE_C::text(200)                as discount_rate_c
  , json:BILLING_EXCEPTION_DETAILS_C::text(200)    as billing_exception_details_c
  , json:CURRENT_QTR_FEE_C::decimal(18, 2)         as current_qtr_fee_c
  , json:PREVIOUS_QTR_FEE_C::decimal(18, 2)        as previous_qtr_fee_c
  , json:RECIPIENT_ROLE_C::text(200)               as recipient_role_c
  , json:_FIVETRAN_DELETED::boolean                as _fivetran_deleted
  , json:_FIVETRAN_SYNCED::timestamp_tz            as _fivetran_synced
  , effective_at                                   as effective_at
  , _created_at                                    as _created_at
from {{ source('salesforce_compass', 'arapitem_c') }}
