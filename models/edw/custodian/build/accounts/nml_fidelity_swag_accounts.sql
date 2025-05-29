select
    a.effective_date::date                               as effective_date
    , a.custodian::varchar(500)                          as custodian
    , cf.firm                                            as firm
    , a.firm_source::varchar(500)                        as firm_source
    , a.account_number::varchar(500)                     as account_number
    , a.account_number_formatted::varchar(500)           as account_number_formatted

    , a.custodian_link::varchar(500)                     as custodian_link-- branch/firm/gnumber? primary g number but how?
    , a.custodian_link_detail::varchar(500)              as custodian_link_detail
    , null::varchar(500)                                 as rep_link
    , null::varchar(500)                                 as rep_link_detail
    , ar.normalized::varchar(500)                        as account_type-- (ira rollover, etc)
    , ar.definition::varchar(500)                        as account_type_source_definition
    , a.account_type_source_code::varchar(500)           as account_type_source_code
    , a.opened_date::date                                as opened_date

    , a.account_title::varchar(500)                      as account_title
    , a.first_name::varchar(500)                         as first_name
    , a.middle_name::varchar(500)                        as middle_name
    , a.last_name::varchar(500)                          as last_name

    , a.irs_id::varchar(500)                             as irs_id
    , a.irs_id_type::varchar(500)                        as irs_id_type
    , a.birth_date::date                                 as birth_date

    , a.email_address::varchar(500)                      as email_address
    , a.phone::varchar(500)                              as phone
    , a.cost_basis_method_mutual_funds::varchar(500)     as cost_basis_method_mutual_funds
    , a.cost_basis_method_non_mutual_funds::varchar(500) as cost_basis_method_non_mutual_funds
    , a.is_taxable::int                                  as is_taxable
    , a.is_fee_authorized::int                           as is_fee_authorized
    , a.is_prime_broker::int                             as is_prime_broker
    , a.is_margin_enabled::int                           as is_margin_enabled
    , a.options_approval_level::varchar(500)             as options_approval_level
    , a.restrictions_source_code::varchar(500)           as restrictions_source_code
    , a.is_multiple_margin_enabled::int                  as is_multiple_margin_enabled
    , r.definition::varchar(500)                         as restrictions_source_definition
    , r.normalized::varchar(500)                         as restrictions

    , a.mailing_address_street::varchar(500)             as mailing_address_street
    , a.mailing_address_city::varchar(500)               as mailing_address_city
    , a.mailing_address_state::varchar(500)              as mailing_address_state
    , a.mailing_address_zip::varchar(500)                as mailing_address_zip
    , a.mailing_address_country::varchar(500)            as mailing_address_country
    , a.legal_address_street::varchar(500)               as legal_address_street
    , a.legal_address_city::varchar(500)                 as legal_address_city
    , a.legal_address_state::varchar(500)                as legal_address_state
    , a.legal_address_zip::varchar(500)                  as legal_address_zip
    , a.legal_address_country::varchar(500)              as legal_address_country
    , {{ col_is_head(
        reference=ref('int_fidelity_swag_accounts'),
        source_date_col='a.effective_date'
        ) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._created_at::timestamp                           as _created_at
    , a._source_loaded_at::timestamp                     as _source_loaded_at
    , a._source_file                                     as _source_file
from {{ ref('int_fidelity_swag_accounts') }} as a
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
