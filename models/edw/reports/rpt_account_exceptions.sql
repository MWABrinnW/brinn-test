-- [account decision clash] surfaces accounts with identical decision tree values;
-- i.e., the chosen primary account was made arbitrarily
with bld_accounts as (
    select a.*
    from {{ ref('bld_accounts') }} as a
    inner join {{ ref('dates') }} as dt
        -- Filter to latest date
        on a.effective_date = dt.prior_market_date
        and dt.date_key = current_date()
        -- Ignore accounts we have flagged as excluded.
        and a.is_excluded = 0
)

, account_decision_clash_cte as (
    select
        a.effective_date
        , a.system_key
        , a.firm_source
        , a.account_number
        , a.pms_account_id
        , a.crm_account_id
        , a.advisor
        , a.pms_advisor
        , a.crm_advisor
        , a.opened_date
        , a.closed_date
        , a.pms_closed_date
        , a.crm_closed_date
        , a.custodian
        , a.account_value
        , a.location_code
        , a.office_name
        , a.aum_classification
        , a.pref_advisor__account_number
        , a.pref_advisor
        , a.pref_location
        , a.pref_system_key
        , a.is_primary
        , a.is_excluded
        , a.excluded_reasons
        , a.is_institutional
        , a.__account_key
        , a.__custodian_cust
        , a._extra_fields
        , count(a.__account_key)
            over (
                partition by
                    a.is_institutional
                    , a.effective_date
                    , a.__account_key
                    , a.__custodian_cust
            )                   as __account_key_counts
        , concat(
            a.__prefer_open
            , a.__key_match_preference
            , a.__ovrd_acct_and_or_advisor
            , a.__prefer_portfolio
            , a.__ovrd_location
            , a.__prefer_tamarac
            , a.__prefer_orion
            , a.__prefer_with_crm_id
        )::int                  as decision_tree_score
        , dense_rank() over (
            partition by
                a.is_institutional
                , a.effective_date
                , a.__account_key
                , a.__custodian_cust
            order by (concat(
                a.__prefer_open
                , a.__key_match_preference
                , a.__ovrd_acct_and_or_advisor
                , a.__prefer_portfolio
                , a.__ovrd_location
                , a.__prefer_tamarac
                , a.__prefer_orion
                , a.__prefer_with_crm_id
            )::int) desc
        )                       as rank_decision_logic_score
        , a.is_market_month_end as is_market_month_end
        , a._source_loaded_at   as _source_loaded_at
        , a._created_at         as _created_at
    from bld_accounts as a
    where true
        -- only consider a single record from a similar system
        and a.dedupe_system_rn = 1
        and a.aum_classification <> 'Data Aggregation / Reporting Only'
)

, rank_1_ties_cte as (
    select
        effective_date
        , system_key
        , firm_source
        , account_number
        , pms_account_id
        , crm_account_id
        , advisor
        , pms_advisor
        , crm_advisor
        , opened_date
        , closed_date
        , pms_closed_date
        , crm_closed_date
        , custodian
        , account_value
        , location_code
        , office_name
        , aum_classification
        , pref_advisor__account_number
        , pref_advisor
        , pref_location
        , pref_system_key
        , is_primary
        , is_excluded
        , excluded_reasons
        , _extra_fields
        , count(*) over (
            partition by is_institutional , effective_date , __account_key , __custodian_cust
        ) as rank_1_count
    from account_decision_clash_cte
    where rank_decision_logic_score = 1
)

, distinct_bda as (
    select distinct
        effective_date
        , account_number
        , system_key
        , team
    from {{ ref('black_diamond_mps__base_accounts') }}
    where true
        and is_head = 1
        and system_key = 'black_diamond__mps'
        and account_number is not null
        and team is not null
)

, accounts_missing_advisors as (
    select
        a.effective_date
        , a.system_key
        , a.account_number
        , case
            when a.system_key = 'orion__mps' then oa.advisor
            else bda.team
        end::text   as advisor_source
        , a.advisor as advisor
    from {{ ref('edw_accounts') }} as a
    left join {{ ref('orion__bld_accounts') }} as oa
        on a.effective_date = oa.effective_date
        and a.account_number = oa.account_number
        and a.system_key = oa.system_key
        and oa.account_number is not null
        and oa.system_key = 'orion__mps'
    left join distinct_bda as bda
        on a.effective_date = bda.effective_date
        and a.account_number = bda.account_number
        and a.system_key = bda.system_key
    where a.system_key in ('orion__mps' , 'black_diamond__mps')
        and a.advisor is null
        and a.is_head = 1
)

