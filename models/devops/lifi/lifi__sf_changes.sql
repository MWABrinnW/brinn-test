with cte_links as
    (
        select al.*
            ,ca.total_value as account_value
            ,row_number() over(partition by al.effective_date, al.custodian, al.account_number order by al._source_loaded_at desc) as rn
        from {{ ref('custodian_account_links') }} al
        left join {{ ref('custodian_accounts') }} ca
            on al.effective_date = ca.effective_date
            and al.custodian = ca.custodian
            and al.account_number = ca.account_number
        where al.is_head = 1
          --and link in ('08109543', '08208363', '08275983', '08438162', 'G13389051', 'G18661267', 'G16609625')
          and al.custodian in ('fidelity', 'schwab')
    )
   , cte_orion as -- NOT all qualify as LIFI
    (
        select *
        from cte_links
        where link in ('08438162', 'G16609625') -- Schwab Orion Master # and Fidelity Super Orion G #
        -- exclude duplicates, because an account could be linked to more than one
        qualify row_number() over (partition by effective_date, custodian, account_number order by _source_loaded_at desc) =
                1
    )
   , cte_schwab as -- NOT all qualify as LIFI
    (
        select *
        from cte_links
        where link in ('08109543', '08208363', '08275983')
        -- exclude duplicates, because an account could be linked to more than one
        qualify row_number() over (partition by effective_date, custodian, account_number order by _source_loaded_at desc) =
                1
    )
   , cte_fidelity as -- NOT all qualify as LIFI
    (
        select *
        from cte_links
        where link in ('G13389051', 'G18661267')
        -- exclude duplicates, because an account could be linked to more than one
        qualify row_number() over (partition by effective_date, custodian, account_number order by _source_loaded_at desc) =
                1
    )
   , cte_custodian as -- all of these qualify as LIFI
    (
        select *
        from cte_schwab
        -- schwab LIFI accounts must be included under Orion master number
        where account_number in (
                                    select distinct account_number
                                    from cte_orion
                                )
        union
        select *
        from cte_fidelity
        -- fidelity LIFI accounts must be included under Orion master number
        where account_number in (
                                    select distinct account_number
                                    from cte_orion
                                )
    )
   , cte_salesforce as -- NOT all qualify as LIFI
    (
        select id
             , replace(replace(upper(identifier__c), '-', ''), 'Ascent -- ', '')::varchar(100) as account_number
             , status__c::varchar(100)                                          as status_c
             , closingdate__c::varchar(100)                                     as closing_date_c
             , subadvisor__c::varchar(100)                                      as subadvisor_c
             , try_to_boolean(linked_individual_fixed_income__c)::int           as linked_individual_fixed_income_c
             , custodian__c::varchar(100)                                       as custodian_c
             , case
                   when custodian__c = 'a1IC000000RXr2GMAT' then 'schwab'
                   when custodian__c = 'a1IC000000RXr2xMAD' then 'fidelity'
                   else custodian__c end::varchar(100)                          as custodian
        from {{ source('lifi', 'estate_item_temp_lifi') }}
        where 1 = 1
          and isdeleted = false
          and (
            -- accounts that are assigned special subadvisor
                    subadvisor__c = '001C000001aKJMGIA4'
                -- accounts that are currently flagged as LIFI in salesforce
                or try_to_boolean(linked_individual_fixed_income__c)::int = 1
                -- accounts that are LIFI per fidelity/schwab
                or replace(identifier__c, '-', '') in (
                                                         select distinct account_number
                                                         from cte_custodian
                                                     )
            )
    )
   , cte_accounts as
    (
        select account_number
        from cte_custodian
        union
        select account_number
        from cte_salesforce
    )
   , cte_final as
    (
        select a.account_number                                              as account_number
             , sf.id                                                         as sf_id
             , IFF(o.account_number is not null, 1, 0)                       as is_in_orion
             , IFF(sh.account_number is not null, 1, 0)                      as is_in_schwab
             , IFF(f.account_number is not null, 1, 0)                       as is_in_fidelity
             , IFF(c.account_number is not null, 1, 0)                       as is_in_custodian
             , IFF(sf.account_number is not null, 1, 0)                      as is_in_salesforce
             , IFF(sf.subadvisor_c in ('001C000001aKJMGIA4'), 1, 0)          as is_salesforce_subadvisor
             , IFF(sf.subadvisor_c in ('001C000001aKJMGIA4')
                       and sf.custodian not in ('schwab', 'fidelity'), 1, 0) as is_subadvisor_lifi
             , IFF(c.account_number is not null, 1, 0)                       as is_custodian_lifi
             , IFF(sf.linked_individual_fixed_income_c = 1, 1, 0)            as is_salesforce_lifi
             , case
                   when is_in_custodian = 1
                       then 1
                   when is_subadvisor_lifi = 1
                       then 1
                   else 0
            end                                                              as is_lifi
             , case
                   when is_custodian_lifi = 1 and is_in_fidelity = 1
                       then 'custodian linked (fidelity)'
                   when is_custodian_lifi = 1 and is_in_schwab = 1
                       then 'custodian linked (schwab)'
                   when is_in_schwab = 1 and is_in_orion = 0
                       then 'not in orion, but schwab linked'
                   when is_in_fidelity = 1 and is_in_orion = 0
                       then 'not in orion, but fidelity linked'
                   when is_subadvisor_lifi = 1
                       then 'subadvisor assigned, and non schwab/fidelity'
                   when is_in_custodian = 0 and is_subadvisor_lifi = 0
                       then 'not linked and no subadvisor'
                   else null
            end                                                              as lifi_reason
             , case
                   when is_lifi = 1 and is_salesforce_lifi = 1
                       then 'LIFI, SF is accurate'
                   when is_lifi = 1 and is_salesforce_lifi = 0
                       then 'LIFI, update SF'
                   when is_lifi = 0 and is_salesforce_lifi = 1
                       then 'DE-LIFI, update SF'
                   when is_lifi = 0 and is_salesforce_lifi = 0 -- this category is expected to be empty
                       then 'non-LIFI, SF is accurate'
                   else null
            end                                                              as change_summary
             , IFF(is_lifi <> is_salesforce_lifi, 1, 0)                      as salesforce_needs_updated
             , sf.closing_date_c                                             as sf_closed_date
             , sf.status_c                                                   as sf_status
             , IFF(l.account_number is not null, 1, 0)                       as is_linked_at_all
             , l.account_value                                               as custodian_account_value
        from cte_accounts a
                 left join cte_custodian c
                           on a.account_number = c.account_number
                 left join cte_salesforce sf
                           on a.account_number = sf.account_number
                 left join cte_orion o
                           on a.account_number = o.account_number
                 left join cte_schwab sh
                           on a.account_number = sh.account_number
                 left join cte_fidelity f
                           on a.account_number = f.account_number
                 left join cte_links l
                           on a.account_number = l.account_number and l.rn = 1
        where true
    )
select *
from cte_final
