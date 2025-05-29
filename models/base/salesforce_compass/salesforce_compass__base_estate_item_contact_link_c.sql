select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OWNER_ID::varchar(18)                            as owner_id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:CONTACT_C::varchar(18)                           as contact_c
    , a.json:ESTATE_ITEM_C::varchar(18)                       as estate_item_c
    , a.json:ROLE_C::varchar(4099)                            as role_c
    , a.json:SORT_ORDER_C::double                             as sort_order_c
    , a.json:BENEFICIARY_SHARE_PERCENTAGE_C::double           as beneficiary_share_percentage_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:ROLE_FILTER_C::varchar(3900)                     as role_filter_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'estate_item_contact_link_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_head_for_day
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_latest
    , case
        when a._created_at = min(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_earliest
from {{ source('salesforce_compass', 'estate_item_contact_link_c') }} as a
