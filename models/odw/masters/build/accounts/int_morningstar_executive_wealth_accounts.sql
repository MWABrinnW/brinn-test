with cte_effective_dates as (
    select distinct effective_date
    from {{ ref('morningstar_executive_wealth__base_accounts') }}

)

, cte_morningstar_accounts as (
    select
        account_name
        , account_custodian
        , account_type
        , case
            when client_name = 'Friends Cove Mutual Ins. Co.' and account_name = 'Equity Account'
                then ''
            else
                account_number
        end
            as account_number
        , account_value
        , account_value_date
        , client_name
        , account_owner
        , portfolio_risk_score
        , open_date
        , closed_date
        , performance_start_date
        , investment_strategy
        , investment_objective
        , primary_benchmark
        , secondary_benchmark
        , tertiary_benchmark
        , tracking_method
        , last_reconciled_date
        , account_authorization
        , client_aggregate_calculation
        , effective_date
        , _source_loaded_at
        , _source_file
        , row_number()
            over (
                partition by effective_date , account_number
                order by _source_loaded_at desc , last_reconciled_date desc
            )
            as rn
    from {{ ref('morningstar_executive_wealth__base_accounts') }}
    where true
        and effective_date in (select a.effective_date from cte_effective_dates as a)
        -- business logic
        and coalesce(client_name , '') <> 'XXXXXXX'
)

, cte_morningstar_aum as (
    select
        effective_date
        , advisor_name
        , client_name
        , account_name
        , case
            when client_name = 'Friends Cove Mutual Ins. Co.' and account_name = 'Equity Account'
                then ''
            else
                account_number
        end
            as account_number
        , custodian
        , account_managed_by
        , investment_strategy
        , cash_amount
        , cash_percent
        , us_stock_amount
        , us_stock_percent
        , non_us_stock_amount
        , non_us_stock_percent
        , bond_amount
        , bond_percent
        , other_amount
        , other_percent
        , not_classified_amount
        , not_classified_percent
        , total_account_amount
        , case
            when account_name ilike '%spring lake%' and account_name ilike '%fund%'
                then 1
            else 0
        end
            as is_spring_lake
        , _source_loaded_at
        , row_number()
            over (
                partition by effective_date , coalesce(account_number , account_name)
                order by _source_loaded_at desc
            )
            as rn
    from {{ ref('morningstar_executive_wealth__base_aum') }}
    where true
        and effective_date in (select a.effective_date from cte_effective_dates as a)
        -- business logic
        and coalesce(advisor_name , '') not in ('' , 'Sub Total' , 'Total')
        and coalesce(client_name , '') <> 'XXXXXXX'
)

, cte_supplements as (
    select *
    from {{ ref('aux__base_executive_wealth_account_data') }}
    where effective_at::date in (select a.effective_date from cte_effective_dates as a)
    qualify
        row_number()
            over (
                partition by effective_at::date , financial_account_number , financial_account_name
                order by effective_at desc , _source_loaded_at::date desc
            )
        = 1
)

, cte_accounts as (
    select
        effective_date
        , coalesce(account_number , account_name) as account_number
    from cte_morningstar_accounts
    union distinct
    select
        effective_date
        , coalesce(account_number , account_name) as account_number
    from cte_morningstar_aum
)

