{%- macro accf_5_customer_due_diligence_cdd_information_optional(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, case
  when effective_date < '2023-10-01'
    then trim(nullif(substring(content, 25, 3), '000'))
  else trim(nullif(substring(content, 25, 4), '0000'))
  end::varchar(4) as investment_professional_ip_number
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as record_transaction_code
, try_to_date(nullif(substring(content, 42, 8), '00000000'), 'YYYYMMDD')::date as certification_date
, trim(nullif(substring(content, 50, 32), '00000000000000000000000000000000'))::varchar(32) as fincen_certification_form_certified_by
, trim(nullif(substring(content, 82, 40), '0000000000000000000000000000000000000000'))::varchar(40) as position_held_by_fincen_certifier
, trim(nullif(substring(content, 122, 1), '0'))::varchar(1) as legal_entity_exempted_from_the_cdd_rule
-- , trim(nullif(substring(content, 123, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as not_used_4
, trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as entity_is_a_financial_institution_regulated_by_federal_functional_regulator_or_bank
, trim(nullif(substring(content, 174, 1), '0'))::varchar(1) as entity_is_a_department_or_agency_of_united_states
, trim(nullif(substring(content, 175, 1), '0'))::varchar(1) as entity_is_an_investment_company
, trim(nullif(substring(content, 176, 1), '0'))::varchar(1) as entity_is_an_investment_adviser
, trim(nullif(substring(content, 177, 1), '0'))::varchar(1) as entity_is_an_exchange_or_clearing_agency
, trim(nullif(substring(content, 178, 1), '0'))::varchar(1) as entity_is_any_other_entity_registered_with_sec_under_securities_and_exchange
, trim(nullif(substring(content, 179, 1), '0'))::varchar(1) as entity_is_a_registered_entity
, trim(nullif(substring(content, 180, 1), '0'))::varchar(1) as entity_is_a_public_accounting_firm_registered_under_section_102_of_sarbanes
, trim(nullif(substring(content, 181, 1), '0'))::varchar(1) as entity_is_a_bank_holding_company
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as entity_is_a_pooled_investment_vehicle_operated_or_advised_by_financial_institution
, trim(nullif(substring(content, 183, 1), '0'))::varchar(1) as entity_is_an_insurance_company_regulated_by_a_state
, trim(nullif(substring(content, 184, 1), '0'))::varchar(1) as entity_is_a_financial_market_utility_designated_by_financial_stability_oversight
, trim(nullif(substring(content, 185, 1), '0'))::varchar(1) as entity_is_a_foreign_financial_institution_established_in_jurisdiction_where_regulator
, trim(nullif(substring(content, 186, 1), '0'))::varchar(1) as entity_is_a_nonus_governmental_department
, trim(nullif(substring(content, 187, 1), '0'))::varchar(1) as entity_is_any_legal_entity_that_opens_private_banking_account_subject_to_31_cfr
, trim(nullif(substring(content, 188, 1), '0'))::varchar(1) as entity_trust_is_not_a_statutory_trust_created_by_filing_with_secretary_of_state_or
, trim(nullif(substring(content, 189, 1), '0'))::varchar(1) as entity_is_not_a_legal_entity_customer_as_defined_by_cdd_rule
, trim(nullif(substring(content, 190, 1), '0'))::varchar(1) as any_entity
, trim(nullif(substring(content, 191, 1), '0'))::varchar(1) as any_entity_organized_under_laws_of_united_states_or_of_any_state
-- , trim(nullif(substring(content, 192, 38), '00000000000000000000000000000000000000'))::varchar(38) as reserved
-- , trim(nullif(substring(content, 230, 20), '00000000000000000000'))::varchar(20) as not_used_5
, trim(nullif(substring(content, 250, 40), '0000000000000000000000000000000000000000'))::varchar(40) as pershing_firm_designated_identifier_fdid
, trim(nullif(substring(content, 290, 40), '0000000000000000000000000000000000000000'))::varchar(40) as previous_ibd_firm_designated_identifier_fdid
, trim(nullif(substring(content, 330, 2), '00'))::varchar(2) as business_purpose_code
, trim(nullif(substring(content, 332, 1), '0'))::varchar(1) as affiliate_indicator
, trim(nullif(substring(content, 333, 1), '0'))::varchar(1) as retail_investor_indicator
, try_to_date(nullif(substring(content, 334, 8), '00000000'), 'YYYYMMDD')::date as crs_generation_date
, try_to_date(nullif(substring(content, 342, 8), '00000000'), 'YYYYMMDD')::date as firm_crs_generation_date
, trim(nullif(substring(content, 350, 128), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(128) as nature_and_purpose_of_account
, trim(nullif(substring(content, 478, 20), '00000000000000000000'))::varchar(20) as prior_firm_crd_number
, try_to_date(nullif(substring(content, 498, 8), '00000000'), 'YYYYMMDD')::date as last_cat_reportable_activity_date
, try_to_date(nullif(substring(content, 506, 8), '00000000'), 'YYYYMMDD')::date as last_cais_report_date
, trim(nullif(substring(content, 514, 1), '0'))::varchar(1) as cais_status
, trim(nullif(substring(content, 515, 4), '0000'))::varchar(4) as last_cais_report_trigger
, trim(nullif(substring(content, 519, 1), '0'))::varchar(1) as request_cais_reporting
-- , trim(nullif(substring(content, 520, 230), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(230) as not_used_6
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = '5'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
