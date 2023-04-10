{%- macro acct_w_additional_account_level_information(src) -%}

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
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as nonus_dollar_trading
, trim(nullif(substring(content, 43, 3), '000'))::varchar(3) as base_currency
, trim(nullif(substring(content, 46, 3), '000'))::varchar(3) as income_currency
, trim(nullif(substring(content, 49, 3), '000'))::varchar(3) as statement_language
, trim(nullif(substring(content, 52, 3), '000'))::varchar(3) as statement_format_code
, trim(nullif(substring(content, 55, 1), '0'))::varchar(1) as msrb_statement_indicator
-- , trim(nullif(substring(content, 56, 6), '000000'))::varchar(6) as not_used_4
, trim(nullif(substring(content, 62, 1), '0'))::varchar(1) as politically_exposed_person
, trim(nullif(substring(content, 63, 25), '0000000000000000000000000'))::varchar(25) as first_name_of_politically_exposed_person
, trim(nullif(substring(content, 88, 25), '0000000000000000000000000'))::varchar(25) as last_name_of_politically_exposed_person
, trim(nullif(substring(content, 113, 4), '0000'))::varchar(4) as suffix_of_politically_exposed_person
, trim(nullif(substring(content, 117, 35), '00000000000000000000000000000000000'))::varchar(35) as political_office_held
, trim(nullif(substring(content, 152, 2), '00'))::varchar(2) as country_of_office
, trim(nullif(substring(content, 154, 1), '0'))::varchar(1) as foreign_bank_account_indicator
, try_to_date(nullif(substring(content, 155, 8), '00000000'), 'YYYYMMDD')::date as foreign_bank_certification_date
, try_to_date(nullif(substring(content, 163, 8), '00000000'), 'YYYYMMDD')::date as foreign_bank_certification_expiration_date
, trim(nullif(substring(content, 171, 1), '0'))::varchar(1) as central_bank_indicator
, trim(nullif(substring(content, 172, 1), '0'))::varchar(1) as account_for_foreign_financial_institution
, trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as foreign_bank_account_operating_under_offshore
, trim(nullif(substring(content, 174, 1), '0'))::varchar(1) as foreign_bank_account_operating_under_banking_license
, trim(nullif(substring(content, 175, 1), '0'))::varchar(1) as foreign_bank_account_operating_under_banking_license_2
, trim(nullif(substring(content, 176, 2), '00'))::varchar(2) as number_of_peopleentities_that_own
, trim(nullif(substring(content, 178, 1), '0'))::varchar(1) as proprietary_account_owned_by_broker_dealer
-- , trim(nullif(substring(content, 179, 3), '000'))::varchar(3) as not_used_5
, trim(nullif(substring(content, 182, 1), '0'))::varchar(1) as telephone_1_transaction_code
, trim(nullif(substring(content, 183, 1), '0'))::varchar(1) as usinternational_indicator_1
, trim(nullif(substring(content, 184, 1), '0'))::varchar(1) as telephone_type_id_1
, trim(nullif(substring(content, 185, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_1
, trim(nullif(substring(content, 233, 7), '0000000'))::varchar(7) as telephone_extension_1
, trim(nullif(substring(content, 240, 1), '0'))::varchar(1) as telephone_2_transaction_code
, trim(nullif(substring(content, 241, 1), '0'))::varchar(1) as usinternational_indicator_2
, trim(nullif(substring(content, 242, 1), '0'))::varchar(1) as telephone_type_id_2
, trim(nullif(substring(content, 243, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_2
, trim(nullif(substring(content, 291, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 298, 1), '0'))::varchar(1) as telephone_3_transaction_code
, trim(nullif(substring(content, 299, 1), '0'))::varchar(1) as usinternational_indicator_3
, trim(nullif(substring(content, 300, 1), '0'))::varchar(1) as telephone_type_id_3
, trim(nullif(substring(content, 301, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_3
, trim(nullif(substring(content, 349, 7), '0000000'))::varchar(7) as telephone_extension_3
, trim(nullif(substring(content, 356, 1), '0'))::varchar(1) as telephone_4_transaction_code
, trim(nullif(substring(content, 357, 1), '0'))::varchar(1) as usinternational_indicator_4
, trim(nullif(substring(content, 358, 1), '0'))::varchar(1) as telephone_type_id_4
, trim(nullif(substring(content, 359, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_4
, trim(nullif(substring(content, 407, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 414, 1), '0'))::varchar(1) as telephone_5_transaction_code
, trim(nullif(substring(content, 415, 1), '0'))::varchar(1) as usinternational_indicator_5
, trim(nullif(substring(content, 416, 1), '0'))::varchar(1) as telephone_type_id_5
, trim(nullif(substring(content, 417, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_5
, trim(nullif(substring(content, 465, 7), '0000000'))::varchar(7) as telephone_extension_5
, trim(nullif(substring(content, 472, 1), '0'))::varchar(1) as telephone_6_transaction_code
, trim(nullif(substring(content, 473, 1), '0'))::varchar(1) as usinternational_indicator_6
, trim(nullif(substring(content, 474, 1), '0'))::varchar(1) as telephone_type_id_6
, trim(nullif(substring(content, 475, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_6
, trim(nullif(substring(content, 523, 7), '0000000'))::varchar(7) as telephone_extension_6
, trim(nullif(substring(content, 530, 1), '0'))::varchar(1) as telephone_7_transaction_code
, trim(nullif(substring(content, 531, 1), '0'))::varchar(1) as usinternational_indicator_7
, trim(nullif(substring(content, 532, 1), '0'))::varchar(1) as telephone_type_id_7
, trim(nullif(substring(content, 533, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_7
, trim(nullif(substring(content, 581, 7), '0000000'))::varchar(7) as telephone_extension_7
, trim(nullif(substring(content, 588, 1), '0'))::varchar(1) as telephone_8_transaction_code
, trim(nullif(substring(content, 589, 1), '0'))::varchar(1) as usinternational_indicator_8
, trim(nullif(substring(content, 590, 1), '0'))::varchar(1) as telephone_type_id_8
, trim(nullif(substring(content, 591, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_8
, trim(nullif(substring(content, 639, 7), '0000000'))::varchar(7) as telephone_extension_8
, trim(nullif(substring(content, 646, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as email_address
, trim(nullif(substring(content, 696, 1), '0'))::varchar(1) as external_positions_indicator
, trim(nullif(substring(content, 697, 1), '0'))::varchar(1) as purge_eligible_indicator
, trim(nullif(substring(content, 698, 1), '0'))::varchar(1) as advisory_account_indicator
, trim(nullif(substring(content, 699, 4), '0000'))::varchar(4) as product_profile_code
, nullif(nullif(trim(substring(content, 703, 2)), '00'), '')::int as cents_per_share_discount
, trim(nullif(substring(content, 705, 10), '0000000000'))::varchar(10) as for_pershing_internal_use_only
, try_to_date(nullif(substring(content, 715, 8), '00000000'), 'YYYYMMDD')::date as option_disclosure_date
, trim(nullif(substring(content, 723, 23), '00000000000000000000000'))::varchar(23) as for_pershing_internal_use_only_2
, trim(nullif(substring(content, 746, 4), '0000'))::varchar(4) as country_of_account_level_tax_residency
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'W'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
