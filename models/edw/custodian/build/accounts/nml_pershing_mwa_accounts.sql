select
    a.effective_date::date                              as effective_date
    , a.custodian::varchar(500)                         as custodian
    , cf.firm                                           as firm
    , a.firm_source::varchar(500)                       as firm_source
    , a.account_number::varchar(500)                    as account_number
    , a.account_number::varchar(500)                    as account_number_formatted

    , null::varchar(500)                                as custodian_link
    , null::varchar(500)                                as custodian_link_detail
    , a.investment_professional_ip_number::varchar(500) as rep_link
    , 'ip_number'::varchar(500)                         as rep_link_detail
    , ar.normalized::varchar(500)                       as account_type-- (ira rollover, etc)
    , ar.definition::varchar(500)                       as account_type_source_definition
    , a.registration_type::varchar(500)                 as account_type_source_code

    , a.date_account_opened::date                       as opened_date
    , a.account_title::varchar(500)                     as account_title
    , a.first_name::varchar(500)                        as first_name
    , a.middle_name::varchar(500)                       as middle_name
    , a.last_name::varchar(500)                         as last_name

    , replace(a.tax_id_number , '-' , '')::varchar(20)  as irs_id
    , case
        when a.tax_id_type = 'S'
            then 'ssn'
        when a.tax_id_type = 'T'
            then 'tin'
    end::varchar(500)                                   as irs_id_type
    , a.birth_date::date                                as birth_date-- not provided

    , a.email_address_1::varchar(500)                   as email_address
    , a.telephone_number_1::varchar(20)                 as phone
    , null::varchar(500)                                as cost_basis_method_mutual_funds-- needs normalization
    , null::varchar(500)                                as cost_basis_method_non_mutual_funds-- needs normalization
    , case
        when coalesce(a.tax_status , '') = 'B'
            then 0
        else 1
    end::int                                            as is_taxable
    , null::int                                         as is_fee_authorized
    , case
        when coalesce(a.prime_brokerfree_fund_indicator , '') = 'B'
            then 1
        else 0
    end::int                                            as is_prime_broker
    , null::int                                         as is_margin_enabled
    , null::varchar(500)                                as options_approval_level
    , null::varchar(500)                                as restrictions_source_code
    , null::int                                         as is_multiple_margin_enabled
    , null::varchar(500)                                as restrictions_source_definition
    , null::varchar(500)                                as restrictions
    , a.mailing_address_street::varchar(500)            as mailing_address_street
    , a.mailing_address_city::varchar(500)              as mailing_address_city
    , a.mailing_address_state::varchar(500)             as mailing_address_state
    , a.mailing_address_zip::varchar(12)                as mailing_address_zip
    , a.mailing_address_country::varchar(500)           as mailing_address_country
    , a.legal_address_street::varchar(500)              as legal_address_street
    , a.legal_address_city::varchar(500)                as legal_address_city
    , a.legal_address_state::varchar(500)               as legal_address_state
    , a.legal_address_zip::varchar(12)                  as legal_address_zip
    , a.legal_address_country::varchar(500)             as legal_address_country
    , a._source_loaded_at::timestamp                    as _created_at
    , a._source_loaded_at::timestamp                    as _source_loaded_at
    , a._source_file                                    as _source_file
from {{ ref('int_pershing_mwa_accounts') }} as a
left join {{ ref('custodian_firms') }} as cf
    on a.firm_source = cf.firm_source
left join {{ ref('custodian_mappings') }} as ar
    on ar.custodian = 'pershing'
    and ar.field = 'account_registration'
    and a.registration_type = ar.source
where true
    and a.account_status_indicator <> 'C'
