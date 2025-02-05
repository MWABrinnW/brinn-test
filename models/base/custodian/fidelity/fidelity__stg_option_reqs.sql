select
    nullif(trim(json:"account #"::text(200)) , '')                   as account_number_formatted
    , replace(upper(trim(account_number_formatted)) , '-' , '')      as account_number
    , nullif(trim(json:"balance date hist"::text(200)) , '')         as balance_date_hist
    , nullif(trim(json:"established date"::text(200)) , '')          as established_date
    , nullif(trim(json:"house call/surplus"::text(200)) , '')        as house_call_surplus
    , nullif(trim(json:"house call/surplus (mm)"::text(200)) , '')   as house_call_surplus_mm
    , nullif(trim(json:"house option requirements"::text(200)) , '') as house_option_requirements
    , nullif(trim(json:"margin agreement status"::text(200)) , '')   as margin_agreement_status
    , nullif(trim(json:"option agreement status"::text(200)) , '')   as option_agreement_status
    , nullif(trim(json:"option level"::text(200)) , '')              as option_level
    , {{ col_is_head(
        reference=source('fidelity', 'option_reqs'),
        source_date_col='_source_file_date',
        reference_date_col='_source_file_date') }}
    , _source_file::text(200)                                        as _source_file
    , _source_file_date::date                                        as _source_file_date
    , _row_number::int                                               as _row_number
    , _checksum::text(200)                                           as _checksum
from {{ source('fidelity', 'option_reqs') }}
