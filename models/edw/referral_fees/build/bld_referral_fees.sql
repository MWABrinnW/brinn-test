select
      yearmo
    , quarter_end_date
    , effective_date
    , custodian
    , firm_source
    , referral_party_name
    , account_number
    , client_id
    , client_name
    , referral_rate
    , referral_fee_original
    , adjustments
    , referral_fee
    , is_period_latest
    , _source_loaded_at::timestamp_tz as _source_loaded_at
    , _source_file
from {{ ref('int_schwab_san_referral_fees') }}

union all

select
      yearmo
    , quarter_end_date
    , effective_date
    , custodian
    , firm_source
    , referral_party_name
    , account_number
    , client_id
    , client_name
    , referral_rate
    , referral_fee_original
    , adjustments
    , referral_fee
    , is_period_latest
    , _source_loaded_at::timestamp_tz
    , _source_file
from {{ ref('int_schwab_advisor_network_fees') }}

union all

select
      yearmo                      as yearmo
    , quarter_end_date            as quarter_end_date
    , effective_date              as effective_date
    , custodian                   as custodian
    , firm_source                 as firm_source
    , referral_party_name         as referral_party_name
    , account_number              as account_number
    , null::varchar(100)          as cliend_id
    , account_name                as client_name
    , null::decimal(10,5)         as referral_rate
    , account_total_fee           as referral_fee_original
    , 0::decimal(15,2)            as adjustments
    , account_total_fee           as referral_fee
    , is_period_latest            as is_period_latest
    , _created_at::timestamp_tz   as _created_at
    , _source_file                as _source_file
from {{ ref('fidelity_mwa_history__base_referral_fees') }}
