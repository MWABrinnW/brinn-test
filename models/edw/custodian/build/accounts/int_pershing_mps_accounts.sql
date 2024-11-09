-- depends_on: {{ source('pershing_mps', 'accf') }}
-- depends_on: {{ source('pershing_mps', 'acct') }}
-- depends_on: {{ ref('pershing_mps__accf_a_main_account_information') }}
-- depends_on: {{ ref('pershing_mps__accf_b_main_account_information') }}
-- depends_on: {{ ref('pershing_mps__acct_a_main_account_information') }}
-- depends_on: {{ ref('pershing_mps__acct_b_main_account_information') }}
-- depends_on: {{ ref('pershing_mps__hldr_j_individual_entity_client_common_information') }}
-- depends_on: {{ ref('pershing_mps__accf_c_main_account_information_address_1_and_2') }}
-- depends_on: {{ ref('pershing_mps__acct_c_main_account_information_address_1_and_2') }}

{{config(
    materialized='table',
)}}

/*
    Pershing sends full files weekly (fridays) and delta files on all days.
    We need to use the full files as a base and layer on top any changes received from the delta files.

    - Set all full records and duplicate each full file across the following delta files (up until the next full file)
    - Get all delta records
    - Date spine all full and delta records to extend them through the current week
    - Union all full and delta records together
    - Select first record for each date
*/

