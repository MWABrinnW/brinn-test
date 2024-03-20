select
    a.json:LAST_MODIFIED_DATE::timestamp_tz      as last_modified_date
  , a.json:SHIPPING_POSTAL_CODE::text(900)       as shipping_postal_code
  , a.json:ID::text(900)                         as id
  , a.json:SHIPPING_STREET::text(1600)           as shipping_street
  , a.json:BILLING_LONGITUDE::float              as billing_longitude
  , a.json:LAST_VIEWED_DATE::timestamp_tz        as last_viewed_date
  , a.json:LAST_MODIFIED_BY_ID::text(900)        as last_modified_by_id
  , a.json:BILLING_STATE::text(1100)             as billing_state
  , a.json:DESCRIPTION::text(96800)              as description
  , a.json:SYSTEM_MODSTAMP::timestamp_tz         as system_modstamp
  , a.json:ACCOUNT_ID::text(900)                 as account_id
  , a.json:SHIPPING_LATITUDE::float              as shipping_latitude
  , a.json:BILLING_STREET::text(1600)            as billing_street
  , a.json:EFFECTIVE_DATE::date                  as effective_date
  , a.json:SHIPPING_LONGITUDE::float             as shipping_longitude
  , a.json:ACTIVATED_DATE::timestamp_tz          as activated_date
  , a.json:BILLING_LATITUDE::float               as billing_latitude
  , a.json:TOTAL_AMOUNT::number(18, 2)           as total_amount
  , a.json:IS_REDUCTION_ORDER::boolean           as is_reduction_order
  , a.json:OWNER_ID::text(900)                   as owner_id
  , a.json:END_DATE::date                        as end_date
  , a.json:SHIPPING_CITY::text(1000)             as shipping_city
  , a.json:CONTRACT_ID::text(900)                as contract_id
  , a.json:TYPE::text(1600)                      as type
  , a.json:_FIVETRAN_SYNCED::timestamp_tz        as _fivetran_synced
  , a.json:ORIGINAL_ORDER_ID::text(900)          as original_order_id
  , a.json:LAST_REFERENCED_DATE::timestamp_tz    as last_referenced_date
  , a.json:SHIPPING_COUNTRY::text(1100)          as shipping_country
  , a.json:CREATED_BY_ID::text(900)              as created_by_id
  , a.json:BILLING_POSTAL_CODE::text(900)        as billing_postal_code
  , a.json:PRICEBOOK_2_ID::text(900)             as pricebook_2_id
  , a.json:BILLING_CITY::text(1000)              as billing_city
  , a.json:ACTIVATED_BY_ID::text(900)            as activated_by_id
  , a.json:IS_DELETED::boolean                   as is_deleted
  , a.json:STATUS_CODE::text(1000)               as status_code
  , a.json:BILLING_GEOCODE_ACCURACY::text(1000)  as billing_geocode_accuracy
  , a.json:_FIVETRAN_DELETED::boolean            as _fivetran_deleted
  , a.json:STATUS::text(1100)                    as status
  , a.json:BILLING_COUNTRY::text(1100)           as billing_country
  , a.json:SHIPPING_STATE::text(1100)            as shipping_state
  , a.json:COMPANY_AUTHORIZED_BY_ID::text(900)   as company_authorized_by_id
  , a.json:SHIPPING_GEOCODE_ACCURACY::text(1000) as shipping_geocode_accuracy
  , a.json:CREATED_DATE::timestamp_tz            as created_date
  , a.json:CUSTOMER_AUTHORIZED_BY_ID::text(900)  as customer_authorized_by_id
  , a.json:ORDER_NUMBER::text(900)               as order_number
  , a.effective_at::timestamp                    as effective_at
  , a._created_at::timestamp                     as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'ORDER'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end         as is_latest
from {{ source('salesforce_mps', 'ORDER') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'ORDER') }}
    group by 1, 2
)                                            b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
