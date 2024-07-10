select
    a.effective_date
    , 'tda'                          as custodian
    , 'mwa'::varchar(50)             as firm
    , 'mwa'::varchar(50)             as firm_source
    , a.account_number               as account_number
    , a.account_number               as account_number_formatted

    , null::varchar(50)              as custodian_link
    , null::varchar(50)              as custodian_link_detail
    , a.advisor_id                   as rep_link
    , 'rep_code'                     as rep_link_detail
    , null::varchar(100)             as account_type-- (ira rollover, etc)
    , null::varchar(100)             as account_type_source_definition
    , a.account_type::varchar(100)   as account_type_source_code
    , null::date                     as opened_date

    , a.account_type::varchar(100)   as account_title
    , a.first_name::varchar(100)     as first_name
    , null::varchar(100)             as middle_name-- not provided
    , a.last_name::varchar(100)      as last_name

    , a.ssn::varchar(20)             as irs_id
    , case
        when left(a.ssn , 1) = '9'
            then 'tin'
        else 'ssn'
    end::varchar(100)                as irs_id_type
    , a.birth_date::date             as birth_date

    , null::varchar(75)              as email_address
    , a.phone_number::varchar(20)    as phone
    , null::varchar(50)              as cost_basis_method_mutual_funds-- not available
    , null::varchar(50)              as cost_basis_method_non_mutual_funds-- not available
    , case
        when coalesce(a.taxable , 'N') = 'Y'
            then 1
        else 0
    end::int                         as is_taxable
    , null::int                      as is_fee_authorized
    , null::int                      as is_prime_broker
    , null::int                      as is_margin_enabled
    , null::varchar(200)             as options_approval_level
    , null::varchar(100)             as restrictions_source_code
    , null::int                      as is_multiple_margin_enabled
    , null::varchar(100)             as restrictions_source_defintion
    , null::varchar(100)             as restrictions
    , trim(concat(
        coalesce(a.street , '')
        , coalesce(a.address_2 , ' ')
        , coalesce(a.address_3 , ' ')
        , coalesce(a.address_4 , ' ')
        , coalesce(a.address_5 , ' ')
        , coalesce(a.address_6 , ' ')
    ))                               as mailing_address_street
    , a.city::varchar(200)           as mailing_address_city
    , a.state::varchar(200)          as mailing_address_state
    , a.zip_code::varchar(12)        as mailing_address_zip
    , null::varchar(200)             as mailing_address_country
    , null::varchar(200)             as legal_address_street
    , null::varchar(200)             as legal_address_city
    , null::varchar(200)             as legal_address_state
    , null::varchar(12)              as legal_address_zip
    , null::varchar(200)             as legal_address_country
    , {{ col_is_head(reference=ref('tda__int_accounts'), source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._created_at::timestamp       as _created_at
    , a._source_loaded_at::timestamp as _source_loaded_at
    , a._source_file                 as _source_file
from {{ ref('tda__int_accounts') }} as a
where true
    and a.rep_code_firm = 'mwa'
    and a.is_active = 1