with cte_effective_date_map as
(
    select distinct effective_date, 'full' as src
    from {{ source('pershing_mps', 'accf') }}
    where true

    union

    select distinct effective_date, 'delta' as src
    from {{ source('pershing_mps', 'acct') }}
    where true
        and effective_date >= (select min(effective_date) from {{ ref('pershing_mps__accf_a_main_account_information') }})
)
,cte_effective_dates as
(
    select distinct effective_date
    from cte_effective_date_map
)
,cte_full_dates as
(
    select distinct effective_date
    from cte_effective_date_map
    where src = 'full'
)
,cte_date_index as
(
    select
        s.effective_date as effective_date_base
        ,d.date_key as effective_date
        ,row_number() over(partition by s.effective_date order by d.date_key) - 1 as delta_ordinal
    from cte_full_dates s
    cross join (
        select date_key
        from edw.ref.dates
        where true
            and is_market_day = 1
            and date_key between (select min(effective_date) from cte_effective_dates) and (select max(effective_date) from cte_effective_dates)
        ) d
    where datediff(day, s.effective_date, d.date_key) between 0 and 6
)
,cte_account_spine_fulls as
(
    select
         dt.effective_date as effective_date
        ,f.effective_date as effective_date_source
        ,f.effective_date as effective_date_base
        ,2 as order_preference
        ,dt.delta_ordinal
        ,'full' as src
        ,f.transaction_code
        ,f.record_indicator_value
        ,f.record_id_sequence_number
        ,f.account_number
        ,f.introducing_broker_dealer_ibd_number
        ,f.investment_professional_ip_number
        ,f.account_short_name
        ,f.transaction_type
        ,f.autotitled_or_usertitled_account
        ,f.account_type_code
        ,f.registration_type
        ,f.number_of_account_title_lines_in_registration_lines
        ,f.account_registration_line_1
        ,f.account_registration_line_2
        ,f.account_registration_line_3
        ,f.account_registration_line_4
        ,f.account_registration_line_5
        ,f.account_registration_line_6
        ,f.date_account_opened
        ,f.date_account_information_updated
        ,f.account_status_indicator
        ,f.pending_closed_date
        ,f.date_account_closed
        ,f.closing_notice_date
        ,f.account_reactivated_date
        ,f.date_account_reopened
        ,f.proceeds
        ,f.transfer_instructions
        ,f.income_instructions
        ,f.number_of_confirms_for_this_account
        ,f.number_of_statements_for_this_account
        ,f.investment_objective_transaction_code
        ,f.comments
        ,f.employer_shortname
        ,f.employers_cusip
        ,f.employers_symbol
        ,f.margin_privileges_revoked
        ,f.statement_review_date
        ,f.margin_papers_on_file
        ,f.option_papers_on_file
        ,f.for_pershing_internal_use_only
        ,f.good_faith_margin
        ,f.investment_professional_discretion_granted
        ,f.investment_advisor_discretion_granted
        ,f.third_party_discretion_granted
        ,f.third_party_name
        ,f.risk_factor_code
        ,f.investment_objective_code
        ,f.option__equities
        ,f.option__index
        ,f.option__debt
        ,f.option__currency
        ,f.option_level_1
        ,f.option_level_2
        ,f.option_level_3
        ,f.option_level_4
        ,f.option__call_limits
        ,f.option__put_limits
        ,f.option__total_limits_of_puts_and_calls
        ,f.nonus_dollar_trading
        ,f.not_used_reserved_for_future_use
        ,f.noncustomer_indicator
        ,f.third_party_fee_indicator
        ,f.third_party_fee_approval_date
        ,f.intermediary_account_indicator
        ,f.commission_schedule
        ,f.group_index
        ,f.money_manager_id
        ,f.money_manager_objective_id
        ,f.dtc_id_confirm_number_for_noncod_account
        ,f.caps_master_mnemonic
        ,f.employee_id
        ,f.prime_brokerfree_fund_indicator
        ,f.fee_based_account_indicator
        ,f.pershing_internal_use_only
        ,f.fee_based_termination_date
        ,f.plan_name
        ,f.selfdirected_401k_account_type
        ,f.plan_type
        ,f.plan_number
        ,f.employeeemployee_relative_indicator
        ,f.commission_percent_discount
        ,f.block_mutual_fund_fees
        ,f.name_of_investment_professional_who_signed_new
        ,f.date_investment_professional_signed_new_account_form
        ,f.name_of_principal_who_signed_new_account_form
        ,f.date_principal_signed_new_account_form
        ,f.politically_exposed_person_indicator
        ,f.private_banking_account_indicator
        ,f.foreign_bank_account_indicator
        ,f.initial_source_of_funds
        ,f.usa_patriot_act_exempt_reason
        ,f.primary_country_of_citizenship
        ,f.country_of_residence
        ,f.birth_date
        ,f.agebased_fund_roll_exempt_indicator
        ,f.money_fund_reform__retail
        ,f.trusted_contact_status
        ,f.regulatory_account_type_category
        ,f.account_managed_by_trust_company_indicator
        ,f.voting_authority
        ,f.internal_use
        ,f.internal_use_2
        ,f.internal_use_3
        ,f.internal_use_4
        ,f.customer_type
        ,f.internal_use_5
        ,f.internal_use_6
        ,f.internal_use_7
        ,f.internal_use_8
        ,f.internal_use_9
        ,f.fulfillment_method
        ,f.credit_interest_indicator
        ,f.ama_indicator
        ,f.for_pershing_internal_use_only_2
        ,b.tax_id_type
        ,b.tax_id_number
        ,b.tax_status
        ,j.email_address_1
        ,j.telephone_number_1
        ,case
            when j.client_name_type_format = 'P'
                then f.account_short_name
            when j.client_name_type_format = 'F'
                then  rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.freeform_line_1, '')
                             , nvl(j.freeform_line_2, '')
                             , nvl(j.freeform_line_3, '')
                             , nvl(j.freeform_line_4, '')), '(\s{2,})', ' '), ' '))
            end as account_title
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_first_name
            else null
            end                                     as first_name
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_middle_name
            else null
            end                                     as middle_name
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_last_name
            else null
            end                                     as last_name
        ,rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.address_line_1, '')
                             , nvl(j.address_line_2, '')
                             , nvl(j.address_line_3, '')
                             , nvl(j.address_line_4, '')), '(\s{2,})', ' '), ' '))
                                                    as mailing_address_street
        ,j.city                                     as mailing_address_city
        ,j.state                                    as mailing_address_state
        ,j.zippostal_code                           as mailing_address_zip
        ,j.country_code                             as mailing_address_country
        ,rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.address_line_1_2, '')
                             , nvl(j.address_line_2_2, '')
                             , nvl(j.address_line_3_2, '')
                             , nvl(j.address_line_4_2, '')), '(\s{2,})', ' '), ' '))
                                                    as legal_address_street
        ,j.city_2                                   as legal_address_city
        ,j.state_2                                  as legal_address_state
        ,j.zippostal_code_2                         as legal_address_zip
        ,j.country_code_2                           as legal_address_country
        ,maic.cost_basis_accounting_system
        ,maic.disposition_method_for_mutual_funds
        ,maic.disposition_method_for_all_other_security_types
        ,maic.disposition_method_for_stocks_in_dividend_reinvestment
        ,f.is_head
        {# ,f.is_current #}
        ,f._source_loaded_at
        ,f._source_file
    from {{ ref('pershing_mps__accf_a_main_account_information') }} f
    left join {{ ref('pershing_mps__accf_b_main_account_information') }} b
        on f.effective_date = b.effective_date
        and f.account_number = b.account_number
    left join {{ ref('pershing_mps__hldr_j_individual_entity_client_common_information') }} j
        on f.effective_date = j.effective_date
        and f.account_number = j.account_number
        and j.client_type = 'AH'
    left join {{ ref('pershing_mps__accf_c_main_account_information_address_1_and_2') }} maic
        on f.effective_date = maic.effective_date
        and f.account_number = maic.account_number
    join cte_date_index dt
        on f.effective_date = dt.effective_date_base
)
,cte_account_spine_deltas as
(
    select
         di.effective_date as effective_date
        ,f.effective_date as effective_date_source
        ,dt.effective_date_base as effective_date_base
        ,1 as order_preference
        ,dt.delta_ordinal
        ,'delta' as src
        ,f.transaction_code
        ,f.record_indicator_value
        ,f.record_id_sequence_number
        ,f.account_number
        ,f.introducing_broker_dealer_ibd_number
        ,f.investment_professional_ip_number
        ,f.account_short_name
        ,f.transaction_type
        ,f.autotitled_or_usertitled_account
        ,f.account_type_code
        ,f.registration_type
        ,f.number_of_account_title_lines_in_registration_lines
        ,f.account_registration_line_1
        ,f.account_registration_line_2
        ,f.account_registration_line_3
        ,f.account_registration_line_4
        ,f.account_registration_line_5
        ,f.account_registration_line_6
        ,f.date_account_opened
        ,f.date_account_information_updated
        ,f.account_status_indicator
        ,f.pending_closed_date
        ,f.date_account_closed
        ,f.closing_notice_date
        ,f.account_reactivated_date
        ,f.date_account_reopened
        ,f.proceeds
        ,f.transfer_instructions
        ,f.income_instructions
        ,f.number_of_confirms_for_this_account
        ,f.number_of_statements_for_this_account
        ,f.investment_objective_transaction_code
        ,f.comments
        ,f.employer_shortname
        ,f.employers_cusip
        ,f.employers_symbol
        ,f.margin_privileges_revoked
        ,f.statement_review_date
        ,f.margin_papers_on_file
        ,f.option_papers_on_file
        ,f.for_pershing_internal_use_only
        ,f.good_faith_margin
        ,f.investment_professional_discretion_granted
        ,f.investment_advisor_discretion_granted
        ,f.third_party_discretion_granted
        ,f.third_party_name
        ,f.risk_factor_code
        ,f.investment_objective_code
        ,f.option__equities
        ,f.option__index
        ,f.option__debt
        ,f.option__currency
        ,f.option_level_1
        ,f.option_level_2
        ,f.option_level_3
        ,f.option_level_4
        ,f.option__call_limits
        ,f.option__put_limits
        ,f.option__total_limits_of_puts_and_calls
        ,f.nonus_dollar_trading
        ,f.not_used_reserved_for_future_use
        ,f.noncustomer_indicator
        ,f.third_party_fee_indicator
        ,f.third_party_fee_approval_date
        ,f.intermediary_account_indicator
        ,f.commission_schedule
        ,f.group_index
        ,f.money_manager_id
        ,f.money_manager_objective_id
        ,f.dtc_id_confirm_number_for_noncod_account
        ,f.caps_master_mnemonic
        ,f.employee_id
        ,f.prime_brokerfree_fund_indicator
        ,f.fee_based_account_indicator
        ,f.pershing_internal_use_only
        ,f.fee_based_termination_date
        ,f.plan_name
        ,f.selfdirected_401k_account_type
        ,f.plan_type
        ,f.plan_number
        ,f.employeeemployee_relative_indicator
        ,f.commission_percent_discount
        ,f.block_mutual_fund_fees
        ,f.name_of_investment_professional_who_signed_new
        ,f.date_investment_professional_signed_new_account_form
        ,f.name_of_principal_who_signed_new_account_form
        ,f.date_principal_signed_new_account_form
        ,f.politically_exposed_person_indicator
        ,f.private_banking_account_indicator
        ,f.foreign_bank_account_indicator
        ,f.initial_source_of_funds
        ,f.usa_patriot_act_exempt_reason
        ,f.primary_country_of_citizenship
        ,f.country_of_residence
        ,f.birth_date
        ,f.agebased_fund_roll_exempt_indicator
        ,f.money_fund_reform__retail
        ,f.trusted_contact_status
        ,f.regulatory_account_type_category
        ,f.account_managed_by_trust_company_indicator
        ,f.voting_authority
        ,f.internal_use
        ,f.internal_use_2
        ,f.internal_use_3
        ,f.internal_use_4
        ,f.customer_type
        ,f.internal_use_5
        ,f.internal_use_6
        ,f.internal_use_7
        ,f.internal_use_8
        ,f.internal_use_9
        ,f.fulfillment_method
        ,f.credit_interest_indicator
        ,f.ama_indicator
        ,f.for_pershing_internal_use_only_2
        ,b.tax_id_type
        ,b.tax_id_number
        ,b.tax_status
        ,j.email_address_1
        ,j.telephone_number_1
        ,case
            when j.client_name_type_format = 'P'
                then f.account_short_name
            when j.client_name_type_format = 'F'
                then  rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.freeform_line_1, '')
                             , nvl(j.freeform_line_2, '')
                             , nvl(j.freeform_line_3, '')
                             , nvl(j.freeform_line_4, '')), '(\s{2,})', ' '), ' '))
            end as account_title
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_first_name
            else null
            end                                     as first_name
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_middle_name
            else null
            end                                     as middle_name
        ,case
            when j.client_name_type_format = 'P'
                then j.individual_last_name
            else null
            end                                     as last_name
        ,rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.address_line_1, '')
                             , nvl(j.address_line_2, '')
                             , nvl(j.address_line_3, '')
                             , nvl(j.address_line_4, '')), '(\s{2,})', ' '), ' '))
                                                    as mailing_address_street
        ,j.city                                     as mailing_address_city
        ,j.state                                    as mailing_address_state
        ,j.zippostal_code                           as mailing_address_zip
        ,j.country_code                             as mailing_address_country
        ,rtrim(ltrim(regexp_replace(concat_ws(' '
                             , nvl(j.address_line_1_2, '')
                             , nvl(j.address_line_2_2, '')
                             , nvl(j.address_line_3_2, '')
                             , nvl(j.address_line_4_2, '')), '(\s{2,})', ' '), ' '))
                                                    as legal_address_street
        ,j.city_2                                   as legal_address_city
        ,j.state_2                                  as legal_address_state
        ,j.zippostal_code_2                         as legal_address_zip
        ,j.country_code_2                           as legal_address_country
        ,maic.cost_basis_accounting_system
        ,maic.disposition_method_for_mutual_funds
        ,maic.disposition_method_for_all_other_security_types
        ,maic.disposition_method_for_stocks_in_dividend_reinvestment
        ,f.is_head
        {# ,f.is_current #}
        ,f._source_loaded_at
        ,f._source_file
    from {{ ref('pershing_mps__acct_a_main_account_information') }} f
    left join {{ ref('pershing_mps__acct_b_main_account_information') }} b
        on f.effective_date = b.effective_date
        and f.account_number = b.account_number
    left join {{ ref('pershing_mps__hldr_j_individual_entity_client_common_information') }} j
        on f.effective_date = j.effective_date
        and f.account_number = j.account_number
        and j.client_type = 'AH'
    left join {{ ref('pershing_mps__acct_c_main_account_information_address_1_and_2') }} maic
        on f.effective_date = maic.effective_date
        and f.account_number = maic.account_number
    join cte_date_index dt
        on f.effective_date = dt.effective_date
    cross join (select effective_date from cte_date_index) di
    where di.effective_date between f.effective_date and dateadd(d, 6, dt.effective_date_base)
)
,cte_accounts_all as
(
    select *
    from cte_account_spine_fulls

    union all

    select *
    from cte_account_spine_deltas
    qualify row_number() over(partition by effective_date, account_number order by effective_date_source desc) = 1
)

