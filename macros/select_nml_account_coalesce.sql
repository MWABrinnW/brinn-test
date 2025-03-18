{%- macro select_nml_account_coalesce(system_key) -%}
-- todo: validate the assign custodian key macro aligns with changes made to the custodian field
, coalesce(
        coalesce(
            ovrd_acct._custodian
            , ovrd_sys_acct._custodian
            , ovrd_sys_adv._custodian
        )
        , map_cus_glo.target_value , crm_custodian , pms_custodian
    )                                                                        as custodian
    , coalesce(crm_account_type , pms_account_type)                          as account_type
    , coalesce(
        coalesce(
            ovrd_acct._account_name
            , ovrd_sys_acct._account_name
            , ovrd_sys_adv._account_name
        )
        , crm_account_name
        , pms_account_name
    )                                                                        as account_name
    , coalesce(crm_registrant_name , pms_registrant_name)                    as registrant_name
    , coalesce(crm_client_name , pms_client_name)                            as client_name
    , coalesce(pms_is_active , crm_is_active)                                as is_active
    , pms_created_date                                                       as created_date
    , coalesce(pms_opened_date , crm_opened_date)                            as opened_date
    , coalesce(pms_closed_date , crm_closed_date)                            as closed_date
    , coalesce(
        coalesce(
            ovrd_acct._account_value
            , ovrd_sys_acct._account_value
            , ovrd_sys_adv._account_value
        )
        {% if system_key | lower == 'salesforce__compass_rps' -%} , nv.plan_assets_c::decimal(16 , 2) {%- endif %}
        , pms_account_value
        , crm_account_value
    )                                                                        as account_value
    , coalesce(
        coalesce(
            ovrd_acct._advisor
            , ovrd_sys_acct._advisor
            , ovrd_sys_adv._advisor
        )
        {% if system_key | lower in ['black_diamond__mps' , 'orion__mps'] -%} , coalesce(pms_advisor , crm_advisor) {%- endif %}
        , crm_advisor 
        , pms_advisor
    )                                                                        as advisor
    , coalesce(
        coalesce(
            ovrd_acct._advisor_email
            , ovrd_sys_acct._advisor_email
            , ovrd_sys_adv._advisor_email
        )
        , crm_advisor_email , pms_advisor_email
    )                                                                        as advisor_email
    , null::text(100)                                                        as advisor_employee_id
    , coalesce(
        coalesce(
            ovrd_acct._location_code
            , ovrd_sys_acct._location_code
            , ovrd_sys_adv._location_code
        )
        , crm_location_code , pms_location_code
    )                                                                        as location_code
    {% if system_key | lower in ['orion__core', 'addepar__corbenic','black_diamond__houston', 'envestnet__manasquan'] -%}
        , coalesce(crm_fee_schedule, pms_fee_schedule) as fee_schedule
    {% else %}
        , coalesce(pms_fee_schedule, crm_fee_schedule) as fee_schedule
    {% endif %}
    , coalesce(crm_model_investment_strategy , pms_model_investment_strategy) as model_investment_strategy
    , coalesce(
        coalesce(
            ovrd_acct._aum_classification
            , ovrd_sys_acct._aum_classification
            , ovrd_sys_adv._aum_classification
            , map_aum_glo.target_value
        )
        {% if system_key | lower in ['black_diamond__mps' , 'orion__mps'] -%} , coalesce(pms_aum_classification , crm_aum_classification) {%- endif %}
        , crm_aum_classification 
        , pms_aum_classification
    )                                                                        as aum_classification
    , coalesce(
        coalesce(
            ovrd_acct._is_erisa
            , ovrd_sys_acct._is_erisa
            , ovrd_sys_adv._is_erisa
        )
        , crm_is_erisa , pms_is_erisa
    )                                                                        as is_erisa
    , coalesce(
        coalesce(
            ovrd_acct._is_discretionary
            , ovrd_sys_acct._is_discretionary
            , ovrd_sys_adv._is_discretionary
        )
        , pms_is_discretionary , crm_is_discretionary
    )::int                                                                   as is_discretionary
    , coalesce(
        coalesce(
            ovrd_acct._is_voting_proxied
            , ovrd_sys_acct._is_voting_proxied
            , ovrd_sys_adv._is_voting_proxied
        )
        , crm_is_voting_proxied , pms_is_voting_proxied
    )                                                                        as is_voting_proxied
    , coalesce(
        coalesce(
            ovrd_acct._is_prime_broker
            , ovrd_sys_acct._is_prime_broker
            , ovrd_sys_adv._is_prime_broker
        )
        , crm_is_prime_broker , pms_is_prime_broker
    )                                                                        as is_prime_broker
    , coalesce(
        coalesce(
            ovrd_acct._is_broker_dealer_account
            , ovrd_sys_acct._is_broker_dealer_account
            , ovrd_sys_adv._is_broker_dealer_account
        )
        , crm_is_broker_dealer_account , pms_is_broker_dealer_account
    )                                                                        as is_broker_dealer_account
{%- endmacro -%}
