{%- macro fidelity_nabase_107_employer(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src.identifier.split('_')[1].lower() ~ "'" }}                                 as firm_source
  , RECORD_TYPE                          as RECORD_TYPE
  , RECORD_NUMBER                        as RECORD_NUMBER
  , FIRM                                 as FIRM
  , BRANCH                               as BRANCH
  , ACCOUNT_NUMBER                       as ACCOUNT_NUMBER
  , AFFILIATION_STATUS                   as AFFILIATION_STATUS
  , NYSE_RULE_407_INDICATOR              as NYSE_RULE_407_INDICATOR
  , FINANCIAL_INSTITUTION_NAME           as FINANCIAL_INSTITUTION_NAME
  , FINANCIAL_INSTITUTION_ADDRESS_LINE_1 as FINANCIAL_INSTITUTION_ADDRESS_LINE_1
  , FINANCIAL_INSTITUTION_ADDRESS_LINE_2 as FINANCIAL_INSTITUTION_ADDRESS_LINE_2
  , FINANCIAL_INSTITUTION_ADDRESS_LINE_3 as FINANCIAL_INSTITUTION_ADDRESS_LINE_3
  , OCCUPATION                           as OCCUPATION
  , EMPLOYER_NAME                        as EMPLOYER_NAME
  , EMPLOYER_ADDRESS_LINE_1              as EMPLOYER_ADDRESS_LINE_1
  , EMPLOYER_ADDRESS_LINE_2              as EMPLOYER_ADDRESS_LINE_2
  , EMPLOYER_ADDRESS_LINE_3              as EMPLOYER_ADDRESS_LINE_3
  , EMPLOYER_ADDRESS_COUNTRY_CODE        as EMPLOYER_ADDRESS_COUNTRY_CODE
  , CONTROL_RELATIONSHIP_CODE_1          as CONTROL_RELATIONSHIP_CODE_1
  , CONTROL_RELATIONSHIP_COMPANY_NAME_1  as CONTROL_RELATIONSHIP_COMPANY_NAME_1
  , CONTROL_RELATIONSHIP_CUSIP_1         as CONTROL_RELATIONSHIP_CUSIP_1
  , CONTROL_RELATIONSHIP_CODE_2          as CONTROL_RELATIONSHIP_CODE_2
  , CONTROL_RELATIONSHIP_COMPANY_NAME_2  as CONTROL_RELATIONSHIP_COMPANY_NAME_2
  , CONTROL_RELATIONSHIP_CUSIP_2         as CONTROL_RELATIONSHIP_CUSIP_2
  , CONTROL_RELATIONSHIP_CODE_3          as CONTROL_RELATIONSHIP_CODE_3
  , CONTROL_RELATIONSHIP_COMPANY_NAME_3  as CONTROL_RELATIONSHIP_COMPANY_NAME_3
  , CONTROL_RELATIONSHIP_CUSIP_3         as CONTROL_RELATIONSHIP_CUSIP_3
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}