{# select

from {{ ref('flyer__stg_sod_accounts_history') }} #}

with cte_account_max_record as (
    select
        account_number
        , custodian
        , account_id
        , max(account_id)  as max_account_id
        , min(_created_at) as min_created_at
        , max(_created_at) as max_created_at
    from {{ ref('flyer__stg_accounts') }}
    group by all
)

, cte_max_collected as (
    select max(max_created_at) as max_created_at
    from cte_account_max_record
)

select
    'copilot'::text                          as system_name
    , 'mwa-options'                          as system_instance
    , system_name || '__' || system_instance as system_key
    , a.account_id
    , a.account_number
    , a.account_name
    , a.custodian
    , case
        when mc.max_created_at is not null
            then 1
        else 0
    end::int                                 as is_active
    , a.start_date
    , ca.total_value
    , ca.is_margin_enabled
    , ca.is_multiple_margin_enabled
    , ca.options_approval_level
    --, a.household_id
    --, a.cust_id
    --, a.model_id
    --, a.sleeve_id
    -- , a.import_date
    --, a.is_cash_account
    --, a.tax_lot_relief_method
    --, a.long_term_tax_rate
    --, a.short_term_tax_rate
    --, a.is_taxable
    --, a.is_disable_sleeves
    --, a.is_explicit_sleeve
    --, a.cash_reserve
    --, a.percent_or_value
    --, a.sleeves
    , a._created_at                          as last_collected_at
    , mr.min_created_at                      as first_collected_at
    , a.effective_date
    , {{ col_is_head(
        reference=ref('flyer__stg_accounts'),
        source_date_col='a.effective_date'
        ) }}
    , a._source_file
    , a._uri
    , a._env
from {{ ref('flyer__stg_accounts') }} as a
inner join cte_account_max_record as mr
    on a._created_at = mr.max_created_at
    and a.account_id = mr.account_id
left join {{ ref('custodian_accounts') }} as ca
    on a.account_number = ca.account_number
    and lower(ca.custodian) = lower(a.custodian)
    and ca.is_head = 1
left join cte_max_collected as mc
    on a._created_at::date = mc.max_created_at::date
where 1 = 1
qualify row_number() over (partition by a.account_number , a.custodian order by a._created_at desc) = 1