, cte_accounts_joined as (
    select
        a.effective_date                                                          as effective_date
        , a.account_number                                                        as account_number_source
        , case
            when coalesce(acc.account_number , acc.account_name) is not null
                and aum.account_number is not null
                then 1
            else 0
        end                                                                       as exists_both
        , case
            when coalesce(acc.account_number , acc.account_name) is not null
                then 1
            else 0
        end                                                                       as exists_base_accounts
        , case
            when coalesce(aum.account_number , acc.account_name) is not null
                then 1
            else 0
        end                                                                       as exists_base_aum
        , 'Morningstar Executive Wealth'                                          as system_name
        , 'datalake.morningstar_executive_wealth'::varchar(100)                   as system_details
        , replace(a.account_number , '  ' , ' ')                                  as financial_account_number
        , ltrim(replace(replace(a.account_number , '  ' , ' ') , '-' , '') , '0') as financial_account_number_clean
        , null::varchar(50)                                                       as internal_financial_account_number
        , sup.internal_household_number                                           as internal_household_number
        , acc.account_owner                                                       as registrant_name
        , coalesce(acc.account_name , aum.account_name)                           as financial_account_name
        , coalesce(aum.client_name , acc.client_name)                             as household_name
        , 'L-10007'                                                               as location_code
        , 'Pittsburgh, PA - Downtown'                                             as location_name
        , coalesce(acc.account_type , sup.type_of_account)                        as type_of_account
        , coalesce(acc.account_custodian , sup.custodian)                         as custodian
        , coalesce(acc.investment_strategy , sup.model_investment_strategy)       as model_investment_strategy
        , coalesce(aum.advisor_name , sup.client_manager)                         as client_manager
        , sup.fee_schedule                                                        as fee_schedule
        , coalesce(sup.erisa , 'No')                                              as erisa
        , case
            when aum.account_number is null
                then 0
            else 1
        end                                                                       as account_active
        , sup.aum_classification_status                                           as aum_classification_status
        , coalesce(acc.account_authorization , sup.discretion_status)             as discretion_status
        , coalesce(sup.proxy_voting_status , 'Unknown')                           as proxy_voting_status
        , coalesce(sup.cost_basis_disposal_method , 'Unknown')                    as cost_basis_disposal_method
        , coalesce(sup.prime_broker_enabled , 'Unknown')                          as prime_broker_enabled
        , coalesce(aum.total_account_amount , acc.account_value)                  as current_value
        , coalesce(sup.account_open_date , acc.open_date , '2022-10-01')          as account_open_date
        , sup.closed_date                                                         as closed_date
        , a.effective_date                                                        as as_of_date
        , sup.aum_status                                                          as aum_status
        , coalesce(aum.is_spring_lake , 0)                                        as is_spring_lake

        , aum.advisor_name                                                        as aum_client_manager
        , aum.client_name                                                         as aum_client_name
        , acc.client_name                                                         as acc_client_name
        , coalesce(acc._source_loaded_at , aum._source_loaded_at)                 as _source_loaded_at
    from cte_accounts as a
    left join cte_morningstar_aum as aum
        on a.effective_date = aum.effective_date
        and a.account_number = coalesce(aum.account_number , aum.account_name)
        and aum.rn = 1
    left join cte_morningstar_accounts as acc
        on a.effective_date = acc.effective_date
        and a.account_number = coalesce(acc.account_number , acc.account_name)
        and acc.rn = 1
    left join cte_supplements as sup
        on ltrim(replace(replace(a.account_number , '  ' , ' ') , '-' , '') , '0') = sup.financial_account_number_clean
        and acc.effective_date = sup.effective_at::date
)

, cte_spring_lake as (
    select
        acc.effective_date
        , acc.account_number_source
        , acc.exists_both
        , acc.exists_base_accounts
        , acc.exists_base_aum
        , acc.system_name
        , acc.system_details
        , sup.financial_account_number
        , sup.financial_account_number_clean
        , acc.internal_financial_account_number
        , acc.internal_household_number
        , acc.registrant_name
        , acc.financial_account_name
        , acc.household_name
        , acc.location_code
        , acc.location_name
        , acc.type_of_account
        , acc.custodian
        , acc.model_investment_strategy
        , coalesce(acc.client_manager , sl.advisor_name) as client_manager
        , acc.fee_schedule
        , acc.erisa
        , acc.account_active
        , acc.aum_classification_status
        , acc.discretion_status
        , acc.proxy_voting_status
        , acc.cost_basis_disposal_method
        , acc.prime_broker_enabled
        , acc.current_value
        , acc.account_open_date
        , acc.closed_date
        , acc.as_of_date
        , acc.aum_status
        , acc.is_spring_lake
        , acc._source_loaded_at
    from cte_morningstar_aum as sl
    left join cte_accounts_joined as acc
        on sl.effective_date = acc.effective_date
        and sl.account_name = acc.account_number_source
    left join cte_supplements as sup
        on acc.financial_account_name = sup.financial_account_name
        and acc.effective_date = sup.effective_at::date
    where acc.is_spring_lake = 1
)

