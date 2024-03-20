select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:BILLING_GEOCODE_ACCURACY::text(1000)           as billing_geocode_accuracy
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:ACTIVATED_BY_ID::text(900)                     as activated_by_id
  , a.json:BILLING_CITY::text(1000)                       as billing_city
  , a.json:COMPANY_SIGNED_ID::text(900)                   as company_signed_id
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:SHIPPING_STATE::text(1100)                     as shipping_state
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:BILLING_STATE::text(1100)                      as billing_state
  , a.json:ACTIVATED_DATE::timestamp_tz                   as activated_date
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:SHIPPING_STREET::text(1600)                    as shipping_street
  , a.json:START_DATE::date                               as start_date
  , a.json:SHIPPING_COUNTRY::text(1100)                   as shipping_country
  , a.json:BILLING_POSTAL_CODE::text(900)                 as billing_postal_code
  , a.json:BILLING_LONGITUDE::float                       as billing_longitude
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:CUSTOMER_SIGNED_ID::text(900)                  as customer_signed_id
  , a.json:COMPANY_SIGNED_DATE::date                      as company_signed_date
  , a.json:STATUS::text(1100)                             as status
  , a.json:ACCOUNT_ID::text(900)                          as account_id
  , a.json:LAST_ACTIVITY_DATE::date                       as last_activity_date
  , a.json:CONTRACT_TERM::number(38, 0)                   as contract_term
  , a.json:OWNER_ID::text(900)                            as owner_id
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:OWNER_EXPIRATION_NOTICE::text(1000)            as owner_expiration_notice
  , a.json:LAST_APPROVED_DATE::timestamp_tz               as last_approved_date
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:SPECIAL_TERMS::text(4800)                      as special_terms
  , a.json:STATUS_CODE::text(1000)                        as status_code
  , a.json:SHIPPING_GEOCODE_ACCURACY::text(1000)          as shipping_geocode_accuracy
  , a.json:CUSTOMER_SIGNED_DATE::date                     as customer_signed_date
  , a.json:CUSTOMER_SIGNED_TITLE::text(1000)              as customer_signed_title
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:SHIPPING_LONGITUDE::float                      as shipping_longitude
  , a.json:BILLING_STREET::text(1600)                     as billing_street
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:CONTRACT_NUMBER::text(900)                     as contract_number
  , a.json:SHIPPING_LATITUDE::float                       as shipping_latitude
  , a.json:ID::text(900)                                  as id
  , a.json:BILLING_LATITUDE::float                        as billing_latitude
  , a.json:SHIPPING_POSTAL_CODE::text(900)                as shipping_postal_code
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:DESCRIPTION::text(96800)                       as description
  , a.json:END_DATE::date                                 as end_date
  , a.json:SHIPPING_CITY::text(1000)                      as shipping_city
  , a.json:BILLING_COUNTRY::text(1100)                    as billing_country
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'contract'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'contract') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'contract') }}
    group by 1, 2
)                                               b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
