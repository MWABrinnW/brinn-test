with cte_max_per_day as (
    select
        _uri
        , _created_at::date as _created_date
        , {{ parse_copilot_env(col='_uri') }}
        , max(_created_at)  as _max_created_at_for_day
    from {{ source('flyer', 'restrictions') }}
    where _env = {{ "'" ~ copilot_env() ~ "'" }}
    group by all
)

, cte_max as (
    select
        _uri
        , max(_max_created_at_for_day) as _max_created_at
    from cte_max_per_day
    group by _uri
)

select
     'copilot'::text as system_name
    , 'mwa-options' as system_instance
    , system_name || '__' || system_instance as system_key
    , to_date(
        a.json:restrictionStartDate::text(200), 'YYYYMMDD'
        )                                                       as restriction_start_date
    , case
        when a.json:restrictionEndDate != ''
            then to_date(a.json:restrictionEndDate::text(200), 'YYYYMMDD')
    end                                                         as restriction_end_date
    , try_to_boolean(a.json:enabled::text)::int                 as is_enabled
    , a.json:restrictionId::text(200)                           as restriction_id
    , a.json:accountId::text(200)                               as account_id
    , a.json:custId::text(200)                                  as cust_id
    , a.json:userId::text(200)                                  as user_id
    , a.json:restrictionType::text(200)                         as restriction_type
    , a.json:extRestriction::text(200)                          as external_restriction
    , a.json:restrictionMapping::text(200)                      as restriction_mapping
    , a.json:securityId::text(200)                              as security_id
    , a.json:cusip::text(200)                                   as cusip
    , a.json:product::text(200)                                 as product
    , a.json:notes::text(200)                                   as notes
    , to_timestamp_tz(
        a.json:lastModified::text(200)
        , 'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM'
    )                                                           as last_modified_at
    , case
        when mx._max_created_at is not null
            then 1
        else 0
    end::int                                                    as is_head
    , case
        when a._created_at = mxpd._max_created_at_for_day
            then 1
        else 0
    end::int                                                    as is_head_for_day
    , dt.prior_market_date                                      as effective_date
    , a._created_at                                             as _created_at
    , a._source_file                                            as _source_file
    , a._uri                                                    as _uri
    , {{ parse_copilot_env(col='a._uri') }}
from {{ source('flyer', 'restrictions') }} as a
left join cte_max as mx
    on a._uri = mx._uri
    and a._created_at = mx._max_created_at
left join cte_max_per_day as mxpd
    on a._uri = mxpd._uri
    and a._created_at::date = mxpd._created_date
left join {{ ref('dates' ) }} as dt
    on a._created_at::date = dt.date_key
where 1 = 1
    and _env = {{ "'" ~ copilot_env() ~ "'" }}
