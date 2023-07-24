select
    dt.prior_market_date                                         as effective_date
  , case
        when _source_file ilike '%0001183388%'
            then 'mwa'
        when _source_file ilike 'PLACEHOLDER'
            then 'mps'
        when _source_file ilike '%0001192288%'
            then 'swag'
        else null
        end                                                      as firm_source
  , json:"account #"::text(200)                                  as account_number_formatted
  , replace(json:"account #"::text(200), '-', '')                as account_number
  , json:"primary account holder"::text(200)                     as primary_account_holder
  , json:"fbsi short name"::text(200)                            as custom_short_name
  , json:"reg type"::text(200)                                   as reg_type
  , json:"reg type code"::text(200)                              as reg_type_code
  , case
        when json:"open/closed indicator"::text(200) ilike 'open'
            then 1
        else 0
        end                                                      as is_open
  , json:"established date"::date                                as established_date
  , nullif(trim(json:"agency"::text(200)), '')                   as agency
  , nullif(trim(json:"registration and address"::text(200)), '') as registration_and_address
  , nullif(trim(json:"rr1"::text(200)), '')                      as rr1
  , nullif(trim(json:"rr2"::text(200)), '')                      as rr2
  , nullif(trim(json:"account restrictions"::text(1500)), '')    as account_restrictions
  , nullif(trim(json:"primary g#"::text(200)), '')               as primary_gnum
  , nullif(trim(json:"primary g# advisor"::text(200)), '')       as primary_gnum_advisor
  , nullif(trim(json:"secondary g# 1"::text(200)), '')           as secondary_gnum_1
  , nullif(trim(json:"secondary g# name 1"::text(200)), '')      as secondary_gnum_name_1
  , nullif(trim(json:"secondary g# 2"::text(200)), '')           as secondary_gnum_2
  , nullif(trim(json:"secondary g# name 2"::text(200)), '')      as secondary_gnum_name_2
  , nullif(trim(json:"secondary g# 3"::text(200)), '')           as secondary_gnum_3
  , nullif(trim(json:"secondary g# name 3"::text(200)), '')      as secondary_gnum_name_3
  , nullif(trim(json:"secondary g# 4"::text(200)), '')           as secondary_gnum_4
  , nullif(trim(json:"secondary g# name 4"::text(200)), '')      as secondary_gnum_name_4
  , nullif(trim(json:"secondary g# 5"::text(200)), '')           as secondary_gnum_5
  , nullif(trim(json:"secondary g# name 5"::text(200)), '')      as secondary_gnum_name_5
  , nullif(trim(json:"secondary g# 6"::text(200)), '')           as secondary_gnum_6
  , nullif(trim(json:"secondary g# name 6"::text(200)), '')      as secondary_gnum_name_6
  , nullif(trim(json:"secondary g# 7"::text(200)), '')           as secondary_gnum_7
  , nullif(trim(json:"secondary g# name 7"::text(200)), '')      as secondary_gnum_name_7
  , nullif(trim(json:"secondary g# 8"::text(200)), '')           as secondary_gnum_8
  , nullif(trim(json:"secondary g# name 8"::text(200)), '')      as secondary_gnum_name_8
  , nullif(trim(json:"secondary g# 9"::text(200)), '')           as secondary_gnum_9
  , nullif(trim(json:"secondary g# name 9"::text(200)), '')      as secondary_gnum_name_9
  , nullif(trim(json:"secondary g# 10"::text(200)), '')          as secondary_gnum_10
  , nullif(trim(json:"secondary g# name 10"::text(200)), '')     as secondary_gnum_name_10
  , _created_at                                                  as _source_loaded_at
  , {{ col_is_head(reference=source('fidelity', 'gnums'), source_date_col='a._source_file_date', reference_date_col='_source_file_date') }}
  , {{ col_is_current(date_col='dt.prior_market_date') }}
  , _source_file::text(200)                                      as _source_file
  , _source_file_date::date                                      as _source_file_date
  , _row_number::int                                             as _row_number
  , _checksum::text(200)                                         as _checksum
from {{ source('fidelity', 'gnums') }} a
left join {{ ref('dates') }} dt
    on a._source_file_date = dt.date_key
