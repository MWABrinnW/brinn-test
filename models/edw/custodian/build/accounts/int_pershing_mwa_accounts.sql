{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

/*
    Pershing sends full files weekly (fridays) and delta files on all days.
    We need to use the full files as a base and layer on top any changes received from the delta files.

    - Set all full records and duplicate each full file across the following delta files (up until the next full file)
    - Get all delta records
    - Date spine all full and delta records to extend them through the current week
    - Union all full and delta records together
    - Select first record for each date
*/

{%-
    set src_models = [
         'pershing_mwa__accf_a_main_account_information'
         , 'pershing_mwa__acct_a_main_account_information'
    ]
-%}


{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the holdings/positions from custodians normalized. #}
{%-
    set nml_models = [
         'nml_schwab_mwa_holdings'
         ,'nml_schwab_mwa_holdings'
         ,'nml_schwab_swag_holdings'
    ]
%}


with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - ({{ lookback }} + 8)
        {%- endif %}
    group by all
    order by 1,2
    {% else -%}
    select null::date as effective_date
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
    select
        dt.date_key                     as effective_date
        , a.effective_date              as original_effective_date
        , max(a._created_at)            as _created_at
        , {{"'" ~ src_model ~ "'"}}     as model_source
    from {{ ref(src_model) }} a
    cross join {{ ref('dates') }} dt
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and a.effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        -- We add to the lookback because there may not be a delta file sent if there
        -- were no changes to any accounts. We need to use the most recent full file
        -- as the 'base' or starting point for the accounts and spine them out to each
        -- subsequent effective_date. Full files are every friday and delta files are
        -- each day.
        and a.effective_date >= current_date() - ({{ lookback }} + 8)
        {%- endif %}
        {%- if src_model == 'pershing_mwa__accf_a_main_account_information' %}
        and dt.date_key between a.effective_date and a.effective_date + 7
        and dt.date_key < current_date()
        and dt.is_market_day = 1
        {%- else %}
        and a.effective_date = dt.date_key
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date from source_summary group by all
    union
    select effective_date from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
    left join destination_summary d
        on a.effective_date = d.effective_date
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

--------------------------------------------------------------

, delta_dates as (
    select
        effective_date
    from {{ source('pershing_mwa', 'acct') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from dates_to_refresh)
        {# -- This is needed for a full refresh.
        and effective_date >= (select min(effective_date) from {{ ref('pershing_mwa__accf_a_main_account_information') }}) #}
    group by all
)

, full_dates as (
    select
        effective_date
    from {{ source('pershing_mwa', 'accf') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and (
            effective_date in (select distinct effective_date from dates_to_refresh)
            -- Add a buffer of 7 days to make sure we always grab the full file for the week.
            or effective_date >= (select min(effective_date) from delta_dates) - 8
        )
    group by all
)

, cte_effective_date_map as (
    select distinct
        effective_date
        , 'full' as src
    from full_dates
    where 1 = 1

    union

    select distinct
        effective_date
        , 'delta' as src
    from delta_dates
    where 1 = 1
)

, cte_effective_dates as (
    select distinct effective_date
    from cte_effective_date_map
)

, cte_full_dates as (
    select distinct effective_date
    from cte_effective_date_map
    where src = 'full'
)

, cte_date_index as (
    select
        s.effective_date as effective_date_base
        , d.date_key     as effective_date
        , row_number() over (
            partition by s.effective_date
            order by d.date_key
        ) - 1            as delta_ordinal
    from cte_full_dates as s
    cross join (
        select date_key
        from edw.ref.dates
        where true
            and is_market_day = 1
            and date_key between (select min(effective_date) from cte_effective_dates
            ) and (select max(effective_date) from cte_effective_dates
            )
    ) as d
    where datediff(day , s.effective_date , d.date_key) between 0 and 6
)

---------------------------------------------------------------------

, accf_b as (
    select
        effective_date
        , account_number
        , tax_id_type
        , tax_id_number
        , tax_status
    from {{ ref('pershing_mwa__accf_b_main_account_information') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from cte_effective_dates)
)

, accf_c as (
    select
        effective_date
        , account_number
        , cost_basis_accounting_system
        , disposition_method_for_mutual_funds
        , disposition_method_for_all_other_security_types
        , disposition_method_for_stocks_in_dividend_reinvestment
    from {{ ref('pershing_mwa__accf_c_main_account_information_address_1_and_2') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from cte_effective_dates)
)

, acct_b as (
    select
        effective_date
        , account_number
        , tax_id_type
        , tax_id_number
        , tax_status
    from {{ ref('pershing_mwa__acct_b_main_account_information') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from cte_effective_dates)
)

, acct_c as (
    select
        effective_date
        , account_number
        , cost_basis_accounting_system
        , disposition_method_for_mutual_funds
        , disposition_method_for_all_other_security_types
        , disposition_method_for_stocks_in_dividend_reinvestment
    from {{ ref('pershing_mwa__acct_c_main_account_information_address_1_and_2') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from cte_effective_dates)
)

, hldr_j as (
    select
        effective_date
        , account_number
        , client_type
        , email_address_1
        , telephone_number_1
        , client_name_type_format
        , freeform_line_1
        , freeform_line_2
        , freeform_line_3
        , freeform_line_4
        , address_line_1
        , address_line_2
        , address_line_3
        , address_line_4
        , address_line_1_2
        , address_line_2_2
        , address_line_3_2
        , address_line_4_2
        , city
        , state
        , zippostal_code
        , country_code
        , individual_first_name
        , individual_middle_name
        , individual_last_name
        , city_2
        , state_2
        , zippostal_code_2
        , country_code_2
    from {{ ref('pershing_mwa__hldr_j_individual_entity_client_common_information') }}
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and effective_date in (select distinct effective_date from cte_effective_dates)
)


, cte_account_spine_fulls as (
    select
        dt.effective_date                                           as effective_date
        , f.effective_date                                            as effective_date_source
        , f.effective_date                                            as effective_date_base
        , 2                                                           as order_preference
        , dt.delta_ordinal                                            as delta_ordinal
        , 'full'                                                      as src
        , f.transaction_code                                          as transaction_code
        , f.record_indicator_value                                    as record_indicator_value
        , f.record_id_sequence_number                                 as record_id_sequence_number
        , f.account_number                                            as account_number
        , f.introducing_broker_dealer_ibd_number                      as introducing_broker_dealer_ibd_number
        , f.investment_professional_ip_number                         as investment_professional_ip_number
        , f.account_short_name                                        as account_short_name
        , f.transaction_type                                          as transaction_type
        , f.autotitled_or_usertitled_account                          as autotitled_or_usertitled_account
        , f.account_type_code                                         as account_type_code
        , f.registration_type                                         as registration_type
        , f.number_of_account_title_lines_in_registration_lines       as number_of_account_title_lines_in_registration_lines
        , f.account_registration_line_1                               as account_registration_line_1
        , f.account_registration_line_2                               as account_registration_line_2
        , f.account_registration_line_3                               as account_registration_line_3
        , f.account_registration_line_4                               as account_registration_line_4
        , f.account_registration_line_5                               as account_registration_line_5
        , f.account_registration_line_6                               as account_registration_line_6
        , f.date_account_opened                                       as date_account_opened
        , f.date_account_information_updated                          as date_account_information_updated
        , f.account_status_indicator                                  as account_status_indicator
        , f.pending_closed_date                                       as pending_closed_date
        , f.date_account_closed                                       as date_account_closed
        , f.closing_notice_date                                       as closing_notice_date
        , f.account_reactivated_date                                  as account_reactivated_date
        , f.date_account_reopened                                     as date_account_reopened
        , f.proceeds                                                  as proceeds
        , f.transfer_instructions                                     as transfer_instructions
        , f.income_instructions                                       as income_instructions
        , f.number_of_confirms_for_this_account                       as number_of_confirms_for_this_account
        , f.number_of_statements_for_this_account                     as number_of_statements_for_this_account
        , f.investment_objective_transaction_code                     as investment_objective_transaction_code
        , f.comments                                                  as comments
        , f.employer_shortname                                        as employer_shortname
        , f.employers_cusip                                           as employers_cusip
        , f.employers_symbol                                          as employers_symbol
        , f.margin_privileges_revoked                                 as margin_privileges_revoked
        , f.statement_review_date                                     as statement_review_date
        , f.margin_papers_on_file                                     as margin_papers_on_file
        , f.option_papers_on_file                                     as option_papers_on_file
        , f.for_pershing_internal_use_only                            as for_pershing_internal_use_only
        , f.good_faith_margin                                         as good_faith_margin
        , f.investment_professional_discretion_granted                as investment_professional_discretion_granted
        , f.investment_advisor_discretion_granted                     as investment_advisor_discretion_granted
        , f.third_party_discretion_granted                            as third_party_discretion_granted
        , f.third_party_name                                          as third_party_name
        , f.risk_factor_code                                          as risk_factor_code
        , f.investment_objective_code                                 as investment_objective_code
        , f.option__equities                                          as option__equities
        , f.option__index                                             as option__index
        , f.option__debt                                              as option__debt
        , f.option__currency                                          as option__currency
        , f.option_level_1                                            as option_level_1
        , f.option_level_2                                            as option_level_2
        , f.option_level_3                                            as option_level_3
        , f.option_level_4                                            as option_level_4
        , f.option__call_limits                                       as option__call_limits
        , f.option__put_limits                                        as option__put_limits
        , f.option__total_limits_of_puts_and_calls                    as option__total_limits_of_puts_and_calls
        , f.nonus_dollar_trading                                      as nonus_dollar_trading
        , f.not_used_reserved_for_future_use                          as not_used_reserved_for_future_use
        , f.noncustomer_indicator                                     as noncustomer_indicator
        , f.third_party_fee_indicator                                 as third_party_fee_indicator
        , f.third_party_fee_approval_date                             as third_party_fee_approval_date
        , f.intermediary_account_indicator                            as intermediary_account_indicator
        , f.commission_schedule                                       as commission_schedule
        , f.group_index                                               as group_index
        , f.money_manager_id                                          as money_manager_id
        , f.money_manager_objective_id                                as money_manager_objective_id
        , f.dtc_id_confirm_number_for_noncod_account                  as dtc_id_confirm_number_for_noncod_account
        , f.caps_master_mnemonic                                      as caps_master_mnemonic
        , f.employee_id                                               as employee_id
        , f.prime_brokerfree_fund_indicator                           as prime_brokerfree_fund_indicator
        , f.fee_based_account_indicator                               as fee_based_account_indicator
        , f.pershing_internal_use_only                                as pershing_internal_use_only
        , f.fee_based_termination_date                                as fee_based_termination_date
        , f.plan_name                                                 as plan_name
        , f.selfdirected_401k_account_type                            as selfdirected_401k_account_type
        , f.plan_type                                                 as plan_type
        , f.plan_number                                               as plan_number
        , f.employeeemployee_relative_indicator                       as employeeemployee_relative_indicator
        , f.commission_percent_discount                               as commission_percent_discount
        , f.block_mutual_fund_fees                                    as block_mutual_fund_fees
        , f.name_of_investment_professional_who_signed_new            as name_of_investment_professional_who_signed_new
        , f.date_investment_professional_signed_new_account_form      as date_investment_professional_signed_new_account_form
        , f.name_of_principal_who_signed_new_account_form             as name_of_principal_who_signed_new_account_form
        , f.date_principal_signed_new_account_form                    as date_principal_signed_new_account_form
        , f.politically_exposed_person_indicator                      as politically_exposed_person_indicator
        , f.private_banking_account_indicator                         as private_banking_account_indicator
        , f.foreign_bank_account_indicator                            as foreign_bank_account_indicator
        , f.initial_source_of_funds                                   as initial_source_of_funds
        , f.usa_patriot_act_exempt_reason                             as usa_patriot_act_exempt_reason
        , f.primary_country_of_citizenship                            as primary_country_of_citizenship
        , f.country_of_residence                                      as country_of_residence
        , f.birth_date                                                as birth_date
        , f.agebased_fund_roll_exempt_indicator                       as agebased_fund_roll_exempt_indicator
        , f.money_fund_reform__retail                                 as money_fund_reform__retail
        , f.trusted_contact_status                                    as trusted_contact_status
        , f.regulatory_account_type_category                          as regulatory_account_type_category
        , f.account_managed_by_trust_company_indicator                as account_managed_by_trust_company_indicator
        , f.voting_authority                                          as voting_authority
        , f.internal_use                                              as internal_use
        , f.internal_use_2                                            as internal_use_2
        , f.internal_use_3                                            as internal_use_3
        , f.internal_use_4                                            as internal_use_4
        , f.customer_type                                             as customer_type
        , f.internal_use_5                                            as internal_use_5
        , f.internal_use_6                                            as internal_use_6
        , f.internal_use_7                                            as internal_use_7
        , f.internal_use_8                                            as internal_use_8
        , f.internal_use_9                                            as internal_use_9
        , f.fulfillment_method                                        as fulfillment_method
        , f.credit_interest_indicator                                 as credit_interest_indicator
        , f.ama_indicator                                             as ama_indicator
        , f.for_pershing_internal_use_only_2                          as for_pershing_internal_use_only_2
        , b.tax_id_type                                               as tax_id_type
        , b.tax_id_number                                             as tax_id_number
        , b.tax_status                                                as tax_status
        , j.email_address_1                                           as email_address_1
        , j.telephone_number_1                                        as telephone_number_1
        , case
                when j.client_name_type_format = 'P'
                    then f.account_short_name
                when j.client_name_type_format = 'F'
                    then rtrim(ltrim(regexp_replace(concat_ws(
                                                            ' '
                                                        , coalesce(j.freeform_line_1, '')
                                                        , coalesce(j.freeform_line_2, '')
                                                        , coalesce(j.freeform_line_3, '')
                                                        , coalesce(j.freeform_line_4, '')
                                                    ), '(\s{2,})', ' '), ' '))
                end                                                     as account_title
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_first_name
                end                                                     as first_name
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_middle_name
                end                                                     as middle_name
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_last_name
                end                                                     as last_name
        , rtrim(ltrim(regexp_replace(concat_ws(
                                            ' '
                                        , coalesce(j.address_line_1, '')
                                        , coalesce(j.address_line_2, '')
                                        , coalesce(j.address_line_3, '')
                                        , coalesce(j.address_line_4, '')
                                    ), '(\s{2,})', ' '), ' '))
                                                                        as mailing_address_street
        , j.city                                                      as mailing_address_city
        , j.state                                                     as mailing_address_state
        , j.zippostal_code                                            as mailing_address_zip
        , j.country_code                                              as mailing_address_country
        , rtrim(ltrim(regexp_replace(concat_ws(
                                            ' '
                                        , coalesce(j.address_line_1_2, '')
                                        , coalesce(j.address_line_2_2, '')
                                        , coalesce(j.address_line_3_2, '')
                                        , coalesce(j.address_line_4_2, '')
                                    ), '(\s{2,})', ' '), ' '))
                                                                        as legal_address_street
        , j.city_2                                                    as legal_address_city
        , j.state_2                                                   as legal_address_state
        , j.zippostal_code_2                                          as legal_address_zip
        , j.country_code_2                                            as legal_address_country
        , maic.cost_basis_accounting_system                           as cost_basis_accounting_system
        , maic.disposition_method_for_mutual_funds                    as disposition_method_for_mutual_funds
        , maic.disposition_method_for_all_other_security_types        as disposition_method_for_all_other_security_types
        , maic.disposition_method_for_stocks_in_dividend_reinvestment as disposition_method_for_stocks_in_dividend_reinvestment
        , f._source_loaded_at                                         as _source_loaded_at
        , f._source_file                                              as _source_file
    from {{ ref('pershing_mwa__accf_a_main_account_information') }} as f
    left join accf_b as b
        on f.effective_date = b.effective_date
        and f.account_number = b.account_number
        and exists(select 1 from dates_to_refresh)
        and b.effective_date in (select distinct effective_date from dates_to_refresh)
    left join hldr_j as j
        on f.effective_date = j.effective_date
        and f.account_number = j.account_number
        and j.client_type = 'AH'
        and exists(select 1 from dates_to_refresh)
        and j.effective_date in (select distinct effective_date from dates_to_refresh)
    left join accf_c as maic
        on f.effective_date = maic.effective_date
        and f.account_number = maic.account_number
        and exists(select 1 from dates_to_refresh)
        and maic.effective_date in (select distinct effective_date from dates_to_refresh)
    inner join cte_date_index as dt
        on f.effective_date = dt.effective_date_base
    where 1 = 1
        and exists(select 1 from dates_to_refresh)
        and f.effective_date in (select distinct effective_date from cte_effective_dates)
)

, cte_account_spine_deltas as (
    select
        di.effective_date                                             as effective_date
        , f.effective_date                                            as effective_date_source
        , dt.effective_date_base                                      as effective_date_base
        , 1                                                           as order_preference
        , dt.delta_ordinal                                            as delta_ordinal
        , 'delta'                                                     as src
        , f.transaction_code                                          as transaction_code
        , f.record_indicator_value                                    as record_indicator_value
        , f.record_id_sequence_number                                 as record_id_sequence_number
        , f.account_number                                            as account_number
        , f.introducing_broker_dealer_ibd_number                      as introducing_broker_dealer_ibd_number
        , f.investment_professional_ip_number                         as investment_professional_ip_number
        , f.account_short_name                                        as account_short_name
        , f.transaction_type                                          as transaction_type
        , f.autotitled_or_usertitled_account                          as autotitled_or_usertitled_account
        , f.account_type_code                                         as account_type_code
        , f.registration_type                                         as registration_type
        , f.number_of_account_title_lines_in_registration_lines       as number_of_account_title_lines_in_registration_lines
        , f.account_registration_line_1                               as account_registration_line_1
        , f.account_registration_line_2                               as account_registration_line_2
        , f.account_registration_line_3                               as account_registration_line_3
        , f.account_registration_line_4                               as account_registration_line_4
        , f.account_registration_line_5                               as account_registration_line_5
        , f.account_registration_line_6                               as account_registration_line_6
        , f.date_account_opened                                       as date_account_opened
        , f.date_account_information_updated                          as date_account_information_updated
        , f.account_status_indicator                                  as account_status_indicator
        , f.pending_closed_date                                       as pending_closed_date
        , f.date_account_closed                                       as date_account_closed
        , f.closing_notice_date                                       as closing_notice_date
        , f.account_reactivated_date                                  as account_reactivated_date
        , f.date_account_reopened                                     as date_account_reopened
        , f.proceeds                                                  as proceeds
        , f.transfer_instructions                                     as transfer_instructions
        , f.income_instructions                                       as income_instructions
        , f.number_of_confirms_for_this_account                       as number_of_confirms_for_this_account
        , f.number_of_statements_for_this_account                     as number_of_statements_for_this_account
        , f.investment_objective_transaction_code                     as investment_objective_transaction_code
        , f.comments                                                  as comments
        , f.employer_shortname                                        as employer_shortname
        , f.employers_cusip                                           as employers_cusip
        , f.employers_symbol                                          as employers_symbol
        , f.margin_privileges_revoked                                 as margin_privileges_revoked
        , f.statement_review_date                                     as statement_review_date
        , f.margin_papers_on_file                                     as margin_papers_on_file
        , f.option_papers_on_file                                     as option_papers_on_file
        , f.for_pershing_internal_use_only                            as for_pershing_internal_use_only
        , f.good_faith_margin                                         as good_faith_margin
        , f.investment_professional_discretion_granted                as investment_professional_discretion_granted
        , f.investment_advisor_discretion_granted                     as investment_advisor_discretion_granted
        , f.third_party_discretion_granted                            as third_party_discretion_granted
        , f.third_party_name                                          as third_party_name
        , f.risk_factor_code                                          as risk_factor_code
        , f.investment_objective_code                                 as investment_objective_code
        , f.option__equities                                          as option__equities
        , f.option__index                                             as option__index
        , f.option__debt                                              as option__debt
        , f.option__currency                                          as option__currency
        , f.option_level_1                                            as option_level_1
        , f.option_level_2                                            as option_level_2
        , f.option_level_3                                            as option_level_3
        , f.option_level_4                                            as option_level_4
        , f.option__call_limits                                       as option__call_limits
        , f.option__put_limits                                        as option__put_limits
        , f.option__total_limits_of_puts_and_calls                    as option__total_limits_of_puts_and_calls
        , f.nonus_dollar_trading                                      as nonus_dollar_trading
        , f.not_used_reserved_for_future_use                          as not_used_reserved_for_future_use
        , f.noncustomer_indicator                                     as noncustomer_indicator
        , f.third_party_fee_indicator                                 as third_party_fee_indicator
        , f.third_party_fee_approval_date                             as third_party_fee_approval_date
        , f.intermediary_account_indicator                            as intermediary_account_indicator
        , f.commission_schedule                                       as commission_schedule
        , f.group_index                                               as group_index
        , f.money_manager_id                                          as money_manager_id
        , f.money_manager_objective_id                                as money_manager_objective_id
        , f.dtc_id_confirm_number_for_noncod_account                  as dtc_id_confirm_number_for_noncod_account
        , f.caps_master_mnemonic                                      as caps_master_mnemonic
        , f.employee_id                                               as employee_id
        , f.prime_brokerfree_fund_indicator                           as prime_brokerfree_fund_indicator
        , f.fee_based_account_indicator                               as fee_based_account_indicator
        , f.pershing_internal_use_only                                as pershing_internal_use_only
        , f.fee_based_termination_date                                as fee_based_termination_date
        , f.plan_name                                                 as plan_name
        , f.selfdirected_401k_account_type                            as selfdirected_401k_account_type
        , f.plan_type                                                 as plan_type
        , f.plan_number                                               as plan_number
        , f.employeeemployee_relative_indicator                       as employeeemployee_relative_indicator
        , f.commission_percent_discount                               as commission_percent_discount
        , f.block_mutual_fund_fees                                    as block_mutual_fund_fees
        , f.name_of_investment_professional_who_signed_new            as name_of_investment_professional_who_signed_new
        , f.date_investment_professional_signed_new_account_form      as date_investment_professional_signed_new_account_form
        , f.name_of_principal_who_signed_new_account_form             as name_of_principal_who_signed_new_account_form
        , f.date_principal_signed_new_account_form                    as date_principal_signed_new_account_form
        , f.politically_exposed_person_indicator                      as politically_exposed_person_indicator
        , f.private_banking_account_indicator                         as private_banking_account_indicator
        , f.foreign_bank_account_indicator                            as foreign_bank_account_indicator
        , f.initial_source_of_funds                                   as initial_source_of_funds
        , f.usa_patriot_act_exempt_reason                             as usa_patriot_act_exempt_reason
        , f.primary_country_of_citizenship                            as primary_country_of_citizenship
        , f.country_of_residence                                      as country_of_residence
        , f.birth_date                                                as birth_date
        , f.agebased_fund_roll_exempt_indicator                       as agebased_fund_roll_exempt_indicator
        , f.money_fund_reform__retail                                 as money_fund_reform__retail
        , f.trusted_contact_status                                    as trusted_contact_status
        , f.regulatory_account_type_category                          as regulatory_account_type_category
        , f.account_managed_by_trust_company_indicator                as account_managed_by_trust_company_indicator
        , f.voting_authority                                          as voting_authority
        , f.internal_use                                              as internal_use
        , f.internal_use_2                                            as internal_use_2
        , f.internal_use_3                                            as internal_use_3
        , f.internal_use_4                                            as internal_use_4
        , f.customer_type                                             as customer_type
        , f.internal_use_5                                            as internal_use_5
        , f.internal_use_6                                            as internal_use_6
        , f.internal_use_7                                            as internal_use_7
        , f.internal_use_8                                            as internal_use_8
        , f.internal_use_9                                            as internal_use_9
        , f.fulfillment_method                                        as fulfillment_method
        , f.credit_interest_indicator                                 as credit_interest_indicator
        , f.ama_indicator                                             as ama_indicator
        , f.for_pershing_internal_use_only_2                          as for_pershing_internal_use_only_2
        , b.tax_id_type                                               as tax_id_type
        , b.tax_id_number                                             as tax_id_number
        , b.tax_status                                                as tax_status
        , j.email_address_1                                           as email_address_1
        , j.telephone_number_1                                        as telephone_number_1
        , case
                when j.client_name_type_format = 'P'
                    then f.account_short_name
                when j.client_name_type_format = 'F'
                    then rtrim(ltrim(regexp_replace(concat_ws(
                                                            ' '
                                                        , coalesce(j.freeform_line_1, '')
                                                        , coalesce(j.freeform_line_2, '')
                                                        , coalesce(j.freeform_line_3, '')
                                                        , coalesce(j.freeform_line_4, '')
                                                    ), '(\s{2,})', ' '), ' '))
                end                                                     as account_title
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_first_name
                end                                                     as first_name
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_middle_name
                end                                                     as middle_name
        , case
                when j.client_name_type_format = 'P'
                    then j.individual_last_name
                end                                                     as last_name
        , rtrim(ltrim(regexp_replace(concat_ws(
                                            ' '
                                        , coalesce(j.address_line_1, '')
                                        , coalesce(j.address_line_2, '')
                                        , coalesce(j.address_line_3, '')
                                        , coalesce(j.address_line_4, '')
                                    ), '(\s{2,})', ' '), ' '))
                                                                        as mailing_address_street
        , j.city                                                      as mailing_address_city
        , j.state                                                     as mailing_address_state
        , j.zippostal_code                                            as mailing_address_zip
        , j.country_code                                              as mailing_address_country
        , rtrim(ltrim(regexp_replace(concat_ws(
                                            ' '
                                        , coalesce(j.address_line_1_2, '')
                                        , coalesce(j.address_line_2_2, '')
                                        , coalesce(j.address_line_3_2, '')
                                        , coalesce(j.address_line_4_2, '')
                                    ), '(\s{2,})', ' '), ' '))
                                                                        as legal_address_street
        , j.city_2                                                    as legal_address_city
        , j.state_2                                                   as legal_address_state
        , j.zippostal_code_2                                          as legal_address_zip
        , j.country_code_2                                            as legal_address_country
        , maic.cost_basis_accounting_system                           as cost_basis_accounting_system
        , maic.disposition_method_for_mutual_funds                    as disposition_method_for_mutual_funds
        , maic.disposition_method_for_all_other_security_types        as disposition_method_for_all_other_security_types
        , maic.disposition_method_for_stocks_in_dividend_reinvestment as disposition_method_for_stocks_in_dividend_reinvestment
        , f._source_loaded_at                                         as _source_loaded_at
        , f._source_file                                              as _source_file
    from {{ ref('pershing_mwa__acct_a_main_account_information') }} as f
    left join acct_b as b
        on f.effective_date = b.effective_date
        and f.account_number = b.account_number
        and exists(select 1 from dates_to_refresh)
        and b.effective_date in (select distinct effective_date from dates_to_refresh)
    left join hldr_j as j
        on f.effective_date = j.effective_date
        and f.account_number = j.account_number
        and j.client_type = 'AH'
        and exists(select 1 from dates_to_refresh)
        and j.effective_date in (select distinct effective_date from dates_to_refresh)
    left join acct_c as maic
        on f.effective_date = maic.effective_date
        and f.account_number = maic.account_number
        and exists(select 1 from dates_to_refresh)
        and maic.effective_date in (select distinct effective_date from dates_to_refresh)
    inner join cte_date_index as dt
        on f.effective_date = dt.effective_date
    cross join (select effective_date from cte_date_index) as di
    where 1 = 1
        and di.effective_date between f.effective_date and dateadd(d , 6 , dt.effective_date_base)
        and exists(select 1 from dates_to_refresh)
        and f.effective_date in (select distinct effective_date from cte_effective_dates)
)

, cte_accounts_all as (
    select *
    from cte_account_spine_fulls

    union all

    select *
    from cte_account_spine_deltas
    qualify row_number() over (
        partition by effective_date , account_number
        order by effective_date_source desc
    ) = 1
)

select
    effective_date                                       as effective_date
  , effective_date_source                                as effective_date_source
  , effective_date_base                                  as effective_date_base
    --   , order_preference
    --   , delta_ordinal
  , 'pershing'                                           as custodian
  , 'mwa'                                                as firm_source
  , transaction_code                                     as transaction_code
  , record_indicator_value                               as record_indicator_value
  , record_id_sequence_number                            as record_id_sequence_number
  , account_number                                       as account_number
  , introducing_broker_dealer_ibd_number                 as introducing_broker_dealer_ibd_number
  , investment_professional_ip_number                    as investment_professional_ip_number
  , account_short_name                                   as account_short_name
  , transaction_type                                     as transaction_type
  , autotitled_or_usertitled_account                     as autotitled_or_usertitled_account
  , account_type_code                                    as account_type_code
  , registration_type                                    as registration_type
  , number_of_account_title_lines_in_registration_lines  as number_of_account_title_lines_in_registration_lines
  , account_registration_line_1                          as account_registration_line_1
  , account_registration_line_2                          as account_registration_line_2
  , account_registration_line_3                          as account_registration_line_3
  , account_registration_line_4                          as account_registration_line_4
  , account_registration_line_5                          as account_registration_line_5
  , account_registration_line_6                          as account_registration_line_6
  , date_account_opened                                  as date_account_opened
  , date_account_information_updated                     as date_account_information_updated
  , account_status_indicator                             as account_status_indicator
  , pending_closed_date                                  as pending_closed_date
  , date_account_closed                                  as date_account_closed
  , closing_notice_date                                  as closing_notice_date
  , account_reactivated_date                             as account_reactivated_date
  , date_account_reopened                                as date_account_reopened
  , proceeds                                             as proceeds
  , transfer_instructions                                as transfer_instructions
  , income_instructions                                  as income_instructions
  , number_of_confirms_for_this_account                  as number_of_confirms_for_this_account
  , number_of_statements_for_this_account                as number_of_statements_for_this_account
  , investment_objective_transaction_code                as investment_objective_transaction_code
  , comments                                             as comments
  , employer_shortname                                   as employer_shortname
  , employers_cusip                                      as employers_cusip
  , employers_symbol                                     as employers_symbol
  , margin_privileges_revoked                            as margin_privileges_revoked
  , statement_review_date                                as statement_review_date
  , margin_papers_on_file                                as margin_papers_on_file
  , option_papers_on_file                                as option_papers_on_file
  , for_pershing_internal_use_only                       as for_pershing_internal_use_only
  , good_faith_margin                                    as good_faith_margin
  , investment_professional_discretion_granted           as investment_professional_discretion_granted
  , investment_advisor_discretion_granted                as investment_advisor_discretion_granted
  , third_party_discretion_granted                       as third_party_discretion_granted
  , third_party_name                                     as third_party_name
  , risk_factor_code                                     as risk_factor_code
  , investment_objective_code                            as investment_objective_code
  , option__equities                                     as option__equities
  , option__index                                        as option__index
  , option__debt                                         as option__debt
  , option__currency                                     as option__currency
  , option_level_1                                       as option_level_1
  , option_level_2                                       as option_level_2
  , option_level_3                                       as option_level_3
  , option_level_4                                       as option_level_4
  , option__call_limits                                  as option__call_limits
  , option__put_limits                                   as option__put_limits
  , option__total_limits_of_puts_and_calls               as option__total_limits_of_puts_and_calls
  , nonus_dollar_trading                                 as nonus_dollar_trading
  , not_used_reserved_for_future_use                     as not_used_reserved_for_future_use
  , noncustomer_indicator                                as noncustomer_indicator
  , third_party_fee_indicator                            as third_party_fee_indicator
  , third_party_fee_approval_date                        as third_party_fee_approval_date
  , intermediary_account_indicator                       as intermediary_account_indicator
  , commission_schedule                                  as commission_schedule
  , group_index                                          as group_index
  , money_manager_id                                     as money_manager_id
  , money_manager_objective_id                           as money_manager_objective_id
  , dtc_id_confirm_number_for_noncod_account             as dtc_id_confirm_number_for_noncod_account
  , caps_master_mnemonic                                 as caps_master_mnemonic
  , employee_id                                          as employee_id
  , prime_brokerfree_fund_indicator                      as prime_brokerfree_fund_indicator
  , fee_based_account_indicator                          as fee_based_account_indicator
  , pershing_internal_use_only                           as pershing_internal_use_only
  , fee_based_termination_date                           as fee_based_termination_date
  , plan_name                                            as plan_name
  , selfdirected_401k_account_type                       as selfdirected_401k_account_type
  , plan_type                                            as plan_type
  , plan_number                                          as plan_number
  , employeeemployee_relative_indicator                  as employeeemployee_relative_indicator
  , commission_percent_discount                          as commission_percent_discount
  , block_mutual_fund_fees                               as block_mutual_fund_fees
  , name_of_investment_professional_who_signed_new       as name_of_investment_professional_who_signed_new
  , date_investment_professional_signed_new_account_form as date_investment_professional_signed_new_account_form
  , name_of_principal_who_signed_new_account_form        as name_of_principal_who_signed_new_account_form
  , date_principal_signed_new_account_form               as date_principal_signed_new_account_form
  , politically_exposed_person_indicator                 as politically_exposed_person_indicator
  , private_banking_account_indicator                    as private_banking_account_indicator
  , foreign_bank_account_indicator                       as foreign_bank_account_indicator
  , initial_source_of_funds                              as initial_source_of_funds
  , usa_patriot_act_exempt_reason                        as usa_patriot_act_exempt_reason
  , primary_country_of_citizenship                       as primary_country_of_citizenship
  , country_of_residence                                 as country_of_residence
  , birth_date                                           as birth_date
  , agebased_fund_roll_exempt_indicator                  as agebased_fund_roll_exempt_indicator
  , money_fund_reform__retail                            as money_fund_reform__retail
  , trusted_contact_status                               as trusted_contact_status
  , regulatory_account_type_category                     as regulatory_account_type_category
  , account_managed_by_trust_company_indicator           as account_managed_by_trust_company_indicator
  , voting_authority                                     as voting_authority
  , internal_use                                         as internal_use
  , internal_use_2                                       as internal_use_2
  , internal_use_3                                       as internal_use_3
  , internal_use_4                                       as internal_use_4
  , customer_type                                        as customer_type
  , internal_use_5                                       as internal_use_5
  , internal_use_6                                       as internal_use_6
  , internal_use_7                                       as internal_use_7
  , internal_use_8                                       as internal_use_8
  , internal_use_9                                       as internal_use_9
  , fulfillment_method                                   as fulfillment_method
  , credit_interest_indicator                            as credit_interest_indicator
  , ama_indicator                                        as ama_indicator
  , for_pershing_internal_use_only_2                     as for_pershing_internal_use_only_2
  , tax_id_type                                          as tax_id_type
  , tax_id_number::text(500)                             as tax_id_number
  , tax_status                                           as tax_status
  , email_address_1                                      as email_address_1
  , telephone_number_1                                   as telephone_number_1
  , account_title                                        as account_title
  , first_name                                           as first_name
  , middle_name                                          as middle_name
  , last_name                                            as last_name
  , mailing_address_street                               as mailing_address_street
  , mailing_address_city                                 as mailing_address_city
  , mailing_address_state                                as mailing_address_state
  , mailing_address_zip                                  as mailing_address_zip
  , mailing_address_country                              as mailing_address_country
  , legal_address_street                                 as legal_address_street
  , legal_address_city                                   as legal_address_city
  , legal_address_state                                  as legal_address_state
  , legal_address_zip                                    as legal_address_zip
  , legal_address_country                                as legal_address_country
  , cost_basis_accounting_system                         as cost_basis_accounting_system
  , disposition_method_for_mutual_funds                  as disposition_method_for_mutual_funds
  , disposition_method_for_all_other_security_types      as disposition_method_for_all_other_security_types
  , disposition_method_for_stocks_in_dividend_reinvestment
  , current_timestamp()::timestamp_ntz                   as _created_at
  , _source_loaded_at::timestamp_ntz                     as _source_loaded_at
  , _source_file                                         as _source_file
  , row_number() over (
    partition by effective_date , account_number
    order by order_preference , delta_ordinal
    )                                                    as rn
from cte_accounts_all
where 1 = 1
    and exists(select 1 from dates_to_refresh)
    and effective_date in (select distinct effective_date from dates_to_refresh)
qualify
    row_number() over (
        partition by effective_date , account_number
        order by order_preference , delta_ordinal
    ) = 1
order by effective_date
