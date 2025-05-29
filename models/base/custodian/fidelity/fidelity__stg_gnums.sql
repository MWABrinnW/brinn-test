select
    a.effective_date                                                  as effective_date
    , case
        when a._source_file ilike '%0001183388%'
            then 'mwa'
        when a._source_file ilike '%0001192287%'
            then 'mps'
        when a._source_file ilike '%0001192288%'
            then 'swag'
        when a._source_file ilike '%0001293057%'
            then 'baystate'
    end::text(200)                                                    as firm_source
    , a.json:"account #"::text(200)                                   as account_number_formatted
    , replace(a.json:"account #"::text(200) , '-' , '')               as account_number
    , a.json:"primary account holder"::text(200)                      as primary_account_holder
    , a.json:"fbsi short name"::text(200)                             as custom_short_name
    , a.json:"reg type"::text(200)                                    as reg_type
    , a.json:"reg type code"::text(200)                               as reg_type_code
    , case
        when a.json:"open/closed indicator"::text(200) ilike 'open'
            then 1
        else 0
    end                                                               as is_open
    , a.json:"established date"::date                                 as established_date
    , nullif(trim(a.json:"agency"::text(200)) , '')                   as agency
    , nullif(trim(a.json:"registration and address"::text(200)) , '') as registration_and_address
    , nullif(trim(a.json:"rr1"::text(200)) , '')                      as rr1
    , nullif(trim(a.json:"rr2"::text(200)) , '')                      as rr2
    , nullif(trim(a.json:"account restrictions"::text(1500)) , '')    as account_restrictions
    , nullif(trim(a.json:"primary g#"::text(200)) , '')               as primary_gnum
    , nullif(trim(a.json:"primary g# advisor"::text(200)) , '')       as primary_gnum_advisor
    , nullif(trim(a.json:"secondary g# 1"::text(200)) , '')           as secondary_gnum_1
    , nullif(trim(a.json:"secondary g# name 1"::text(200)) , '')      as secondary_gnum_name_1
    , nullif(trim(a.json:"secondary g# 2"::text(200)) , '')           as secondary_gnum_2
    , nullif(trim(a.json:"secondary g# name 2"::text(200)) , '')      as secondary_gnum_name_2
    , nullif(trim(a.json:"secondary g# 3"::text(200)) , '')           as secondary_gnum_3
    , nullif(trim(a.json:"secondary g# name 3"::text(200)) , '')      as secondary_gnum_name_3
    , nullif(trim(a.json:"secondary g# 4"::text(200)) , '')           as secondary_gnum_4
    , nullif(trim(a.json:"secondary g# name 4"::text(200)) , '')      as secondary_gnum_name_4
    , nullif(trim(a.json:"secondary g# 5"::text(200)) , '')           as secondary_gnum_5
    , nullif(trim(a.json:"secondary g# name 5"::text(200)) , '')      as secondary_gnum_name_5
    , nullif(trim(a.json:"secondary g# 6"::text(200)) , '')           as secondary_gnum_6
    , nullif(trim(a.json:"secondary g# name 6"::text(200)) , '')      as secondary_gnum_name_6
    , nullif(trim(a.json:"secondary g# 7"::text(200)) , '')           as secondary_gnum_7
    , nullif(trim(a.json:"secondary g# name 7"::text(200)) , '')      as secondary_gnum_name_7
    , nullif(trim(a.json:"secondary g# 8"::text(200)) , '')           as secondary_gnum_8
    , nullif(trim(a.json:"secondary g# name 8"::text(200)) , '')      as secondary_gnum_name_8
    , nullif(trim(a.json:"secondary g# 9"::text(200)) , '')           as secondary_gnum_9
    , nullif(trim(a.json:"secondary g# name 9"::text(200)) , '')      as secondary_gnum_name_9
    , nullif(trim(a.json:"secondary g# 10"::text(200)) , '')          as secondary_gnum_10
    , nullif(trim(a.json:"secondary g# name 10"::text(200)) , '')     as secondary_gnum_name_10
    , a._created_at                                                   as _created_at
    , a._created_at                                                   as _source_loaded_at
    , {{ col_is_head(
        reference=source('fidelity', 'gnums'),
        source_date_col='a.effective_date',
        reference_date_col='effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._source_file::text(200)                                       as _source_file
    , a._source_file_date::date                                       as _source_file_date
    , a._row_number::int                                              as _row_number
    , a._checksum::text(200)                                          as _checksum
from {{ source('fidelity', 'gnums') }} as a
