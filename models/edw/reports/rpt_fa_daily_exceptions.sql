select
      a.effective_date
    , a.system_name
    , a.client_manager
    , a.custodian
    , a.financial_account_number_clean
    , a.type_of_account
    , a.current_value
    , a.financial_account_name
    , a.account_active
    , a.closed_date
    , a.account_open_date
    , a.location_code
    , a.location_name
    , a.internal_household_number
    , a.internal_financial_account_number
    , a.sf_18_digit_id
    , a.fee_schedule
    , a.model_investment_strategy

    , ''::varchar(2000)
        -- Missing client manager
        || nvl(CASE WHEN a.closed_date is null and coalesce(a.client_manager, '') = '' and coalesce(a.financial_account_name,'') not ilike '%closed%'
            THEN 'Missing client_manager; ' END,'')
        -- Missing AUM status
        || nvl(CASE WHEN a.closed_date is null and coalesce(a.aum_classification_status,'') = '' and a.current_value > 0
            THEN 'Missing aum_classification_status; ' END,'')
        -- Missing custodian
        || nvl(CASE WHEN nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.custodian,'') = ''
            THEN 'Missing custodian; ' END,'')
        -- Missing location_code
        || nvl(CASE WHEN nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.location_code,'') = '' and a.current_value > 0
            THEN 'Missing location_code; ' END,'')
        -- Missing location_code and has location_name
        || nvl(CASE WHEN nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.location_code,'') = '' and nvl(a.location_name,'') <> '' and a.current_value > 0
            THEN 'Missing location_code but has location_name; ' END,'')
        -- Active with closed_date
        || nvl(CASE WHEN a.closed_date is not null and a.account_active::int = 1
            THEN 'account_active with closed_date; ' END,'')
        -- Funded without open_date
        || nvl(CASE WHEN a.account_open_date is null and a.current_value > 0
            THEN 'Funded without open_date; ' END,'')
        -- Duplicate in same system
        || nvl(CASE WHEN d1.record_count > 1 and d1.system_count = 1
            THEN 'Duplicate in pms; ' END,'')
        -- Duplicate across multiple systems
        || nvl(CASE WHEN a.account_active::int = 1 and d1.system_count > 1
            THEN 'Duplicate in multiple systems; ' END,'')

        -- Placeholder
        || nvl(CASE WHEN 1=2
            THEN '; ' END,'')
        as exceptions
from {{ source('edw_mwa', 'financial_account_daily') }} a
left join (
             select effective_date, financial_account_number_clean, count(*) as record_count, count(distinct system_name) as system_count
             from {{ source('edw_mwa', 'financial_account_daily') }}
             where nvl(financial_account_number_clean, '') <> ''
                and account_active::int = 1
                and system_name not in ('Salesforce')
                and effective_date = (select max(effective_date) from {{ source('edw_mwa', 'financial_account_daily') }})
             group by effective_date, financial_account_number_clean
             having count(*) > 1
         ) d1
    on a.effective_date = d1.effective_date
    and a.financial_account_number_clean = d1.financial_account_number_clean
where true
    -- Latest effective date only
    and a.effective_date = (select max(effective_date) from edw.mwa.financial_account_daily)
    -- EXCEPTIONS -------------------------
    and (
    -- Missing client manager
    ( nvl(a.closed_date,current_date() - 7) >= current_date() -7 and coalesce(a.client_manager, '') = '' and coalesce(a.financial_account_name,'') not ilike '%closed%' )
    -- Missing AUM status
    or ( nvl(a.closed_date,current_date() - 7) >= current_date() -7 and coalesce(a.aum_classification_status,'') = '' and a.current_value > 0 )
    -- Missing custodian
    or ( nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.custodian,'') = '' )
    -- Missing location code
    or ( nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.location_code,'') = '' and a.current_value > 0 )
    -- Missing location_code and has location_name
    or ( nvl(a.closed_date,current_date() - 7) >= current_date() - 7 and nvl(a.location_code,'') = '' and nvl(a.location_name,'') <> '' and a.current_value > 0 )
    -- Active with closed date
    or ( a.closed_date is not null and a.account_active::int = 1 )
    -- Funded without open date
    or ( a.account_open_date is null and a.current_value > 0 )
    -- Duplicate in same system
    or ( a.account_active::int = 1 and d1.record_count > 1 and d1.system_count = 1 )
    -- Duplicate across multiple systems
    or ( a.account_active::int = 1 and d1.system_count > 1 )
    -- Placeholder
    or ( 1=2 )
    )
    -- END EXCEPTIONS ---------------------
order by a.system_name, a.household_name, a.financial_account_name