select
    effective_date
  , effective_date_source
  , effective_date_base
--   , order_preference
--   , delta_ordinal
  , 'pershing' as custodian
  , 'mps' as firm_source
  , transaction_code
  , record_indicator_value
  , record_id_sequence_number
  , account_number
  , introducing_broker_dealer_ibd_number
  , investment_professional_ip_number
  , account_short_name
  , transaction_type
  , autotitled_or_usertitled_account
  , account_type_code
  , registration_type
  , number_of_account_title_lines_in_registration_lines
  , account_registration_line_1
  , account_registration_line_2
  , account_registration_line_3
  , account_registration_line_4
  , account_registration_line_5
  , account_registration_line_6
  , date_account_opened
  , date_account_information_updated
  , account_status_indicator
  , pending_closed_date
  , date_account_closed
  , closing_notice_date
  , account_reactivated_date
  , date_account_reopened
  , proceeds
  , transfer_instructions
  , income_instructions
  , number_of_confirms_for_this_account
  , number_of_statements_for_this_account
  , investment_objective_transaction_code
  , comments
  , employer_shortname
  , employers_cusip
  , employers_symbol
  , margin_privileges_revoked
  , statement_review_date
  , margin_papers_on_file
  , option_papers_on_file
  , for_pershing_internal_use_only
  , good_faith_margin
  , investment_professional_discretion_granted
  , investment_advisor_discretion_granted
  , third_party_discretion_granted
  , third_party_name
  , risk_factor_code
  , investment_objective_code
  , option__equities
  , option__index
  , option__debt
  , option__currency
  , option_level_1
  , option_level_2
  , option_level_3
  , option_level_4
  , option__call_limits
  , option__put_limits
  , option__total_limits_of_puts_and_calls
  , nonus_dollar_trading
  , not_used_reserved_for_future_use
  , noncustomer_indicator
  , third_party_fee_indicator
  , third_party_fee_approval_date
  , intermediary_account_indicator
  , commission_schedule
  , group_index
  , money_manager_id
  , money_manager_objective_id
  , dtc_id_confirm_number_for_noncod_account
  , caps_master_mnemonic
  , employee_id
  , prime_brokerfree_fund_indicator
  , fee_based_account_indicator
  , pershing_internal_use_only
  , fee_based_termination_date
  , plan_name
  , selfdirected_401k_account_type
  , plan_type
  , plan_number
  , employeeemployee_relative_indicator
  , commission_percent_discount
  , block_mutual_fund_fees
  , name_of_investment_professional_who_signed_new
  , date_investment_professional_signed_new_account_form
  , name_of_principal_who_signed_new_account_form
  , date_principal_signed_new_account_form
  , politically_exposed_person_indicator
  , private_banking_account_indicator
  , foreign_bank_account_indicator
  , initial_source_of_funds
  , usa_patriot_act_exempt_reason
  , primary_country_of_citizenship
  , country_of_residence
  , birth_date
  , agebased_fund_roll_exempt_indicator
  , money_fund_reform__retail
  , trusted_contact_status
  , regulatory_account_type_category
  , account_managed_by_trust_company_indicator
  , voting_authority
  , internal_use
  , internal_use_2
  , internal_use_3
  , internal_use_4
  , customer_type
  , internal_use_5
  , internal_use_6
  , internal_use_7
  , internal_use_8
  , internal_use_9
  , fulfillment_method
  , credit_interest_indicator
  , ama_indicator
  , for_pershing_internal_use_only_2
  , tax_id_type
  , tax_id_number::text(500) as tax_id_number
  , tax_status
  , email_address_1
  , telephone_number_1
  , account_title
  , first_name
  , middle_name
  , last_name
  , mailing_address_street
  , mailing_address_city
  , mailing_address_state
  , mailing_address_zip
  , mailing_address_country
  , legal_address_street
  , legal_address_city
  , legal_address_state
  , legal_address_zip
  , legal_address_country
  , cost_basis_accounting_system
  , disposition_method_for_mutual_funds
  , disposition_method_for_all_other_security_types
  , disposition_method_for_stocks_in_dividend_reinvestment
  , {{ col_is_head(reference='cte_accounts_all') }}
  , {{ col_is_current(date_col='effective_date') }}
  , current_timestamp()::timestamp as _created_at
  , _source_loaded_at::timestamp as _source_loaded_at
  , _source_file
  , row_number() over(partition by effective_date, account_number order by order_preference, delta_ordinal) as rn
from cte_accounts_all
where true
qualify row_number() over(partition by effective_date, account_number order by order_preference, delta_ordinal) = 1
order by effective_date
