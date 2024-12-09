with tpg_accounts as (
    select
        replace(customeraccountnumber , '  ' , ' ')              as financial_account_number
        , ltrim(replace(customeraccountnumber , '-' , '') , '0') as financial_account_number_clean
        , customeraccountnumber                                  as internal_financial_account_number
        , substring(customeraccountnumber , 1 , 3)               as internal_household_number
        , 'TPG HFW'                                              as system_name
        , customername                                           as registrant_name
        , customername                                           as financial_account_name
        , customername                                           as household_name
        , customertypedesc                                       as type_of_account
        , fairvalue                                              as current_value
        , effective_date                                         as as_of_date
        , effective_date                                         as effective_date
        -- last day of previous month
        , last_day(effective_date)                               as month_end_date
        , source_file                                            as source_filename
        , record_datetime::date                                  as record_date
        , record_datetime                                        as record_datetime

        , row_number() over (
            partition by customeraccountnumber , effective_date
            order by record_datetime desc
        )                                                        as rn
        , {{ col_is_head(reference=ref('tpg_hfw__vw_accounts')) }}
        , {{ col_is_current(date_col='effective_date') }}

    from {{ ref("tpg_hfw__vw_accounts") }}
    where effective_date >= '2024-11-01'
)

, cte_fa as (
    select
        uuid_string()                                                           as record_id
        , t.system_name                                                         as system_name
        , 'DATALAKE.TPG_HFW.VW_ACCOUNTS'                                        as system_details
        , t.financial_account_number                                            as financial_account_number
        , t.financial_account_number_clean                                      as financial_account_number_clean
        , t.internal_financial_account_number                                   as internal_financial_account_number
        , t.internal_household_number                                           as internal_household_number
        , t.registrant_name                                                     as registrant_name
        , coalesce(sf.account_name , t.financial_account_name)                  as financial_account_name
        , coalesce(sf.household_name , t.household_name)                        as household_name
        , coalesce(sf.household_location_code , 'L-10004')                      as location_code
        , coalesce(sf.location_name , 'Bloomfield Hills, MI - Springdale Park') as location_name
        , t.type_of_account                                                     as type_of_account
        , sf.custodian                                                          as custodian
        , sf.investment_strategy                                                as model_investment_strategy
        , sf.client_manager                                                     as client_manager
        , sf.fee_schedule                                                       as fee_schedule
        , case
            when sf.is_erisa = 1 then 'Yes'
            when sf.is_erisa = 0 then 'No'
        end                                                                     as erisa
        , sf.is_active                                                          as account_active
        , sf.aum_classification                                                 as aum_classification_status
        , null                                                                  as discretion_status
        , null                                                                  as proxy_voting_status
        , null                                                                  as cost_basis_disposal_method
        , null                                                                  as prime_broker_enabled
        , t.current_value                                                       as current_value
        , sf.opened_date                                                        as account_open_date
        , sf.closed_date                                                        as closed_date
        , t.as_of_date                                                          as as_of_date
        , case
            when sf.closed_date is not null then 'Exclude'
            when sf.is_active = 0 then 'Exclude'
            when sf.aum_classification = 'Data Aggregation / Reporting Only' then 'Exclude'
            when t.source_filename is null then 'Exclude'
            else 'Include'
        end                                                                     as aum_status
        , t.effective_date                                                      as effective_date
        , t.month_end_date                                                      as month_end_date
        , t.source_filename                                                     as source_filename
        , t.record_date                                                         as record_date
        , t.record_datetime                                                     as record_datetime
        , null                                                                  as source_system_custodian
        , coalesce(t.system_name , '') || '|'
        || coalesce(t.internal_financial_account_number , '')
        || '|' || t.effective_date                                              as key_financial_account
    from tpg_accounts as t
    left join {{ ref("salesforce_compass_accounts") }} as sf
        on t.financial_account_number_clean = sf.account_number
        and t.effective_date = sf.effective_at::date
    where t.rn = 1
)

select *
from cte_fa
