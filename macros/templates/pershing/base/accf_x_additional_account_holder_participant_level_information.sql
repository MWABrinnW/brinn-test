{%- macro accf_x_additional_account_holder_participant_level_information(src) -%}

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
-- , trim(nullif(substring(content, 48, 2), '00'))::varchar(2) as not_used_4
, trim(nullif(substring(content, 50, 4), '0000'))::varchar(4) as attention_line_prefix
, trim(nullif(substring(content, 54, 28), '0000000000000000000000000000'))::varchar(28) as attention_line_detail
, trim(nullif(substring(content, 82, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_1
, trim(nullif(substring(content, 114, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_2
, trim(nullif(substring(content, 146, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_3
, trim(nullif(substring(content, 178, 32), '00000000000000000000000000000000'))::varchar(32) as address_line_4
, trim(nullif(substring(content, 210, 15), '000000000000000'))::varchar(15) as city
, trim(nullif(substring(content, 225, 2), '00'))::varchar(2) as state
, trim(nullif(substring(content, 227, 15), '000000000000000'))::varchar(15) as zippostal_code
, trim(nullif(substring(content, 242, 2), '00'))::varchar(2) as country_code
-- , trim(nullif(substring(content, 244, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 246, 1), '0'))::varchar(1) as employee_of_this_ibd
, trim(nullif(substring(content, 247, 1), '0'))::varchar(1) as related_to_employee_of_this_ibd
, trim(nullif(substring(content, 248, 25), '0000000000000000000000000'))::varchar(25) as employee_first_name
, trim(nullif(substring(content, 273, 25), '0000000000000000000000000'))::varchar(25) as employee_last_name
, trim(nullif(substring(content, 298, 4), '0000'))::varchar(4) as employee_suffix
, trim(nullif(substring(content, 302, 4), '0000'))::varchar(4) as relationship_to_employee
, trim(nullif(substring(content, 306, 1), '0'))::varchar(1) as employee_of_another_ibd
, trim(nullif(substring(content, 307, 20), '00000000000000000000'))::varchar(20) as ibd_name
, trim(nullif(substring(content, 327, 1), '0'))::varchar(1) as related_to_employee_of_another_ibd
, trim(nullif(substring(content, 328, 20), '00000000000000000000'))::varchar(20) as ibd_name_2
, trim(nullif(substring(content, 348, 25), '0000000000000000000000000'))::varchar(25) as employee_first_name_2
, trim(nullif(substring(content, 373, 25), '0000000000000000000000000'))::varchar(25) as employee_last_name_2
, trim(nullif(substring(content, 398, 4), '0000'))::varchar(4) as employee_suffix_2
, trim(nullif(substring(content, 402, 4), '0000'))::varchar(4) as relationship_to_employee_of_another_ibd
, trim(nullif(substring(content, 406, 1), '0'))::varchar(1) as other_brokerage_accounts
, trim(nullif(substring(content, 407, 20), '00000000000000000000'))::varchar(20) as name_of_ibd_where_account_held
, trim(nullif(substring(content, 427, 1), '0'))::varchar(1) as holderparticipant_or_immediate_family_member
, trim(nullif(substring(content, 428, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as affiliation
, trim(nullif(substring(content, 473, 1), '0'))::varchar(1) as holderparticipant_a_senior_officer
, trim(nullif(substring(content, 474, 45), '000000000000000000000000000000000000000000000'))::varchar(45) as name_of_public_company
, trim(nullif(substring(content, 519, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as id_verification_comments
, trim(nullif(substring(content, 569, 4), '0000'))::varchar(4) as account_holderparticipant_role_code
, to_number(nullif(nullif(trim(substring(content, 573, 18)), '000000000000000000'), '')) / power(10, 09)::number as beneficiary_percent_allocation
, trim(nullif(substring(content, 591, 2), '00'))::varchar(2) as relationship_to_primary_holder_code
, trim(nullif(substring(content, 593, 90), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(90) as for_pershing_internal_use_only
, trim(nullif(substring(content, 683, 2), '00'))::varchar(2) as primary_holders_relationship_to_decedent_beneficiary
, try_to_date(nullif(substring(content, 685, 8), '00000000'), 'YYYYMMDD')::date as date_of_death
, trim(nullif(substring(content, 693, 8), '00000000'))::varchar(8) as large_trader_id_prefix
-- , trim(nullif(substring(content, 701, 2), '00'))::varchar(2) as reserved
, trim(nullif(substring(content, 703, 4), '0000'))::varchar(4) as large_trader_id_suffix
-- , trim(nullif(substring(content, 707, 10), '0000000000'))::varchar(10) as reserved_2
, trim(nullif(substring(content, 717, 2), '00'))::varchar(2) as additional_country_of_citizenship_1
, trim(nullif(substring(content, 719, 2), '00'))::varchar(2) as additional_country_of_citizenship_2
, trim(nullif(substring(content, 721, 2), '00'))::varchar(2) as additional_country_of_citizenship_3
, trim(nullif(substring(content, 723, 2), '00'))::varchar(2) as additional_country_of_citizenship_4
, trim(nullif(substring(content, 725, 2), '00'))::varchar(2) as additional_country_of_citizenship_5
, trim(nullif(substring(content, 727, 1), '0'))::varchar(1) as u
, trim(nullif(substring(content, 728, 2), '00'))::varchar(2) as country_of_birth
, trim(nullif(substring(content, 730, 1), '0'))::varchar(1) as per_stirpes_beneficiary_designation
, trim(nullif(substring(content, 731, 9), '000000000'))::varchar(9) as internal_pershing_assigned_client_id
-- , trim(nullif(substring(content, 740, 2), '00'))::varchar(2) as not_used_6
, try_to_date(nullif(substring(content, 742, 8), '00000000'), 'YYYYMMDD')::date as formed_on_date
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'X'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
