-- Legacy flow = "DM - MIS Moxy Portfolio Builder SF to SQL Stage.yxwz"

with restrictions_cte as (
    select
        a.trading_id
        , f.value                                  as individual_restriction
        , row_number() over (
            partition by a.trading_id
            order by f.seq
        )                                          as rn
        , min(rn) over (partition by a.trading_id) as min_rn
    from {{ ref('moxy__int_accounts_build') }} as a
    , lateral flatten(input => split(a.trade_restriction , '\n')) as f
    where replace(f.value , ' ' , '') ilike '%donottrade%'
)

select
    a.crm_account_id                                                  as crm_account_id
    , a.pms_account_id                                                as pms_account_id
    , a.trading_id                                                    as portfolio_id
    , replace(a.account_number , '-' , '')                            as account_number

    -- [Axys fields]
    -- As represented in salesforce, no cleaning.
    , a.account_number_formatted                                      as cust
    , a.custodian                                                     as custodi
    -- Axys expects a portfolio id as a key. Use the trading id from salesforce.
    , a.trading_id                                                    as acctno
    , a.registration_type                                             as atype

    , a.pms_account_id                                                as ornid
    , array_to_string(
        array_construct_compact(
            a.account_name , a.registration_type , a.account_number_formatted
        )
        , ' '
    )::text                                                           as name

    , case regexp_replace(a.minimum_cash , '[^0-9.]' , '')::decimal(20 , 2)
        when 0 then null
        else regexp_replace(a.minimum_cash , '[^0-9.]' , '')::decimal(20 , 2)
    end::text                                                         as cashbuf
    , iff(a.tax_status = 'Exempt' , 0 , 1)::text                      as taxstat

    , case
        when a.subadvisor_name ilike '%cincinnati%'
            then to_char(a.subadvisor_date_opened , 'YYYYMMDD')
        else to_char(a.opening_date , 'YYYYMMDD')
    end                                                               as stdate
    --, replace(assistant.contact_name, ' (EMP)', '') as assistant_name
    , coalesce(
        replace(coalesce(a.administrator , a.contact_name) , ' (EMP)' , '')
        , ''
    )                                                                 as assist
    , replace(coalesce(a.advisor , a.client_manager) , ' (EMP)' , '') as qbmgrid
    , replace(a.agent_administrator , ' (EMP)' , '')                  as agent_administrator
    , replace(a.trustee_advisor , ' (EMP)' , '')                      as trustee_advisor
    , replace(a.subadvisor , ' (EMP)' , '')                           as subadvisor
    -- Clean up the equity style names, removing Riverpoint and Mariner.
    , coalesce(trim(
        regexp_replace(
            regexp_replace(
                regexp_replace(
                    regexp_replace(
                        regexp_replace(
                            a.model , 'riverpoint' , '' , 1 , 1 , 'i'
                        ) , 'mariner' , '' , 1 , 1 , 'i'
                    ) , 'portfolio' , '' , 1 , 1 , 'i'
                ) , '^([^\\w]+)(.*)' , '\\2'
            ) , '  ' , ' '
        )
    ) , '')                                                           as eqstrat
    , eqstrat                                                         as udef1
    , case
        when coalesce(a.aum_classification , '') <> 'AUM - Assets Under Management'
            then 'M'
        else a.status
    end                                                               as pstat
    , pstat                                                           as status
    , case
        -- This scenario updates status__c as 'M' and subsequently '0' here in the
        -- legacy process (toolid 50).
        when coalesce(a.aum_classification , '') <> 'AUM - Assets Under Management'
            then 0
        when a.status ilike 'open'
            then 1
        else 0
    end::text                                                         as portstat
    , case
        when a.is_blocked = 1 and a.has_trade_restriction = 1
            then r.individual_restriction
        when a.is_blocked = 1 and a.has_trade_restriction = 0
            then 'Do Not Trade - Other Reason'
        else 'Actively Traded'
    end::text                                                         as trdstat
    , iff(a.is_billing_exception = 1 , 'DNC' , 'Bill')                as bill
    , iff(a.is_billing_exception = 1 , '100' , '0')                   as ndscnt
    , iff(a.is_non_discretionary = 0 , 1 , 0)::text                   as discret
    , iff(a.is_firm_traded = 1 , 'Yes' , 'No')                        as udef2
    , a.household_fee_manager_name                                    as feemgr
    , a.equity_goal::text                                             as goal
    , a.household_name                                                as hhold
    , a.household_legal_address_state                                 as primres
    , a.ytd_realized_gain_loss::text                                  as ytdrgl
    , to_char(a._created_at , 'YYYY-MM-DD HH24:MI:SS')                as recdate
    , a.is_intraday_import                                            as is_intraday_import
    , a.trading_id                                                    as trading_id
from {{ ref('moxy__int_accounts_build') }} as a
left join restrictions_cte as r
    on a.trading_id = r.trading_id
    and r.rn = r.min_rn
where 1 = 1
