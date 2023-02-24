{%- macro fidelity_nabase_3x0_notification(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                         as RECORD_TYPE
  , RECORD_NUMBER                                       as RECORD_NUMBER
  , FIRM                                                as FIRM
  , BRANCH                                              as BRANCH
  , ACCOUNT_NUMBER                                      as ACCOUNT_NUMBER
  , FFR_XREF                                            as FFR_XREF
  , EMAIL_ADDRESS                                       as EMAIL_ADDRESS
  , EMAIL_ADDRESS_OF_RECORD                             as EMAIL_ADDRESS_OF_RECORD
  , STATEMENT_SUPPRESSION_INDICATOR                     as STATEMENT_SUPPRESSION_INDICATOR
  , STATEMENT_SUPPRESSION_PENDING_INDICATOR             as STATEMENT_SUPPRESSION_PENDING_INDICATOR
  , CONFIRM_SUPPRESSION_INDICATOR                       as CONFIRM_SUPPRESSION_INDICATOR
  , CONFIRM_SUPPRESSION_PENDING_INDICATOR               as CONFIRM_SUPPRESSION_PENDING_INDICATOR
  , RAP_SUPPRESSION_INDICATOR                           as RAP_SUPPRESSION_INDICATOR
  , RAP_SUPPRESSION_PENDING_INDICATOR                   as RAP_SUPPRESSION_PENDING_INDICATOR
  , SHAREHOLDER_DOCUMENTS_SUPPRESSION_INDICATOR         as SHAREHOLDER_DOCUMENTS_SUPPRESSION_INDICATOR
  , SHAREHOLDER_DOCUMENTS_SUPPRESSION_PENDING_INDICATOR as SHAREHOLDER_DOCUMENTS_SUPPRESSION_PENDING_INDICATOR
  , TAX_FORMS_SUPPRESSION_INDICATOR                     as TAX_FORMS_SUPPRESSION_INDICATOR
  , TAX_FORMS_SUPPRESSION_PENDING_INDICATOR             as TAX_FORMS_SUPPRESSION_PENDING_INDICATOR
  , QPR_SUPPRESSION_INDICATOR                           as QPR_SUPPRESSION_INDICATOR
  , QPR_SUPPRESSION_PENDING_INDICATOR                   as QPR_SUPPRESSION_PENDING_INDICATOR
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}