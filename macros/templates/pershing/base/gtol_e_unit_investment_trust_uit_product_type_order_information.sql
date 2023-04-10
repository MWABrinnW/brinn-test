{%- macro gtol_e_unit_investment_trust_uit_product_type_order_information(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 2), '00'))::varchar(2) as transaction_code
, trim(nullif(substring(content, 3, 1), '0'))::varchar(1) as record_indicator_value
, nullif(nullif(trim(substring(content, 4, 8)), '00000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 12, 10), '0000000000'))::varchar(10) as account_number
-- , trim(nullif(substring(content, 22, 1), '0'))::varchar(1) as reserved
, trim(nullif(substring(content, 23, 3), '000'))::varchar(3) as introducing_broker_dealer_ibd_number
-- , trim(nullif(substring(content, 26, 3), '000'))::varchar(3) as reserved_2
-- , trim(nullif(substring(content, 29, 14), '00000000000000'))::varchar(14) as not_used
, trim(nullif(substring(content, 43, 2), '00'))::varchar(2) as order_source_system_identifier
, trim(nullif(substring(content, 45, 20), '00000000000000000000'))::varchar(20) as order_source_system_order_id
, try_to_date(nullif(substring(content, 65, 8), '00000000'), 'YYYYMMDD')::date as order_source_system_creation_date
, try_to_time(nullif(substring(content, 73, 12), '000000000000'), 'HH24MISSFF6')::time as order_source_system_creation_time
, nullif(nullif(trim(substring(content, 85, 8)), '00000000'), '')::int as order_source_system_update_date
, try_to_time(nullif(substring(content, 93, 12), '000000000000'), 'HH24MISSFF6')::time as order_source_system_update_time
, trim(nullif(substring(content, 105, 2), '00'))::varchar(2) as order_record_type
, try_to_date(nullif(substring(content, 107, 8), '00000000'), 'YYYYMMDD')::date as date_introducing_broker_receives_order
, try_to_time(nullif(substring(content, 115, 12), '000000000000'), 'HH24MISSFF6')::time as time_introducing_broker_receives_order
, trim(nullif(substring(content, 127, 10), '0000000000'))::varchar(10) as ibd_order_receipt_time_zone
, try_to_date(nullif(substring(content, 137, 8), '00000000'), 'YYYYMMDD')::date as date_pershing_associate_enters_order
, try_to_time(nullif(substring(content, 145, 12), '000000000000'), 'HH24MISSFF6')::time as time_pershing_associate_enters_order
, trim(nullif(substring(content, 157, 10), '0000000000'))::varchar(10) as pershing_associate_order_entry_time_zone
, try_to_date(nullif(substring(content, 167, 8), '00000000'), 'YYYYMMDD')::date as order_activity_effective_date
, trim(nullif(substring(content, 175, 10), '0000000000'))::varchar(10) as order_activity_effective_time_zone
, nullif(nullif(trim(substring(content, 185, 8)), '00000000'), '')::int as order_activity_status_update_date
, try_to_time(nullif(substring(content, 193, 12), '000000000000'), 'HH24MISSFF6')::time as order_activity_status_update_time
, trim(nullif(substring(content, 205, 1), '0'))::varchar(1) as discretion_exercised_code
, trim(nullif(substring(content, 206, 2), '00'))::varchar(2) as price_type_code
, trim(nullif(substring(content, 208, 2), '00'))::varchar(2) as time_in_force_code
, trim(nullif(substring(content, 210, 1), '0'))::varchar(1) as all_or_none_indicator
, trim(nullif(substring(content, 211, 2), '00'))::varchar(2) as buysell_qualifier_code
, trim(nullif(substring(content, 213, 2), '00'))::varchar(2) as cancel_status_code
, trim(nullif(substring(content, 215, 1), '0'))::varchar(1) as cancelcorrect_reason_code
, trim(nullif(substring(content, 216, 1), '0'))::varchar(1) as callput_indicator
, trim(nullif(substring(content, 217, 1), '0'))::varchar(1) as product_identifier_for_record_e
, to_number(nullif(nullif(trim(substring(content, 218, 18)), '000000000000000000'), '')) / power(10, 05)::number as lot_size
, to_number(nullif(nullif(trim(substring(content, 236, 18)), '000000000000000000'), '')) / power(10, 02)::number as amount
, to_number(nullif(nullif(trim(substring(content, 254, 18)), '000000000000000000'), '')) / power(10, 02)::number as miscellaneous_fee
, try_to_time(nullif(substring(content, 272, 12), '000000000000'), 'HH24MISSFF6')::time as cutoff_time
-- , trim(nullif(substring(content, 284, 24), '000000000000000000000000'))::varchar(24) as not_used_2
, trim(nullif(substring(content, 308, 1), '0'))::varchar(1) as input_lot_size_type
, trim(nullif(substring(content, 309, 1), '0'))::varchar(1) as overunder_buy_rule_code
, trim(nullif(substring(content, 310, 1), '0'))::varchar(1) as nav_status_code
, trim(nullif(substring(content, 311, 100), '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(100) as security_description
, trim(nullif(substring(content, 411, 1), '0'))::varchar(1) as rollover_indicator
, iff(substring(content, 430, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 412, 18)), '000000000000000000'), '')) / power(10, 02)::number as break_point_amount
, trim(nullif(substring(content, 430, 1), '0'))::varchar(1) as break_point_amount_sign
, iff(substring(content, 449, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 431, 18)), '000000000000000000'), '')) / power(10, 05)::number as break_point_quantity
, trim(nullif(substring(content, 449, 1), '0'))::varchar(1) as break_point_quantity_sign
, trim(nullif(substring(content, 450, 1), '0'))::varchar(1) as break_point_type_code
, trim(nullif(substring(content, 451, 40), '0000000000000000000000000000000000000000'))::varchar(40) as external_vendor_id
-- , trim(nullif(substring(content, 491, 176), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(176) as not_used_3
, trim(nullif(substring(content, 667, 2), '00'))::varchar(2) as cancelcorrect_code
, trim(nullif(substring(content, 669, 40), '0000000000000000000000000000000000000000'))::varchar(40) as location_of_security
, trim(nullif(substring(content, 709, 40), '0000000000000000000000000000000000000000'))::varchar(40) as comments
, trim(nullif(substring(content, 749, 40), '0000000000000000000000000000000000000000'))::varchar(40) as external_client_order_id
, iff(substring(content, 807, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 789, 18)), '000000000000000000'), '')) / power(10, 05)::number as leaves_quantity
, trim(nullif(substring(content, 807, 1), '0'))::varchar(1) as leaves_quantity_sign
, trim(nullif(substring(content, 808, 15), '000000000000000'))::varchar(15) as source_system_creation_user_id
, trim(nullif(substring(content, 823, 8), '00000000'))::varchar(8) as source_system_update_user_id
, trim(nullif(substring(content, 831, 2), '00'))::varchar(2) as order_execution_status
, try_to_date(nullif(substring(content, 833, 8), '00000000'), 'YYYYMMDD')::date as pershing_system_order_approval_date
, try_to_time(nullif(substring(content, 841, 12), '000000000000'), 'HH24MISSFF6')::time as pershing_system_order_approval_time
, trim(nullif(substring(content, 853, 15), '000000000000000'))::varchar(15) as pershing_system_order_approval_user_id
, trim(nullif(substring(content, 868, 40), '0000000000000000000000000000000000000000'))::varchar(40) as ibd_order_received_from
, try_to_date(nullif(substring(content, 908, 8), '00000000'), 'YYYYMMDD')::date as pershing_order_receipt_date
, try_to_time(nullif(substring(content, 916, 12), '000000000000'), 'HH24MISSFF6')::time as pershing_order_receipt_time
, trim(nullif(substring(content, 928, 10), '0000000000'))::varchar(10) as pershing_order_receipt_time_zone
, trim(nullif(substring(content, 938, 40), '0000000000000000000000000000000000000000'))::varchar(40) as pershing_order_received_from
, try_to_date(nullif(substring(content, 978, 8), '00000000'), 'YYYYMMDD')::date as external_order_entry_date
, try_to_time(nullif(substring(content, 986, 12), '000000000000'), 'HH24MISSFF6')::time as external_order_entry_time
, trim(nullif(substring(content, 998, 10), '0000000000'))::varchar(10) as external_order_entry_time_zone
, trim(nullif(substring(content, 1008, 16), '0000000000000000'))::varchar(16) as execution_facility_name
, trim(nullif(substring(content, 1024, 2), '00'))::varchar(2) as order_type_code
, trim(nullif(substring(content, 1026, 20), '00000000000000000000'))::varchar(20) as pershing_internal_trade_reference_number
, trim(nullif(substring(content, 1046, 1), '0'))::varchar(1) as tick_size_pilot_retail_attestation_indicator
, trim(nullif(substring(content, 1047, 2), '00'))::varchar(2) as brokeragebank_custody_indicator
, trim(nullif(substring(content, 1049, 1), '0'))::varchar(1) as calculated_uit_rollover_indicator
, trim(nullif(substring(content, 1050, 1), '0'))::varchar(1) as applied_uit_rollover_indicator
, trim(nullif(substring(content, 1051, 3), '000'))::varchar(3) as principalagency_indicator
, trim(nullif(substring(content, 1054, 1), '0'))::varchar(1) as liquidity_indicator
, trim(nullif(substring(content, 1055, 4), '0000'))::varchar(4) as liquidity_type
, trim(nullif(substring(content, 1059, 40), '0000000000000000000000000000000000000000'))::varchar(40) as firm_designated_identifier_fdid
-- , trim(nullif(substring(content, 1099, 125), '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'))::varchar(125) as not_used_4
, nullif(nullif(trim(substring(content, 1224, 4)), '0000'), '')::int as pershing_internal_version_number
, trim(nullif(substring(content, 1228, 18), '000000000000000000'))::varchar(18) as order_identifier
, trim(nullif(substring(content, 1246, 3), '000'))::varchar(3) as investment_professional_ip_of_record
-- , trim(nullif(substring(content, 1249, 1), '0'))::varchar(1) as reserved_3
, trim(nullif(substring(content, 1250, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 3, 1) = 'E'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
