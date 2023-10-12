{%- macro accf_p_account_settlement_instruction_information(src) -%}

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
, trim(nullif(substring(content, 41, 6), '000000'))::varchar(6) as parent_id
, trim(nullif(substring(content, 47, 8), '00000000'))::varchar(8) as institution_id
, trim(nullif(substring(content, 55, 16), '0000000000000000'))::varchar(16) as institution_ia_account_number
, trim(nullif(substring(content, 71, 8), '00000000'))::varchar(8) as alert_acronym
, trim(nullif(substring(content, 79, 12), '000000000000'))::varchar(12) as alert_access_code
, trim(nullif(substring(content, 91, 1), '0'))::varchar(1) as confirmation_option
, try_to_date(nullif(substring(content, 92, 8), '00000000'), 'YYYYMMDD')::date as birth_date
-- , trim(nullif(substring(content, 100, 4), '0000'))::varchar(4) as not_used_4
, trim(nullif(substring(content, 104, 2), '00'))::varchar(2) as country_of_citizenship_code_cod
, trim(nullif(substring(content, 106, 1), '0'))::varchar(1) as dtc_transaction_code
, trim(nullif(substring(content, 107, 4), '0000'))::varchar(4) as locationproduct_code
, trim(nullif(substring(content, 111, 8), '00000000'))::varchar(8) as institution_number
, trim(nullif(substring(content, 119, 40), '0000000000000000000000000000000000000000'))::varchar(40) as institution_name
, trim(nullif(substring(content, 159, 8), '00000000'))::varchar(8) as agent_number
, trim(nullif(substring(content, 167, 40), '0000000000000000000000000000000000000000'))::varchar(40) as agent_name
, trim(nullif(substring(content, 207, 16), '0000000000000000'))::varchar(16) as agent_internal_number
, trim(nullif(substring(content, 223, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as agent_internal_name
, trim(nullif(substring(content, 273, 8), '00000000'))::varchar(8) as clearing_agent_number
, trim(nullif(substring(content, 281, 35), '00000000000000000000000000000000000'))::varchar(35) as clearing_agent_name
, trim(nullif(substring(content, 316, 8), '00000000'))::varchar(8) as first_dtc_ip_number
, trim(nullif(substring(content, 324, 23), '00000000000000000000000'))::varchar(23) as first_ip_account_number
, trim(nullif(substring(content, 347, 8), '00000000'))::varchar(8) as second_dtc_ip_number
, trim(nullif(substring(content, 355, 23), '00000000000000000000000'))::varchar(23) as second_ip_account_number
, trim(nullif(substring(content, 378, 1), '0'))::varchar(1) as fed_transaction_code
, trim(nullif(substring(content, 379, 4), '0000'))::varchar(4) as locationproduct_code_2
, trim(nullif(substring(content, 383, 9), '000000000'))::varchar(9) as aba_number
, trim(nullif(substring(content, 392, 40), '0000000000000000000000000000000000000000'))::varchar(40) as internal_account_number
, trim(nullif(substring(content, 432, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as federal_wire_bank_name
, trim(nullif(substring(content, 482, 1), '0'))::varchar(1) as eur_transaction_code
, trim(nullif(substring(content, 483, 4), '0000'))::varchar(4) as locationproduct_code_3
, trim(nullif(substring(content, 487, 8), '00000000'))::varchar(8) as euroclear_number
, trim(nullif(substring(content, 495, 15), '000000000000000'))::varchar(15) as euroclear_account_number
, trim(nullif(substring(content, 510, 1), '0'))::varchar(1) as ced_transaction_code
, trim(nullif(substring(content, 511, 4), '0000'))::varchar(4) as locationproduct_code_4
, trim(nullif(substring(content, 515, 8), '00000000'))::varchar(8) as cedel_number
, trim(nullif(substring(content, 523, 15), '000000000000000'))::varchar(15) as cedel_account_number
, trim(nullif(substring(content, 538, 1), '0'))::varchar(1) as phy_transaction_code
, trim(nullif(substring(content, 539, 4), '0000'))::varchar(4) as locationproduct_code_5
, trim(nullif(substring(content, 543, 15), '000000000000000'))::varchar(15) as account_number_for_physical_delivery
, trim(nullif(substring(content, 558, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_1
, trim(nullif(substring(content, 590, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_2
, trim(nullif(substring(content, 622, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_3
, trim(nullif(substring(content, 654, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_4
, trim(nullif(substring(content, 686, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_5
, trim(nullif(substring(content, 718, 32), '00000000000000000000000000000000'))::varchar(32) as other_instructions_6
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'P'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
