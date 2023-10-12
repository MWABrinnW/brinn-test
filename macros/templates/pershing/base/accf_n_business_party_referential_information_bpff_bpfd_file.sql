{%- macro accf_n_business_party_referential_information_bpff_bpfd_file(src) -%}

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
, trim(nullif(substring(content, 41, 1), '0'))::varchar(1) as business_party_1_transaction_code
, trim(nullif(substring(content, 42, 9), '000000000'))::varchar(9) as business_party_1_id
, trim(nullif(substring(content, 51, 4), '0000'))::varchar(4) as business_party_1_role_code
, trim(nullif(substring(content, 55, 1), '0'))::varchar(1) as business_party_1_has_discretion
-- , trim(nullif(substring(content, 56, 7), '0000000'))::varchar(7) as not_used_4
, trim(nullif(substring(content, 63, 1), '0'))::varchar(1) as business_party_2_transaction_code
, trim(nullif(substring(content, 64, 9), '000000000'))::varchar(9) as business_party_2_id
, trim(nullif(substring(content, 73, 4), '0000'))::varchar(4) as business_party_2_role_code
, trim(nullif(substring(content, 77, 1), '0'))::varchar(1) as business_party_2_has_discretion
-- , trim(nullif(substring(content, 78, 7), '0000000'))::varchar(7) as not_used_5
, trim(nullif(substring(content, 85, 1), '0'))::varchar(1) as business_party_3_transaction_code
, trim(nullif(substring(content, 86, 9), '000000000'))::varchar(9) as business_party_3_id
, trim(nullif(substring(content, 95, 4), '0000'))::varchar(4) as business_party_3_role_code
, trim(nullif(substring(content, 99, 1), '0'))::varchar(1) as business_party_3_has_discretion
-- , trim(nullif(substring(content, 100, 7), '0000000'))::varchar(7) as not_used_6
, trim(nullif(substring(content, 107, 1), '0'))::varchar(1) as business_party_4_transaction_code
, trim(nullif(substring(content, 108, 9), '000000000'))::varchar(9) as business_party_4_id
, trim(nullif(substring(content, 117, 4), '0000'))::varchar(4) as business_party_4_role_code
, trim(nullif(substring(content, 121, 1), '0'))::varchar(1) as business_party_4_has_discretion
-- , trim(nullif(substring(content, 122, 7), '0000000'))::varchar(7) as not_used_7
, trim(nullif(substring(content, 129, 1), '0'))::varchar(1) as business_party_5_transaction_code
, trim(nullif(substring(content, 130, 9), '000000000'))::varchar(9) as business_party_5_id
, trim(nullif(substring(content, 139, 4), '0000'))::varchar(4) as business_party_5_role_code
, trim(nullif(substring(content, 143, 1), '0'))::varchar(1) as business_party_5_has_discretion
-- , trim(nullif(substring(content, 144, 7), '0000000'))::varchar(7) as not_used_8
, trim(nullif(substring(content, 151, 1), '0'))::varchar(1) as business_party_6_transaction_code
, trim(nullif(substring(content, 152, 9), '000000000'))::varchar(9) as business_party_6_id
, trim(nullif(substring(content, 161, 4), '0000'))::varchar(4) as business_party_6_role_code
, trim(nullif(substring(content, 165, 1), '0'))::varchar(1) as business_party_6_has_discretion
-- , trim(nullif(substring(content, 166, 7), '0000000'))::varchar(7) as not_used_9
, trim(nullif(substring(content, 173, 1), '0'))::varchar(1) as business_party_7_transaction_code
, trim(nullif(substring(content, 174, 9), '000000000'))::varchar(9) as business_party_7_id
, trim(nullif(substring(content, 183, 4), '0000'))::varchar(4) as business_party_7_role_code
, trim(nullif(substring(content, 187, 1), '0'))::varchar(1) as business_party_7_has_discretion
-- , trim(nullif(substring(content, 188, 7), '0000000'))::varchar(7) as not_used_10
, trim(nullif(substring(content, 195, 1), '0'))::varchar(1) as business_party_8_transaction_code
, trim(nullif(substring(content, 196, 9), '000000000'))::varchar(9) as business_party_8_id
, trim(nullif(substring(content, 205, 4), '0000'))::varchar(4) as business_party_8_role_code
, trim(nullif(substring(content, 209, 1), '0'))::varchar(1) as business_party_8_has_discretion
-- , trim(nullif(substring(content, 210, 7), '0000000'))::varchar(7) as not_used_11
, trim(nullif(substring(content, 217, 1), '0'))::varchar(1) as business_party_9_transaction_code
, trim(nullif(substring(content, 218, 9), '000000000'))::varchar(9) as business_party_9_id
, trim(nullif(substring(content, 227, 4), '0000'))::varchar(4) as business_party_9_role_code
, trim(nullif(substring(content, 231, 1), '0'))::varchar(1) as business_party_9_has_discretion
-- , trim(nullif(substring(content, 232, 7), '0000000'))::varchar(7) as not_used_12
, trim(nullif(substring(content, 239, 1), '0'))::varchar(1) as business_party_10_transaction_code
, trim(nullif(substring(content, 240, 9), '000000000'))::varchar(9) as business_party_10_id
, trim(nullif(substring(content, 249, 4), '0000'))::varchar(4) as business_party_10_role_code
, trim(nullif(substring(content, 253, 1), '0'))::varchar(1) as business_party_10_has_discretion
-- , trim(nullif(substring(content, 254, 7), '0000000'))::varchar(7) as not_used_13
, trim(nullif(substring(content, 261, 1), '0'))::varchar(1) as business_party_11_transaction_code
, trim(nullif(substring(content, 262, 9), '000000000'))::varchar(9) as business_party_11_id
, trim(nullif(substring(content, 271, 4), '0000'))::varchar(4) as business_party_11_role_code
, trim(nullif(substring(content, 275, 1), '0'))::varchar(1) as business_party_11_has_discretion
-- , trim(nullif(substring(content, 276, 7), '0000000'))::varchar(7) as not_used_14
, trim(nullif(substring(content, 283, 1), '0'))::varchar(1) as business_party_12_transaction_code
, trim(nullif(substring(content, 284, 9), '000000000'))::varchar(9) as business_party_12_id
, trim(nullif(substring(content, 293, 4), '0000'))::varchar(4) as business_party_12_role_code
, trim(nullif(substring(content, 297, 1), '0'))::varchar(1) as business_party_12_has_discretion
-- , trim(nullif(substring(content, 298, 7), '0000000'))::varchar(7) as not_used_15
, trim(nullif(substring(content, 305, 1), '0'))::varchar(1) as business_party_13_transaction_code
, trim(nullif(substring(content, 306, 9), '000000000'))::varchar(9) as business_party_13_id
, trim(nullif(substring(content, 315, 4), '0000'))::varchar(4) as business_party_13_role_code
, trim(nullif(substring(content, 319, 1), '0'))::varchar(1) as business_party_13_has_discretion
-- , trim(nullif(substring(content, 320, 7), '0000000'))::varchar(7) as not_used_16
, trim(nullif(substring(content, 327, 1), '0'))::varchar(1) as business_party_14_transaction_code
, trim(nullif(substring(content, 328, 9), '000000000'))::varchar(9) as business_party_14_id
, trim(nullif(substring(content, 337, 4), '0000'))::varchar(4) as business_party_14_role_code
, trim(nullif(substring(content, 341, 1), '0'))::varchar(1) as business_party_14_has_discretion
-- , trim(nullif(substring(content, 342, 7), '0000000'))::varchar(7) as not_used_17
, trim(nullif(substring(content, 349, 1), '0'))::varchar(1) as business_party_15_transaction_code
, trim(nullif(substring(content, 350, 9), '000000000'))::varchar(9) as business_party_15_id
, trim(nullif(substring(content, 359, 4), '0000'))::varchar(4) as business_party_15_role_code
, trim(nullif(substring(content, 363, 1), '0'))::varchar(1) as business_party_15_has_discretion
-- , trim(nullif(substring(content, 364, 7), '0000000'))::varchar(7) as not_used_18
, trim(nullif(substring(content, 371, 1), '0'))::varchar(1) as business_party_16_transaction_code
, trim(nullif(substring(content, 372, 9), '000000000'))::varchar(9) as business_party_16_id
, trim(nullif(substring(content, 381, 4), '0000'))::varchar(4) as business_party_16_role_code
, trim(nullif(substring(content, 385, 1), '0'))::varchar(1) as business_party_16_has_discretion
-- , trim(nullif(substring(content, 386, 7), '0000000'))::varchar(7) as not_used_19
, trim(nullif(substring(content, 393, 1), '0'))::varchar(1) as business_party_17_transaction_code
, trim(nullif(substring(content, 394, 9), '000000000'))::varchar(9) as business_party_17_id
, trim(nullif(substring(content, 403, 4), '0000'))::varchar(4) as business_party_17_role_code
, trim(nullif(substring(content, 407, 1), '0'))::varchar(1) as business_party_17_has_discretion
-- , trim(nullif(substring(content, 408, 7), '0000000'))::varchar(7) as not_used_20
, trim(nullif(substring(content, 415, 1), '0'))::varchar(1) as business_party_18_transaction_code
, trim(nullif(substring(content, 416, 9), '000000000'))::varchar(9) as business_party_18_id
, trim(nullif(substring(content, 425, 4), '0000'))::varchar(4) as business_party_18_role_code
, trim(nullif(substring(content, 429, 1), '0'))::varchar(1) as business_party_18_has_discretion
-- , trim(nullif(substring(content, 430, 7), '0000000'))::varchar(7) as not_used_21
, trim(nullif(substring(content, 437, 1), '0'))::varchar(1) as business_party_19_transaction_code
, trim(nullif(substring(content, 438, 9), '000000000'))::varchar(9) as business_party_19_id
, trim(nullif(substring(content, 447, 4), '0000'))::varchar(4) as business_party_19_role_code
, trim(nullif(substring(content, 451, 1), '0'))::varchar(1) as business_party_19_has_discretion
-- , trim(nullif(substring(content, 452, 7), '0000000'))::varchar(7) as not_used_22
, trim(nullif(substring(content, 459, 1), '0'))::varchar(1) as business_party_20_transaction_code
, trim(nullif(substring(content, 460, 9), '000000000'))::varchar(9) as business_party_20_id
, trim(nullif(substring(content, 469, 4), '0000'))::varchar(4) as business_party_20_role_code
, trim(nullif(substring(content, 473, 1), '0'))::varchar(1) as business_party_20_has_discretion
-- , trim(nullif(substring(content, 474, 7), '0000000'))::varchar(7) as not_used_23
, trim(nullif(substring(content, 481, 1), '0'))::varchar(1) as business_party_21_transaction_code
, trim(nullif(substring(content, 482, 9), '000000000'))::varchar(9) as business_party_21_id
, trim(nullif(substring(content, 491, 4), '0000'))::varchar(4) as business_party_21_role_code
, trim(nullif(substring(content, 495, 1), '0'))::varchar(1) as business_party_21_has_discretion
-- , trim(nullif(substring(content, 496, 7), '0000000'))::varchar(7) as not_used_24
, trim(nullif(substring(content, 503, 1), '0'))::varchar(1) as business_party_22_transaction_code
, trim(nullif(substring(content, 504, 9), '000000000'))::varchar(9) as business_party_22_id
, trim(nullif(substring(content, 513, 4), '0000'))::varchar(4) as business_party_22_role_code
, trim(nullif(substring(content, 517, 1), '0'))::varchar(1) as business_party_22_has_discretion
-- , trim(nullif(substring(content, 518, 7), '0000000'))::varchar(7) as not_used_25
, trim(nullif(substring(content, 525, 1), '0'))::varchar(1) as business_party_23_transaction_code
, trim(nullif(substring(content, 526, 9), '000000000'))::varchar(9) as business_party_23_id
, trim(nullif(substring(content, 535, 4), '0000'))::varchar(4) as business_party_23_role_code
, trim(nullif(substring(content, 539, 1), '0'))::varchar(1) as business_party_23_has_discretion
-- , trim(nullif(substring(content, 540, 7), '0000000'))::varchar(7) as not_used_26
, trim(nullif(substring(content, 547, 1), '0'))::varchar(1) as business_party_24_transaction_code
, trim(nullif(substring(content, 548, 9), '000000000'))::varchar(9) as business_party_24_id
, trim(nullif(substring(content, 557, 4), '0000'))::varchar(4) as business_party_24_role_code
, trim(nullif(substring(content, 561, 1), '0'))::varchar(1) as business_party_24_has_discretion
-- , trim(nullif(substring(content, 562, 7), '0000000'))::varchar(7) as not_used_27
, trim(nullif(substring(content, 569, 1), '0'))::varchar(1) as business_party_25_transaction_code
, trim(nullif(substring(content, 570, 9), '000000000'))::varchar(9) as business_party_25_id
, trim(nullif(substring(content, 579, 4), '0000'))::varchar(4) as business_party_25_role_code
, trim(nullif(substring(content, 583, 1), '0'))::varchar(1) as business_party_25_has_discretion
-- , trim(nullif(substring(content, 584, 7), '0000000'))::varchar(7) as not_used_28
, trim(nullif(substring(content, 591, 1), '0'))::varchar(1) as business_party_26_transaction_code
, trim(nullif(substring(content, 592, 9), '000000000'))::varchar(9) as business_party_26_id
, trim(nullif(substring(content, 601, 4), '0000'))::varchar(4) as business_party_26_role_code
, trim(nullif(substring(content, 605, 1), '0'))::varchar(1) as business_party_26_has_discretion
-- , trim(nullif(substring(content, 606, 7), '0000000'))::varchar(7) as not_used_29
, trim(nullif(substring(content, 613, 1), '0'))::varchar(1) as business_party_27_transaction_code
, trim(nullif(substring(content, 614, 9), '000000000'))::varchar(9) as business_party_27_id
, trim(nullif(substring(content, 623, 4), '0000'))::varchar(4) as business_party_27_role_code
, trim(nullif(substring(content, 627, 1), '0'))::varchar(1) as business_party_27_has_discretion
-- , trim(nullif(substring(content, 628, 7), '0000000'))::varchar(7) as not_used_30
, trim(nullif(substring(content, 635, 1), '0'))::varchar(1) as business_party_28_transaction_code
, trim(nullif(substring(content, 636, 9), '000000000'))::varchar(9) as business_party_28_id
, trim(nullif(substring(content, 645, 4), '0000'))::varchar(4) as business_party_28_role_code
, trim(nullif(substring(content, 649, 1), '0'))::varchar(1) as business_party_28_has_discretion
-- , trim(nullif(substring(content, 650, 7), '0000000'))::varchar(7) as not_used_31
, trim(nullif(substring(content, 657, 1), '0'))::varchar(1) as business_party_29_transaction_code
, trim(nullif(substring(content, 658, 9), '000000000'))::varchar(9) as business_party_29_id
, trim(nullif(substring(content, 667, 4), '0000'))::varchar(4) as business_party_29_role_code
, trim(nullif(substring(content, 671, 1), '0'))::varchar(1) as business_party_29_has_discretion
-- , trim(nullif(substring(content, 672, 7), '0000000'))::varchar(7) as not_used_32
, trim(nullif(substring(content, 679, 1), '0'))::varchar(1) as business_party_30_transaction_code
, trim(nullif(substring(content, 680, 9), '000000000'))::varchar(9) as business_party_30_id
, trim(nullif(substring(content, 689, 4), '0000'))::varchar(4) as business_party_30_role_code
, trim(nullif(substring(content, 693, 1), '0'))::varchar(1) as business_party_30_has_discretion
-- , trim(nullif(substring(content, 694, 7), '0000000'))::varchar(7) as not_used_33
, trim(nullif(substring(content, 701, 1), '0'))::varchar(1) as business_party_31_transaction_code
, trim(nullif(substring(content, 702, 9), '000000000'))::varchar(9) as business_party_31_id
, trim(nullif(substring(content, 711, 4), '0000'))::varchar(4) as business_party_31_role_code
, trim(nullif(substring(content, 715, 1), '0'))::varchar(1) as business_party_31_has_discretion
-- , trim(nullif(substring(content, 716, 7), '0000000'))::varchar(7) as not_used_34
, trim(nullif(substring(content, 723, 1), '0'))::varchar(1) as business_party_32_transaction_code
, trim(nullif(substring(content, 724, 9), '000000000'))::varchar(9) as business_party_32_id
, trim(nullif(substring(content, 733, 4), '0000'))::varchar(4) as business_party_32_role_code
, trim(nullif(substring(content, 737, 1), '0'))::varchar(1) as business_party_32_has_discretion
-- , trim(nullif(substring(content, 738, 7), '0000000'))::varchar(7) as not_used_35
, nullif(nullif(trim(substring(content, 745, 5)), '00000'), '')::int as secondary_sequence_number
, trim(nullif(substring(content, 750, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'N'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
