select
      a.yearmo
    , a.quarter_end_date
    , a.effective_date
    , a.custodian
    , a.firm_source
    , a.referral_party_name
    , a.account_number
    , a.client_id
    , a.client_name
    , fam.client_manager
    , fam.location_code
    , fam.location_name
    , a.referral_rate
    , a.referral_fee_original
    , a.adjustments
    , a.referral_fee
    --, a.is_period_latest
    , case
        -- Consider SAN final if there is a lock date.
        -- If no lock date then consider it final if
        -- the report is from the last day of following month.
        when a.referral_party_name ilike 'SAN Program'
            then case
                when b.lock_date is not null
                    then 1
                when a.effective_date = last_report.month_last_market_date
                    then 1
                else 0
                end
        -- If WAS exists it should be considered final.
        else 1
        end::int            as is_final
    , b.lock_date
    , a._source_loaded_at
    , a._source_file
from {{ ref('bld_referral_fees') }} a
left join {{ ref('aux__stg_referral_fees_lock_dates') }} b
    on a.quarter_end_date = b.quarter_end_date
    and a.referral_party_name = b.referral_party_name
left join {{ source('edw_mwa', 'financial_account_monthly') }} fam
    on a.quarter_end_date = fam.month_end_date
    and a.account_number = fam.financial_account_number_clean
left join {{ ref('dates') }} last_report
    -- Get the first day of next month so we can retrieve the last effective date
    -- of the month following quarter end.
    on a.quarter_end_date + 1 = last_report.date_key
where 1=1
    and a.quarter_end_date >= '9/30/2023' --data before 2023Q3 not validated
    and (
        -- For Schwab SAN, we receive prior quarter every day and it changes over time,
        -- usually up until ~17-23 calendar days after quarter end.
        -- We will consider the last report from the last day in the month end
        -- after quarter end to be final. UNLESS a lock date is entered.
        (
            a.referral_party_name ilike 'SAN Program' and a.effective_date =
            coalesce(
                b.lock_date
                , last_report.month_last_market_date
                , case when a.is_period_latest = 1 then a.effective_date else null end
            )
        )
        or
        -- For Fidelity WAS, we only load one file per period.
        (a.referral_party_name in ('SAN Program - Coral Gables', 'WAS Program') and a.is_period_latest = 1)
    )

union all

select
      a.yearmo
    , a.quarter_end_date
    , a.effective_date
    , a.custodian
    , a.firm_source
    , a.referral_party_name
    , a.account_number
    , a.client_id
    , a.client_name
    , fam.client_manager
    , fam.location_code
    , fam.location_name
    , a.referral_rate
    , a.referral_fee_original
    , a.adjustments
    , a.referral_fee
    --, a.is_period_latest
    , 1::int as is_final
    , a.lock_date
    , a._source_loaded_at
    , a._source_file
from {{ ref('int_legacy_referral_fees') }} a
left join {{ source('edw_mwa', 'financial_account_monthly') }} fam
    on a.quarter_end_date = fam.month_end_date
    and a.account_number = fam.financial_account_number_clean
where a.quarter_end_date < '9/30/2023'
