select
    'schwab'                                                                    as custodian
  , cl.firm_source                                                              as firm_source
  , cf.firm                                                                     as firm
  , nullif(trim(substring(content, 1, 2)), '')::text(200)                       as record_type
  , to_date(nullif(trim(substring(content, 4, 8)), '')::text(200), 'YYYYMMDD')  as business_date
  , right(nullif(trim(substring(content, 13, 8)), '')::text(200), 8)            as master_account_number
  , nullif(trim(substring(content, 22, 8)), '')::text(200)                      as account_number
  , to_date(nullif(trim(substring(content, 31, 8)), '')::text(200), 'YYYYMMDD') as trade_date
  , to_date(nullif(trim(substring(content, 40, 8)), '')::text(200), 'YYYYMMDD') as settlement_date
  , nullif(trim(substring(content, 49, 6)), '')::text(200)                      as action
  , nullif(trim(substring(content, 56, 6)), '')::text(200)                      as cancel
  , nullif(trim(substring(content, 63, 30)), '')::text(200)                     as symbol
  , nullif(trim(substring(content, 94, 9)), '')::text(200)                      as cusip
  , nullif(trim(substring(content, 104, 7)), '')::text(200)                     as schwab_internal_security_number
  , nullif(trim(substring(content, 112, 40)), '')::text(200)                    as trace_symbol
  , nullif(trim(substring(content, 153, 80)), '')::text(200)                    as security_description
  , nullif(trim(substring(content, 234, 16)), '')::text(200)                    as account_type
  , nullif(trim(substring(content, 251, 19)), '')::decimal(20, 5)               as quantity
  , nullif(trim(substring(content, 271, 16)), '')::decimal(20, 5)               as price
  , nullif(trim(substring(content, 288, 16)), '')::decimal(20, 5)               as principal
  , nullif(trim(substring(content, 305, 16)), '')::decimal(20, 5)               as total_amount
  , nullif(trim(substring(content, 322, 16)), '')::decimal(20, 5)               as step_in_fee
  , nullif(trim(substring(content, 339, 14)), '')::decimal(20, 5)               as schwab_commission
  , nullif(trim(substring(content, 354, 14)), '')::decimal(20, 5)               as executing_broker_commission
  , nullif(trim(substring(content, 369, 14)), '')::decimal(20, 5)               as prime_broker_fee
  , nullif(trim(substring(content, 384, 14)), '')::decimal(20, 5)               as transaction_fee
  , nullif(trim(substring(content, 399, 14)), '')::decimal(20, 5)               as broker_service_fee
  , nullif(trim(substring(content, 414, 14)), '')::decimal(20, 5)               as exchange_processing_fee
  , nullif(trim(substring(content, 429, 14)), '')::decimal(20, 5)               as order_handling_fee
  , nullif(trim(substring(content, 444, 14)), '')::decimal(20, 5)               as other_fees
  , nullif(trim(substring(content, 459, 6)), '') ::decimal(20, 5)               as other_fees_description
  , nullif(trim(substring(content, 466, 14)), '')::decimal(20, 5)               as accrued_interest
  , nullif(trim(substring(content, 481, 14)), '')::text(200)                    as state_tax
  , nullif(trim(substring(content, 496, 6)), '')::text(200)                     as tax_description
  , nullif(trim(substring(content, 503, 14)), '')::text(200)                    as executing_broker_markup_or_markdown
  , nullif(trim(substring(content, 518, 14)), '')::decimal(20, 5)               as research_fee
  , nullif(trim(substring(content, 533, 30)), '')::text(200)                    as account_name_address_1
  , nullif(trim(substring(content, 564, 30)), '')::text(200)                    as account_name_address_2
  , nullif(trim(substring(content, 595, 30)), '')::text(200)                    as account_name_address_3
  , nullif(trim(substring(content, 626, 30)), '')::text(200)                    as account_name_address_4
  , nullif(trim(substring(content, 657, 30)), '')::text(200)                    as account_name_address_5
  , nullif(trim(substring(content, 688, 30)), '')::text(200)                    as account_name_address_6
  , nullif(trim(substring(content, 719, 45)), '')::text(200)                    as account_title_1
  , nullif(trim(substring(content, 765, 45)), '')::text(200)                    as account_title_2
  , nullif(trim(substring(content, 811, 45)), '')::text(200)                    as account_title_3
  , nullif(trim(substring(content, 857, 30)), '')::text(200)                    as unused_field_4
  , nullif(trim(substring(content, 888, 30)), '')::text(200)                    as unused_field_5
  , nullif(trim(substring(content, 919, 8)), '')::text(200)                     as messages_break_indicator
  , nullif(trim(substring(content, 928, 80)), '')::text(200)                    as message_1
  , nullif(trim(substring(content, 1009, 80)), '')::text(200)                   as message_2
  , nullif(trim(substring(content, 1090, 80)), '')::text(200)                   as message_3
  , nullif(trim(substring(content, 1171, 80)), '')::text(200)                   as message_4
  , nullif(trim(substring(content, 1252, 80)), '')::text(200)                   as message_5
  , nullif(trim(substring(content, 1333, 80)), '')::text(200)                   as message_6
  , nullif(trim(substring(content, 1414, 80)), '')::text(200)                   as message_7
  , master_number                                                               as master_number
  , cl.is_deceased                                                              as is_deceased
  , cl.is_from_tda_migration                                                    as is_from_tda_migration
  , effective_date                                                              as effective_date
  , dense_rank() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc, master_number asc
                    )                                                           as rn
  , dense_rank() over(partition by a.effective_date, account_number, cl.firm_source
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc, master_number asc
                    )                                                           as rn_firm
  , dense_rank() over(partition by a.effective_date, account_number
                    order by case
                        when master_number = '08438162' -- orion
                            then 1
                        when master_number = '08109543' -- fixed income
                            then 2
                        when master_number = '08315101' -- non-orion
                            then 3
                        when master_number = '08355335' -- mps
                            then 4
                        when master_number = '08051423' -- swag
                            then 5
                        else 6
                        end asc, master_number asc
                    )                                                           as rn_global
  , {{ col_is_head(reference=source('schwab', 'tcf')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , _created_at                                                                 as _source_loaded_at
  , _source_file                                                                as _source_file
from {{ source('schwab', 'tcf') }} a
left join {{ ref('aux__stg_custodian_links') }} cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} cf
    on cl.firm_source = cf.firm_source
where left(content, 2) = 'D1'
