select
    a.effective_date
  , 'tda'                            as custodian
  , 'mwa'::varchar(50)               as firm
  , 'mwa'::varchar(50)               as firm_source
  , a.account_number                 as account_number
  , a.account_number                 as account_number_formatted

  , null::varchar(50)                as custodian_link
  , null::varchar(50)                as custodian_link_detail
  , a.advisor_id                     as rep_link
  , 'rep_code'                       as rep_link_detail
  , a.account_type                   as account_type_source_code
  , null                             as account_type_source_definition
  , null                             as account_type -- (ira rollover, etc)
  , null                             as opened_date

  , a.account_type                   as account_title
  , a.first_name                     as first_name
  , null                             as middle_name -- not provided
  , a.last_name                      as last_name

  , a.ssn::varchar(20)               as irs_id
  , case
        when left(a.ssn, 1) = '9'
            then 'tin'
        else 'ssn'
        end                          as irs_id_type
  , a.birth_date                     as birth_date

  , null::varchar(75)                as email_address
  , a.phone_number::varchar(20)      as phone
  , null::varchar(50)                as cost_basis_method_mutual_funds -- not available
  , null::varchar(50)                as cost_basis_method_non_mutual_funds -- not available
  , case
        when nvl(a.taxable, 'N') = 'Y'
            then 1
        else 0
        end::int                     as is_taxable
  , null::int                        as is_fee_authorized
  , null::int                        as is_prime_broker
  , null                             as restrictions_source_code
  , null                             as restrictions_source_defintion
  , null                             as restrictions
  , trim(concat(nvl(a.street, ''),
                nvl(a.address_2, ' '),
                nvl(a.address_3, ' '),
                nvl(a.address_4, ' '),
                nvl(a.address_5, ' '),
                nvl(a.address_6, ' ')
    ))                               as mailing_address_street
  , a.city::varchar(200)             as mailing_address_city
  , a.state::varchar(200)            as mailing_address_state
  , a.zip_code::varchar(12)          as mailing_address_zip
  , null::varchar(200)               as mailing_address_country
  , null::varchar(200)               as legal_address_street
  , null::varchar(200)               as legal_address_city
  , null::varchar(200)               as legal_address_state
  , null::varchar(12)                as legal_address_zip
  , null::varchar(200)               as legal_address_country
  , {{ col_is_head(reference=ref('tda__int_accounts'), source_date_col='a.effective_date') }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._created_at::timestamp         as _created_at
  , a._source_loaded_at::timestamp   as _source_loaded_at
  , a._source_file                   as _source_file
from {{ ref('tda__int_accounts') }} a
where true
  and a.rep_code_firm = 'swag'
  and a.is_active = 1
