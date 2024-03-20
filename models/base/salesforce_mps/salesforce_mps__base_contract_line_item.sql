select
    'salesforce'::text(200)                               as system_name
  , 'baystate'::text(200)                                 as system_instance
  , concat(system_name, '__', system_instance)::text(200) as system_key
  , 'mps'::text(200)                                      as firm_source
  , a.json:LAST_REFERENCED_DATE::timestamp_tz             as last_referenced_date
  , a.json:SUBTOTAL::number(18, 2)                        as subtotal
  , a.json:SYSTEM_MODSTAMP::timestamp_tz                  as system_modstamp
  , a.json:END_DATE::date                                 as end_date
  , a.json:LINE_ITEM_NUMBER::text(1600)                   as line_item_number
  , a.json:LAST_VIEWED_DATE::timestamp_tz                 as last_viewed_date
  , a.json:LIST_PRICE::number(18, 2)                      as list_price
  , a.json:SERVICE_CONTRACT_ID::text(900)                 as service_contract_id
  , a.json:_FIVETRAN_DELETED::boolean                     as _fivetran_deleted
  , a.json:STATUS::text(1600)                             as status
  , a.json:ROOT_CONTRACT_LINE_ITEM_ID::text(900)          as root_contract_line_item_id
  , a.json:LAST_MODIFIED_BY_ID::text(900)                 as last_modified_by_id
  , a.json:CREATED_DATE::timestamp_tz                     as created_date
  , a.json:ASSET_ID::text(900)                            as asset_id
  , a.json:PARENT_CONTRACT_LINE_ITEM_ID::text(900)        as parent_contract_line_item_id
  , a.json:ID::text(900)                                  as id
  , a.json:CREATED_BY_ID::text(900)                       as created_by_id
  , a.json:PRODUCT_2_ID::text(900)                        as product_2_id
  , a.json:START_DATE::date                               as start_date
  , a.json:PRICEBOOK_ENTRY_ID::text(900)                  as pricebook_entry_id
  , a.json:UNIT_PRICE::number(18, 2)                      as unit_price
  , a.json:QUANTITY::float                                as quantity
  , a.json:_FIVETRAN_SYNCED::timestamp_tz                 as _fivetran_synced
  , a.json:DESCRIPTION::text(96800)                       as description
  , a.json:IS_DELETED::boolean                            as is_deleted
  , a.json:LAST_MODIFIED_DATE::timestamp_tz               as last_modified_date
  , a.json:TOTAL_PRICE::number(18, 2)                     as total_price
  , a.json:DISCOUNT::float                                as discount
  , a.json:LOCATION_ID::text(900)                         as location_id
  , a.effective_at::timestamp                             as effective_at
  , a._created_at::timestamp                              as _created_at
  , {{ col_is_head(
    reference=source('salesforce_mps', 'contract_line_item'),
    source_date_col='a.effective_at',
    reference_date_col='effective_at'
    ) }}
  , case when b.rn = 1 then 1 else 0 end                  as is_latest
from {{ source('salesforce_mps', 'contract_line_item') }} a
left join (
    select
        effective_at::date                                                            as effective_at
      , _created_at                                                                   as _created_at
      , row_number() over (partition by effective_at::date order by _created_at desc) as rn
    from {{ source('salesforce_mps', 'contract_line_item') }}
    group by 1, 2
)                                                         b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at
