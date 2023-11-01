select
      to_char(dt.quarter_end_date, 'YYYYMM')::int                     as yearmo
    , dt.quarter_end_date                                             as quarter_end_date
    , a.effective_date                                                as effective_date
    , a.custodian                                                     as custodian
    , a.firm_source                                                   as firm_source
    , 'SAN Program - Coral Gables'                                    as referral_party_name
    , a.account_number                                                as account_number
    , null::varchar(100)                                              as client_id
    , a.client_name::varchar(200)                                     as client_name
    , 1::int                                                          as is_billed
    , a.fee_percent                                                   as referral_rate
    , a.advisor_network_participation_fee::decimal(15,2)              as referral_fee_original
    , a.advisor_network_participation_fee::decimal(15,2)              as referral_fee
    , 0::decimal(15,2)                                                as adjustments
    , max(a.effective_date) over(partition by to_char(dt.quarter_end_date, 'YYYYMM')::int) as period_max_effective_date
    , case when a.effective_date = period_max_effective_date
        then 1
        else 0
        end                                                           as is_period_latest
    , a._source_loaded_at                                             as _source_loaded_at
    , a._source_file                                                  as _source_file
from {{ ref('schwab_mwa_history__base_referral_fees_advisor_network') }} a
left join {{ ref('dates') }} dt
    on a.transaction_date = dt.date_key
where true
    and a.master_number = '08365016'
