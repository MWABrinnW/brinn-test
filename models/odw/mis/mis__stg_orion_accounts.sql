select
    a.content:account_number_formatted::text            as account_number_formatted
    , a.content:account_number::text                    as account_number
    , a.content:custodian::text                         as custodian
    , a.content:account_id::int                         as account_id
    , a.content:account_type::text                      as account_type
    , a.content:account_name::text                      as account_name
    , a.content:registration_id::int                    as registration_id
    , a.content:registrant_name::text                   as registrant_name
    , a.content:household_id::int                       as household_id
    , a.content:household_name::text                    as household_name
    , a.content:client_open_date::date                  as client_open_date
    , a.content:is_active::int                          as is_active
    , a.content:created_date::date                      as created_date
    , a.content:opened_date::date                       as opened_date
    , a.content:closed_date::date                       as closed_date
    , a.content:closed_date_udf::text                   as closed_date_udf
    , a.content:representative_id::int                  as representative_id
    , a.content:advisor::text                           as advisor
    , a.content:advisor_email::text                     as advisor_email
    , a.content:location_code::text                     as location_code
    , a.content:investment_strategy::text               as investment_strategy
    , a.content:fkalclient::int                         as fkalclient
    , a.content:bd_name::text                           as bd_name
    , a.content:last_reconciled_date::date              as last_reconciled_date
    , a.content:is_in_balance::boolean::int             as is_in_balance
    , a.content:has_non_downloading_asset::boolean::int as has_non_downloading_asset
    , a.content:trading_instructions::text              as trading_instructions
    , a.content:is_managed::boolean::int                as is_managed
    , a.content:custodian_account_restriction::text     as custodian_account_restriction
    , a.content:subadvisor_id::int                      as subadvisor_id
    , a.content:subadvisor::text                        as subadvisor
    , a.content:fund_family::text                       as fund_family
    , a.content:is_sma::boolean::int                    as is_sma
    , a.content:sma_asset_id::int                       as sma_asset_id
    , a.content:sma_asset::text                         as sma_asset
    , a.content:download_source::text                   as download_source
    , a.content:is_trading_blocked::boolean::int        as is_trading_blocked
    , a.content:fee_schedule::text                      as fee_schedule
    , a.content:eclipse_sma::text                       as eclipse_sma
    , a.content:eclipse_enabled::boolean::int           as eclipse_enabled
    , a.content:committed_amount_udf::text              as committed_amount_udf
    , a.content:_extracted_at::text                     as _extracted_at
    , a._created_at                                     as _created_at
    , dt.prior_market_date                              as effective_date
    , {{ col_is_head(
        reference=source('mis', 'orion_accounts'),
        source_date_col='a._created_at',
        reference_date_col='_created_at'
        ) }}
from {{ source('mis', 'orion_accounts') }} as a
left join {{ ref('dates') }} as dt
    on a._created_at::date = dt.date_key
