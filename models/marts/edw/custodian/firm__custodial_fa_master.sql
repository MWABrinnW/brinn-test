select
    effective_date
    ,custodian
    ,firm
    ,account_number
    ,account_number_formatted
    ,custodian_link
    ,custodian_link_detail
    ,account_type_source_code
    ,account_type_source_definition
    ,account_type
    ,opened_date
    ,account_title
    ,first_name
    ,middle_name
    ,last_name
    ,irs_id
    ,irs_id_type
    ,birth_date
    ,email_address
    ,phone
    ,cost_basis_method_mutual_funds
    ,cost_basis_method_non_mutual_funds
    ,is_taxable
    ,is_fee_authorized
    ,is_prime_broker
    ,restrictions_source_code
    ,restrictions_source_definition
    ,restrictions
    ,mailing_address_street
    ,mailing_address_city
    ,mailing_address_state
    ,mailing_address_zip
    ,legal_address_street
    ,legal_address_city
    ,legal_address_state
    ,legal_address_zip
    ,legal_address_country
    ,{{ col_is_head(reference=ref('build__int_custodial_fa_master'), reference_date_col='effective_date', source_date_col='effective_date') }}
    ,{{ col_is_current(date_col='effective_date') }}
    ,_created_at
from {{ ref('build__int_custodial_fa_master') }}
where true
    and custodian <> 'tda'