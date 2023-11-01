select
      to_char(dt.prior_quarter_end_date, 'YYYYMM')::int                 as yearmo
    , dt.prior_quarter_end_date                                         as quarter_end_date
    , a.effective_date                                                  as effective_date
    , a.report_run_date                                                 as report_run_date
    , a.custodian                                                       as custodian
    , a.firm_source                                                     as firm_source
    , 'SAN Program'                                                     as referral_party_name
    , a.account_number                                                  as account_number
    , a.household_id                                                    as client_id
    , a.client_name::varchar(200)                                       as client_name
    , case
        when a.billed_not_billed ilike 'billed'
            then 1
        else 0
        end::int                                                        as is_billed
    , a.termination_date                                                as termination_date
    , a.account_daily_balance::decimal(17,2)                            as account_daily_balance
    , a.count_of_accounts_within_household                              as count_of_accounts_within_household
    , sum(iff(a.billed_not_billed ilike 'billed', 1, 0))
        over(partition by a.quarter
            , a.effective_date
            , a.household_id)                                           as count_of_billed_accounts_within_household
    , a.fees_due_for_household                                          as fees_due_for_household
    , sum(nvl(a.fees_due_for_household,0))
        over(partition by a.quarter
            , a.effective_date
            , a.household_id)::decimal(17,2)                            as household_fees
    , adj.amount                                                        as household_adjustments
    , sum(
        case when a.billed_not_billed ilike 'billed'
            then a.account_daily_balance
        else 0
        end::decimal(17,2))
        over(partition by a.quarter
            , a.effective_date
            , a.household_id)::decimal(17,2)                            as household_total_daily_balance
    , case
        when a.billed_not_billed ilike 'billed' and household_total_daily_balance = 0
            then 1 / count_of_billed_accounts_within_household
        when a.billed_not_billed ilike 'billed'
        --when 1=1
            then (a.account_daily_balance / household_total_daily_balance)::float
        else 0
        end::float                                                      as percentage_of_total
    , a.blended_tiered_rate                                             as blended_tiered_rate
    , null::decimal(10,5)                                               as referral_rate
    , (percentage_of_total
        * (household_fees))::decimal(17,2)                              as referral_fee_original
    , (percentage_of_total
        * (household_fees + nvl(adj.amount,0)))::decimal(17,2)          as referral_fee
    , nvl(adj.amount,0)                                                 as adjustments
    , max(a.effective_date) over(partition by to_char(dt.quarter_end_date, 'YYYYMM')::int) as period_max_effective_date
    , case when a.effective_date = period_max_effective_date
        then 1
        else 0
        end                                                             as is_period_latest
    , a._source_loaded_at                                               as _source_loaded_at
    , a._source_file                                                    as _source_file
    , object_construct_keep_null(
        'billed_not_billed', a.billed_not_billed
    )                                                                   as extra_fields
from {{ ref('schwab_mwa_history__base_referral_fees_prior_quarter') }} a
left join {{ ref('dates') }} dt
    on a.report_run_date = dt.date_key
left join {{ ref('aux__stg_referral_fees_san_adjustments') }} adj
    on to_char(dt.prior_quarter_end_date, 'YYYYMM')::int = adj.period_datenum
    and a.household_id = adj.household_id
where a.master_number = '08365016'
