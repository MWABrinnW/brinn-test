{{ config(
  grants = {'select': ['engineering']}
) }}

select
    json:ID::text                               as id
    , json:OWNER_ID::text                       as owner_id
    , json:IS_DELETED::text                     as is_deleted
    , json:NAME::text                           as name
    , json:RECORD_TYPE_ID::text                 as record_type_id
    , json:CREATED_DATE::timestamp_tz           as created_date
    , json:CREATED_BY_ID::text                  as created_by_id
    , json:LAST_MODIFIED_DATE::timestamp_tz     as last_modified_date
    , json:LAST_MODIFIED_BY_ID::text            as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamp_tz        as system_modstamp
    , json:LAST_ACTIVITY_DATE::timestamp_tz     as last_activity_date
    , json:LAST_VIEWED_DATE::timestamp_tz       as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamp_tz   as last_referenced_date
    , json:ESTATE_ITEM_C::text                  as estate_item_c
    , json:MHSERVICE_C::text                    as mhservice_c
    , json:RECIPIENT_C::text                    as recipient_c
    , json:PAYOUT_RATE_NEW_C::text              as payout_rate_new_c
    , json:CHANGE_YEAR_C::text                  as change_year_c
    , json:INITIAL_CHANGE_DATE_C::date          as initial_change_date_c
    , json:CLIENT_C::text                       as client_c
    , json:BILLING_ACCOUNT_C::text              as billing_account_c
    , json:NET_FEE_C::text                      as net_fee_c
    , json:GROSS_REVENUE_NO_ADJUSTMENTS_C::text as gross_revenue_no_adjustments_c
    , json:DISCOUNT_RATE_C::text                as discount_rate_c
    , json:BILLING_EXCEPTION_DETAILS_C::text    as billing_exception_details_c
    , json:CURRENT_QTR_FEE_C::decimal(18 , 2)   as current_qtr_fee_c
    , json:PREVIOUS_QTR_FEE_C::decimal(18 , 2)  as previous_qtr_fee_c
    , json:RECIPIENT_ROLE_C::text               as recipient_role_c
    , json:GROUP_NUMBER_C::text                 as group_number_c
    , json:INACTIVE_DATE_C::text                as inactive_date_c
    , json:IS_ACTIVE_C::text                    as is_active_c
    , json:IS_OVERRIDE_C::text                  as is_override_c
    , json:ORIGINAL_RATE_SOURCE_C::text         as original_rate_source_c
    , json:PAYOUT_RATE_INITIAL_C::text          as payout_rate_initial_c
    , json:PAYOUT_TYPE_C::text                  as payout_type_c
    , json:DO_NOT_PAY_C::text                   as do_not_pay_c
    , json:PAYEE_TYPE_C::text                   as payee_type_c
    , json:ADMIN_FEE_C::text                    as admin_fee_c
    , json:FEE_ORION_C::text                    as fee_orion_c
    , json:PAYOUT_RATE_ONGOING_C::text          as payout_rate_ongoing_c
    , json:EFFECTIVERATE_C::text                as effectiverate_c
    , json:BILLING_EXCEPTION_C::text            as billing_exception_c
    , json:BILLING_EXCEPTION_CATEGORY_C::text   as billing_exception_category_c
    , json:_FIVETRAN_DELETED::boolean           as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_tz       as _fivetran_synced
    , effective_at                              as effective_at
    , _created_at                               as _created_at
from {{ source('salesforce_compass', 'arapitem_c') }}
