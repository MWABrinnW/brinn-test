with cpg_split_detail_cte_1 as (
    select
        hh.account_id                                       as split_dtl_account_id
        , hh.name                                           as split_dtl_role_name
        , hh.effective_at                                   as effective_at
        , hh.is_head_for_day                                as is_head_for_day
        , hh.column_name                                    as split_dtl_split_index
        , to_number(right(trim(split_dtl_split_index) , 1)) as split_dtl_sol_role_id
        , quantity                                          as split_dtl_split_amount
    from {{ ref('dynamics_tamarac_cpg__stg_accounts') }} as hh
    unpivot (quantity for column_name in (tamc_split_1 , tamc_split_2 , tamc_split_3 , tamc_split_4))
    where true
        and is_head_for_day = 1
        and date(effective_at) >= '1900-01-01'
)

, cpg_split_detail_cte_2 as (
    select
        ctn_1._record_2_id_value                                                                        as z__record_2_id_value
        , ctn_1.name                                                                                    as z_connection_name
        , ctn_2.name                                                                                    as y_connection_name
        , ctn_2.connection_id                                                                           as y_connection_id
        , ctr_1.name                                                                                    as z_role_name
        , to_number(right(trim(ctr_1.name) , 1))                                                        as sol_role_id
        , max(sol_role_id) over (
            partition by ctn_1._record_2_id_value
            order by ctn_1._record_2_id_value
        )                                                                                               as num_of_sol
        , to_varchar(coalesce(cte_1.split_dtl_split_amount , round((1 / num_of_sol) , 5)) * 100) || '%' as split_amount
        , ctn_1.effective_at                                                                            as effective_at

    -- , cte_1.SPLIT_DTL_SOL_ROLE_ID
    -- , cte_1.SPLIT_DTL_ACCOUNT_ID
    from {{ ref('dynamics_tamarac_cpg__stg_connections') }} as ctn_1

    left join {{ ref('dynamics_tamarac_cpg__stg_connection_roles') }} as ctr_1
        on ctn_1._record_1_role_id_value = ctr_1.connection_role_id
        and date(ctn_1.effective_at) = date(ctr_1.effective_at)
        and ctr_1.is_head_for_day = 1

    inner join {{ ref('dynamics_tamarac_cpg__stg_connections') }} as ctn_2
        on ctn_1._related_connection_id_value = ctn_2.connection_id
        and date(ctn_1.effective_at) = date(ctn_2.effective_at)
        and ctn_2.is_head_for_day = 1

    left join {{ ref('dynamics_tamarac_cpg__stg_connection_roles') }} as ctr_2
        on ctn_2._record_1_role_id_value = ctr_2.connection_role_id
        and date(ctn_1.effective_at) = date(ctr_2.effective_at)
        and ctr_2.is_head_for_day = 1

    inner join {{ ref('dynamics_tamarac_cpg__stg_accounts') }} as cpg_acc
        on ctn_1._record_2_id_value = cpg_acc.account_id
        and date(ctn_1.effective_at) = date(cpg_acc.effective_at)
        and cpg_acc.is_head_for_day = 1


    inner join {{ ref('dynamics_tamarac_cpg__stg_account_types') }} as cpg_act
        on cpg_acc._account_type_id_value = cpg_act.tam_account_type_id
        and date(ctn_1.effective_at) = date(cpg_act.effective_at)
        and cpg_act.is_head_for_day = 1

    left join cpg_split_detail_cte_1 as cte_1
        on ctn_1._record_2_id_value = cte_1.split_dtl_account_id
        and sol_role_id = cte_1.split_dtl_sol_role_id
        and date(ctn_1.effective_at) = date(cte_1.effective_at)
        and cte_1.is_head_for_day = 1

    where true
        and ctn_1.state_code = 0
        and ctn_2.state_code = 0
        and cpg_act.tam_name != 'Broker Dealer/RIA'
        and ctr_1.name != 'Employee'
        and ctr_1.name ilike '%SOLICITOR%'
        and date(ctn_1.effective_at) >= '1900-01-01'
        and ctn_1.is_head_for_day = 1


    order by ctn_1._record_2_id_value , ctr_1.name
)

, cpg_split_detail_cte_final as (
    select
        z__record_2_id_value                                               as hh_id
        , effective_at                                                     as effective_at
        , listagg(y_connection_name || ' (' || split_amount || ')' , '; ') as sol_detail
        , listagg(y_connection_id || '; ')                                 as sol_detail_id
    from cpg_split_detail_cte_2
    where true
    group by all
)

----------------------------------------------------
select

    'dynamics'                                           as crm
    , 'tamarac_cpg'                                      as instance_location
    , crm || '__' || instance_location                   as crm_key
    , dfa.tam_custodian                                  as custodian
    , dfa.tam_upload_id                                  as crm_pms_account_id
    , dfa.tam_financial_account_id                       as crm_account_number
    , dfa.tam_finance_account_id                         as account_id
    , dfa.tam_financial_acct_type                        as account_type
    , dfa.tam_name                                       as account_name
    , dfa.tam_name                                       as registrant_name
    , dfa._tam_account_id_value                          as household_id
    , coalesce(dhh.name , 'Orphaned Dynamics Household') as household_name
    , iff(dfa.tam_termination_date is null , 1 , 0)      as is_active
    , dfa.created_at::date                               as created_date
    , null                                               as opened_date-- use pms
    , dfa.tam_termination_date                           as closed_date
    , dfa.tam_total_value                                as account_value
    , sol.sol_detail::text                               as advisor
    , sol.sol_detail_id::text                            as advisor_id
    , crm_key                                            as advisor_id_source
    , null::string                                       as advisor_email-- placeholder to be replaced
    , '112'                                              as location_code
    , null                                               as fee_schedule-- use pms
    , dfa.tam_model                                      as investment_strategy
    , null                                               as aum_classification-- use pms
    , null                                               as is_erisa-- use pms
    , dfa.tam_discretionary_account                      as is_discretionary
    , null                                               as is_voting_proxied-- use pms
    , null                                               as is_prime_broker-- use pms
    , null                                               as is_broker_dealer_account-- use pms
    , dfa.effective_at::date                             as effective_date
    , dfa.is_head::int                                   as is_head

from {{ ref('dynamics_tamarac_cpg__stg_finance_accounts') }} as dfa

left join {{ ref('dynamics_tamarac_cpg__stg_accounts') }} as dhh
    on dfa._tamc_solicitor_payment_household_value = dhh.account_id
    and date(dfa.effective_at) = date(dhh.effective_at)
    and dhh.is_head_for_day = 1
    and dhh._fivetran_deleted = 0

left join cpg_split_detail_cte_final as sol
    on dfa._tamc_solicitor_payment_household_value = sol.hh_id
    and date(dfa.effective_at) = date(sol.effective_at)


where true
    and dfa.effective_at >= '2024-09-30'--remove date filter
    and dfa.is_head_for_day = 1
    and dfa._fivetran_deleted = 0
qualify (
    row_number()
        over
        (
            partition by dfa.tam_upload_id , date(dfa.effective_at)
            order by dfa.tam_upload_id asc , date(dfa.effective_at) asc , dfa._fivetran_synced desc
        )
) = 1
