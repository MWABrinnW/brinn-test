with cte_estate_item as (
    select
        name
        , regexp_replace(
            ltrim(upper(replace(identifier , '-' , '')) , '0')
            , '\\s{2,}' , ' '
        )::text                                      as account_number
        , identifier                                 as account_number_formatted
        , account_id_orion                           as pms_account_id
        , registration_type_name                     as registration_type
        , custodian_name                             as custodian
        , name                                       as account_name
        , account_description                        as account_description
        , am_restrictions                            as am_restrictions
        , aum_classification                         as aum_classification
        , billing_exception                          as is_billing_exception
        , block_on_account                           as is_blocked
        , cash_balance                               as cash_balance
        , closing_date                               as closing_date
        , comments                                   as comments
        , distribution_amount                        as distribution_amount
        , distribution_frequency                     as distribution_frequency
        , distribution_type                          as distribution_type
        , equity_goal                                as equity_goal
        , estate_item_type                           as estate_item_type
        , firm_trading                               as is_firm_traded
        , investment_status_notes                    as investment_status_notes
        , maturity_restriction                       as maturity_restriction
        , minimum_cash                               as minimum_cash
        , non_discretionary_account                  as is_non_discretionary
        , opening_date                               as opening_date
        , subadvisor_name                            as subadvisor_name
        , subadvisor_date_opened                     as subadvisor_date_opened
        , other_restriction                          as other_restriction
        , prime_broker_enabled                       as is_prime_broker
        , linked_individual_fixed_income             as is_lifi
        , rating_restriction                         as rating_restriction
        , record_type_id                             as record_type_id
        , restriction_notes                          as restriction_notes
        , restriction_notes_2                        as restriction_notes_2
        , sma_review_required                        as is_sma_review_required
        , state_1                                    as state_1
        , state_2                                    as state_2
        , status                                     as status
        , tax_status                                 as tax_status
        , trade_restriction                          as trade_restriction
        , trading_id                                 as trading_id
        , trading_system                             as trading_system
        , model_on_account_name                      as model
        , household_id                               as household_id
        , household_name                             as household_name
        , household_client_manager_name              as client_manager
        , household_parent_name                      as household_parent_name
        , household_legal_firm_name                  as household_legal_firm_name
        , household_legal_address_state              as household_legal_address_state
        , household_mailing_state                    as mailing_state
        , household_mariner_location_name            as household_mariner_location_name
        , household_fee_manager_name                 as household_fee_manager_name
        , ytd_realized_gain_loss                     as ytd_realized_gain_loss
        , id                                         as crm_account_id
        , _created_at                                as _created_at
        -- destinations
        , case
            when identifier not ilike 'Ascent%'
                and subadvisor_id ilike '001C000001aKJMGIA4'
                and coalesce(status , '') <> ''
                and (
                    coalesce(status , '') ilike 'Closed'
                    or (
                        prime_broker_enabled::int = 1
                        and linked_individual_fixed_income::int = 1
                    )
                )
                then 1
            else 0
        end::int                                     as is_perform
        , case
            when status ilike 'Open'
                and trading_system ilike 'Axys/Moxy - Cincinnati'
                and coalesce(trading_id , '') <> ''
                -- Exclude thirdparty per Debbie W 12/6/204
                -- Removing until go-live.
                --and coalesce(model , '') not ilike '%thirdparty/%'
                -- Apply trading eligibility rules.
                and (
                    coalesce(subadvisor_name , '') ilike 'Cincinnati Asset Management'
                    or coalesce(client_manager , '') not in ('Patrick Richter (EMP)' , 'Keith Hamberg (EMP)')
                )
                and (
                    coalesce(aum_classification , '') not in (
                        'Data Aggregation / Reporting Only' , 'AUA - Assets Under Advisory'
                    )
                    or coalesce(subadvisor_name , '') ilike 'Cincinnati Asset Management'
                )
                then 1
            else 0
        end::int                                     as is_moxy

        , iff(is_perform = 1 or is_moxy = 1 , 1 , 0) as is_included
        , array_construct_compact(
            iff(is_perform = 1 , 'perform' , null)
            , iff(is_moxy = 1 , 'moxy' , null)
        )                                            as trading_systems
        , is_moxy_intra_day_import                   as is_intraday_import
    from {{ ref('mis__stg_salesforce_compass_estate_item') }}
    where 1 = 1
        and is_head = 1
        and coalesce(identifier , '') <> ''
)

select
    account_number                    as account_number
    , account_number_formatted        as account_number_formatted
    , account_name                    as account_name
    , pms_account_id                  as pms_account_id
    , crm_account_id                  as crm_account_id
    , custodian                       as custodian
    , case
        when status ilike 'open' and closing_date is null
            then 1
        else 0
    end::int                          as is_active
    , account_description             as account_description
    , registration_type               as registration_type
    , aum_classification              as aum_classification
    , cash_balance                    as cash_balance
    , comments                        as comments
    , distribution_amount             as distribution_amount
    , distribution_frequency          as distribution_frequency
    , distribution_type               as distribution_type
    , equity_goal                     as equity_goal
    , estate_item_type                as estate_item_type
    , investment_status_notes         as investment_status_notes
    , minimum_cash                    as minimum_cash
    , opening_date                    as opening_date
    , closing_date                    as closing_date
    , subadvisor_name                 as subadvisor_name
    , subadvisor_date_opened          as subadvisor_date_opened
    , am_restrictions                 as am_restrictions
    , maturity_restriction            as maturity_restriction
    , rating_restriction              as rating_restriction
    , other_restriction               as other_restriction
    , restriction_notes               as restriction_notes
    , restriction_notes_2             as restriction_notes_2
    , record_type_id                  as record_type_id
    , state_1                         as state_1
    , state_2                         as state_2
    , mailing_state                   as mailing_state
    , status                          as status
    , tax_status                      as tax_status
    , trade_restriction               as trade_restriction
    , trading_id                      as trading_id
    , trading_system                  as trading_system
    , model                           as model
    , household_id                    as household_id
    , household_name                  as household_name
    , household_parent_name           as household_parent_name
    , household_legal_firm_name       as household_legal_firm_name
    , household_mariner_location_name as household_mariner_location_name
    , household_legal_address_state   as household_legal_address_state
    , household_fee_manager_name      as household_fee_manager_name
    , ytd_realized_gain_loss          as ytd_realized_gain_loss
    , is_billing_exception::int       as is_billing_exception
    , is_blocked::int                 as is_blocked
    , client_manager                  as client_manager
    , is_sma_review_required::int     as is_sma_review_required
    , is_firm_traded                  as is_firm_traded
    , is_non_discretionary::int       as is_non_discretionary
    , is_prime_broker::int            as is_prime_broker
    , is_lifi::int                    as is_lifi
    , is_perform                      as is_perform
    , is_moxy                         as is_moxy
    , is_included                     as is_included
    , trading_systems                 as trading_systems
    , is_intraday_import              as is_intraday_import

    , row_number() over (
        partition by account_number
        order by closing_date desc , _created_at desc
    )                                 as rn
    , _created_at                     as _created_at
from cte_estate_item
--where is_included = 1
