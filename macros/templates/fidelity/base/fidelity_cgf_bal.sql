{%- macro fidelity_cgf_bal(src) -%}

SELECT
    effective_date                                                as effective_date
  , 'fidelity-cgf'                                                as custodian
  , {{ "'" ~ src ~ "'" }}                                         as firm_source
  , nullif(trim(substring(content, 1, 10)), '') as g_number
  , nullif(trim(substring(content, 11, 15)), '') as cgf_account_number
  , nullif(trim(substring(content, 26, 13)), '')::decimal(13,2) as ytd_contribution_amount
  , nullif(trim(substring(content, 39, 13)), '')::decimal(13,2) as ytd_grant_amount
  , nullif(trim(substring(content, 52, 1)), '') as ytd_misc_sign
  , iff(substring(content, 52, 1)='+', 1, -1) * nullif(trim(substring(content, 53, 13)), '')::decimal(13,2) as ytd_misc_amount
  , nullif(trim(substring(content, 66, 13)), '')::decimal(13,2) as total_market_value
  , nullif(trim(substring(content, 79, 13)), '')::decimal(13,2) as giving_value
  , nullif(trim(substring(content, 92, 13)), '')::decimal(13,2) as match_value
  , {{ col_is_head(reference=source('fidelity_' ~ src, 'cgf_bal')) }}
  , {{ col_is_current(date_col='effective_date') }} 
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ source('fidelity_' ~ src, 'cgf_bal') }}
where 1 = 1
  and left(content, 1) = 'G'

{%- endmacro -%}