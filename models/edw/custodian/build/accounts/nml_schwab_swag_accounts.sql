select
    a.effective_date::date                                         as effective_date
  , 'schwab'::varchar(50)                                          as custodian
  , a.firm::varchar(50)                                            as firm
  , a.firm_source::varchar(50)                                     as firm_source
  , a.account_number::varchar(50)                                  as account_number
  , a.account_number::varchar(50)                                  as account_number_formatted

  , a.master_account_number::varchar(50)                           as custodian_link
  , 'master_number'::varchar(50)                                   as custodian_link_detail
  , null::varchar(50)                                              as rep_link
  , null::varchar(50)                                              as rep_link_detail
    -- ,lower(customer_type)                   as registration_type -- (inv,trust,org)
  , a.account_registration::varchar(50)                            as account_type_source_code
  , ar.definition::varchar(50)                                     as account_type_source_definition
  , ar.normalized::varchar(50)                                     as account_type -- (ira rollover, etc)

  , a.date_opened_established::date                                as opened_date
  , a.account_title_line_1::varchar(200)                           as account_title
  , a.taxpayer_first_name::varchar(200)                            as first_name
  , a.taxpayer_middle_name::varchar(200)                           as middle_name
  , a.taxpayer_last_name::varchar(200)                             as last_name

  , replace(a.social_security_number_ssntax_id_number_tin, '-', '')::varchar(20) as irs_id
  , case
        when left(a.social_security_number_ssntax_id_number_tin, 1) = '9'
            then 'tin'
        else 'ssn'
        end::varchar(10)                                           as irs_id_type
  , null                                                           as birth_date -- not provided

  , a.email_address::varchar(75)                                   as email_address
  , a.phone::varchar(20)                                           as phone
  , a.cost_basis_method_for_mutual_funds::varchar(50)              as cost_basis_method_mutual_funds -- needs normalization
  , a.cost_basis_method_non_mutual_funds::varchar(50)              as cost_basis_method_non_mutual_funds -- needs normalization
  , case
        when nvl(a.account_taxable_indicator, 'N') = 'Y'
            then 1
        else 0
        end::int                                                   as is_taxable
  , case
        when nvl(a.fa_fee_status, 'N') = 'Y'
            then 1
        else 0
        end::int                                                   as is_fee_authorized
  , case
        when nvl(a.prime_broker_enabled_indicator, 'N') = 'Y'
            then 1
        else 0
        end::int                                                   as is_prime_broker
  , nullif(rtrim(regexp_replace(concat_ws('|'
                                    , nvl(a.restriction_reason_code_1, '')
                                    , nvl(a.restriction_reason_code_2, '')
                                    , nvl(a.restriction_reason_code_3, '')
                                    , nvl(a.restriction_reason_code_4, '')
                                    , nvl(a.restriction_reason_code_5, '')), '(\\|{2,5})', '|'), '|'), '')::varchar(200)
                                                                   as restrictions_source_code
  , null::varchar(75)                                              as restrictions_source_definition
  , null::varchar(75)                                              as restrictions
  , trim(concat(nvl(a.mailing_address_line_1, ''),
                nvl(a.mailing_address_line_2, ' '),
                nvl(a.mailing_address_line_3, ' ')))::varchar(200) as mailing_address_street
  , a.account_mailing_city::varchar(75)                            as mailing_address_city
  , a.account_mailing_state::varchar(50)                           as mailing_address_state
  , a.account_mailing_zip::varchar(12)                             as mailing_address_zip
  , a.account_mailing_country_code::varchar(50)                    as mailing_address_country
  , null::varchar(200)                                             as legal_address_street
  , null::varchar(75)                                              as legal_address_city
  , null::varchar(50)                                              as legal_address_state
  , null::varchar(12)                                              as legal_address_zip
  , null::varchar(50)                                              as legal_address_country
  , a.is_head::int                                                 as is_head
  , a.is_current::int                                              as is_current
  , a._source_loaded_at::timestamp                                 as _created_at
  , a._source_loaded_at::timestamp                                 as _source_loaded_at
  , null::varchar(200)                                             as _source_file
from {{ ref('schwab__base_accounts') }} a
left join {{ ref('custodian_mappings') }}           ar
    on ar.custodian = 'schwab'
    and ar.field = 'account_registration'
    and a.account_registration = ar.source
where true
    and a.firm_source = 'swag'
    and a.rn = 1
