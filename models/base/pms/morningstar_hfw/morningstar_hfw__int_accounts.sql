with cte_effective_dates as
    (
        select distinct effective_date
        from {{ ref('morningstar_hfw__base_accounts')}}
        where effective_date >= '2/1/2023' -- excluding pre 202302, not all dataset were being collected consistently
        order by effective_date
    )
   , cte_morningstar_aum as
    (
        select iff(client_name = 'Friends Cove Mutual Ins. Co.' AND account_name = 'Equity Account',
                   '001050977010', replace(account_number, '  ', ' '))                                        as account_number
             , row_number() over (partition by account_number, effective_date order by effective_at desc) as rn
             , effective_date
             , advisor_name
             , client_name
             , account_name
             , nullif(custodian, 'Unassigned')                                           as custodian
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
             , effective_at
             , _created_at
             , _source_file
             , 'Morningstar HFW'                                                               as system_name
             , 'DATALAKE.MORNINGSTAR_HFW.BASE_AUM'                                       as system_details
        from {{ ref('morningstar_hfw__base_aum') }}
        where true
          and effective_date in (
                                    select effective_date
                                    from cte_effective_dates
                                )
          and trim(advisor_name) not in ('Sub Total', 'Total', '')
          and advisor_name is not null
          and client_name != 'XXXXXXX'
    )
   , cte_morningstar_accounts as
    (
        select iff(client_name = 'Friends Cove Mutual Ins. Co.' AND ACCOUNT_NAME = 'Equity Account',
                   '001050977010',
                   replace(account_number, '  ', ' '))                                            as account_number
             , row_number() over (PARTITION BY account_number, effective_date order by last_reconciled_date desc) as rn
             , account_name
             , nullif(account_custodian, 'Unassigned')                                            as account_custodian
             , account_type
             , account_value
             , account_value_date
             , client_name
             , account_owner
             , portfolio_risk_score
             , nvl(nullif(trim(open_date), ''), '2022-08-01')                                     as open_date -- logic pulled from Alteryx flow
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
             , _created_at
             , _source_file
             , 'Morningstar HFW'                                                                        as system_name
             , 'DATALAKE.MORNINGSTAR_HFW.BASE_ACCOUNTS'                                           as system_details
        from {{ ref('morningstar_hfw__base_accounts') }}
        where true
          and effective_date in (
                                    select effective_date
                                    from cte_effective_dates
                                )
          and CLIENT_NAME != 'XXXXXXX'
    )
   , cte_tpg_accounts as
    (
        select customeraccountnumber
             , customername
             , customertypedesc
             , fairvalue
             , parvalue
             , effective_date
             , record_datetime
             , source_file
             , 'TPG HFW'                               as system_name
             , 'DATALAKE.TPG_HFW.VW_ACCOUNTS'          as system_details
             , substring(customeraccountnumber, 1, 3)  as internal_household_number
             , row_number() over (PARTITION BY customeraccountnumber, effective_date order by record_datetime desc) as rn
        from {{ ref("tpg_hfw__vw_accounts") }}
        where effective_date in (
                                    select effective_date
                                    from cte_effective_dates
                                )
    )
   , cte_tpg_morningstar_overlap as
    (
        select 
            client_name
            ,tpg_id_number
            ,morningstar_acct_number
            ,morningstar_account_name
            ,_created_at
             , 'Comerica' as custodian -- helps with coalesce in cte_joined
        from {{ ref('aux__base_hfw_tpg_mstar_overlap') }}
    )
   , cte_hfw_account_data as
    (
        select nullif(financial_account_number, 'NULL')          as financial_account_number
             , nullif(financial_account_number_clean, 'NULL')    as financial_account_number_clean
             , nullif(internal_financial_account_number, 'NULL') as internal_financial_account_number
             , nullif(internal_household_number, 'NULL')         as internal_household_number
             , nullif(registrant_name, 'NULL')                   as registrant_name
             , nullif(financial_account_name, 'NULL')            as financial_account_name
             , nullif(household_name, 'NULL')                    as household_name
             , nullif(location_code, 'NULL')                     as location_code
             , nullif(location_name, 'NULL')                     as location_name
             , nullif(type_of_account, 'NULL')                   as type_of_account
             , nullif(custodian, 'NULL')                         as custodian
             , nullif(source_system_custodian, 'NULL')           as source_system_custodian
             , nullif(verified_custodian, 'NULL')                as verified_custodian
             , nullif(model_investment_strategy, 'NULL')         as model_investment_strategy
             , nullif(client_manager, 'NULL')                    as client_manager
             , nullif(source_system_client_manager, 'NULL')      as source_system_client_manager
             , nullif(primary_client_manager, 'NULL')            as primary_client_manager
             , nullif(fee_schedule, 'NULL')                      as fee_schedule
             , nullif(erisa, 'NULL')                             as erisa
             , nullif(account_active, 'NULL')                    as account_active
             , nullif(aum_classification_status, 'NULL')         as aum_classification_status
             , nullif(discretion_status, 'NULL')                 as discretion_status
             , nullif(proxy_voting_status, 'NULL')               as proxy_voting_status
             , nullif(cost_basis_disposal_method, 'NULL')        as cost_basis_disposal_method
             , nullif(prime_broker_enabled, 'NULL')              as prime_broker_enabled
             , account_open_date                                 as account_open_date
             , closed_date                                       as closed_date
             , nullif(system_name, 'NULL')                       as system_name
             , update_date                                       as update_date
             , nullif(NOTES, 'NULL')                             as NOTES
             , effective_at                                      as effective_at
             , _created_at                                       as _created_at
        from {{ ref("aux__base_hfw_acct_data") }}
        where effective_at::date in (
                                        select effective_date
                                        from cte_effective_dates
                                    )
    )
   , cte_fa_base as
    (
        select replace(t.customeraccountnumber, '  ', ' ') as financial_account_number
             , o.tpg_id_number                             as internal_financial_account_number
             , t.effective_date
        from cte_tpg_accounts t
        left join cte_tpg_morningstar_overlap o
            on t.customeraccountnumber = o.tpg_id_number
        where internal_financial_account_number is null

        union

        select replace(m.account_number, '  ', ' ') as financial_account_number
             , o.tpg_id_number                      as internal_financial_account_number
             , m.effective_date
        from cte_morningstar_aum m
        left join cte_tpg_morningstar_overlap o
            on m.account_number = o.morningstar_acct_number

        union

        select replace(m.account_number, '  ', ' ') as financial_account_number
             , o.tpg_id_number                      as internal_financial_account_number
             , m.effective_date
        from cte_morningstar_accounts m
        left join cte_tpg_morningstar_overlap o
            on m.account_number = o.morningstar_acct_number

        union

        select replace(financial_account_number, '  ', ' ') as financial_account_number
             , internal_financial_account_number            as internal_financial_account_number
             , effective_at::date                           as effective_at
        from cte_hfw_account_data h

    )
   , cte_joined as
    (
      select 
            uuid_string()                                                                     as record_id
            , case
                  when olap.client_name is not null then 'Morningstar HFW'
                  when t_acc.effective_date is not null then 'TPG HFW'
                  when m_acc.effective_date is not null then 'Morningstar HFW'
                  when hfw.system_name = 'TPG' then 'TPG HFW'
                  when hfw.system_name = 'MSTAR' then 'Morningstar HFW'
                  else hfw.system_name end                                                      as system_name
            , case
                  when olap.client_name is not null then 'DATALAKE.MORNINGSTAR_HFW.BASE_AUM'
                  when t_acc.effective_date is not null then 'DATALAKE.TPG_HFW.VW_ACCOUNTS'
                  when m_acc.effective_date is not null then 'DATALAKE.MORNINGSTAR_HFW.BASE_ACCOUNTS'
                  when hfw.system_name = 'TPG' then 'DATALAKE.TPG_HFW.VW_ACCOUNTS'
                  when hfw.system_name = 'MSTAR' then 'DATALAKE.MORNINGSTAR_HFW.BASE_ACCOUNTS'
                  else hfw.system_name end                                                      as system_details
            , b.financial_account_number                                                        as financial_account_number
            , ltrim(replace(b.financial_account_number, '-', ''), '0')                          as financial_account_number_clean
            , b.internal_financial_account_number                                               as internal_financial_account_number
            , case
                  when olap.client_name is not null then substring(t_acc.internal_household_number, 1, 3)
                  when t_acc.effective_date is not null then substring(t_acc.internal_household_number, 1, 3)
                  when m_acc.effective_date is not null then null
                  else hfw.internal_household_number end                                        as internal_household_number
            , case
                  when olap.client_name is not null then t_acc.customername
                  when t_acc.effective_date is not null then t_acc.customername
                  when m_acc.effective_date is not null then m_acc.account_owner
                  else hfw.registrant_name end                                                  as registrant_name
            , case
                  when olap.client_name is not null then m_acc.account_name
                  when t_acc.effective_date is not null then t_acc.customername
                  when m_acc.effective_date is not null then m_acc.account_name
                  else hfw.financial_account_name end                                           as financial_account_name
            , case
                  when olap.client_name is not null then t_acc.customername
                  when t_acc.effective_date is not null then t_acc.customername
                  when m_acc.effective_date is not null then m_acc.client_name
                  else hfw.household_name end                                                   as household_name
            , 'L-10004'                                                                         as location_code
            , 'Bloomfield Hills, MI - Springdale Park'                                          as location_name
            , case
                  when olap.client_name is not null then t_acc.customertypedesc
                  when t_acc.effective_date is not null then t_acc.customertypedesc
                  when m_acc.effective_date is not null then m_acc.ACCOUNT_TYPE
                  else hfw.type_of_account end                                                  as type_of_account
            , case
                  when hfw.EFFECTIVE_AT is null then null
                  when hfw.EFFECTIVE_AT is not null
                  then coalesce(olap.custodian, m_acc.account_custodian, hfw.custodian) end as custodian
            , case
                  when olap.client_name is not null then m_aum.INVESTMENT_STRATEGY
                  when t_acc.effective_date is not null then null
                  when m_acc.effective_date is not null then m_acc.INVESTMENT_STRATEGY
                  else hfw.model_investment_strategy end                                        as model_investment_strategy
            , iff(hfw.EFFECTIVE_AT is not null, coalesce(hfw.client_manager, m_aum.advisor_name),
                  null)                                                                         as client_manager
            , hfw.fee_schedule                                                                  as fee_schedule
            , hfw.erisa                                                                         as erisa
            , iff(hfw.effective_at is not null and
                  (
                        t_acc.effective_date is not null or
                        m_acc.effective_date is not null or
                        m_aum.effective_date is not null
                  ), hfw.account_active,
                  0)                                                                            as account_active
            , iff(hfw.EFFECTIVE_AT is null, 'Data Aggregation / Reporting Only',
                  hfw.aum_classification_status)                                                as aum_classification_status
            , hfw.discretion_status                                                             as discretion_status
            , hfw.proxy_voting_status                                                           as proxy_voting_status
            , hfw.cost_basis_disposal_method                                                    as cost_basis_disposal_method
            , hfw.prime_broker_enabled                                                          as prime_broker_enabled
            , case
                  when olap.client_name is not null then m_aum.total_account_amount
                  when t_acc.effective_date is not null then t_acc.fairvalue
                  when m_acc.effective_date is not null then m_aum.total_account_amount
            end                                                                                 as current_value
            , case
                  when olap.client_name is not null then m_acc.open_date
                  when t_acc.effective_date is not null then null
                  when m_acc.effective_date is not null then m_acc.open_date
                  else hfw.account_open_date end                                                as account_open_date
            , iff(hfw.EFFECTIVE_AT is null, '2022-08-31', hfw.closed_date)                      as closed_date
            , case
                  when olap.client_name is not null then m_aum.effective_date
                  when t_acc.effective_date is not null then t_acc.effective_date
                  when m_acc.effective_date is not null then m_acc.effective_date
                  else hfw.EFFECTIVE_AT::date end                                               as as_of_date
            , null                                                                              as aum_status     -- calculated in next cte
            , b.effective_date                                                                  as effective_date
            , dateadd(day, -1,
                  date_from_parts(year(current_date), month(current_date), 1))                  as month_end_date -- last day of previous month
            , case
                  when olap.client_name is not null then m_acc._source_file
                  when t_acc.effective_date is not null then t_acc.SOURCE_FILE
                  when m_acc.effective_date is not null then m_acc._source_file
            end                                                                                 as source_filename
            , current_date()                                                                    as record_date
            , current_timestamp()                                                               as record_datetime
            , coalesce(olap.custodian, m_acc.account_custodian, hfw.custodian)                  as source_system_custodian

            , case when hfw.financial_account_number is not null then 1 else 0 end              as joined_hfw
            , case when m_aum.account_number is not null then 1 else 0 end                      as joined_m_aum
            , case when m_acc.account_number is not null then 1 else 0 end                      as joined_m_acc
            , case when t_acc.customeraccountnumber is not null then 1 else 0 end               as joined_t_acc
            , case when olap.morningstar_acct_number is not null then 1 else 0 end              as joined_olap
            , {{ col_is_head(reference='cte_fa_base', reference_date_col='effective_date', source_date_col='b.effective_date') }}
            , {{ col_is_current(date_col='b.effective_date') }}
      from cte_fa_base b
      left join cte_hfw_account_data hfw
            on b.financial_account_number = hfw.financial_account_number
            and b.effective_date = hfw.effective_at::date
      left join cte_morningstar_aum m_aum
            on b.financial_account_number = m_aum.account_number
            and b.effective_date = m_aum.effective_date
            and m_aum.rn = 1
      left join cte_morningstar_accounts m_acc
            on b.financial_account_number = m_acc.account_number
            and b.effective_date = m_acc.effective_date
            and m_acc.rn = 1
      left join cte_tpg_accounts t_acc
            on (b.financial_account_number = t_acc.customeraccountnumber
                  or b.internal_financial_account_number = t_acc.customeraccountnumber)
            and b.effective_date = t_acc.effective_date
            and t_acc.rn = 1
      left join cte_tpg_morningstar_overlap olap
            on b.financial_account_number = olap.morningstar_acct_number
    )
   , cte_fa as
    (
      select j.record_id                                                    as record_id
            , j.system_name                                                 as system_name
            , j.system_details                                              as system_details
            , j.financial_account_number                                    as financial_account_number
            , j.financial_account_number_clean                              as financial_account_number_clean
            , j.internal_financial_account_number                           as internal_financial_account_number
            , j.internal_household_number                                   as internal_household_number
            , j.registrant_name                                             as registrant_name
            , coalesce(sf.account_name, j.financial_account_name)           as financial_account_name
            , coalesce(sf.household_name, j.household_name)                 as household_name
            , coalesce(sf.household_location_code, j.location_code)         as location_code
            , coalesce(sf.location, j.location_name)                        as location_name
            , j.type_of_account                                             as type_of_account
            , coalesce(sf.custodian, j.custodian)                           as custodian
            , coalesce(sf.investment_strategy, j.model_investment_strategy) as model_investment_strategy
            , coalesce(sf.client_manager, j.client_manager)                 as client_manager
            , coalesce(sf.fee_schedule, j.fee_schedule)                     as fee_schedule
            , coalesce(case
                    when sf.is_erisa = 1 then 'Yes'
                    when sf.is_erisa = 0 then 'No'
                    end, j.erisa)                                    as erisa
            , coalesce(sf.is_active, j.account_active)                      as account_active
            , coalesce(sf.aum_classification, j.aum_classification_status)  as aum_classification_status
            , j.discretion_status                                           as discretion_status
            , j.proxy_voting_status                                         as proxy_voting_status
            , j.cost_basis_disposal_method                                  as cost_basis_disposal_method
            , j.prime_broker_enabled                                        as prime_broker_enabled
            , j.current_value                                               as current_value
            , coalesce(sf.opened_date, j.account_open_date)                 as account_open_date
            , coalesce(sf.closed_date, j.closed_date)                       as closed_date
            , j.as_of_date                                                  as as_of_date
            , case
                  when j.closed_date is not null then 'Exclude'
                  when j.account_active = 0 then 'Exclude'
                  when j.aum_classification_status = 'Data Aggregation / Reporting Only' then 'Exclude'
                  when source_filename is null then 'Exclude'
                  else 'Include' end                                        as aum_status
            , j.effective_date                                              as effective_date
            , j.month_end_date                                              as month_end_date
            , j.source_filename                                             as source_filename
            , j.record_date                                                 as record_date
            , j.record_datetime                                             as record_datetime
            , j.custodian                                                   as source_system_custodian
            , nvl(j.system_name, '') || '|' ||
                  nvl(j.internal_financial_account_number, '') ||
                  '|' || j.effective_date                                       as key_financial_account
        from cte_joined j
        left join {{ ref("int_salesforce_compass_accounts")}} sf
            on j.financial_account_number = sf.account_number
            and j.effective_date = sf.effective_at::date
            and sf.is_latest = 1
    )
   
select *
from cte_fa
