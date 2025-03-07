with cte_agg_strat as (
    select
        a.*
        , array_agg(distinct a.portfolio_code) over (partition by a.account_number , a.effective_date) as _pms_account_id
        , listagg(a.goal , ' | ') over (partition by a.account_number , a.effective_date)              as _pms_intestment_strategy
        , listagg(a.acct_name , ' | ') over (partition by a.account_number , a.effective_date)         as _pms_account_name
    from {{ ref('axys_granite__stg_accounts') }} as a


)

select
    ag.effective_date                           as effective_date
    , ag.system_name                            as system_name
    , ag.system_instance                        as system_instance
    , ag.system_key                             as system_key
    , ag.firm_source                            as firm_source
    , ag.account_number_formatted               as account_number_formatted
    , ag.account_number                         as account_number
    , ag.account_number                         as pms_account_number
    , ag.custodian::text(200)                   as pms_custodian
    , ag._pms_account_id::variant               as pms_account_id
    , ag._pms_account_name::text(200)           as pms_account_name
    , ag.crm_id::text(200)                      as pms_client_id
    , iff(ag.acct_status = 'Open' , 1 , 0)::int as pms_is_active
    , min(ag.begin_mgmt_date::date)             as pms_opened_date
    , ag.close_date::date                       as pms_closed_date
    , sum(ag.aum)::decimal(16 , 2)              as pms_account_value
    , case
        when ag.coverage_officer = 'SBS' then 'Scott Schermerhorn'
        when ag.coverage_officer = 'TSL' then 'Tim Lesko'
        when ag.coverage_officer = 'WDH' then 'Bill Hutchens, Jr.'
        when ag.coverage_officer = 'JMS' then 'Joyce Skaperdas'
        when ag.coverage_officer = 'VGS' then 'Victor Soucy'
        when ag.coverage_officer = 'NFM' then 'Nick MacDonald'
        when ag.coverage_officer = 'MEC' then 'Martha Cottrill'
        else ag.coverage_officer
    end::text(200)                              as pms_advisor
    , ag._pms_intestment_strategy::text(200)    as pms_model_investment_strategy
    , case
        when ag.discretion = 'Discretionary' then 0
        when ag.discretion = 'Non-Discretionary' then 1
    end::int                                    as pms_is_discretionary
    , case
        when ag.proxy_vote = 'Sole' then 1
        when ag.proxy_vote = 'Client' then 0
    end::int                                    as pms_is_voting_proxied
    , try_to_boolean(ag.prime_enabled)::int     as pms_is_prime_broker
    , ag.account_type                           as type
    , ag.is_head::int                           as is_head
    , null::int                                 as is_current
    , ag._created_at::datetime                  as _created_at
from cte_agg_strat as ag
group by all