, cte_spring_lake_joined as (
    select
        acc.effective_date
        , acc.account_number_source
        , acc.exists_both
        , acc.exists_base_accounts
        , acc.exists_base_aum
        , acc.system_name
        , acc.system_details
        , coalesce(sl.financial_account_number , acc.financial_account_number)
            as financial_account_number
        , coalesce(
            sl.financial_account_number_clean
            , ltrim(replace(replace(
                coalesce(sl.financial_account_number , acc.financial_account_number) , '  ' , ' '
            ) , '-' , '') , '0')
        )
            as financial_account_number_clean
        , acc.internal_financial_account_number
        , coalesce(s.internal_household_number , acc.internal_household_number)
            as internal_household_number
        , coalesce(sl.registrant_name , acc.registrant_name)
            as registrant_name
        , coalesce(sl.financial_account_name , acc.financial_account_name)
            as financial_account_name
        , coalesce(sl.household_name , acc.household_name , s.household_name)                      as household_name
        , coalesce(s.location_code , acc.location_code)
            as location_code
        , coalesce(s.location_name , acc.location_name)
            as location_name
        , coalesce(s.type_of_account , acc.type_of_account)
            as type_of_account
        , case when sl.financial_account_number is not null then 'Fidelity' else acc.custodian end as custodian
        , coalesce(s.model_investment_strategy , acc.model_investment_strategy)
            as model_investment_strategy
        , coalesce(s.client_manager , acc.client_manager)
            as client_manager
        , coalesce(s.fee_schedule , acc.fee_schedule)                                              as fee_schedule
        , coalesce(s.erisa , acc.erisa)                                                            as erisa
        , acc.account_active
        , coalesce(s.aum_classification_status , acc.aum_classification_status)
            as aum_classification_status
        , coalesce(s.discretion_status , acc.discretion_status)
            as discretion_status
        , coalesce(s.proxy_voting_status , acc.proxy_voting_status)
            as proxy_voting_status
        , coalesce(s.cost_basis_disposal_method , acc.cost_basis_disposal_method)
            as cost_basis_disposal_method
        , coalesce(s.prime_broker_enabled , acc.prime_broker_enabled)
            as prime_broker_enabled
        , coalesce(sl.current_value , acc.current_value)
            as current_value
        , coalesce(s.account_open_date , acc.account_open_date)
            as account_open_date
        , coalesce(s.closed_date , acc.closed_date)                                                as closed_date
        , coalesce(sl.as_of_date , acc.as_of_date)                                                 as as_of_date
        , coalesce(s.aum_status , acc.aum_status)                                                  as aum_status
        , acc.is_spring_lake
        , case when sl.financial_account_number is not null then 1 else 0 end                      as is_joined
        , acc._source_loaded_at
    from cte_accounts_joined as acc
    left join cte_spring_lake as sl
        on acc.effective_date = sl.effective_date
        and acc.financial_account_name = sl.financial_account_name
    left join cte_supplements as s
        on coalesce(sl.financial_account_number_clean , coalesce(sl.financial_account_number , acc.financial_account_number))
        = s.financial_account_number_clean
        and acc.effective_date = s.effective_at::date
    where true
        and acc.is_spring_lake = 1
)

, cte_accounts_supplemented as (
    select
        effective_date
        , account_number_source
        , exists_both
        , exists_base_accounts
        , exists_base_aum
        , system_name
        , system_details
        , financial_account_number
        , financial_account_number_clean
        , internal_financial_account_number
        , internal_household_number
        , registrant_name
        , financial_account_name
        , household_name
        , location_code
        , location_name
        , type_of_account
        , custodian
        , model_investment_strategy
        , client_manager
        , fee_schedule
        , erisa
        , account_active
        , aum_classification_status
        , discretion_status
        , proxy_voting_status
        , cost_basis_disposal_method
        , prime_broker_enabled
        , current_value
        , account_open_date
        , closed_date
        , as_of_date
        , aum_status
        , is_spring_lake
        , _source_loaded_at
        , 1 as grp
    from cte_accounts_joined
    where exists_both = 1

    union all

    select
        * exclude is_joined
        , 2 as grp
    from cte_spring_lake_joined
    --     where is_joined = 1

    union all

    select
        effective_date
        , account_number_source
        , exists_both
        , exists_base_accounts
        , exists_base_aum
        , system_name
        , system_details
        , financial_account_number
        , financial_account_number_clean
        , internal_financial_account_number
        , internal_household_number
        , registrant_name
        , financial_account_name
        , household_name
        , location_code
        , location_name
        , type_of_account
        , custodian
        , model_investment_strategy
        , client_manager
        , fee_schedule
        , erisa
        , account_active
        , aum_classification_status
        , discretion_status
        , proxy_voting_status
        , cost_basis_disposal_method
        , prime_broker_enabled
        , current_value
        , account_open_date
        , closed_date
        , as_of_date
        , aum_status
        , is_spring_lake
        , _source_loaded_at
        , 3 as grp
    from cte_accounts_joined
    where exists_both = 0 and is_spring_lake = 0
)



select
    effective_date
    , account_number_source
    , exists_both
    , exists_base_accounts
    , exists_base_aum
    , 'morningstar'                                as system_name
    , 'executive_wealth'                           as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , financial_account_number
    , financial_account_number_clean
    , internal_financial_account_number
    , internal_household_number
    , registrant_name
    , financial_account_name
    , household_name
    , location_code
    , location_name
    , type_of_account
    , custodian
    , model_investment_strategy
    , client_manager
    , fee_schedule
    , erisa
    , case
        when closed_date is not null
            then 0
        when client_manager is null and household_name is null
            then 0
        else 1
    end                                            as account_active
    , aum_classification_status
    , discretion_status
    , proxy_voting_status
    , cost_basis_disposal_method
    , prime_broker_enabled
    , current_value
    , account_open_date
    , closed_date
    , as_of_date
    , case
        when aum_classification_status in ('' , '')
            then 'Exclude'
        when closed_date is not null
            then 'Exclude'
        when account_active = 0
            then 'Exclude'
        else
            'Include'
    end                                            as aum_status
    , _source_loaded_at
    , {{ col_is_head(reference=ref('morningstar_executive_wealth__base_accounts'), source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , grp                                          as _grp
from cte_accounts_supplemented
where true
