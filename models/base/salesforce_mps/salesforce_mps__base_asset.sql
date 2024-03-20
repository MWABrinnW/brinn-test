select
    a.json:STREET::text(1600)                 as street
  , a.json:CREATED_DATE::timestamp_tz         as created_date
  , a.json:PURCHASE_DATE::date                as purchase_date
  , a.json:ACCOUNT_ID::text(900)              as account_id
  , a.json:LAST_MODIFIED_DATE::timestamp_tz   as last_modified_date
  , a.json:ROOT_ASSET_ID::text(900)           as root_asset_id
  , a.json:PARENT_ID::text(900)               as parent_id
  , a.json:PRICE::number(18, 2)               as price
  , a.json:LAST_MODIFIED_BY_ID::text(900)     as last_modified_by_id
  , a.json:PRODUCT_CODE::text(1600)           as product_code
  , a.json:ID::text(900)                      as id
  , a.json:ASSET_SERVICED_BY_ID::text(900)    as asset_serviced_by_id
  , a.json:SERIAL_NUMBER::text(1100)          as serial_number
  , a.json:LONGITUDE::float                   as longitude
  , a.json:QUANTITY::float                    as quantity
  , a.json:DESCRIPTION::text(96800)           as description
  , a.json:COUNTRY::text(1100)                as country
  , a.json:USAGE_END_DATE::date               as usage_end_date
  , a.json:NAME::text(1600)                   as name
  , a.json:CREATED_BY_ID::text(900)           as created_by_id
  , a.json:PRODUCT_2_ID::text(900)            as product_2_id
  , a.json:STOCK_KEEPING_UNIT::text(1400)     as stock_keeping_unit
  , a.json:INSTALL_DATE::date                 as install_date
  , a.json:IS_COMPETITOR_PRODUCT::boolean     as is_competitor_product
  , a.json:LAST_VIEWED_DATE::timestamp_tz     as last_viewed_date
  , a.json:CONTACT_ID::text(900)              as contact_id
  , a.json:STATUS::text(1600)                 as status
  , a.json:_FIVETRAN_DELETED::boolean         as _fivetran_deleted
  , a.json:OWNER_ID::text(900)                as owner_id
  , a.json:CITY::text(1000)                   as city
  , a.json:_FIVETRAN_SYNCED::timestamp_tz     as _fivetran_synced
  , a.json:LAST_REFERENCED_DATE::timestamp_tz as last_referenced_date
  , a.json:STATE::text(1100)                  as state
  , a.json:SYSTEM_MODSTAMP::timestamp_tz      as system_modstamp
  , a.json:ASSET_PROVIDED_BY_ID::text(900)    as asset_provided_by_id
  , a.json:GEOCODE_ACCURACY::text(1000)       as geocode_accuracy
  , a.json:IS_DELETED::boolean                as is_deleted
  , a.json:IS_INTERNAL::boolean               as is_internal
  , a.json:LATITUDE::float                    as latitude
  , a.json:ASSET_LEVEL::number(38, 0)         as asset_level
  , a.json:POSTAL_CODE::text(900)             as postal_code
  , a.effective_at::timestamp                 as effective_at
  , a._created_at::timestamp                  as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'asset'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end      as is_latest
from {{ source('salesforce_mps', 'asset') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'asset') }}
    group by 1, 2
)                                            b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
