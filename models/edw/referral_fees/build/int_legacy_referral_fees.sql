select
    to_char(revenue_quarter , 'YYYYMM')::int as yearmo
    , revenue_quarter                        as quarter_end_date
    , revenue_quarter                        as effective_date
    , case
        when system_name ilike '%fidelity%'
            then 'fidelity'
        when system_name ilike '%schwab%'
            then 'schwab'
        else null
    end::text(200)                           as custodian
    , 'mwa'::text(200)                       as firm_source
    , case
        when source_file_name ilike 'AN%'
            then 'SAN Program - Coral Gables'
        else referral_party_name
        end::text(200)                       as referral_party_name
    , financial_account_number               as account_number
    -- If we want this field we should repopulate the source table with it added.
    -- It would need to be joined with upstream tables on dw1.
    , null::text(200)                        as client_id
    , client_name                            as client_name
    , referral_rate                          as referral_rate
    , null::decimal(20 , 2)                  as referral_fee_original
    , null::decimal(20 , 2)                  as adjustments
    , referral_fee                           as referral_fee
    , 1::int                                 as is_period_latest
    , record_datetime::timestamp_tz          as _source_loaded_at
    -- If we want this field we should repopulate the source table with it added.
    -- It would need to be joined with upstream tables on dw1.
    , source_file_name::text(200)            as _source_file
    , null::date                             as lock_date
from {{ ref('edw_legacy__base_revenue_referral_fees') }}
