with cte_max_per_day as (
    select
        _uri
        , _created_at::date as _created_date
        , {{ parse_copilot_env(col='_uri') }}
        , max(_created_at)  as _max_created_at_for_day
    from {{ source('flyer', 'accounts') }}
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
    , a.json:accountId::int                            as account_id
    , a.json:accountNumber::text(200)                  as account_number
    , a.json:name::text(200)                           as account_name
    , a.json:custodian::text(200)                      as custodian
    , a.json:householdId::text(200)                    as household_id
    , a.json:custId::text(200)                         as cust_id
    , a.json:modelId::text(200)                        as model_id
    --doesn't populate, use the groups payload
    -- , a.json:groupId::text(200) as group_id
    , a.json:sleeveId::text(200)                       as sleeve_id
    , to_timestamp(
        a.json:startDate::varchar(100)
        , 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'
    )::date                                            as start_date
    , to_timestamp(
        a.json:importDate::varchar(100)
        , 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'
    )::date                                            as import_date
    , try_to_boolean(a.json:cashAccount::text)::int    as is_cash_account
    , a.json:taxLotReliefMethod                        as tax_lot_relief_method
    , a.json:longTermTaxRate                           as long_term_tax_rate
    , a.json:shortTermTaxRate                          as short_term_tax_rate
    , try_to_boolean(a.json:taxable::text)::int        as is_taxable
    , try_to_boolean(a.json:disableSleeves::text)::int as is_disable_sleeves
    , try_to_boolean(a.json:explicitSleeve::text)::int as is_explicit_sleeve
    , a.json:cashReserve                               as cash_reserve
    , a.json:percentOrValue                            as percent_or_value
    , a.json:sleeves                                   as sleeves
    , case
        when mx._max_created_at is not null
            then 1
        else 0
    end::int
        as is_head
    , case
        when a._created_at = mxpd._max_created_at_for_day
            then 1
        else 0
    end::int
        as is_head_for_day
    -- Derive effective date based on record created date
    , dt.prior_market_date                             as effective_date
    , a._created_at                                    as _created_at
    , a._source_file                                   as _source_file
    , a._uri                                           as _uri
    , {{ parse_copilot_env(col='a._uri') }}
from {{ source('flyer', 'accounts') }} as a
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
