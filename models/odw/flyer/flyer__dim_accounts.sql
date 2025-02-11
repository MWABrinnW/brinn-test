with accounts as (
    select
        system_name
        , system_instance
        , system_key
        , account_id
        , account_number
        , account_name
        , custodian
        , start_date
        , import_date
        , _created_at
        , effective_date
        , _source_file
        , _uri
        , _env
    from {{ ref('flyer__stg_accounts') }}
    where 1 = 1
        and is_head = 1
)

, cte_option_requirement as (
    select
        account_number        as account_number
        , 'schwab'            as custodian
        , option_requirements as option_requirements
    from {{ ref('schwab__base_cash') }}
    where is_head = 1
        and rn_global = 1
        and account_number in (
            select distinct t.account_number
            from accounts as t
        )

    union all

    select
        account_number              as account_number
        , 'fidelity'                as custodian
        , house_option_requirements as option_requirements
    from {{ ref('fidelity__stg_option_reqs') }}
    where is_head = 1
        and account_number in (
            select distinct t.account_number
            from accounts as t
        )
)

, custodian_accounts as (
    select
        custodian
        , account_number
        , total_value
        , is_margin_enabled
        , is_multiple_margin_enabled
        , options_approval_level
    from {{ ref('custodian_accounts') }}
    where 1 = 1
        and is_head = 1
)

, sod_accounts as (
    select account_no as account_number
    from {{ ref('flyer__stg_sod_accounts_history') }}
    where is_head = 1
    group by all
)

, account_groups as (
    select
        a.account_id       as account_id
        , a.account_number as account_number
        , array_agg(distinct a.group_name) within group (
            order by a.group_name
        )                  as groups
    --, lower(a.custodian) as custodian
    --, a._created_at      as last_collected_at
    --, a._source_file     as _source_file
    from {{ ref('flyer__stg_groups') }} as a
    where 1 = 1
        and a.is_head = 1
    group by all
)

select
    'copilot'::text                          as system_name
    , 'mwa-options'                          as system_instance
    , system_name || '__' || system_instance as system_key
    , a.account_id                           as account_id
    , a.account_number                       as account_number
    , a.account_name                         as account_name
    , a.custodian                            as custodian
    , case
        when soda.account_number is not null
            then 1
        else 0
    end::int                                 as is_linked
    , ag.groups                              as groups
    , a.start_date                           as start_date
    , ca.total_value                         as total_value
    , ca.is_margin_enabled                   as is_margin_enabled
    , ca.is_multiple_margin_enabled          as is_multiple_margin_enabled
    , ca.options_approval_level              as options_approval_level
    , opr.option_requirements                as option_requirements
    , a.import_date                          as created_date
    , a._created_at                          as last_collected_at
    , a.effective_date                       as effective_date
    , {{ col_is_head(
        reference=ref('flyer__stg_accounts'),
        source_date_col='a.effective_date'
        ) }}
    , a._source_file                         as _source_file
    , a._uri                                 as _uri
    , a._env                                 as _env
from accounts as a
left join account_groups as ag
    on a.account_id = ag.account_id
left join sod_accounts as soda
    on a.account_number = soda.account_number
left join cte_option_requirement as opr
    on a.account_number = opr.account_number
    and lower(a.custodian) = lower(opr.custodian)
left join custodian_accounts as ca
    on a.account_number = ca.account_number
    and lower(ca.custodian) = lower(a.custodian)
where 1 = 1
qualify row_number() over (
        partition by a.account_number , a.custodian
        order by a._created_at desc
    ) = 1
