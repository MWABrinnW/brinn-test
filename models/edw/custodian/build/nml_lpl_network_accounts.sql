select
    a.effective_date::date                          as effective_date
  , 'lpl'::varchar(50)                              as custodian
  , cf.firm                                         as firm
  , a.firm_source                                   as firm_source
  , a.lpl_account_no::varchar(50)                   as account_number
  , a.lpl_account_no::varchar(50)                   as account_number_formatted
  , a.subscriber_id::varchar(50)                    as custodian_link
  , 'subscriber id'::varchar(50)                    as custodian_link_detail
  , a.rep_id::varchar(50)                           as rep_link
  , 'rep id'::varchar(50)                           as rep_link_detail
  , a.institution_type::varchar(75)                 as account_type_source_code
  , ar.definition::varchar(100)                     as account_type_source_definition
  , ar.normalized::varchar(100)                     as account_type
  , a.open_date::date                               as opened_date
  , a.account_name::varchar(100)                    as account_title
  , c.first_name::varchar(100)                      as first_name
  , c.middle_name::varchar(100)                     as middle_name
  , c.last_name::varchar(100)                       as last_name
  , replace(a.client_ssn_tin, '-', '')::varchar(20) as irs_id
  , case
        when left(c.ssn_tin, 1) = '9'
            then 'tin'
        when c.is_ssn = 1
            then 'ssn'
        else
            'other'
        end                                         as irs_id_type
  , c.birth_date::date                              as birth_date
  , a.email_address::varchar(75)                    as email_address
  , replace(a.home_phone_no, '-', '')::varchar(20)  as phone
  , null::varchar(50)                               as cost_basis_method_mutual_funds
  , null::varchar(50)                               as cost_basis_method_non_mutual_funds
  , null::int                                       as is_taxable
  , null::int                                       as is_fee_authorized
  , null::int                                       as is_prime_broker
  , null::varchar(100)                              as restrictions_source_code
  , null::varchar(100)                              as restrictions_source_definition
  , null::varchar(100)                              as restrictions
  , trim(concat(nvl(c.address_1, ''),
                nvl(c.address_2, ' '),
                nvl(c.address_3, ' ')))             as mailing_address_street
  , c.city                                          as mailing_address_city
  , c.state                                         as mailing_address_state
  , c.zip_code                                      as mailing_address_zip
  , case
        when c.is_foreign = 0
            then 'US'
        else null end                               as mailing_address_country
  , null::varchar(100)                              as legal_address_street
  , null::varchar(100)                              as legal_address_city
  , null::varchar(100)                              as legal_address_state
  , null::varchar(100)                              as legal_address_zip
  , null::varchar(100)                              as legal_address_country
  , a.is_head::int                                  as is_head
  , a.is_current::int                               as is_current
  , a._source_loaded_at::timestamp                  as _source_loaded_at
  , a._source_loaded_at::timestamp                  as _created_at
from {{ ref('lpl_network__base_accounts') }}     a
    -- left join lpl_network__base_account_participants ap
--           on a.account_id = ap.account_id
--               and a.effective_date = ap.effective_date
--               and ap.account_role = 'Primary Customer'
left join {{ ref('custodian_firms') }} cf
    on a.firm_source = cf.firm_source
left join {{ ref('lpl_network__base_clients') }} c
    on a.client_id = c.client_id
    and a.effective_date = c.effective_date
left join {{ ref('custodian_mappings') }} ar
    on ar.custodian = 'lpl'
    and ar.field = 'account_registration'
    and a.institution_type = ar.source
where true
