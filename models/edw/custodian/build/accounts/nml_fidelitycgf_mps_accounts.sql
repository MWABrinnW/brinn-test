select
    a.effective_date       as effective_date
    , a.custodian          as custodian
    , cf.firm              as firm
    , a.firm_source        as firm_source
    , a.cgf_account_number as account_number
    , a.cgf_account_number as account_number_formatted
    , a.g_number           as custodian_link-- branch/firm/gnumber? primary g number but how?
    , 'g_number'           as custodian_link_detail
    , null::varchar(50)    as rep_link
    , null::varchar(50)    as rep_link_detail
    , null::varchar(50)    as account_type
    , null::varchar(50)    as account_type_source_definition
    , null                 as account_type_source_code--account_classification or account_type
    , null::date           as opened_date
    , null::varchar(200)   as account_title
    , a.first_name         as first_name
    , a.middle_name        as middle_name
    , a.last_name          as last_name
    , null::varchar(20)    as irs_id
    , null::varchar(10)    as irs_id_type
    , a.date_of_birth      as birth_date
    , null::varchar(75)    as email_address
    , null::varchar(20)    as phone
    , null::varchar(50)    as cost_basis_method_mutual_funds
    , null::varchar(50)    as cost_basis_method_non_mutual_funds
    , null::int            as is_taxable
    , null::int            as is_fee_authorized
    , null::int            as is_prime_broker
    , null::int            as is_margin_enabled
    , null::varchar(200)   as options_approval_level
    , null::varchar(75)    as restrictions_source_code
    , null::int            as is_multiple_margin_enabled
    , null::varchar(75)    as restrictions_source_definition
    , null::varchar(75)    as restrictions
    , case
        when a.address_line_3 is not null then concat_ws(', ' , a.address_line_1 , a.address_line_2 , a.address_line_3)
        when a.address_line_2 is not null then concat_ws(', ' , a.address_line_1 , a.address_line_2)
        when a.address_line_1 is not null then a.address_line_1
    end                    as mailing_address_street
    , a.city               as mailing_address_city
    , a.state              as mailing_address_state
    , a.zip                as mailing_address_zip
    , null                 as mailing_address_country
    , case
        when a.address_line_3 is not null then concat_ws(', ' , a.address_line_1 , a.address_line_2 , a.address_line_3)
        when a.address_line_2 is not null then concat_ws(', ' , a.address_line_1 , a.address_line_2)
        when a.address_line_1 is not null then a.address_line_1
    end                    as legal_address_street
    , a.city               as legal_address_city
    , a.state              as legal_address_state
    , a.zip                as legal_address_zip
    , null                 as legal_address_country
    , {{ col_is_head(reference=ref('fidelity_mps_history__vw_cgf_acct'), source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , a._source_loaded_at  as _created_at
    , a._source_loaded_at  as _source_loaded_at
    , a._source_file       as _source_file
from {{ ref('fidelity_mps_history__vw_cgf_acct') }} as a
left join {{ ref('custodian_firms') }} as cf
    on a.firm_source = cf.firm_source
where true
