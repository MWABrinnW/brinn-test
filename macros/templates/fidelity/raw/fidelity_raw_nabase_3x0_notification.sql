{%- macro fidelity_raw_nabase_3x0_notification(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 9)), '')                                           as FFR_XREF
  , nullif(trim(substring(content, 27, 80)), '')                                          as EMAIL_ADDRESS
  , nullif(trim(substring(content, 107, 1)), '')                                          as EMAIL_ADDRESS_OF_RECORD
  , nullif(trim(substring(content, 108, 1)), '')                                          as STATEMENT_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 109, 1)), '')                                          as STATEMENT_SUPPRESSION_PENDING_INDICATOR
  , nullif(trim(substring(content, 110, 1)), '')                                          as CONFIRM_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 111, 1)), '')                                          as CONFIRM_SUPPRESSION_PENDING_INDICATOR
  , nullif(trim(substring(content, 112, 1)), '')                                          as RAP_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 113, 1)), '')                                          as RAP_SUPPRESSION_PENDING_INDICATOR
  , nullif(trim(substring(content, 114, 1)), '')                                          as SHAREHOLDER_DOCUMENTS_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 115, 1)), '')                                          as SHAREHOLDER_DOCUMENTS_SUPPRESSION_PENDING_INDICATOR
  , nullif(trim(substring(content, 116, 1)), '')                                          as TAX_FORMS_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 117, 1)), '')                                          as TAX_FORMS_SUPPRESSION_PENDING_INDICATOR
  , nullif(trim(substring(content, 118, 1)), '')                                          as QPR_SUPPRESSION_INDICATOR
  , nullif(trim(substring(content, 119, 1)), '')                                          as QPR_SUPPRESSION_PENDING_INDICATOR
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and rlike(left(content, 4), 'D3[0-9]0')
{%- endmacro -%}