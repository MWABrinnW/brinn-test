{{ config(tags=["referral_fees"]) }}
select
      json:"quarter_end_date"::date             as quarter_end_date
    , json:"lock_date"::date                    as lock_date
    , json:"referral_party_name"::text(200)     as referral_party_name
    , _created_at::timestamp_ntz                as _created_at
    , _box_file_id::text(100)                   as _box_file_id
from {{ source('aux', 'referral_fees_lock_dates') }}
