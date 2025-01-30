with cte_moxy_accounts as (
    select *
    from {{ ref('mis__accounts') }}
    where 1 = 1
        and rn = 1
        and is_moxy = 1
        -- Include only accounts that are eligible for trading.
        -- Translated from `DM - MIS Moxy Portfolios Builder SF to SQL Stage.yxwz`
        and is_active = 1
        and trading_system = 'Axys/Moxy - Cincinnati'

        and (
            subadvisor_name = 'Cincinnati Asset Management'
            or (coalesce(client_manager , '') not in ('Patrick Richter (EMP)' , 'Keith Hamberg (EMP)'))
        )

        and (
            subadvisor_name = 'Cincinnati Asset Management'
            or (coalesce(aum_classification , '') not in ('Data Aggregation / Reporting Only' , 'AUA - Assets Under Advisory'))
        )
)

, cte_moxy_households as (
    select distinct household_id from cte_moxy_accounts
)

, cte_acr as (
    select
        acr.household_id   as household_id
        , acr.contact_id   as contact_id
        , acr.contact_name as contact_name
        , acr.roles        as roles
        , row_number() over (
            partition by acr.household_id , acr.roles
            order by acr.contact_id
        )                  as rn
    from {{ ref('mis__stg_salesforce_compass_account_contact_relation') }} as acr
    inner join cte_moxy_households as a
        on acr.household_id = a.household_id
    where 1 = 1
        and acr.is_head = 1
        and acr.roles in ('Client Service Associate' , 'Accountant')
)

, cte_estate_item_contact_link as (
    select
        eicl.estate_item_id as estate_item_id
        , eicl.role         as role
        , eicl.contact_id   as contact_id
        , eicl.contact_name as contact_name
    from {{ ref('mis__stg_salesforce_compass_estate_item_contact_link') }} as eicl
    inner join cte_moxy_accounts as a
        on eicl.estate_item_id = a.crm_account_id
    left join {{ ref('mis__stg_salesforce_compass_estate_item') }} as ei
        on eicl.estate_item_id = ei.id
        and ei.is_head = 1
    where 1 = 1
        and eicl.is_head = 1
        and eicl.role ilike any ('Advisor' , 'Administrator')
)

, cte_estate_item_contact_link_pivoted as (
    select
        estate_item_id                                                      as estate_item_id
        , max(case when role = 'Administrator' then contact_name end)       as administrator
        , max(case when role = 'Advisor' then contact_name end)             as advisor
        , max(case when role = 'Agent;Administrator' then contact_name end) as agent_administrator
        , max(case when role = 'Trustee;Advisor' then contact_name end)     as trustee_advisor
        , max(case when role = 'Subadvisor' then contact_name end)          as subadvisor
    from cte_estate_item_contact_link
    group by all
)

, cte_accounts as (
    select
        a.*
        , a.trading_id                      as portfolio_id
        -- users and assigned roles
        , roles.administrator               as administrator
        , roles.advisor                     as advisor
        , roles.agent_administrator         as agent_administrator
        , roles.trustee_advisor             as trustee_advisor
        , roles.subadvisor                  as subadvisor
        , assistant.contact_name            as contact_name
        , case
            when replace(a.trade_restriction , ' ' , '') ilike '%donottrade%'
                then 1
            else 0
        end::int                            as has_trade_restriction
        , array_construct_compact('ACTIVE') as groups
    from cte_moxy_accounts as a
    left join cte_estate_item_contact_link_pivoted as roles
        on a.crm_account_id = roles.estate_item_id
    left join cte_acr as assistant
        on a.household_id = assistant.household_id
        and assistant.roles = 'Client Service Associate'
        and assistant.rn = 1
)

select *
from cte_accounts
