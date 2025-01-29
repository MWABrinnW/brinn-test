{%- macro select_nml_account_coalesce(system_key) -%}
, coalesce(
        coalesce(
            ovrd_acc._custodian
            , ovrd_pms_acc._custodian
            , ovrd_pms_adv._custodian
        )
        , map_cus_glo.target_value , pms_custodian , crm_custodian
    )                                                                        as custodian
    , pms_account_id                                                         as account_id
    , coalesce(crm_account_type , pms_account_type)                          as account_type
    , coalesce(
        coalesce(
            ovrd_acc._account_name
            , ovrd_pms_acc._account_name
            , ovrd_pms_adv._account_name
        )
        , crm_account_name
        , pms_account_name
    )                                                                        as account_name
    , coalesce(crm_registrant_name , pms_registrant_name)                    as registrant_name
    , pms_household_id                                                       as household_id
    , coalesce(crm_household_name , pms_household_name)                      as household_name
    , pms_is_active                                                          as is_active
    , pms_created_date                                                       as created_date
    , coalesce(pms_opened_date , crm_opened_date)                            as opened_date
    , case when a.system_key in ('salesforce__compass_rps', 'salesforce__compass_mic', 'tpg__hfw') then crm_closed_date
        else pms_closed_date 
    end                                                                      as closed_date
    , coalesce(
        coalesce(
            ovrd_acc._account_value
            , ovrd_pms_acc._account_value
            , ovrd_pms_adv._account_value
        )
        {% if system_key | lower == 'salesforce__compass_rps' -%} , nv.plan_assets_c::decimal(16 , 2) {%- endif %}
    {% if system_key | lower == 'salesforce__compass_mic' -%} , crm_account_value {%- endif %}

        , pms_account_value
    )                                                                        as account_value
    , coalesce(
        coalesce(
            ovrd_acc._advisor
            , ovrd_pms_acc._advisor
            , ovrd_pms_adv._advisor
        )
        , pms_advisor , crm_advisor
    )                                                                        as advisor
    , coalesce(
        coalesce(
            ovrd_acc._advisor_email
            , ovrd_pms_acc._advisor_email
            , ovrd_pms_adv._advisor_email
        )
        , pms_advisor_email , crm_advisor_email
    )                                                                        as advisor_email
    , null::text(100)                                                        as advisor_employee_id
    , coalesce(
        coalesce(
            ovrd_acc._location_code
            , ovrd_pms_acc._location_code
            , ovrd_pms_adv._location_code
        )
        , crm_location_code , pms_location_code
    )                                                                        as location_code
    , coalesce(pms_fee_schedule , crm_fee_schedule)                          as fee_schedule
    , coalesce(pms_investment_strategy , crm_investment_strategy)            as investment_strategy
    , coalesce(
        coalesce(
            ovrd_acc._aum_classification
            , ovrd_pms_acc._aum_classification
            , ovrd_pms_adv._aum_classification
        )
        , crm_aum_classification , pms_aum_classification
    )                                                                        as aum_classification
    , coalesce(
        coalesce(
            ovrd_acc._is_erisa
            , ovrd_pms_acc._is_erisa
            , ovrd_pms_adv._is_erisa
        )
        , crm_is_erisa , pms_is_erisa
    )                                                                        as is_erisa
    , coalesce(
        coalesce(
            ovrd_acc._is_discretionary
            , ovrd_pms_acc._is_discretionary
            , ovrd_pms_adv._is_discretionary
        )
        , crm_is_discretionary , pms_is_discretionary
    )                                                                        as is_discretionary
    , coalesce(
        coalesce(
            ovrd_acc._is_voting_proxied
            , ovrd_pms_acc._is_voting_proxied
            , ovrd_pms_adv._is_voting_proxied
        )
        , crm_is_voting_proxied , pms_is_voting_proxied
    )                                                                        as is_voting_proxied
    , coalesce(
        coalesce(
            ovrd_acc._is_prime_broker
            , ovrd_pms_acc._is_prime_broker
            , ovrd_pms_adv._is_prime_broker
        )
        , crm_is_prime_broker , pms_is_prime_broker
    )                                                                        as is_prime_broker
    , coalesce(
        coalesce(
            ovrd_acc._is_broker_dealer_account
            , ovrd_pms_acc._is_broker_dealer_account
            , ovrd_pms_adv._is_broker_dealer_account
        )
        , crm_is_broker_dealer_account , pms_is_broker_dealer_account
    )                                                                        as is_broker_dealer_account
{%- endmacro -%}
