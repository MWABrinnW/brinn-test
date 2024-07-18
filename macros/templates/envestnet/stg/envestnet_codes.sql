{%- macro envestnet_codes_security_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(4) AS security_type_code
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS security_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Security Type'
{%- endmacro -%}

{%- macro envestnet_codes_style_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(25) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS style_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS style_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Style Type'
{%- endmacro -%}

{%- macro envestnet_codes_transaction_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS transaction_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS transaction_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Transaction Type'
{%- endmacro -%}

{%- macro envestnet_codes_transaction_mapping(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS mapping_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS custodian_name
    , nullif(split_part(content, '|', 4), '')::varchar(50) AS book_keeping_code
    , nullif(split_part(content, '|', 5), '')::varchar(50) AS transaction_mapping_type
    , nullif(split_part(content, '|', 6), '')::varchar(50) AS transaction_mapping_code
    , nullif(split_part(content, '|', 7), '')::varchar(100) AS transaction_mapping_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Transaction Mapping'
{%- endmacro -%}

{%- macro envestnet_codes_service_request_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS service_request_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS service_request_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Service Request Type'
{%- endmacro -%}

{%- macro envestnet_codes_instruction_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS instruction_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS instruction_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Instruction Type'
{%- endmacro -%}

{%- macro envestnet_codes_registration_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS registration_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS registration_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Registration Type'
{%- endmacro -%}

{%- macro envestnet_codes_ssn_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS ssn_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS ssn_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'SSN Type'
{%- endmacro -%}

{%- macro envestnet_codes_product_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS product_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS product_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product Type'
{%- endmacro -%}

{%- macro envestnet_codes_product_name(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS product_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS product_name_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product Name'
{%- endmacro -%}

{%- macro envestnet_codes_fund_family(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS fund_family_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS fund_family_name
    , nullif(split_part(content, '|', 4), '')::int AS entity_type
    , nullif(split_part(content, '|', 5), '')::varchar(4) AS nscc_code
    , nullif(split_part(content, '|', 6), '')::varchar(10) AS mstar_dtcc_code
    , nullif(split_part(content, '|', 7), '')::varchar(10) AS dst_code
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Fund Family'
{%- endmacro -%}

{%- macro envestnet_codes_commission_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS commission_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS commission_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Commission Type'
{%- endmacro -%}

{%- macro envestnet_codes_contact_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS contact_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS contact_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Contact Type'
{%- endmacro -%}

{%- macro envestnet_codes_annual_income(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS annual_income_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS annual_income_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Annual Income'
{%- endmacro -%}

{%- macro envestnet_codes_estimated_net_worth(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS estimated_net_worth_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS estimated_net_worth_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Estimated Net Worth'
{%- endmacro -%}

{%- macro envestnet_codes_investable_assets(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS investable_assets_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS investable_assets_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Investable Assets'
{%- endmacro -%}

{%- macro envestnet_codes_tax_bracket(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS tax_bracket_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS tax_bracket_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Tax Bracket'
{%- endmacro -%}

{%- macro envestnet_codes_investment_objective_rank(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS investment_objective_rank_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS investment_objective_rank_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Investment Objective Rank'
{%- endmacro -%}

{%- macro envestnet_codes_suitability_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::char(1) AS suitability_status_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS suitability_status_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Suitability Status'
{%- endmacro -%}

{%- macro envestnet_codes_risk_tolerance(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::char(1) AS risk_tolerance_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS risk_tolerance_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Risk Tolerance'
{%- endmacro -%}

{%- macro envestnet_codes_time_horizon(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::char(1) AS time_horizon_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS time_horizon_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Time Horizon'
{%- endmacro -%}

{%- macro envestnet_codes_investment_knowledge(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::char(1) AS investment_knowledge_type
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS investment_knowledge_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Investment Knowledge'
{%- endmacro -%}

{%- macro envestnet_codes_tax_efficiency(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS tax_efficiency_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS tax_efficiency_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Tax Efficiency'
{%- endmacro -%}

{%- macro envestnet_codes_product_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS status_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS product_status_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product Status'
{%- endmacro -%}

{%- macro envestnet_codes_product_imr_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS imr_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS product_imr_status_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product IMR Status'
{%- endmacro -%}

{%- macro envestnet_codes_risk_scale(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS risk_scale_min_point
    , nullif(split_part(content, '|', 3), '')::int AS risk_scale_max_point
    , nullif(split_part(content, '|', 4), '')::varchar(128) AS risk_scale_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Risk Scale'
{%- endmacro -%}

{%- macro envestnet_codes_billing_debit_method(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS billing_debit_method_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS billing_debit_method_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Billing Debit Method'
{%- endmacro -%}

{%- macro envestnet_codes_account_history_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS history_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS account_history_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Account History Type'
{%- endmacro -%}

{%- macro envestnet_codes_fee_component_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS fee_component_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS fee_component_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Fee Component Type'
{%- endmacro -%}

{%- macro envestnet_codes_billing_mode(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS billing_mode_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS billing_mode_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Billing Mode'
{%- endmacro -%}

{%- macro envestnet_codes_asset_calculation_method(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS calculation_method_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS asset_calculation_method_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Asset Calculation Method'
{%- endmacro -%}

{%- macro envestnet_codes_fee_filter_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS fee_filter_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS fee_filter_type
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Fee Filter Type'
{%- endmacro -%}

{%- macro envestnet_codes_asset_category(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS fee_filter_type_id
    , nullif(split_part(content, '|', 3), '')::int AS billing_mode_id
    , nullif(split_part(content, '|', 4), '')::varchar(128) AS asset_category_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Asset Category'
{%- endmacro -%}

{%- macro envestnet_codes_account_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS account_status
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS account_status_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Account Status'
{%- endmacro -%}

{%- macro envestnet_codes_trade_exchange(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS trade_exchange_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS trade_exchange_name
    , nullif(split_part(content, '|', 4), '')::varchar(128) AS trade_exchange_description
    , nullif(split_part(content, '|', 5), '')::varchar(10) AS exchange_region
    , nullif(split_part(content, '|', 6), '')::CHAR(4) AS exchange_mic_code
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Trade Exchange'
{%- endmacro -%}

{%- macro envestnet_codes_sector(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(2) AS sector_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS sector
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Sector'
{%- endmacro -%}

{%- macro envestnet_codes_gics_sector(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(3) AS gics_sector_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS gics_sector
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'GICS Sector'
{%- endmacro -%}

{%- macro envestnet_codes_sp_rating(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(2) AS sp_rating_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS sp_rating
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'S&P Rating'
{%- endmacro -%}

{%- macro envestnet_codes_moody_rating(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(2) AS moody_rating_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS moody_rating
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Moody Rating'
{%- endmacro -%}

{%- macro envestnet_codes_country(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS country_id
    , nullif(split_part(content, '|', 3), '')::varchar(150) AS country_name
    , nullif(split_part(content, '|', 4), '')::varchar(50) AS country_abbreviation
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Country'
{%- endmacro -%}

{%- macro envestnet_codes_employment_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS employment_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS employment_status
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Employment Status'
{%- endmacro -%}

{%- macro envestnet_codes_marital_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS marital_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS marital_status
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Marital Status'
{%- endmacro -%}

{%- macro envestnet_codes_relationship(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS relationship_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS relationship
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Relationship'
{%- endmacro -%}

{%- macro envestnet_codes_salutation(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS salutation_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS salutation
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Salutation'
{%- endmacro -%}

{%- macro envestnet_codes_currency(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS currency_id
    , nullif(split_part(content, '|', 3), '')::varchar(3) AS currency_code
    , nullif(split_part(content, '|', 4), '')::varchar(50) AS currency_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Currency'
{%- endmacro -%}

{%- macro envestnet_codes_authorized_programs(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS program_id
    , nullif(split_part(content, '|', 3), '')::varchar(250) AS program_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Authorized Programs'
{%- endmacro -%}

{%- macro envestnet_codes_product_class(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS product_class_id
    , nullif(split_part(content, '|', 3), '')::varchar(250) AS product_class_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product Class'
{%- endmacro -%}

{%- macro envestnet_codes_sale_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS sale_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS sale_type
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Sale Type'
{%- endmacro -%}

{%- macro envestnet_codes_proposal_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS proposal_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS proposal_status
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Proposal Status'
{%- endmacro -%}

{%- macro envestnet_codes_address_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS address_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS address_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Address Type'
{%- endmacro -%}

{%- macro envestnet_codes_dashboard_product_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS dashboard_product_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS dashboard_product_type
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Dashboard Product Type'
{%- endmacro -%}

{%- macro envestnet_codes_alert_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS alert_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS alert_type
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Alert Type'
{%- endmacro -%}

{%- macro envestnet_codes_ensemble(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS ensemble_id
    , nullif(split_part(content, '|', 3), '')::varchar(16) AS ensemble_code
    , nullif(split_part(content, '|', 4), '')::varchar(256) AS ensemble_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Ensemble'
{%- endmacro -%}

{%- macro envestnet_codes_account_pricing_tier(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS pricing_tier_id
    , nullif(split_part(content, '|', 3), '')::varchar(512) AS pricing_tier_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Account Pricing Tier'
{%- endmacro -%}

{%- macro envestnet_codes_aum_method(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS aum_method_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS aum_method_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'AUM Method'
{%- endmacro -%}

{%- macro envestnet_codes_fee_paid_by(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS fee_paid_by_id
    , nullif(split_part(content, '|', 3), '')::varchar(256) AS fee_paid_by_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Fee Paid By'
{%- endmacro -%}

{%- macro envestnet_codes_industry(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS industry_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(256) AS industry_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Industry'
{%- endmacro -%}

{%- macro envestnet_codes_client_activity(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS client_activity_id
    , nullif(split_part(content, '|', 3), '')::varchar(256) AS client_activity_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Client Activity'
{%- endmacro -%}

{%- macro envestnet_codes_restriction_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS restriction_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(256) AS restriction_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Restriction Type'
{%- endmacro -%}

{%- macro envestnet_codes_program_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS program_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(256) AS program_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Program Type'
{%- endmacro -%}

{%- macro envestnet_codes_advisor_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS advisor_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS advisor_status_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Advisor Status'
{%- endmacro -%}

{%- macro envestnet_codes_owner_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS owner_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS owner_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Owner Type'
{%- endmacro -%}

{%- macro envestnet_codes_custodians(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS custodian_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS custodian_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Custodians'
{%- endmacro -%}

{%- macro envestnet_codes_trading_platforms(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS trading_platform_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS trading_platform_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Trading Platforms'
{%- endmacro -%}

{%- macro envestnet_codes_external_trading_platforms(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS external_trading_platform_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS external_trading_platform_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'External Trading Platforms'
{%- endmacro -%}

{%- macro envestnet_codes_contract_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::varchar(100) AS contract_type
    , nullif(split_part(content, '|', 3), '')::varchar(100) AS contract_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Contract Type'
{%- endmacro -%}

{%- macro envestnet_codes_liability_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS liability_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS liability_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Liability Type'
{%- endmacro -%}

{%- macro envestnet_codes_billing_frequency(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS billing_frequency_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS billing_frequency_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Billing Frequency'
{%- endmacro -%}

{%- macro envestnet_codes_change_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS change_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS change_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Change Type'
{%- endmacro -%}

{%- macro envestnet_codes_reorg_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS reorg_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS reorg_type_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Reorg Type'
{%- endmacro -%}

{%- macro envestnet_codes_product_overlay_feature(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS product_overlay_feature_id
    , nullif(split_part(content, '|', 3), '')::varchar(128) AS product_overlay_feature_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Product Overlay Feature'
{%- endmacro -%}

{%- macro envestnet_codes_programs(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS program_id
    , nullif(split_part(content, '|', 3), '')::varchar(250) AS program_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Programs'
{%- endmacro -%}

{%- macro envestnet_codes_license_registration_info(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS license_registration_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(15) AS license_registration_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'License Registration Info'
{%- endmacro -%}

{%- macro envestnet_codes_external_service(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS service_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS service_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'External Service'
{%- endmacro -%}

{%- macro envestnet_codes_index_type(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS index_type_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS index_type_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Index Type'
{%- endmacro -%}

{%- macro envestnet_codes_index_scope(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS index_scope_id
    , nullif(split_part(content, '|', 3), '')::varchar(50) AS index_scope_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Index Scope'
{%- endmacro -%}

{%- macro envestnet_codes_gics_industry_group(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS gics_industry_group_id
    , nullif(split_part(content, '|', 3), '')::varchar(70) AS gics_industry_group_name
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'GICS Industry Group'
{%- endmacro -%}

{%- macro envestnet_codes_credit_card_account_status(src) -%}
SELECT
    nullif(split_part(content, '|', 1), '')::varchar(50) AS record_type
    , nullif(split_part(content, '|', 2), '')::int AS account_status_id
    , nullif(split_part(content, '|', 3), '')::varchar(20) AS account_status_description
    , effective_date                                             as effective_date
from {{ source('envestnet_' + src, 'codes') }}
where split_part(content, '|', 1) = 'Credit Card Account Status'
{%- endmacro -%}
