
select
    a.effective_date
  , a.custodian
  , a.firm
  , a.account_number                                           as account_number
  , a.account_number_formatted                                 as account_number_formatted

  , a.custodian_link -- branch/firm/gnumber? primary g number but how?
  , a.custodian_link_detail
  , a.account_type_source_code
  , ar.definition                                              as account_type_source_definition
  , ar.normalized                                              as account_type -- (ira rollover, etc)
  , a.opened_date

  , a.account_title
  , a.first_name
  , a.middle_name
  , a.last_name

  , a.irs_id
  , a.irs_id_type
  , a.birth_date

  , a.email_address
  , a.phone
  , a.cost_basis_method_mutual_funds
  , a.cost_basis_method_non_mutual_funds
  , a.is_taxable
  , a.is_fee_authorized
  , a.is_prime_broker
  , a.restrictions_source_code
  , r.definition                                               as restrctions_source_defintion
  , r.normalized                                               as restrictions

  , a.mailing_address_street::varchar(100)  as mailing_address_street
  , a.mailing_address_city::varchar(100)    as mailing_address_city
  , a.mailing_address_state::varchar(100)   as mailing_address_state
  , a.mailing_address_zip::varchar(100)     as mailing_address_zip
  , a.mailing_address_country::varchar(100) as mailing_address_country
  , a.legal_address_street::varchar(100)    as legal_address_street
  , a.legal_address_city::varchar(100)      as legal_address_city
  , a.legal_address_state::varchar(100)     as legal_address_state
  , a.legal_address_zip::varchar(100)       as legal_address_zip
  , a.legal_address_country::varchar(100)   as legal_address_country
  , a.is_head
  , a.is_current
  , a._source_loaded_at
  , a._created_at
from {{ ref('int_fidelity_mps_accounts') }} a
left join {{ ref('custodian_mappings') }} r
    on r.custodian = 'fidelity'
    and r.field = 'restriction'
    and a.restrictions_source_code = r.source
left join {{ ref('custodian_mappings') }} ar
    on ar.custodian = 'fidelity'
    and ar.field = 'account_registration'
    and a.account_type_source_code = ar.source
