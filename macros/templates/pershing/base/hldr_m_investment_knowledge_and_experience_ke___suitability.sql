{%- macro hldr_m_investment_knowledge_and_experience_ke___suitability(src) -%}

select
trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_codes
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 9), '000000000'))::varchar(9) as account_number
, trim(nullif(substring(content, 21, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 24, 1), '0'))::varchar(1) as not_used
, trim(nullif(substring(content, 25, 4), '0000'))::varchar(4) as investment_professional_ip_number
, trim(nullif(substring(content, 29, 10), '0000000000'))::varchar(10) as account_short_name
-- , trim(nullif(substring(content, 39, 2), '00'))::varchar(2) as not_used_2
, trim(nullif(substring(content, 41, 9), '000000000'))::varchar(9) as introducing_firm
, trim(nullif(substring(content, 50, 20), '00000000000000000000'))::varchar(20) as reserved_for_additional_hierarchical_levels
, trim(nullif(substring(content, 70, 1), '0'))::varchar(1) as record_transaction_code
, trim(nullif(substring(content, 71, 3), '000'))::varchar(3) as secondary_sequence_number
-- , trim(nullif(substring(content, 74, 2), '00'))::varchar(2) as reserved
, trim(nullif(substring(content, 76, 3), '000'))::varchar(3) as client_type
, trim(nullif(substring(content, 79, 4), '0000'))::varchar(4) as client_role
, trim(nullif(substring(content, 83, 20), '00000000000000000000'))::varchar(20) as external_client_id_supplied_by_customer
, trim(nullif(substring(content, 103, 9), '000000000'))::varchar(9) as internal_pershing_assigned_client_id
-- , trim(nullif(substring(content, 112, 20), '00000000000000000000'))::varchar(20) as reserved_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as general_investment_experience
, nullif(nullif(trim(substring(content, 133, 3)), '000'), '')::int as secondary_sequence_number_for_k
, trim(nullif(substring(content, 136, 4), '0000'))::varchar(4) as investment_instrument_code_1
, trim(nullif(substring(content, 140, 1), '0'))::varchar(1) as investment_experience_1
, nullif(nullif(trim(substring(content, 141, 4)), '0000'), '')::int as year_investment_experience_began_1
-- , trim(nullif(substring(content, 145, 4), '0000'))::varchar(4) as reserved_3
, trim(nullif(substring(content, 149, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_1
, trim(nullif(substring(content, 153, 1), '0'))::varchar(1) as for_pershing_internal_use_only
-- , trim(nullif(substring(content, 154, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_4
, trim(nullif(substring(content, 194, 4), '0000'))::varchar(4) as investment_instrument_code_2
, trim(nullif(substring(content, 198, 1), '0'))::varchar(1) as investment_experience_2
, nullif(nullif(trim(substring(content, 199, 4)), '0000'), '')::int as year_investment_experience_began_2
-- , trim(nullif(substring(content, 203, 4), '0000'))::varchar(4) as reserved_5
, trim(nullif(substring(content, 207, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_2
, trim(nullif(substring(content, 211, 1), '0'))::varchar(1) as for_pershing_internal_use_only_2
-- , trim(nullif(substring(content, 212, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_6
, trim(nullif(substring(content, 252, 4), '0000'))::varchar(4) as investment_instrument_code_3
, trim(nullif(substring(content, 256, 1), '0'))::varchar(1) as investment_experience_3
, nullif(nullif(trim(substring(content, 257, 4)), '0000'), '')::int as year_investment_experience_began_3
-- , trim(nullif(substring(content, 261, 4), '0000'))::varchar(4) as reserved_7
, trim(nullif(substring(content, 265, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_3
, trim(nullif(substring(content, 269, 1), '0'))::varchar(1) as for_pershing_internal_use_only_3
-- , trim(nullif(substring(content, 270, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_8
, trim(nullif(substring(content, 310, 4), '0000'))::varchar(4) as investment_instrument_code_4
, trim(nullif(substring(content, 314, 1), '0'))::varchar(1) as investment_experience_4
, nullif(nullif(trim(substring(content, 315, 4)), '0000'), '')::int as year_investment_experience_began_4
-- , trim(nullif(substring(content, 319, 4), '0000'))::varchar(4) as reserved_9
, trim(nullif(substring(content, 323, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_4
, trim(nullif(substring(content, 327, 1), '0'))::varchar(1) as for_pershing_internal_use_only_4
-- , trim(nullif(substring(content, 328, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_10
, trim(nullif(substring(content, 368, 4), '0000'))::varchar(4) as investment_instrument_code_5
, trim(nullif(substring(content, 372, 1), '0'))::varchar(1) as investment_experience_5
, nullif(nullif(trim(substring(content, 373, 4)), '0000'), '')::int as year_investment_experience_began_5
-- , trim(nullif(substring(content, 377, 4), '0000'))::varchar(4) as reserved_11
, trim(nullif(substring(content, 381, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_5
, trim(nullif(substring(content, 385, 1), '0'))::varchar(1) as for_pershing_internal_use_only_5
-- , trim(nullif(substring(content, 386, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_12
, trim(nullif(substring(content, 426, 4), '0000'))::varchar(4) as investment_instrument_code_6
, trim(nullif(substring(content, 430, 1), '0'))::varchar(1) as investment_experience_6
, nullif(nullif(trim(substring(content, 431, 4)), '0000'), '')::int as year_investment_experience_began_6
-- , trim(nullif(substring(content, 435, 4), '0000'))::varchar(4) as reserved_13
, trim(nullif(substring(content, 439, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_6
, trim(nullif(substring(content, 443, 1), '0'))::varchar(1) as for_pershing_internal_use_only_6
-- , trim(nullif(substring(content, 444, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_14
, trim(nullif(substring(content, 484, 4), '0000'))::varchar(4) as investment_instrument_code_7
, trim(nullif(substring(content, 488, 1), '0'))::varchar(1) as investment_experience_7
, nullif(nullif(trim(substring(content, 489, 4)), '0000'), '')::int as year_investment_experience_began_7
-- , trim(nullif(substring(content, 493, 4), '0000'))::varchar(4) as reserved_15
, trim(nullif(substring(content, 497, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_7
, trim(nullif(substring(content, 501, 1), '0'))::varchar(1) as for_pershing_internal_use_only_7
-- , trim(nullif(substring(content, 502, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_16
, trim(nullif(substring(content, 542, 4), '0000'))::varchar(4) as investment_instrument_code_8
, trim(nullif(substring(content, 546, 1), '0'))::varchar(1) as investment_experience_8
, nullif(nullif(trim(substring(content, 547, 4)), '0000'), '')::int as year_investment_experience_began_8
-- , trim(nullif(substring(content, 551, 4), '0000'))::varchar(4) as reserved_17
, trim(nullif(substring(content, 555, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_8
, trim(nullif(substring(content, 559, 1), '0'))::varchar(1) as for_pershing_internal_use_only_8
-- , trim(nullif(substring(content, 560, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_18
, trim(nullif(substring(content, 600, 4), '0000'))::varchar(4) as investment_instrument_code_9
, trim(nullif(substring(content, 604, 1), '0'))::varchar(1) as investment_experience_9
, nullif(nullif(trim(substring(content, 605, 4)), '0000'), '')::int as year_investment_experience_began_9
-- , trim(nullif(substring(content, 609, 4), '0000'))::varchar(4) as reserved_19
, trim(nullif(substring(content, 613, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_9
, trim(nullif(substring(content, 617, 1), '0'))::varchar(1) as for_pershing_internal_use_only_9
-- , trim(nullif(substring(content, 618, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_20
, trim(nullif(substring(content, 658, 4), '0000'))::varchar(4) as investment_instrument_code_10
, trim(nullif(substring(content, 662, 1), '0'))::varchar(1) as investment_experience_10
, nullif(nullif(trim(substring(content, 663, 4)), '0000'), '')::int as year_investment_experience_began_10
-- , trim(nullif(substring(content, 667, 4), '0000'))::varchar(4) as reserved_21
, trim(nullif(substring(content, 671, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_10
, trim(nullif(substring(content, 675, 1), '0'))::varchar(1) as for_pershing_internal_use_only_10
-- , trim(nullif(substring(content, 676, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_22
, trim(nullif(substring(content, 716, 4), '0000'))::varchar(4) as investment_instrument_code_11
, trim(nullif(substring(content, 720, 1), '0'))::varchar(1) as investment_experience_11
, nullif(nullif(trim(substring(content, 721, 4)), '0000'), '')::int as year_investment_experience_began_11
-- , trim(nullif(substring(content, 725, 4), '0000'))::varchar(4) as reserved_23
, trim(nullif(substring(content, 729, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_11
, trim(nullif(substring(content, 733, 1), '0'))::varchar(1) as for_pershing_internal_use_only_11
-- , trim(nullif(substring(content, 734, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_24
, trim(nullif(substring(content, 774, 4), '0000'))::varchar(4) as investment_instrument_code_12
, trim(nullif(substring(content, 778, 1), '0'))::varchar(1) as investment_experience_12
, nullif(nullif(trim(substring(content, 779, 4)), '0000'), '')::int as year_investment_experience_began_12
-- , trim(nullif(substring(content, 783, 4), '0000'))::varchar(4) as reserved_25
, trim(nullif(substring(content, 787, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_12
, trim(nullif(substring(content, 791, 1), '0'))::varchar(1) as for_pershing_internal_use_only_12
-- , trim(nullif(substring(content, 792, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_26
, trim(nullif(substring(content, 832, 4), '0000'))::varchar(4) as investment_instrument_code_13
, trim(nullif(substring(content, 836, 1), '0'))::varchar(1) as investment_experience_13
, nullif(nullif(trim(substring(content, 837, 4)), '0000'), '')::int as year_investment_experience_began_13
-- , trim(nullif(substring(content, 841, 4), '0000'))::varchar(4) as reserved_27
, trim(nullif(substring(content, 845, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_13
, trim(nullif(substring(content, 849, 1), '0'))::varchar(1) as for_pershing_internal_use_only_13
-- , trim(nullif(substring(content, 850, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_28
, trim(nullif(substring(content, 890, 4), '0000'))::varchar(4) as investment_instrument_code_14
, trim(nullif(substring(content, 894, 1), '0'))::varchar(1) as investment_experience_14
, nullif(nullif(trim(substring(content, 895, 4)), '0000'), '')::int as year_investment_experience_began_14
-- , trim(nullif(substring(content, 899, 4), '0000'))::varchar(4) as reserved_29
, trim(nullif(substring(content, 903, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_14
, trim(nullif(substring(content, 907, 1), '0'))::varchar(1) as for_pershing_internal_use_only_14
-- , trim(nullif(substring(content, 908, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_30
, trim(nullif(substring(content, 948, 4), '0000'))::varchar(4) as investment_instrument_code_15
, trim(nullif(substring(content, 952, 1), '0'))::varchar(1) as investment_experience_15
, nullif(nullif(trim(substring(content, 953, 4)), '0000'), '')::int as year_investment_experience_began_15
-- , trim(nullif(substring(content, 957, 4), '0000'))::varchar(4) as reserved_31
, trim(nullif(substring(content, 961, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_15
, trim(nullif(substring(content, 965, 1), '0'))::varchar(1) as for_pershing_internal_use_only_15
-- , trim(nullif(substring(content, 966, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_32
, trim(nullif(substring(content, 1006, 4), '0000'))::varchar(4) as investment_instrument_code_16
, trim(nullif(substring(content, 1010, 1), '0'))::varchar(1) as investment_experience_16
, nullif(nullif(trim(substring(content, 1011, 4)), '0000'), '')::int as year_investment_experience_began_16
-- , trim(nullif(substring(content, 1015, 4), '0000'))::varchar(4) as reserved_33
, trim(nullif(substring(content, 1019, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_16
, trim(nullif(substring(content, 1023, 1), '0'))::varchar(1) as for_pershing_internal_use_only_16
-- , trim(nullif(substring(content, 1024, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_34
, trim(nullif(substring(content, 1064, 4), '0000'))::varchar(4) as investment_instrument_code_17
, trim(nullif(substring(content, 1068, 1), '0'))::varchar(1) as investment_experience_17
, nullif(nullif(trim(substring(content, 1069, 4)), '0000'), '')::int as year_investment_experience_began_17
-- , trim(nullif(substring(content, 1073, 4), '0000'))::varchar(4) as reserved_35
, trim(nullif(substring(content, 1077, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_17
, trim(nullif(substring(content, 1081, 1), '0'))::varchar(1) as for_pershing_internal_use_only_17
-- , trim(nullif(substring(content, 1082, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_36
, trim(nullif(substring(content, 1122, 4), '0000'))::varchar(4) as investment_instrument_code_18
, trim(nullif(substring(content, 1126, 1), '0'))::varchar(1) as investment_experience_18
, nullif(nullif(trim(substring(content, 1127, 4)), '0000'), '')::int as year_investment_experience_began_18
-- , trim(nullif(substring(content, 1131, 4), '0000'))::varchar(4) as reserved_37
, trim(nullif(substring(content, 1135, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_18
, trim(nullif(substring(content, 1139, 1), '0'))::varchar(1) as for_pershing_internal_use_only_18
-- , trim(nullif(substring(content, 1140, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_38
, trim(nullif(substring(content, 1180, 4), '0000'))::varchar(4) as investment_instrument_code_19
, trim(nullif(substring(content, 1184, 1), '0'))::varchar(1) as investment_experience_19
, nullif(nullif(trim(substring(content, 1185, 4)), '0000'), '')::int as year_investment_experience_began_19
-- , trim(nullif(substring(content, 1189, 4), '0000'))::varchar(4) as reserved_39
, trim(nullif(substring(content, 1193, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_19
, trim(nullif(substring(content, 1197, 1), '0'))::varchar(1) as for_pershing_internal_use_only_19
-- , trim(nullif(substring(content, 1198, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_40
, trim(nullif(substring(content, 1238, 4), '0000'))::varchar(4) as investment_instrument_code_20
, trim(nullif(substring(content, 1242, 1), '0'))::varchar(1) as investment_experience_20
, nullif(nullif(trim(substring(content, 1243, 4)), '0000'), '')::int as year_investment_experience_began_20
-- , trim(nullif(substring(content, 1247, 4), '0000'))::varchar(4) as reserved_41
, trim(nullif(substring(content, 1251, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_20
, trim(nullif(substring(content, 1255, 1), '0'))::varchar(1) as for_pershing_internal_use_only_20
-- , trim(nullif(substring(content, 1256, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_42
, trim(nullif(substring(content, 1296, 4), '0000'))::varchar(4) as investment_instrument_code_21
, trim(nullif(substring(content, 1300, 1), '0'))::varchar(1) as investment_experience_21
, nullif(nullif(trim(substring(content, 1301, 4)), '0000'), '')::int as year_investment_experience_began_21
-- , trim(nullif(substring(content, 1305, 4), '0000'))::varchar(4) as reserved_43
, trim(nullif(substring(content, 1309, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_21
, trim(nullif(substring(content, 1313, 1), '0'))::varchar(1) as for_pershing_internal_use_only_21
-- , trim(nullif(substring(content, 1314, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_44
, trim(nullif(substring(content, 1354, 4), '0000'))::varchar(4) as investment_instrument_code_22
, trim(nullif(substring(content, 1358, 1), '0'))::varchar(1) as investment_experience_22
, nullif(nullif(trim(substring(content, 1359, 4)), '0000'), '')::int as year_investment_experience_began_22
-- , trim(nullif(substring(content, 1363, 4), '0000'))::varchar(4) as reserved_45
, trim(nullif(substring(content, 1367, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_22
, trim(nullif(substring(content, 1371, 1), '0'))::varchar(1) as for_pershing_internal_use_only_22
-- , trim(nullif(substring(content, 1372, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_46
, trim(nullif(substring(content, 1412, 4), '0000'))::varchar(4) as investment_instrument_code_23
, trim(nullif(substring(content, 1416, 1), '0'))::varchar(1) as investment_experience_23
, nullif(nullif(trim(substring(content, 1417, 4)), '0000'), '')::int as year_investment_experience_began_23
-- , trim(nullif(substring(content, 1421, 4), '0000'))::varchar(4) as reserved_47
, trim(nullif(substring(content, 1425, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_23
, trim(nullif(substring(content, 1429, 1), '0'))::varchar(1) as for_pershing_internal_use_only_23
-- , trim(nullif(substring(content, 1430, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_48
, trim(nullif(substring(content, 1470, 4), '0000'))::varchar(4) as investment_instrument_code_24
, trim(nullif(substring(content, 1474, 1), '0'))::varchar(1) as investment_experience_24
, nullif(nullif(trim(substring(content, 1475, 4)), '0000'), '')::int as year_investment_experience_began_24
-- , trim(nullif(substring(content, 1479, 4), '0000'))::varchar(4) as reserved_49
, trim(nullif(substring(content, 1483, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_24
, trim(nullif(substring(content, 1487, 1), '0'))::varchar(1) as for_pershing_internal_use_only_24
-- , trim(nullif(substring(content, 1488, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_50
, trim(nullif(substring(content, 1528, 4), '0000'))::varchar(4) as investment_instrument_code_25
, trim(nullif(substring(content, 1532, 1), '0'))::varchar(1) as investment_experience_25
, nullif(nullif(trim(substring(content, 1533, 4)), '0000'), '')::int as year_investment_experience_began_25
-- , trim(nullif(substring(content, 1537, 4), '0000'))::varchar(4) as reserved_51
, trim(nullif(substring(content, 1541, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_25
, trim(nullif(substring(content, 1545, 1), '0'))::varchar(1) as for_pershing_internal_use_only_25
-- , trim(nullif(substring(content, 1546, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_52
, trim(nullif(substring(content, 1586, 4), '0000'))::varchar(4) as investment_instrument_code_26
, trim(nullif(substring(content, 1590, 1), '0'))::varchar(1) as investment_experience_26
, nullif(nullif(trim(substring(content, 1591, 4)), '0000'), '')::int as year_investment_experience_began_26
-- , trim(nullif(substring(content, 1595, 4), '0000'))::varchar(4) as reserved_53
, trim(nullif(substring(content, 1599, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_26
, trim(nullif(substring(content, 1603, 1), '0'))::varchar(1) as for_pershing_internal_use_only_26
-- , trim(nullif(substring(content, 1604, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_54
, trim(nullif(substring(content, 1644, 4), '0000'))::varchar(4) as investment_instrument_code_27
, trim(nullif(substring(content, 1648, 1), '0'))::varchar(1) as investment_experience_27
, nullif(nullif(trim(substring(content, 1649, 4)), '0000'), '')::int as year_investment_experience_began_27
-- , trim(nullif(substring(content, 1653, 4), '0000'))::varchar(4) as reserved_55
, trim(nullif(substring(content, 1657, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_27
, trim(nullif(substring(content, 1661, 1), '0'))::varchar(1) as for_pershing_internal_use_only_27
-- , trim(nullif(substring(content, 1662, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_56
, trim(nullif(substring(content, 1702, 4), '0000'))::varchar(4) as investment_instrument_code_28
, trim(nullif(substring(content, 1706, 1), '0'))::varchar(1) as investment_experience_28
, nullif(nullif(trim(substring(content, 1707, 4)), '0000'), '')::int as year_investment_experience_began_28
-- , trim(nullif(substring(content, 1711, 4), '0000'))::varchar(4) as reserved_57
, trim(nullif(substring(content, 1715, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_28
, trim(nullif(substring(content, 1719, 1), '0'))::varchar(1) as for_pershing_internal_use_only_28
-- , trim(nullif(substring(content, 1720, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_58
, trim(nullif(substring(content, 1760, 4), '0000'))::varchar(4) as investment_instrument_code_29
, trim(nullif(substring(content, 1764, 1), '0'))::varchar(1) as investment_experience_29
, nullif(nullif(trim(substring(content, 1765, 4)), '0000'), '')::int as year_investment_experience_began_29
-- , trim(nullif(substring(content, 1769, 4), '0000'))::varchar(4) as reserved_59
, trim(nullif(substring(content, 1773, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_29
, trim(nullif(substring(content, 1777, 1), '0'))::varchar(1) as for_pershing_internal_use_only_29
-- , trim(nullif(substring(content, 1778, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_60
, trim(nullif(substring(content, 1818, 4), '0000'))::varchar(4) as investment_instrument_code_30
, trim(nullif(substring(content, 1822, 1), '0'))::varchar(1) as investment_experience_30
, nullif(nullif(trim(substring(content, 1823, 4)), '0000'), '')::int as year_investment_experience_began_30
-- , trim(nullif(substring(content, 1827, 4), '0000'))::varchar(4) as reserved_61
, trim(nullif(substring(content, 1831, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_30
, trim(nullif(substring(content, 1835, 1), '0'))::varchar(1) as for_pershing_internal_use_only_30
-- , trim(nullif(substring(content, 1836, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_62
, trim(nullif(substring(content, 1876, 4), '0000'))::varchar(4) as investment_instrument_code_31
, trim(nullif(substring(content, 1880, 1), '0'))::varchar(1) as investment_experience_31
, nullif(nullif(trim(substring(content, 1881, 4)), '0000'), '')::int as year_investment_experience_began_31
-- , trim(nullif(substring(content, 1885, 4), '0000'))::varchar(4) as reserved_63
, trim(nullif(substring(content, 1889, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_31
, trim(nullif(substring(content, 1893, 1), '0'))::varchar(1) as for_pershing_internal_use_only_31
-- , trim(nullif(substring(content, 1894, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_64
, trim(nullif(substring(content, 1934, 4), '0000'))::varchar(4) as investment_instrument_code_32
, trim(nullif(substring(content, 1938, 1), '0'))::varchar(1) as investment_experience_32
, nullif(nullif(trim(substring(content, 1939, 4)), '0000'), '')::int as year_investment_experience_began_32
-- , trim(nullif(substring(content, 1943, 4), '0000'))::varchar(4) as reserved_65
, trim(nullif(substring(content, 1947, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_32
, trim(nullif(substring(content, 1951, 1), '0'))::varchar(1) as for_pershing_internal_use_only_32
-- , trim(nullif(substring(content, 1952, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_66
, trim(nullif(substring(content, 1992, 4), '0000'))::varchar(4) as investment_instrument_code_33
, trim(nullif(substring(content, 1996, 1), '0'))::varchar(1) as investment_experience_33
, nullif(nullif(trim(substring(content, 1997, 4)), '0000'), '')::int as year_investment_experience_began_33
-- , trim(nullif(substring(content, 2001, 4), '0000'))::varchar(4) as reserved_67
, trim(nullif(substring(content, 2005, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_33
, trim(nullif(substring(content, 2009, 1), '0'))::varchar(1) as for_pershing_internal_use_only_33
-- , trim(nullif(substring(content, 2010, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_68
, trim(nullif(substring(content, 2050, 4), '0000'))::varchar(4) as investment_instrument_code_34
, trim(nullif(substring(content, 2054, 1), '0'))::varchar(1) as investment_experience_34
, nullif(nullif(trim(substring(content, 2055, 4)), '0000'), '')::int as year_investment_experience_began_34
-- , trim(nullif(substring(content, 2059, 4), '0000'))::varchar(4) as reserved_69
, trim(nullif(substring(content, 2063, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_34
, trim(nullif(substring(content, 2067, 1), '0'))::varchar(1) as for_pershing_internal_use_only_34
-- , trim(nullif(substring(content, 2068, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_70
, trim(nullif(substring(content, 2108, 4), '0000'))::varchar(4) as investment_instrument_code_35
, trim(nullif(substring(content, 2112, 1), '0'))::varchar(1) as investment_experience_35
, nullif(nullif(trim(substring(content, 2113, 4)), '0000'), '')::int as year_investment_experience_began_35
-- , trim(nullif(substring(content, 2117, 4), '0000'))::varchar(4) as reserved_71
, trim(nullif(substring(content, 2121, 4), '0000'))::varchar(4) as source_of_investment_product_knowledge_35
, trim(nullif(substring(content, 2125, 1), '0'))::varchar(1) as for_pershing_internal_use_only_35
-- , trim(nullif(substring(content, 2126, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_72
, trim(nullif(substring(content, 2166, 30), '000000000000000000000000000000'))::varchar(30) as name_of_other_investment_instrument
, trim(nullif(substring(content, 2196, 4), '0000'))::varchar(4) as other_investment_instrument_code
, trim(nullif(substring(content, 2200, 1), '0'))::varchar(1) as other_investment_experience
, nullif(nullif(trim(substring(content, 2201, 4)), '0000'), '')::int as year_other_investment_experience_began
-- , trim(nullif(substring(content, 2205, 4), '0000'))::varchar(4) as reserved_73
, trim(nullif(substring(content, 2209, 4), '0000'))::varchar(4) as source_of_other_investment_product_knowledge
, trim(nullif(substring(content, 2213, 1), '0'))::varchar(1) as for_pershing_internal_use_only_36
-- , trim(nullif(substring(content, 2214, 40), '0000000000000000000000000000000000000000'))::varchar(40) as reserved_74
, nullif(nullif(trim(substring(content, 2254, 4)), '0000'), '')::int as year_equity_option_buyer_experience_began
, nullif(nullif(trim(substring(content, 2258, 4)), '0000'), '')::int as year_equity_option_seller_experience_began
, trim(nullif(substring(content, 2262, 1), '0'))::varchar(1) as suitability_for_equity_options
, trim(nullif(substring(content, 2263, 1), '0'))::varchar(1) as risk_awareness_for_equity_options
-- , trim(nullif(substring(content, 2264, 20), '00000000000000000000'))::varchar(20) as reserved_75
, nullif(nullif(trim(substring(content, 2284, 4)), '0000'), '')::int as year_currency_option_buyer_experience_began
, nullif(nullif(trim(substring(content, 2288, 4)), '0000'), '')::int as year_currency_option_seller_experience_began
, trim(nullif(substring(content, 2292, 1), '0'))::varchar(1) as suitability_for_currency_options
, trim(nullif(substring(content, 2293, 1), '0'))::varchar(1) as risk_awareness_for_currency_options
-- , trim(nullif(substring(content, 2294, 20), '00000000000000000000'))::varchar(20) as reserved_76
, nullif(nullif(trim(substring(content, 2314, 4)), '0000'), '')::int as year_debt_option_buyer_experience_began
, nullif(nullif(trim(substring(content, 2318, 4)), '0000'), '')::int as year_debt_option_seller_experience_began
, trim(nullif(substring(content, 2322, 1), '0'))::varchar(1) as suitability_for_debt_options
, trim(nullif(substring(content, 2323, 1), '0'))::varchar(1) as risk_awareness_for_debt_options
-- , trim(nullif(substring(content, 2324, 20), '00000000000000000000'))::varchar(20) as reserved_77
, nullif(nullif(trim(substring(content, 2344, 4)), '0000'), '')::int as year_index_option_buyer_experience_began
, nullif(nullif(trim(substring(content, 2348, 4)), '0000'), '')::int as year_index_option_seller_experience_began
, trim(nullif(substring(content, 2352, 1), '0'))::varchar(1) as suitability_for_index_options
, trim(nullif(substring(content, 2353, 1), '0'))::varchar(1) as risk_awareness_for_index_options
-- , trim(nullif(substring(content, 2354, 20), '00000000000000000000'))::varchar(20) as reserved_78
, nullif(nullif(trim(substring(content, 2374, 4)), '0000'), '')::int as year_otc_option_buyer_experience_began
, nullif(nullif(trim(substring(content, 2378, 4)), '0000'), '')::int as year_otc_option_seller_experience_began
, trim(nullif(substring(content, 2382, 1), '0'))::varchar(1) as suitability_for_otc_options
, trim(nullif(substring(content, 2383, 1), '0'))::varchar(1) as risk_awareness_for_otc_options
-- , trim(nullif(substring(content, 2384, 20), '00000000000000000000'))::varchar(20) as reserved_79
-- , trim(nullif(substring(content, 2404, 96), '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(96) as not_used_3
, trim(nullif(substring(content, 2500, 1), '0'))::varchar(1) as literally_x
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
