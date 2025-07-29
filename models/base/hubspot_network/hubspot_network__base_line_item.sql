select
    a.json:ID::text(500)                                 as id
  , a.json:PRODUCT_ID::text(500)                         as product_id
  , a.json:DEAL_ID::text(500)                            as deal_id
  , a.json:IS_DELETED::text(500)                         as is_deleted
  , a.json:PROPERTY_PRICE::text(500)                     as property_price
  , a.json:PROPERTY_CREATEDATE::text(500)                as property_createdate
  , a.json:PROPERTY_DESCRIPTION::text(500)               as property_description
  , a.json:PROPERTY_HS_LASTMODIFIEDDATE::text(500)       as property_hs_lastmodifieddate
  , a.json:PROPERTY_HS_POSITION_ON_QUOTE::text(500)      as property_hs_position_on_quote
  , a.json:PROPERTY_QUANTITY::text(500)                  as property_quantity
  , a.json:PROPERTY_HS_OBJECT_ID::text(500)              as property_hs_object_id
  , a.json:PROPERTY_HS_UPDATED_BY_USER_ID::text(500)     as property_hs_updated_by_user_id
  , a.json:PROPERTY_HS_CREATED_BY_USER_ID::text(500)     as property_hs_created_by_user_id
  , a.json:PROPERTY_RECURRINGBILLINGFREQUENCY::text(500) as property_recurringbillingfrequency
  , a.json:PROPERTY_NAME::text(500)                      as property_name
  , a.json:_FIVETRAN_SYNCED::text(500)                   as _fivetran_synced
  , a.json:PROPERTY_HS_URL::text(500)                    as property_hs_url

  , a.effective_at::timestamp                            as effective_at
  , a._created_at::timestamp                             as _created_at
  , {{ col_is_head(reference=source('hubspot_network', 'line_item'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                 as is_latest
from {{ source('hubspot_network', 'line_item') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('hubspot_network', 'line_item') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at