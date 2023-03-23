{%- macro acct_r_retirement_account_information(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 3), '000'))::varchar(3) as investment_professional_ip_number
-- , trim(nullif(substring(content, 28, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_3
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as retirement_account_transaction_code
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as participant_marital_status
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as sex_of_participant
, trim(nullif(substring(content, 44, 4), '0000'))::varchar(4) as custodian_code
, trim(nullif(substring(content, 48, 4), '0000'))::varchar(4) as type_of_retirement_plan
, trim(nullif(substring(content, 52, 1), '0'))::varchar(1) as type_of_retirement_account
, trim(nullif(substring(content, 53, 10), '0000000000'))::varchar(10) as retirement_plan_number
, trim(nullif(substring(content, 63, 1), '0'))::varchar(1) as selfdirected_indicator
, trim(nullif(substring(content, 64, 1), '0'))::varchar(1) as asset_will_indicator
, try_to_date(nullif(substring(content, 65, 8), '00000000'), 'YYYYMMDD')::date as broker_dealer_conversion_date
, try_to_date(nullif(substring(content, 73, 8), '00000000'), 'YYYYMMDD')::date as adoption_agreement_date
, try_to_date(nullif(substring(content, 81, 8), '00000000'), 'YYYYMMDD')::date as date_plan_established
, try_to_date(nullif(substring(content, 89, 8), '00000000'), 'YYYYMMDD')::date as custodian_date
, try_to_date(nullif(substring(content, 97, 8), '00000000'), 'YYYYMMDD')::date as plan_amendment_date
, try_to_date(nullif(substring(content, 105, 8), '00000000'), 'YYYYMMDD')::date as spousal_consent_date
, trim(nullif(substring(content, 113, 1), '0'))::varchar(1) as education_disability_indicator
, try_to_date(nullif(substring(content, 114, 8), '00000000'), 'YYYYMMDD')::date as disability_start_date
, try_to_date(nullif(substring(content, 122, 8), '00000000'), 'YYYYMMDD')::date as date_of_death
, trim(nullif(substring(content, 130, 9), '000000000'))::varchar(9) as related_brokerage_account_number_1
, trim(nullif(substring(content, 139, 9), '000000000'))::varchar(9) as related_brokerage_account_number_2
, trim(nullif(substring(content, 148, 9), '000000000'))::varchar(9) as related_brokerage_account_number_3
, trim(nullif(substring(content, 157, 32), '00000000000000000000000000000000'))::varchar(32) as employer_name
, nullif(nullif(trim(substring(content, 189, 9)), '000000000'), '')::int as employer_tin
, trim(nullif(substring(content, 198, 32), '00000000000000000000000000000000'))::varchar(32) as trust_administrator
, trim(nullif(substring(content, 230, 1), '0'))::varchar(1) as employer_address_transaction_code
, trim(nullif(substring(content, 231, 1), '0'))::varchar(1) as special_handling_indicator
, trim(nullif(substring(content, 232, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 236, 28), '0000000000000000000000000000'))::varchar(28) as employer_attention_line_detail
, trim(nullif(substring(content, 264, 32), '00000000000000000000000000000000'))::varchar(32) as employer_address_line_1
, trim(nullif(substring(content, 296, 32), '00000000000000000000000000000000'))::varchar(32) as employer_address_line_2
, trim(nullif(substring(content, 328, 32), '00000000000000000000000000000000'))::varchar(32) as employer_address_line_3
, trim(nullif(substring(content, 360, 32), '00000000000000000000000000000000'))::varchar(32) as employer_address_line_4
, trim(nullif(substring(content, 392, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 407, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 409, 15), '000000000000000'))::varchar(15) as zip
, trim(nullif(substring(content, 424, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 426, 100), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(100) as not_used_4
, trim(nullif(substring(content, 526, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as email_address
, trim(nullif(substring(content, 576, 1), '0'))::varchar(1) as telephone_1_transaction_code
, trim(nullif(substring(content, 577, 1), '0'))::varchar(1) as usinternational_indicator_1
, trim(nullif(substring(content, 578, 1), '0'))::varchar(1) as telephone_type_id_1
, trim(nullif(substring(content, 579, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_1
, trim(nullif(substring(content, 639, 7), '0000000'))::varchar(7) as telephone_extension_1
, trim(nullif(substring(content, 646, 1), '0'))::varchar(1) as telephone_2_transaction_code
, trim(nullif(substring(content, 647, 1), '0'))::varchar(1) as usinternational_indicator_2
, trim(nullif(substring(content, 648, 1), '0'))::varchar(1) as telephone_type_id_2
, trim(nullif(substring(content, 649, 60), '000000000000000000000000000000000000000000000000000000000000'))::varchar(60) as telephone_number_2
, trim(nullif(substring(content, 709, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 716, 1), '0'))::varchar(1) as mutual_fund_indicator
, trim(nullif(substring(content, 717, 32), '00000000000000000000000000000000'))::varchar(32) as for_pershing_internal_use_only
-- , trim(nullif(substring(content, 749, 1), '0'))::varchar(1) as not_used_5
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'R'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
