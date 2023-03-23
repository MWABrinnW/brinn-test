select
    a.effective_date::date                                         as effective_date
  , a.custodian::varchar(50)                                       as custodian
  , cf.firm                                                        as firm
  , a.firm_source::varchar(50)                                     as firm_source
  , a.account_number::varchar(50)                                  as account_number
  , a.account_number::varchar(50)                                  as account_number_formatted

  , null::varchar(50)                                              as custodian_link
  , null::varchar(50)                                              as custodian_link_detail
  , a.investment_professional_ip_number::varchar(50)               as rep_link
  , 'ip number'::varchar(50)                                       as rep_link_detail
  , a.registration_type::varchar(50)                               as account_type_source_code
  , ar.definition::varchar(50)                                     as account_type_source_definition
  , ar.normalized::varchar(50)                                     as account_type -- (ira rollover, etc)

  , a.date_account_opened::date                                    as opened_date
  , a.account_title::varchar(200)                                  as account_title
  , a.first_name::varchar(200)                                     as first_name
  , a.middle_name::varchar(200)                                    as middle_name
  , a.last_name::varchar(200)                                      as last_name

  , replace(a.tax_id_number, '-', '')::varchar(20)                 as irs_id
  , case
        when a.tax_id_type = 'S'
            then 'ssn'
        when a.tax_id_type = 'T'
            then 'tin'
        else null
        end::varchar(10)                                           as irs_id_type
  , a.birth_date::date                                             as birth_date -- not provided

  , a.email_address_1::varchar(75)                                 as email_address
  , a.telephone_number_1::varchar(20)                              as phone
  , null::varchar(50)                                              as cost_basis_method_mutual_funds -- needs normalization
  , null::varchar(50)                                              as cost_basis_method_non_mutual_funds -- needs normalization
  , case
        when nvl(a.tax_status,'') = 'B'
            then 0
        else 1
        end::int                                                   as is_taxable
  , null::int                                                      as is_fee_authorized
  , case
        when nvl(a.prime_brokerfree_fund_indicator, '') = 'B'
            then 1
        else 0
        end::int                                                   as is_prime_broker
  , null::varchar(200)                                             as restrictions_source_code
  , null::varchar(200)                                             as restrictions_source_definition
  , null::varchar(200)                                             as restrictions
  , a.mailing_address_street::varchar(200)                         as mailing_address_street
  , a.mailing_address_city::varchar(75)                            as mailing_address_city
  , a.mailing_address_state::varchar(50)                           as mailing_address_state
  , a.mailing_address_zip::varchar(12)                             as mailing_address_zip
  , a.mailing_address_country::varchar(50)                         as mailing_address_country
  , legal_address_street::varchar(200)                             as legal_address_street
  , legal_address_city::varchar(75)                                as legal_address_city
  , legal_address_state::varchar(50)                               as legal_address_state
  , legal_address_zip::varchar(12)                                 as legal_address_zip
  , legal_address_country::varchar(50)                             as legal_address_country
  , a.is_head::int                                                 as is_head
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at::timestamp                                 as _source_loaded_at
  , a._source_loaded_at::timestamp                                 as _created_at
from {{ ref('int_pershing_mwa_accounts') }} a
left join {{ ref('custodian_firms') }} cf
    on a.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }}           ar
    on ar.custodian = 'pershing'
    and ar.field = 'account_registration'
    and a.registration_type = ar.source
where true
    and a.account_status_indicator <> 'C'