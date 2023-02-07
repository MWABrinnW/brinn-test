{{ config(enabled = false) }}

select
    a.effective_date
  , 'tda'                       as custodian
  , 'mwa'                       as firm
  , a.account_number            as account_number
  , a.account_number            as account_number_formatted

  , a.advisor_id                as custodian_link_id
  , 'rep code'                  as custodian_link_detail
    -- ,null                                   as registration_type -- (inv,trust,org)
  , a.account_type              as account_type_source_code
  , null                        as account_type_source_definition
  , null                        as account_type -- (ira rollover, etc)
  , null                        as opened_date

  , a.account_type              as account_title
  , a.first_name                as first_name
  , null                        as middle_name -- not provided
  , a.last_name                 as last_name

  , a.ssn::varchar(20)          as irs_id
  , case
        when left(a.ssn, 1) = '9'
            then 'tin'
        else 'ssn'
        end                     as irs_id_type
  , a.birth_date                as birth_date

  , null                        as email_address
  , a.phone_number::varchar(20) as phone
  , null                        as cost_basis_method_mutual_funds -- not available
  , null                        as cost_basis_method_non_mutual_funds -- not available
  , case
        when nvl(a.taxable, 'N') = 'Y'
            then 1
        else 0
        end                     as is_taxable
  , null                        as is_fee_authorized
  , null                        as is_prime_broker
  , null                        as restrictions_source_code
  , null                        as restrictions_source_defintion
  , null                        as restrictions
  , trim(concat(nvl(a.street, ''),
                nvl(a.address_2, ' '),
                nvl(a.address_3, ' '),
                nvl(a.address_4, ' '),
                nvl(a.address_5, ' '),
                nvl(a.address_6, ' ')
    ))                          as mailing_address_street
  , a.city::varchar(100)        as mailing_address_city
  , a.state::varchar(100)       as mailing_address_state
  , a.zip_code::varchar(12)     as mailing_address_zip
  , null::varchar(100)          as mailing_address_country
  , null::varchar(100)          as legal_address_street
  , null::varchar(100)          as legal_address_city
  , null::varchar(100)          as legal_address_state
  , null::varchar(12)           as legal_address_zip
  , null::varchar(100)          as legal_address_country
  , a.is_head::int              as is_head
  , a.is_current::int           as is_current
  , a._created_at::timestamp    as _created_at
from {{ ref('tda__base_accounts') }} a