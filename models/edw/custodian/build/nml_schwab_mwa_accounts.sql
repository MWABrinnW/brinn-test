select
    a.effective_date
  , 'schwab'                                         as custodian
  , 'mwa'                                            as firm
  , a.account_id                                     as account_number
  , a.account_id                                     as account_number_formatted

  , a.master_account_number                          as custodian_link
  , 'master'                                         as custodian_link_detail
    -- ,lower(customer_type)                   as registration_type -- (inv,trust,org)
  , a.account_registration                           as account_type_source_code
  , ar.definition                                    as account_type_source_definition
  , ar.normalized                                    as account_type -- (ira rollover, etc)

  , a.date_opened                                    as opened_date
  , a.account_title_line_1                           as account_title
  , a.tax_payer_first_name                           as first_name
  , a.tax_payer_middle_name                          as middle_name
  , a.tax_payer_last_name                            as last_name

  , replace(a.ssn_tin, '-', '')::varchar(20)         as irs_id
  , case
        when left(a.ssn_tin, 1) = '9'
            then 'tin'
        else 'ssn'
        end                                          as irs_id_type
  , null                                             as birth_date -- not provided

  , a.email_address                                  as email_address
  , a.phone::varchar(20)                             as phone
  , a.cost_basis_method_for_mutual_funds             as cost_basis_method_mutual_funds -- needs normalization
  , a.cost_basis_method_non_mutual_funds             as cost_basis_method_non_mutual_funds -- needs normalization
  , case
        when nvl(a.account_taxable_indicator, 'N') = 'Y'
            then 1
        else 0
        end                                          as is_taxable
  , case
        when nvl(a.fa_fee_status, 'N') = 'Y'
            then 1
        else 0
        end                                          as is_fee_authorized
  , case
        when nvl(a.prime_broker_enabled_indicator, 'N') = 'Y'
            then 1
        else 0
        end                                          as is_prime_broker
  , nullif(rtrim(regexp_replace(concat_ws('|'
                                    , nvl(a.restriction_reason_code_1, '')
                                    , nvl(a.restriction_reason_code_2, '')
                                    , nvl(a.restriction_reason_code_3, '')
                                    , nvl(a.restriction_reason_code_4, '')
                                    , nvl(a.restriction_reason_code_5, '')), '(\\|{2,5})', '|'), '|'), '')
                                                     as restrictions_source_code
  , null                                             as restrictions_source_definition
  , null                                             as restrictions
  , trim(concat(nvl(a.mailing_address_line_1, ''),
                nvl(a.mailing_address_line_2, ' '),
                nvl(a.mailing_address_line_3, ' '))) as mailing_address_street
  , a.account_mailing_city                           as mailing_address_city
  , a.account_mailing_state                          as mailing_address_state
  , a.account_mailing_zip::varchar(12)               as mailing_address_zip
  , a.account_mailing_country_code                   as mailing_address_country
  , null                                             as legal_address_street
  , null                                             as legal_address_city
  , null                                             as legal_address_state
  , null::varchar(12)                                as legal_address_zip
  , null                                             as legal_address_country
  , is_head
  , is_current
  , _source_loaded_at
from {{ ref('schwab_mwa_history__base_accounts') }} a
left join {{ ref('custodian_mappings') }}           ar
    on ar.custodian = 'schwab'
    and ar.field = 'account_registration'
    and a.account_registration = ar.source