select
    a.json:ORDER_ID::text(900)               as order_id
  , a.json:_FIVETRAN_DELETED::boolean        as _fivetran_deleted
  , a.json:ORIGINAL_ORDER_ITEM_ID::text(900) as original_order_item_id
  , a.json:CREATED_BY_ID::text(900)          as created_by_id
  , a.json:AVAILABLE_QUANTITY::float         as available_quantity
  , a.json:SERVICE_DATE::date                as service_date
  , a.json:LAST_MODIFIED_DATE::timestamp_tz  as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID::text(900)    as last_modified_by_id
  , a.json:LIST_PRICE::number(18, 2)         as list_price
  , a.json:UNIT_PRICE::number(18, 2)         as unit_price
  , a.json:ORDER_ITEM_NUMBER::text(900)      as order_item_number
  , a.json:_FIVETRAN_SYNCED::timestamp_tz    as _fivetran_synced
  , a.json:ID::text(900)                     as id
  , a.json:PRICEBOOK_ENTRY_ID::text(900)     as pricebook_entry_id
  , a.json:DESCRIPTION::text(1600)           as description
  , a.json:CREATED_DATE::timestamp_tz        as created_date
  , a.json:TOTAL_PRICE::number(18, 2)        as total_price
  , a.json:PRODUCT_2_ID::text(900)           as product_2_id
  , a.json:SYSTEM_MODSTAMP::timestamp_tz     as system_modstamp
  , a.json:IS_DELETED::boolean               as is_deleted
  , a.json:END_DATE::date                    as end_date
  , a.json:QUANTITY::float                   as quantity
  , a.effective_at::timestamp                as effective_at
  , a._created_at::timestamp                 as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'order_item'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end     as is_latest
from {{ source('salesforce_mps', 'order_item') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'order_item') }}
    group by 1, 2
)                                                 b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