select
    a.effective_date
    , a.system_key
    , a.firm_source
    , a.account_number
    , a.pms_account_id
    , a.crm_account_id
    , a.advisor
    , a.pms_advisor
    , a.crm_advisor
    , a.opened_date
    , a.closed_date
    , a.pms_closed_date
    , a.crm_closed_date
    , a.custodian
    , a.account_value
    , a.location_code
    , a.office_name
    , a.aum_classification
    , a.pref_advisor__account_number
    , a.pref_advisor
    , a.pref_location
    , a.pref_system_key
    , a.is_primary
    , a.is_excluded
    , a.excluded_reasons
    , a._extra_fields
    , array_to_string(
        array_compact([
            -- [missing advisor id for internal associates sourced from oracle hcm, less addepar]
            case
                when a.advisor_id is null
                    and a.system_key in
                    (
                        'cambak__andco' , 'envestnet__manasquan' , 'black_diamond__houston'
                        , 'tpg__hfw' , 'orion__core'
                    )
                    then 'missing oracle hcm id'
            end
            -- [closed in the crm but not the pms]
            , case
                when a.crm_closed_date is not null
                    and a.pms_closed_date is null
                    and a.crm_closed_date < a.effective_date
                    then 'closed in crm, not pms'
            end
            -- [firm source alignment with system key]
            , case
                when (a.system_instance ilike 'mps' and a.firm_source not ilike 'mps')
                    or (a.system_key ilike '%andco%' and a.firm_source <> 'inst')
                    or (a.system_instance ilike 'baystate' and a.firm_source <> 'baystate')
                    or
                    (a.firm_source = 'mwa' and a.system_instance in ('baystate' , 'andco' , 'mps'))
                    then 'firm source discrepancy'
            end
            -- [Preferred System Key Mismatch]
            , case when a.pref_system_key <> a.system_key then 'system key discrepancy' end
            -- [Custodian Discrepancy]
            , case when a.__custodian_key <> a.__custodian_cust then 'custodian discrepancy' end
        ])
        , '; '
    ) as exceptions
from bld_accounts as a
where true
    -- Generally we only care about exceptions on the primary account record.
    and a.is_primary = 1
    -- Not concerned with closed accounts
    and (a.closed_date is null or a.effective_date < a.closed_date)
    -- Filter for records that have a defined exception.
    and exceptions <> ''
-- unions the [account clash] exceptions
union all
select
    r.effective_date
    , r.system_key
    , r.firm_source
    , r.account_number
    , r.pms_account_id
    , r.crm_account_id
    , r.advisor
    , r.pms_advisor
    , r.crm_advisor
    , r.opened_date
    , r.closed_date
    , r.pms_closed_date
    , r.crm_closed_date
    , r.custodian
    , r.account_value
    , r.location_code
    , r.office_name
    , r.aum_classification
    , r.pref_advisor__account_number
    , r.pref_advisor
    , r.pref_location
    , r.pref_system_key
    , r.is_primary
    , r.is_excluded
    , r.excluded_reasons
    , r._extra_fields
    , 'account clash' as exceptions
from rank_1_ties_cte as r
where true
    and r.rank_1_count > 1
    and r.is_primary = 1

-- accounts missing advisors
union all
select
    ba.effective_date                                                                as effective_date
    , ba.system_key                                                                  as system_key
    , ba.firm_source                                                                 as firm_source
    , ba.account_number                                                              as account_number
    , ba.pms_account_id                                                              as pms_account_id
    , ba.crm_account_id                                                              as crm_account_id
    , ba.advisor                                                                     as advisor
    , ba.pms_advisor                                                                 as pms_advisor
    , ba.crm_advisor                                                                 as crm_advisor
    , ba.opened_date                                                                 as opened_date
    , ba.closed_date                                                                 as closed_date
    , ba.pms_closed_date                                                             as pms_closed_date
    , ba.crm_closed_date                                                             as crm_closed_date
    , ba.custodian                                                                   as custodian
    , ba.account_value                                                               as account_value
    , ba.location_code                                                               as location_code
    , ba.office_name                                                                 as office_name
    , ba.aum_classification                                                          as aum_classification
    , ba.pref_advisor__account_number                                                as pref_advisor__account_number
    , ba.pref_advisor                                                                as pref_advisor
    , ba.pref_location                                                               as pref_location
    , ba.pref_system_key                                                             as pref_system_key
    , ba.is_primary                                                                  as is_primary
    , ba.is_excluded                                                                 as is_excluded
    , ba.excluded_reasons                                                            as excluded_reasons
    , object_insert(ba._extra_fields , 'advisor_source' , ama.advisor_source , true) as _extra_fields
    , case
        when ama.advisor_source is null
            then 'advisor missing in base model from ' || ba.system_key
        when ama.advisor_source is not null
            then 'redtail mismatch from pms advisor/team (' || ama.advisor_source || ')'
    end                                                                              as exceptions
from accounts_missing_advisors as ama
left join bld_accounts as ba
    on ama.effective_date = ba.effective_date
    and ama.system_key = ba.system_key
    and ama.account_number = ba.account_number

order by effective_date , system_key , account_number
