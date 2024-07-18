{%- macro envestnet_account_master(src) -%}
select
    'envestnet'                                                   as system_name
    , {{ "'" ~ src ~ "'" }}                                       as system_instance
    , concat(system_name , '__' , system_instance)                as system_key
    , {{ envestnet_instance_map(src) }}                           as firm_source
    , nullif(split_part(content , '|' , 1), '')::int              as account_id
    , nullif(split_part(content , '|' , 2), '')::varchar(32)      as account_number
    , nullif(split_part(content , '|' , 3), '')::varchar(128)     as account_name
    , nullif(split_part(content , '|' , 4), '')::varchar(128)     as product_name
    , nullif(split_part(content , '|' , 5), '')::varchar(128)     as product_type
    , nullif(split_part(content , '|' , 6), '')::varchar(150)     as customer_name
    , nullif(split_part(content , '|' , 7), '')::varchar(200)     as advisor_name
    , nullif(split_part(content , '|' , 8), '')::varchar(128)     as advisor_branch_name
    , nullif(split_part(content , '|' , 9), '')::varchar(250)     as rep_code
    , nullif(split_part(content , '|' , 10), '')::varchar(128)    as custodian
    , nullif(split_part(content , '|' , 11), '')::date            as start_date
    , nullif(split_part(content , '|' , 12), '')::varchar(8000)   as mailing_label
    , nullif(split_part(content , '|' , 13), '')::varchar(100)    as registration_type
    , nullif(split_part(content , '|' , 14), '')::varchar(2)      as state
    , nullif(split_part(content , '|' , 15), '')::varchar(128)    as name_and_address_1
    , nullif(split_part(content , '|' , 16), '')::varchar(128)    as name_and_address_2
    , nullif(split_part(content , '|' , 17), '')::varchar(64)     as name_and_address_3
    , nullif(split_part(content , '|' , 18), '')::varchar(24)     as name_and_address_4
    , nullif(split_part(content , '|' , 19), '')::varchar(64)     as ssn_tax_id
    , nullif(split_part(content , '|' , 20), '')::int             as ssn_tax_id_flag
    , nullif(split_part(content , '|' , 21), '')::date            as close_date
    , nullif(split_part(content , '|' , 22), '')::int             as accounting_method_of_equities
    , nullif(split_part(content , '|' , 23), '')::int             as accounting_method_of_mutual_funds
    , nullif(split_part(content , '|' , 24), '')::varchar(32)     as master_account_number
    , nullif(split_part(content , '|' , 25), '')::int             as customer_id
    , nullif(split_part(content , '|' , 26), '')::int             as proposal_group_id
    , nullif(split_part(content , '|' , 27), '')::int             as customer_registration_id
    , nullif(split_part(content , '|' , 28), '')::char(1)         as reconciled_status
    , nullif(split_part(content , '|' , 29), '')::date            as last_reconciled_date
    , nullif(split_part(content , '|' , 30), '')::int             as nscc_networking_level
    , nullif(split_part(content , '|' , 31), '')::char(1)         as swp_indicator
    , nullif(split_part(content , '|' , 32), '')::char(1)         as ach_indicator
    , nullif(split_part(content , '|' , 33), '')::char(1)         as pac_spp_indicator
    , nullif(split_part(content , '|' , 34), '')::char(1)         as check_writing
    , nullif(split_part(content , '|' , 35), '')::int             as fund_family_id
    , nullif(split_part(content , '|' , 36), '')::varchar(16)     as import_account
    , nullif(split_part(content , '|' , 37), '')::int             as cross_fund_reinvest
    , nullif(split_part(content , '|' , 38), '')::int             as account_number_indicator
    , nullif(split_part(content , '|' , 39), '')::char(1)         as nf_transfer_eligibility_flag
    , nullif(split_part(content , '|' , 40), '')::int             as custodian_id
    , nullif(split_part(content , '|' , 41), '')::int             as account_status
    , nullif(split_part(content , '|' , 42), '')::int             as registration_type_id
    , nullif(split_part(content , '|' , 43), '')::varchar(64)     as primary_member_first_name
    , nullif(split_part(content , '|' , 44), '')::varchar(64)     as primary_member_middle_name
    , nullif(split_part(content , '|' , 45), '')::varchar(64)     as primary_member_last_name
    , nullif(split_part(content , '|' , 46), '')::varchar(64)     as partner_code
    , nullif(split_part(content , '|' , 47), '')::varchar(16)     as branch_code
    , nullif(split_part(content , '|' , 48), '')::varchar(20)     as alternate_rep_code
    , nullif(split_part(content , '|' , 49), '')::varchar(64)     as advisor_rep_number
    , nullif(split_part(content , '|' , 50), '')::int             as product_id
    , nullif(split_part(content , '|' , 51), '')::int             as proposal_risk_rating
    , nullif(split_part(content , '|' , 52), '')::date            as as_of_close_date
    , nullif(split_part(content , '|' , 53), '')::decimal(18 , 2) as un_supervised_assets
    , nullif(split_part(content , '|' , 54), '')::decimal(18 , 2) as total_cash
    , nullif(split_part(content , '|' , 55), '')::decimal(18 , 2) as total_market_value
    , nullif(split_part(content , '|' , 56), '')::date            as last_updated_by_custodian
    , nullif(split_part(content , '|' , 57), '')::date            as account_created_date
    , nullif(split_part(content , '|' , 58), '')::int             as tax_status
    , nullif(split_part(content , '|' , 59), '')::varchar(22)     as ticker
    , nullif(split_part(content , '|' , 60), '')::int             as advisor_id
    , nullif(split_part(content , '|' , 61), '')::varchar(80)     as benchmark
    , nullif(split_part(content , '|' , 62), '')::int             as goal_id
    , nullif(split_part(content , '|' , 63), '')::decimal(18 , 4) as goal_target
    , nullif(split_part(content , '|' , 64), '')::varchar(64)     as alternate_account_number
    , nullif(split_part(content , '|' , 65), '')::varchar(3)      as currency
    , nullif(split_part(content , '|' , 66), '')::int             as family_member_id
    , nullif(split_part(content , '|' , 67), '')::date            as custodian_position_date
    , nullif(split_part(content , '|' , 68), '')::int             as program_id
    , nullif(split_part(content , '|' , 69), '')::int             as aggregate_account_id
    , nullif(split_part(content , '|' , 70), '')::varchar(64)     as alternate_account_2
    , nullif(split_part(content , '|' , 71), '')::varchar(10)     as fund_family_code
    , nullif(split_part(content , '|' , 72), '')::int             as aggregate_error_code
    , nullif(split_part(content , '|' , 73), '')::varchar(1024)   as aggregate_error_message
    , nullif(split_part(content , '|' , 74), '')::varchar(250)    as product_overlay_feature
    , nullif(split_part(content , '|' , 75), '')::date            as client_review_date
    , nullif(split_part(content , '|' , 76), '')::date            as investment_group_review_date
    , nullif(split_part(content , '|' , 77), '')::date            as account_review_date
    , nullif(split_part(content , '|' , 78), '')::varchar(12)     as solicitor_id
    , nullif(split_part(content , '|' , 79), '')::decimal(18 , 2) as solicitor_percentage
    , nullif(split_part(content , '|' , 80), '')::date            as solicitor_end_date
    , nullif(split_part(content , '|' , 81), '')::char(1)         as collateralized
    , nullif(split_part(content , '|' , 82), '')::char(1)         as investment_selection_discretion
    , nullif(split_part(content , '|' , 83), '')::int             as benchmark_id
    , nullif(split_part(content , '|' , 84), '')::int             as index_type
    , nullif(split_part(content , '|' , 85), '')::int             as index_scope
    , nullif(split_part(content , '|' , 86), '')::varchar(250)    as account_v2_handle
    , nullif(split_part(content , '|' , 87), '')::varchar(32)     as brokerage_account_number
    , nullif(split_part(content , '|' , 88), '')::varchar(32)     as alternate_debit_account_number
    , effective_date                                              as effective_date
    , {{ col_is_head(reference=source('envestnet_' + src, 'accountmaster')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                 as _created_at
    , _source_file                                                as _source_file
from {{ source('envestnet_' + src, 'accountmaster') }}
where split_part(content , '|' , 1) not in ('H', 'T') --ignore header and tail records

{%- endmacro -%}
