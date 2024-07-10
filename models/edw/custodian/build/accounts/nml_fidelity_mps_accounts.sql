select
    a.effective_date::date                              as effective_date
    , a.custodian::varchar(50)                          as custodian
    , cf.firm                                           as firm
    , a.firm_source::varchar(50)                        as firm_source
    , a.account_number::varchar(50)                     as account_number
    , a.account_number_formatted::varchar(50)           as account_number_formatted

    , a.custodian_link::varchar(50)                     as custodian_link-- branch/firm/gnumber? primary g number but how?
    , a.custodian_link_detail::varchar(50)              as custodian_link_detail
    , null::varchar(50)                                 as rep_link
    , null::varchar(50)                                 as rep_link_detail
    , ar.normalized::varchar(50)                        as account_type-- (ira rollover, etc)
    , ar.definition::varchar(50)                        as account_type_source_definition
    , a.account_type_source_code::varchar(50)           as account_type_source_code
    , a.opened_date::date                               as opened_date

    , a.account_title::varchar(200)                     as account_title
    , a.first_name::varchar(200)                        as first_name
    , a.middle_name::varchar(200)                       as middle_name
    , a.last_name::varchar(200)                         as last_name

    , a.irs_id::varchar(10)
    , a.irs_id_type::varchar(75)
    , a.birth_date::date                                as birth_date

    , a.email_address::varchar(75)                      as email_address
    , a.phone::varchar(50)                              as phone
    , a.cost_basis_method_mutual_funds::varchar(50)     as cost_basis_method_mutual_funds
    , a.cost_basis_method_non_mutual_funds::varchar(50) as cost_basis_method_non_mutual_funds
    , a.is_taxable::int                                 as is_taxable
    , a.is_fee_authorized::int                          as is_fee_authorized
    , a.is_prime_broker::int                            as is_prime_broker
    , a.is_margin_enabled::int                          as is_margin_enabled
    , a.options_approval_level::varchar(200)            as options_approval_level
    , a.restrictions_source_code::varchar(200)          as restrictions_source_code
    , a.is_multiple_margin_enabled::int                 as is_multiple_margin_enabled
    , r.definition::varchar(200)                        as restrctions_source_defintion
    , r.normalized::varchar(200)                        as restrictions

    , a.mailing_address_street::varchar(200)            as mailing_address_street
    , a.mailing_address_city::varchar(200)              as mailing_address_city
    , a.mailing_address_state::varchar(200)             as mailing_address_state
    , a.mailing_address_zip::varchar(200)               as mailing_address_zip
    , a.mailing_address_country::varchar(200)           as mailing_address_country
    , a.legal_address_street::varchar(200)              as legal_address_street
    , a.legal_address_city::varchar(200)                as legal_address_city
    , a.legal_address_state::varchar(200)               as legal_address_state
    , a.legal_address_zip::varchar(200)                 as legal_address_zip
    , a.legal_address_country::varchar(200)             as legal_address_country
    , a.is_head::int                                    as is_head
    , a.is_current::int                                 as is_current
    , a._created_at::timestamp                          as _created_at
    , a._source_loaded_at::timestamp                    as _source_loaded_at
    , a._source_file                                    as _source_file
from {{ ref('int_fidelity_mps_accounts') }} as a
left join {{ ref('custodian_firms') }} as cf
    on a.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as r
    on r.custodian = 'fidelity'
    and r.field = 'restriction'
    and a.restrictions_source_code = r.source
left join {{ ref('custodian_mappings') }} as ar
    on ar.custodian = 'fidelity'
    and ar.field = 'account_registration'
    and a.account_type_source_code = ar.source
