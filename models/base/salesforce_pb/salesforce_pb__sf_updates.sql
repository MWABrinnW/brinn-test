with sf_accounts as (
    select
        id                                              as id
        , subadvisor                                    as subadvisor
        , custodian_name                                as custodian
        -- Currently we're using the account number to resolve across systems for PB updates.
        -- Orion account id could be used as an alternative or if it is shown there is a breakdown
        -- when using account number.
        , replace(upper(trim(identifier_c)) , '-' , '') as account_number
        , is_prime_broker_enabled                       as is_prime_broker
        -- null because we'll use custodian/orion first. We need to do this because
        -- the salesforce value is not up to date (sourced from orion) until after the
        -- upsert is complete but we run the PB update against salesforce _before_ the upsert.
        , null::number(19 , 6)                          as current_value
        , status                                        as status
    from {{ ref('salesforce_pb__stg_custodial_pb') }}
    where 1 = 1
        and _created_at = (
            select max(c_pb._created_at)
            from {{ source('salesforce_pb', 'custodial_pb') }} as c_pb
        )
        and (subadvisor = '001C000001aKJMGIA4' or custodian ilike any ('%schwab%' , 'fidelity'))
)

, custodial_accounts as (
    select
        account_number    as account_number
        , is_prime_broker as is_prime_broker
        , total_value     as total_value
        , effective_date  as effective_date
    from {{ ref('custodian_accounts') }}
    where 1 = 1
        and is_head = 1
        and rn_global = 1
        and custodian in ('schwab' , 'fidelity')
        and account_number in (
            select distinct sfa0.account_number from sf_accounts as sfa0
            where sfa0.account_number is not null
        )
)

, upsert_values as (
    select
        account_number
        , current_value
        , system_key
    from {{ ref('pms__accounts') }}
    where 1 = 1
        and system_key = 'orion__core'
        -- We need the orion account id to join with. Ops puts this on the estate
        -- item during their new account setup process prior to triggering the upsert.
        -- If that understanding is not true we should try to join with account_number
        -- as a secondary attempt to resolve the join.
        and (account_number in (
            select distinct sfa1.account_number from sf_accounts as sfa1
            where sfa1.account_number is not null
        ) or ltrim(account_number , '0') in (
            select distinct ltrim(sfa2.account_number , '0') from sf_accounts as sfa2
            where sfa2.account_number is not null
        ))
    -- Attempt to dedupe accounts.
    qualify row_number() over (
            partition by system_key , account_number
            order by closed_date desc , _updated_at desc
        ) = 1
)

, accounts_with_values as (
    select
        a.id                                                            as id
        , a.custodian                                                   as custodian
        , a.account_number                                              as account_number
        , a.is_prime_broker                                             as is_prime_broker_sf
        , b.is_prime_broker                                             as is_prime_broker_custodian
        , b.total_value                                                 as custodian_value
        , case when b.account_number is not null then 1 else 0 end::int as is_in_custodian_feed
        , c.current_value                                               as upsert_value
        , a.subadvisor                                                  as subadvisor
        , a.status                                                      as status
        , mis.is_included                                               as is_included_mis
    from sf_accounts as a
    left join custodial_accounts as b
        on a.account_number = b.account_number
    left join upsert_values as c
        on ltrim(a.account_number , '0') = ltrim(c.account_number , '0')
    left join {{ ref('mis__accounts') }} as mis
        on a.account_number = mis.account_number
    where 1 = 1
)


select
    custodian                                                                as custodian
    , account_number                                                         as account_number
    , id                                                                     as id
    , subadvisor                                                             as subadvisor
    , status                                                                 as status
    -- Account value from the custodian.
    , custodian_value                                                        as custodian_value
    -- Account value from odw.pms.accounts (used in the upsert, sourced from Orion only today).
    , upsert_value                                                           as upsert_value
    , case
        when custodian ilike any ('%schwab%' , 'fidelity') then 1
        else 0
    end::int                                                                 as is_custodial
    -- Current PB status from the custodian.
    , is_prime_broker_custodian                                              as is_prime_broker_custodian
    -- Current PB status in SF on the estate item.
    , is_prime_broker_sf                                                     as is_prime_broker_sf
    -- This is what we think the PB status should be.
    , case
    -- [Prime Broker eligibility requirements]
    -- For schwab/fidelity:
    -- Needs >$100000
    -- Needs custodian attribute for PB
    -- For non schwab/fidelity:
    -- Needs subadvisor 001C000001aKJMGIA4
    -- Needs >$100000

    -- Prefer the custodian value.
        when coalesce(custodian_value , upsert_value , 0) < 100000
            then 0
        -- If value meets requirements and custodian considers account as PB we'll tag it as PB.
        when is_custodial = 1 then is_prime_broker_custodian
        -- If value meets requirements and it's non-schwab/fid we'll assume it is PB.
        when is_custodial = 0 then 1
        -- For non-schwab/fidelity we assume it is prime broker.
        else 1
    end::int                                                                 as is_prime_broker
    , case when is_prime_broker_sf <> is_prime_broker then 1 else 0 end::int as needs_updated
    , ''::text
    ||
    coalesce(case
        when is_custodial = 1 and is_in_custodian_feed = 0 then 'Missing from custodian feed;'
        else ''
    end , '')
    || coalesce(case
        when is_custodial = 1 and is_in_custodian_feed = 1 and coalesce(is_prime_broker_custodian , 0) = 0
            then 'Custodian indicates not PB;'
        else ''
    end , '')
    || coalesce(case
        when (is_in_custodian_feed = 1 or is_custodial = 0)
            and coalesce(custodian_value , upsert_value , 0) < 100000 then 'Does not meet balance requirement;'
        else ''
    end , '')
        as notes
    -- This indicates if the account is currently in our MIS accounts dataset and if it's tagged for Perform.
    , is_included_mis                                                        as is_included_mis
from accounts_with_values
