{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'system_key']
) }}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = 400 -%}

{%-
    set src_models = [
          'nml_cambak_andco_accounts'
         ,'nml_salesforce_compass_rps_accounts'
    ]
-%}

{%-
    set nml_models = [
        'nml_cambak_andco_accounts'
        ,'nml_salesforce_compass_rps_accounts'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select
        effective_date              as effective_date
        , system_key                as system_key
        , sum(account_value)        as account_value
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        -- We only need to build starting in 2025.
        and effective_date >= '2025-01-01'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
        and effective_date is not null
    group by all
    order by 1,2
    {% else -%}
    select null::date as effective_date, null::text as system_key
        , null::decimal(20,2) as account_value
    {% endif -%}
)

, source_summary as (
    {% for src_model in src_models -%}
    select
        effective_date              as effective_date
        , system_key                as system_key
        , sum(account_value)        as account_value
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        -- We only need to build starting in 2025.
        and effective_date >= '2025-01-01'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
        and effective_date is not null
        and effective_date < current_date()
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, system_key from source_summary group by all
    union
    select effective_date, system_key from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.system_key      as system_key
        , s.account_value   as source_account_value
        , d.account_value   as destination_account_value
        , case
            when nvl(s.account_value , 0) <> nvl(d.account_value , 0)
                then 1
            else 0
            end::int        as is_stale
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.system_key = s.system_key
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.system_key = d.system_key
    where 1 = 1
    group by all
)

, data_to_build as (
    {%- for nml_model in nml_models %}
        select
            effective_date                  as effective_date
            , system_name                   as system_name
            , system_instance               as system_instance
            , system_key                    as system_key
            , firm_source                   as firm_source
            , account_number_formatted      as account_number_formatted
            , account_number                as account_number
            , custodian                     as custodian
            , account_type                  as account_type
            , account_name                  as account_name
            , registrant_name               as registrant_name
            , client_name                   as client_name
            , is_active                     as is_active
            , created_date                  as created_date
            , opened_date                   as opened_date
            , closed_date                   as closed_date
            , account_value                 as account_value
            , advisor                       as advisor
            , advisor_id                    as advisor_id
            , advisor_id_source             as advisor_id_source
            , advisor_email                 as advisor_email
            , location_code                 as location_code
            , model_investment_strategy     as model_investment_strategy
            , aum_classification            as aum_classification
            , fee_schedule                  as fee_schedule
            , is_erisa                      as is_erisa
            , is_discretionary              as is_discretionary
            , is_voting_proxied             as is_voting_proxied
            , is_prime_broker               as is_prime_broker
            , is_broker_dealer_account      as is_broker_dealer_account
            , pms_account_number            as pms_account_number
            , pms_custodian                 as pms_custodian
            , pms_account_id::text          as pms_account_id
            , pms_account_type              as pms_account_type
            , pms_account_name              as pms_account_name
            , pms_registrant_name           as pms_registrant_name
            , pms_client_id                 as pms_client_id
            , pms_client_name               as pms_client_name
            , pms_is_active                 as pms_is_active
            , pms_created_date              as pms_created_date
            , pms_opened_date               as pms_opened_date
            , pms_closed_date               as pms_closed_date
            , pms_account_value             as pms_account_value
            , pms_advisor                   as pms_advisor
            , pms_advisor_email             as pms_advisor_email
            , pms_location_code             as pms_location_code
            , pms_fee_schedule              as pms_fee_schedule
            , pms_model_investment_strategy as pms_model_investment_strategy
            , pms_aum_classification        as pms_aum_classification
            , pms_is_erisa                  as pms_is_erisa
            , pms_is_discretionary          as pms_is_discretionary
            , pms_is_voting_proxied         as pms_is_voting_proxied
            , pms_is_prime_broker           as pms_is_prime_broker
            , pms_is_broker_dealer_account  as pms_is_broker_dealer_account
            , pms_cost_basis_method         as pms_cost_basis_method
            , crm                           as crm
            , crm_instance_location         as crm_instance_location
            , crm_key                       as crm_key
            , crm_custodian                 as crm_custodian
            , crm_account_id                as crm_account_id
            , crm_account_type              as crm_account_type
            , crm_account_name              as crm_account_name
            , crm_registrant_name           as crm_registrant_name
            , crm_client_id                 as crm_client_id
            , crm_client_name               as crm_client_name
            , crm_is_active                 as crm_is_active
            , crm_created_date              as crm_created_date
            , crm_opened_date               as crm_opened_date
            , crm_closed_date               as crm_closed_date
            , crm_account_value             as crm_account_value
            , crm_advisor                   as crm_advisor
            , crm_advisor_email             as crm_advisor_email
            , crm_location_code             as crm_location_code
            , crm_fee_schedule              as crm_fee_schedule
            , crm_model_investment_strategy as crm_model_investment_strategy
            , crm_aum_classification        as crm_aum_classification
            , crm_is_erisa                  as crm_is_erisa
            , crm_is_discretionary          as crm_is_discretionary
            , crm_is_voting_proxied         as crm_is_voting_proxied
            , crm_is_prime_broker           as crm_is_prime_broker
            , crm_is_broker_dealer_account  as crm_is_broker_dealer_account
            , system_key__account_name      as system_key__account_name
            , system_key__account_number    as system_key__account_number
            , system_key__advisor           as system_key__advisor
            , advisor__account_number       as advisor__account_number
            , __account_key                 as __account_key
            , __custodian_key               as __custodian_key
            , pref_advisor__account_number  as pref_advisor__account_number
            , pref_advisor                  as pref_advisor
            , pref_location                 as pref_location
            , pref_system_key               as pref_system_key
            , dedupe_system_rn              as dedupe_system_rn
            , dedupe_system_count           as dedupe_system_count
            , has_dupes                     as has_dupes
            , is_excluded                   as is_excluded
            , excluded_reasons              as excluded_reasons
            , _extra_fields                 as _extra_fields
            , _source_loaded_at             as _source_loaded_at
            , _source_file                  as _source_file
            , {{ "'" ~ nml_model ~ "'" }}   as _source_model
            , case
                    when system_key in ('cambak__andco', 'salesforce__compass_rps')
                        then 1
                    else 0
                    end::int                as is_institutional

            , firm_source::variant          as firm_source_verified
            -- These would be populated if they went through custodian supplementation.
            -- Ripped that out as part of the split from the main accounts build.
            , null::text                    as __custodian_cust
            , null::int                     as has_custodial_feed
            , null::int                     as cus_is_discretionary
            , null::int                     as cus_is_prime_broker
            , null::int                     as cus_is_broker_dealer_account
            , null::text                    as link
            , null::text                    as link_type
            , null::text                    as link_subtype
        from {{ ref(nml_model) }}
        where true
            -- Model start date. This applies for full-refresh.
            and effective_date >= '{{ start_date }}'
            {%- if is_incremental() or target.name not in ['prod'] %}
            -- Restrict lookback window if incremental or not prod.
            and effective_date >= current_date() - {{ lookback }}
            {%- endif %}
            and effective_date in (select distinct effective_date from dates_to_refresh where is_stale = 1)
            -- Offer the snowflake query optimizer a chance to prune the query early
            -- if there are no dates to refresh.
            and exists (select 1 from dates_to_refresh where is_stale = 1)
        {%- if not loop.last %}

        union all

        {%- endif %}
    {%- endfor %}
)

, data_to_build_with_locations as (
    select
        a.*
        , l.office_name                                                                   as office_name
    from data_to_build as a
    left join {{ ref('locations') }} as l
        on a.location_code = l.location_code
        and l.active = 1
)

, final as (
    select
        -- [normalized] attributes normalized and coalesced accross source systems
        effective_date                                                                                            as effective_date
        , system_name                                                                                             as system_name
        , system_instance                                                                                         as system_instance
        , system_key                                                                                              as system_key
        , firm_source                                                                                             as firm_source
        , firm_source_verified                                                                                    as firm_source_verified
        , account_number_formatted                                                                                as account_number_formatted
        , account_number                                                                                          as account_number
        , custodian                                                                                               as custodian
        , link                                                                                                    as link
        , link_type                                                                                               as link_type
        , link_subtype                                                                                            as link_subtype
        , account_type                                                                                            as account_type
        , account_name                                                                                            as account_name
        , registrant_name                                                                                         as registrant_name
        , client_name                                                                                             as client_name
        , is_active                                                                                               as is_active
        , created_date                                                                                            as created_date
        , opened_date                                                                                             as opened_date
        , closed_date                                                                                             as closed_date
        -- account values should be 0 if the effective date proceeds the closed date (from system only, except rps)
        , iff(( coalesce(closed_date, '2099-12-31') ) <= effective_date, 0,
                account_value)                                                                                    as account_value
        , advisor                                                                                                 as advisor
        , advisor_id                                                                                              as advisor_id
        , advisor_id_source                                                                                       as advisor_id_source
        , max(advisor_email) over (
                    partition by
                        effective_date
                        , system_key
                        , advisor
                    )                                                                                             as advisor_email
        , location_code                                                                                           as location_code
        , office_name                                                                                             as office_name
        , fee_schedule                                                                                            as fee_schedule
        , model_investment_strategy                                                                               as model_investment_strategy
        , case
                when aum_classification is null then 'Needs Classification'
                else aum_classification
                end::text                                                                                         as aum_classification
        , case when is_erisa = 1 then 1 else 0 end::int                                                           as is_erisa
        , coalesce(null::int, is_discretionary)                                                        as is_discretionary
        , coalesce(null::int, is_prime_broker)                                                          as is_prime_broker
        , coalesce(null::int, is_broker_dealer_account)                                        as is_broker_dealer_account

        , pref_advisor__account_number                                                                            as pref_advisor__account_number
        , pref_advisor                                                                                            as pref_advisor
        , pref_location                                                                                           as pref_location
        , pref_system_key                                                                                         as pref_system_key
        , is_institutional                                                                                        as is_institutional
        , dedupe_system_rn                                                                                        as dedupe_system_rn
        , dedupe_system_count                                                                                     as dedupe_system_count
        --- [global deduplication decision tree] ------------------------------------------------------------------------
        , row_number()
                    over (
                        partition by is_institutional , effective_date , __account_key , __custodian_cust
                        order by
                            -- disqualify excluded account records
                            coalesce(is_excluded, 0) asc
                            -- prefer first record in a system, if duped
                            , dedupe_system_rn asc
                            -- prefer open accounts over closed
                            , iff(closed_date is null, 1, 2) asc
                            -- prefer accounts that have a preferred system key that matches record system key
                            , case when system_key = pref_system_key then 1 else 2 end asc
                            -- prefer records that have an "account", "advisor" override
                            , case
                                when pref_advisor__account_number is not null
                                    then 1
                                when pref_advisor is not null and advisor is not null
                                    then 2
                                else 3
                            end::int
                            -- prefer "portfoliocenter tcea" over other system
                            , case when system_key = 'portfoliocenter__tcea' then 1 else 2 end asc
                            -- prefer records that have a "location" override
                            , case when pref_location = system_key then 1 else 2 end asc
                            -- prefer "tamarac stateg college" over other system
                            , case when system_key = 'tamarac__state_college' and crm = 'dynamics' then 1 else 2 end asc
                            -- prefer "orion" system by firm source
                            , case
                                when system_key = 'orion__core' and coalesce(firm_source_verified[0], firm_source) = 'mwa'
                                    then 1
                                when system_key = 'orion__mps' and coalesce(firm_source_verified[0], firm_source) = 'mps'
                                    then 1
                                else 2
                            end asc
                            -- prefer accounts that were found in CRM
                            , case when crm_account_id is not null then 1 else 2 end asc
                        )                                                                                         as dedupe_global_rn
        , count(*)
                over (partition by is_institutional , effective_date , __account_key , __custodian_cust)          as dedupe_global_count
        , count(distinct system_key)
                over (partition by is_institutional , effective_date , __account_key , __custodian_cust)          as dedupe_system_key_count
        , case when has_dupes = 1 or dedupe_global_count > 1 then 1 else 0 end                                    as has_dupes

        --- [global deduplication decision tree ~ breakout] ----------------------------------------------------------------------------------------------
        , is_excluded                                                                                             as __is_excluded
        , excluded_reasons                                                                                        as __if_excluded_reasons
        , dedupe_system_rn                                                                                        as __dedupe_system_rn
        , iff(closed_date is null, 1, 2)                                                                          as __prefer_open
        , case when system_key = pref_system_key then 1 else 2 end                                                as __key_match_preference
        , case
                when pref_advisor__account_number is not null then 1
                when pref_advisor is not null and advisor is not null then 2
                else 3
                end::int                                                                                          as __ovrd_acct_and_or_advisor
        , case when system_key = 'portfoliocenter__tcea' then 1 else 2 end                                        as __prefer_portfolio
        , case when pref_location = system_key then 1 else 2 end                                                  as __ovrd_location
        , case
                when system_key = 'tamarac__state_college' and crm = 'dynamics' then 1
                else 2
                end                                                                                               as __prefer_tamarac
        , case
                when system_key = 'orion__core' and coalesce(firm_source_verified[0], firm_source) = 'mwa'
                    then 1
                when system_key = 'orion__mps' and coalesce(firm_source_verified[0], firm_source) = 'mps'
                    then 1
                else 2
                end                                                                                               as __prefer_orion
        , case when crm_account_id is not null then 1 else 2 end                                                  as __prefer_with_crm_id
        ----------------------------------------------------------------------------------------------------------------------------------------------------

        , null::int                                                                                               as has_custodial_feed
        , excluded_reasons                                                                                        as excluded_reasons
        , is_excluded                                                                                             as is_excluded

        -- [pms] attributes sourced from the pms
        , pms_account_number                                                                                      as pms_account_number
        , pms_custodian                                                                                           as pms_custodian
        , pms_account_id                                                                                          as pms_account_id
        , pms_account_type                                                                                        as pms_account_type
        , pms_account_name                                                                                        as pms_account_name
        , pms_registrant_name                                                                                     as pms_registrant_name
        , pms_client_id                                                                                           as pms_client_id
        , pms_client_name                                                                                         as pms_client_name
        , pms_is_active                                                                                           as pms_is_active
        , pms_created_date                                                                                        as pms_created_date
        , pms_opened_date                                                                                         as pms_opened_date
        , pms_closed_date                                                                                         as pms_closed_date
        , pms_account_value                                                                                       as pms_account_value
        , pms_advisor                                                                                             as pms_advisor
        , pms_advisor_email                                                                                       as pms_advisor_email
        , pms_location_code                                                                                       as pms_location_code
        , pms_fee_schedule                                                                                        as pms_fee_schedule
        , pms_model_investment_strategy                                                                           as pms_model_investment_strategy
        , pms_aum_classification                                                                                  as pms_aum_classification
        , pms_is_erisa                                                                                            as pms_is_erisa
        , pms_is_discretionary                                                                                    as pms_is_discretionary
        , pms_is_voting_proxied                                                                                   as pms_is_voting_proxied
        , pms_is_prime_broker                                                                                     as pms_is_prime_broker
        , pms_is_broker_dealer_account                                                                            as pms_is_broker_dealer_account

        -- [crm] attributes sourced from the crm
        , crm                                                                                                     as crm
        , crm_instance_location                                                                                   as crm_instance_location
        , crm_key                                                                                                 as crm_key
        , crm_custodian                                                                                           as crm_custodian
        , crm_account_id                                                                                          as crm_account_id
        , crm_account_type                                                                                        as crm_account_type
        , crm_account_name                                                                                        as crm_account_name
        , crm_registrant_name                                                                                     as crm_registrant_name
        , crm_client_id                                                                                           as crm_client_id
        , crm_client_name                                                                                         as crm_client_name
        , crm_is_active                                                                                           as crm_is_active
        , crm_created_date                                                                                        as crm_created_date
        , crm_opened_date                                                                                         as crm_opened_date
        , crm_closed_date                                                                                         as crm_closed_date
        , crm_account_value                                                                                       as crm_account_value
        , crm_advisor                                                                                             as crm_advisor
        , crm_advisor_email                                                                                       as crm_advisor_email
        , crm_location_code                                                                                       as crm_location_code
        , crm_fee_schedule                                                                                        as crm_fee_schedule
        , crm_model_investment_strategy                                                                           as crm_model_investment_strategy
        , crm_aum_classification                                                                                  as crm_aum_classification
        , crm_is_erisa                                                                                            as crm_is_erisa
        , crm_is_discretionary                                                                                    as crm_is_discretionary
        , crm_is_voting_proxied                                                                                   as crm_is_voting_proxied
        , crm_is_prime_broker                                                                                     as crm_is_prime_broker
        , crm_is_broker_dealer_account                                                                            as crm_is_broker_dealer_account

        -- [custodian] attributes sourced from the custodian
        , cus_is_discretionary                                                                                    as cus_is_discretionary
        , cus_is_prime_broker                                                                                     as cus_is_prime_broker
        , cus_is_broker_dealer_account                                                                            as cus_is_broker_dealer_account

        -- [metadata] internal helpers and metadata
        , __custodian_key                                                                                         as __custodian_key
        , __custodian_cust                                                                                        as __custodian_cust
        , system_key__account_number                                                                              as system_key__account_number
        , system_key__advisor                                                                                     as system_key__advisor
        , advisor__account_number                                                                                 as advisor__account_number
        , __account_key                                                                                           as __account_key
        , _source_loaded_at                                                                                       as _source_loaded_at
        , _source_file                                                                                            as _source_file
        , _extra_fields                                                                                           as _extra_fields
    from data_to_build_with_locations
)

select
    *
    , max(case when dedupe_global_rn = 1 then pref_system_key else null end)
        over(partition by effective_date, __custodian_cust, __account_key, is_institutional)                  as __preferred_system_key
    , case
        when dedupe_global_rn = 1
            then 1
        else 0
    end                                                                                                       as is_primary
    , {{ col_is_market_day(date_col = 'effective_date')}}
    , {{ col_is_market_month_end(date_col='effective_date') }}
    , current_timestamp()::timestamp_ntz                                                                      as _created_at
from final
order by __account_key asc , is_primary desc , dedupe_global_rn asc

