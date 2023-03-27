{%- macro acct_h_account_holder_participant_information(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as account_holder_participant_transaction_code
, trim(nullif(substring(content, 42, 3), '000'))::varchar(3) as sequence_number
, trim(nullif(substring(content, 45, 3), '000'))::varchar(3) as account_holder_type
, trim(nullif(substring(content, 48, 1), '0'))::varchar(1) as joint_account_incomenet_worth_indicator
, to_number(nullif(nullif(trim(substring(content, 49, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_annual_income_amount
, to_number(nullif(nullif(trim(substring(content, 67, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_annual_income_amount
, to_number(nullif(nullif(trim(substring(content, 85, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_net_worth_amount
, to_number(nullif(nullif(trim(substring(content, 103, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_net_worth_amount
, trim(nullif(substring(content, 121, 1), '0'))::varchar(1) as telephone_1_transaction_code
, trim(nullif(substring(content, 122, 1), '0'))::varchar(1) as usinternational_indicator_1
, trim(nullif(substring(content, 123, 1), '0'))::varchar(1) as telephone_type_id_1
, trim(nullif(substring(content, 124, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_1
, trim(nullif(substring(content, 172, 7), '0000000'))::varchar(7) as telephone_extension_1
, trim(nullif(substring(content, 179, 1), '0'))::varchar(1) as telephone_2_transaction_code
, trim(nullif(substring(content, 180, 1), '0'))::varchar(1) as usinternational_indicator_2
, trim(nullif(substring(content, 181, 1), '0'))::varchar(1) as telephone_type_id_2
, trim(nullif(substring(content, 182, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_2
, trim(nullif(substring(content, 230, 7), '0000000'))::varchar(7) as telephone_extension_2
, trim(nullif(substring(content, 237, 1), '0'))::varchar(1) as telephone_3_transaction_code
, trim(nullif(substring(content, 238, 1), '0'))::varchar(1) as usinternational_indicator_3
, trim(nullif(substring(content, 239, 1), '0'))::varchar(1) as telephone_type_id_3
, trim(nullif(substring(content, 240, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_3
, trim(nullif(substring(content, 288, 7), '0000000'))::varchar(7) as telephone_extension_3
, trim(nullif(substring(content, 295, 1), '0'))::varchar(1) as telephone_4_transaction_code
, trim(nullif(substring(content, 296, 1), '0'))::varchar(1) as usinternational_indicator_4
, trim(nullif(substring(content, 297, 1), '0'))::varchar(1) as telephone_type_id_4
, trim(nullif(substring(content, 298, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_4
, trim(nullif(substring(content, 346, 7), '0000000'))::varchar(7) as telephone_extension_4
, trim(nullif(substring(content, 353, 1), '0'))::varchar(1) as telephone_5_transaction_code
, trim(nullif(substring(content, 354, 1), '0'))::varchar(1) as usinternational_indicator_5
, trim(nullif(substring(content, 355, 1), '0'))::varchar(1) as telephone_type_id_5
, trim(nullif(substring(content, 356, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_5
, trim(nullif(substring(content, 404, 7), '0000000'))::varchar(7) as telephone_extension_5
, trim(nullif(substring(content, 411, 1), '0'))::varchar(1) as telephone_6_transaction_code
, trim(nullif(substring(content, 412, 1), '0'))::varchar(1) as usinternational_indicator_6
, trim(nullif(substring(content, 413, 1), '0'))::varchar(1) as telephone_type_id_6
, trim(nullif(substring(content, 414, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_6
, trim(nullif(substring(content, 462, 7), '0000000'))::varchar(7) as telephone_extension_6
, trim(nullif(substring(content, 469, 1), '0'))::varchar(1) as telephone_7_transaction_code
, trim(nullif(substring(content, 470, 1), '0'))::varchar(1) as usinternational_indicator_7
, trim(nullif(substring(content, 471, 1), '0'))::varchar(1) as telephone_type_id_7
, trim(nullif(substring(content, 472, 48), '000000000000000000000000000000000000000000000000'))::varchar(48) as telephone_number_7
, trim(nullif(substring(content, 520, 7), '0000000'))::varchar(7) as telephone_extension_7
, trim(nullif(substring(content, 527, 1), '0'))::varchar(1) as consolidated_liquid_net_worth_indicator
, to_number(nullif(nullif(trim(substring(content, 528, 18)), '000000000000000000'), '')) / power(10, 02)::number as minimum_liquid_net_worth_amount
, to_number(nullif(nullif(trim(substring(content, 546, 18)), '000000000000000000'), '')) / power(10, 02)::number as maximum_liquid_net_worth_amount
, trim(nullif(substring(content, 564, 5), '00000'))::varchar(5) as for_pershing_internal_use_only
, trim(nullif(substring(content, 569, 4), '0000'))::varchar(4) as account_holderparticipant_role_code
, trim(nullif(substring(content, 573, 10), '0000000000'))::varchar(10) as participant_short_name
, trim(nullif(substring(content, 583, 1), '0'))::varchar(1) as primary_mail_recipient_indicator
-- , trim(nullif(substring(content, 584, 1), '0'))::varchar(1) as not_used_4
, trim(nullif(substring(content, 585, 50), '00000000000000000000000000000000000000000000000000'))::varchar(50) as email_address
, trim(nullif(substring(content, 635, 4), '0000'))::varchar(4) as type_of_unexpired_photo_government_id_1
, trim(nullif(substring(content, 639, 32), '00000000000000000000000000000000'))::varchar(32) as unexpired_photo_government_id_number_1
, trim(nullif(substring(content, 671, 2), '00'))::varchar(2) as country_of_unexpired_photo_government_id_1
, trim(nullif(substring(content, 673, 2), '00'))::varchar(2) as stateprovince_of_unexpired_photo_government_id_1
, try_to_date(nullif(substring(content, 675, 8), '00000000'), 'YYYYMMDD')::date as expiration_date_of_unexpired_government_photo_id_1
, try_to_date(nullif(substring(content, 683, 8), '00000000'), 'YYYYMMDD')::date as issuance_date_of_unexpired_government_photo_ccyymmdd
, trim(nullif(substring(content, 691, 4), '0000'))::varchar(4) as type_of_unexpired_photo_government_id_2
, trim(nullif(substring(content, 695, 32), '00000000000000000000000000000000'))::varchar(32) as unexpired_photo_government_id_number_2
, trim(nullif(substring(content, 727, 2), '00'))::varchar(2) as country_of_unexpired_photo_government_id_2
, trim(nullif(substring(content, 729, 2), '00'))::varchar(2) as stateprimary_subdivision_of_unexpired_photo
, try_to_date(nullif(substring(content, 731, 8), '00000000'), 'YYYYMMDD')::date as expiration_date_of_unexpired_government_photo_id_2
, try_to_date(nullif(substring(content, 739, 8), '00000000'), 'YYYYMMDD')::date as issuance_date_of_unexpired_government_photo_id_2
, trim(nullif(substring(content, 747, 1), '0'))::varchar(1) as specified_adult_indicator
-- , trim(nullif(substring(content, 748, 2), '00'))::varchar(2) as not_used_5
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'H'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
