{%- macro accf_m_account_holder_participant_level_investment_knowledge(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 3), '000'))::varchar(3) as investment_professional_ip_number
-- , trim(nullif(substring(content, 28, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as record_transaction_code
, trim(nullif(substring(content, 42, 3), '000'))::varchar(3) as sequence_number
, trim(nullif(substring(content, 45, 3), '000'))::varchar(3) as account_holder_type
, trim(nullif(substring(content, 48, 4), '0000'))::varchar(4) as account_holderparticipant_1_role
, trim(nullif(substring(content, 52, 1), '0'))::varchar(1) as general_investment_knowledge
, nullif(nullif(trim(substring(content, 53, 4)), '0000'), '')::int as year_equity_investment_experience_began
, trim(nullif(substring(content, 57, 1), '0'))::varchar(1) as equity_investment_knowledge_code
, nullif(nullif(trim(substring(content, 58, 4)), '0000'), '')::int as year_option_investment_experience_began
, trim(nullif(substring(content, 62, 1), '0'))::varchar(1) as option_investment_knowledge_code
, nullif(nullif(trim(substring(content, 63, 4)), '0000'), '')::int as year_fixed_income_investment_experience_began
, trim(nullif(substring(content, 67, 1), '0'))::varchar(1) as fixed_income_investment_knowledge_code
, nullif(nullif(trim(substring(content, 68, 4)), '0000'), '')::int as year_mutual_fund_investment_experience_began
, trim(nullif(substring(content, 72, 1), '0'))::varchar(1) as mutual_fund_investment_knowledge_code
, nullif(nullif(trim(substring(content, 73, 4)), '0000'), '')::int as year_unit_investment_trust_uit_investment_experience
, trim(nullif(substring(content, 77, 1), '0'))::varchar(1) as uit_investment_knowledge_code
, nullif(nullif(trim(substring(content, 78, 4)), '0000'), '')::int as year_exchange_traded_fund_investment_experience
, trim(nullif(substring(content, 82, 1), '0'))::varchar(1) as etf_investment_knowledge_code
, nullif(nullif(trim(substring(content, 83, 4)), '0000'), '')::int as year_real_estate_investment_experience_began
, trim(nullif(substring(content, 87, 1), '0'))::varchar(1) as real_estate_investment_knowledge_code
, nullif(nullif(trim(substring(content, 88, 4)), '0000'), '')::int as year_insurance_investment_experience_began
, trim(nullif(substring(content, 92, 1), '0'))::varchar(1) as insurance_investment_knowledge_code
, nullif(nullif(trim(substring(content, 93, 4)), '0000'), '')::int as year_variable_annuity_investment_experience_began
, trim(nullif(substring(content, 97, 1), '0'))::varchar(1) as variable_annuity_investment_knowledge_code
, nullif(nullif(trim(substring(content, 98, 4)), '0000'), '')::int as year_fixed_annuity_investment_experience_began
, trim(nullif(substring(content, 102, 1), '0'))::varchar(1) as fixed_annuity_investment_knowledge_code
, nullif(nullif(trim(substring(content, 103, 4)), '0000'), '')::int as year_precious_metals_investment_experience_began
, trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as precious_metals_investment_knowledge_code
, nullif(nullif(trim(substring(content, 108, 4)), '0000'), '')::int as year_commodity_and_futures_investment_experience
, trim(nullif(substring(content, 112, 1), '0'))::varchar(1) as commodity_and_futures_investment_knowledge_code
, trim(nullif(substring(content, 113, 30), '000000000000000000000000000000'))::varchar(30) as other_investment_type
, nullif(nullif(trim(substring(content, 143, 4)), '0000'), '')::int as year_other_type_investment_experience_began
, trim(nullif(substring(content, 147, 1), '0'))::varchar(1) as other_investment_knowledge_code
, trim(nullif(substring(content, 148, 5), '00000'))::varchar(5) as reserved_for_additional_investment_experience
-- , trim(nullif(substring(content, 153, 142), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(142) as not_used_4
, trim(nullif(substring(content, 295, 4), '0000'))::varchar(4) as document_code
, try_to_date(nullif(substring(content, 299, 8), '00000000'), 'YYYYMMDD')::date as document_received_date
, try_to_date(nullif(substring(content, 307, 8), '00000000'), 'YYYYMMDD')::date as document_expiration_date
, trim(nullif(substring(content, 315, 20), '00000000000000000000'))::varchar(20) as related_to_employee_of_this_ibds_employee_id
, nullif(nullif(trim(substring(content, 335, 2)), '00'), '')::int as number_of_dependents
, trim(nullif(substring(content, 337, 32), '00000000000000000000000000000000'))::varchar(32) as bank_name
, trim(nullif(substring(content, 369, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 373, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 401, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_1
, trim(nullif(substring(content, 433, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_2
, trim(nullif(substring(content, 465, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_3
, trim(nullif(substring(content, 497, 32), '00000000000000000000000000000000'))::varchar(32) as bank_address_line_4
, trim(nullif(substring(content, 529, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 544, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 546, 15), '000000000000000'))::varchar(15) as zippostal_code
, trim(nullif(substring(content, 561, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 563, 147), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(147) as not_used_5
, trim(nullif(substring(content, 710, 20), '00000000000000000000'))::varchar(20) as for_pershing_internal_use_only
, trim(nullif(substring(content, 730, 20), '00000000000000000000'))::varchar(20) as client_id
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'M'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
