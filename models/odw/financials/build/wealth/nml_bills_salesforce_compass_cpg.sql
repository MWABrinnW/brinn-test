with dynamics_finance_accounts_cte as (
    select
        *
        , row_number()
            over (
                partition by tam_upload_id , date(effective_at)
                order by
                    tam_upload_id asc
                    , date(effective_at) desc
                    , _tam_account_id_value
                    , created_at desc
            )
            as rn
    from {{ ref('dynamics_tamarac_cpg__stg_finance_accounts') }}
    where date(effective_at) >= '1900-01-01'
        and is_head_for_day = 1
    --and dy_acct.TAM_UPLOAD_ID = '61507'
    qualify rn = 1
)

, cpg_split_detail_cte_1 as (
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
        ctn_1._record_2_id_value                                                                          as z__record_2_id_value
        , ctn_1.name                                                                                      as z_connection_name
        , ctn_2.name                                                                                      as y_connection_name
        , ctr_1.name                                                                                      as z_role_name
        , to_number(right(trim(ctr_1.name) , 1))                                                          as sol_role_id
        , max(sol_role_id) over (partition by ctn_1._record_2_id_value order by ctn_1._record_2_id_value) as num_of_sol
        , to_varchar(coalesce(cte_1.split_dtl_split_amount , round((1 / num_of_sol) , 5)) * 100) || '%'   as split_amount
        , ctn_1.effective_at                                                                              as effective_at

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
    from cpg_split_detail_cte_2
    where true
    group by all
)

---------------------------------------------------------------------------------------------------------------------
---normalized model--------------------------------------------------------------------------------------------------

select

    -- [pms attributes]
    ir.system_name::varchar(200)                                         as system_name
    , ir.system_instance::varchar(200)                                   as system_instance
    , ir.system_key::varchar(200)                                        as system_key


    -- [location
    , '112'::varchar(200)                                                as client_location_code

    -- [invoice]
    , ir.name::varchar(200)                                              as invoice_number_source
    , ir.created_date::timestamp_ntz                                     as invoice_created_at
    , ir.invoice_date_c::date                                            as invoice_date
    , ir.orion_bill_id_c::varchar(200)                                   as billing_statement_id_source
    , ir.id::varchar(200)                                                as billing_statement_id_crm
    , ir.status_c::varchar(200)                                          as invoice_status
    , case
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.quarter_end_date
            then 0
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date != dt.quarter_end_date
            then 1
    end::int                                                             as is_intra_period_invoice
    , trim(upper(ir.account_number_c))::varchar(200)                     as account_number

    , ir.account_number_c::varchar(200)                                  as account_number_formatted
    , ir.billing_account_number_c::varchar(200)                          as billing_account_number
    , ba.upload_account_id::varchar(200)                                 as account_id_pms
    , ir.registration_name_c::varchar(200)                               as registrant_name
    , ba.account_name::varchar(200)                                      as account_name
    , coalesce(
        ba.account_type
        , ir.account_type_c
    )::varchar(200)                                                      as type_of_account
    , ba.primary_household_id::varchar(200)                              as client_id_pms
    , iff(ba.aum_indicator = 1 , 'AUM - Assets Under Management' , 'Data Aggregation / Reporting Only')
    ::varchar(200)                                                       as aum_classification_status
    , trim(ba.target_allocation)::varchar(200)                           as model_investment_strategy
    , ir.custodian_c::varchar(200)                                       as custodian
    , ir.billing_custodian_c::varchar(200)                               as billing_custodian
    , ir.branch_c::varchar(200)                                          as partner_firm
    , ir.branch_2_c::varchar(200)                                        as partner_firm_original


    -- [advisor]
    -- Historical Client Manager (from upsert into Salesforce)
    , ir.quarterback_2_c::varchar(200)                                   as client_manager_source
    -- Historical client manager (from compass account object, historical records)
    , coalesce(
        cte_f.sol_detail
        , ba.primary_advisor
        , ba.household_advisor
    )::varchar(200)
        as client_manager_original
    -- Historical associate ID (from compass account object, historical records)
    , null::varchar(200)                                                 as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , coalesce(
        cte_f.sol_detail
        , ba.primary_advisor
        , ba.household_advisor
    )::varchar(200)                                                      as client_manager_primary
    -- Current associate id (from compass account object, is_head)
    , null::varchar(200)                                                 as associate_id_primary
    , '1099'::varchar(200)                                               as client_manager_type

    -- [assets and fees]
    , ir.fee_type_c::varchar(200)                                        as fee_type
    , coalesce(
        ba.billing_definitions
        , ir.fee_schedule_c
    )
    ::varchar(200)
        as fee_schedule_source
    , null::varchar(200)                                                 as fee_schedule_type
    , null::varchar(200)                                                 as fee_schedule
    , coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date    as assets_as_of_date
    , coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date    as fee_calculation_date
    , case
        when ir.billable_value_c = 0 or ir.net_fee_c = 0 then null
        else ir.net_fee_c / ir.billable_value_c::number(20 , 5)
    end                                                                  as effective_fee_rate
    , ir.total_account_value_c::number(20 , 5)                           as total_account_value
    , ir.billable_value_c::number(20 , 5)                                as billable_value
    , ir.fee_excluded_assets_c::number(20 , 5)                           as fee_excluded_assets
    , ir.gross_fee_c::number(20 , 5)                                     as client_fee_gross
    , ir.fee_rebates_c::number(20 , 5)                                   as client_fee_rebates
    , ir.net_contributions_fee_c::number(20 , 5)                         as client_net_contribution_fee
    , ir.adjustments_fee_c::number(20 , 5)                               as client_adjustments_fee
    , ir.write_off_fee_c::number(20 , 5)                                 as client_write_off_fee
    , ir.net_fee_c::number(20 , 5)                                       as client_fee_net
    , ir.referral_fee_c::decimal(20 , 2)                                 as referral_fee
    , ir.collection_date_c::date                                         as collection_date
    , ir.third_party_calculation_c::boolean                              as third_party_calculation

    -- [billing terms and payment]
    , ir.billing_style_c::varchar(200)                                   as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , coalesce(
        ir.fee_frequency_c
        , ovrd_fee_type.billing_frequency
    )::varchar(200
    )                                                                    as billing_frequency
    , ir.billing_method_c::varchar(200)                                  as billing_method
    , case
        when ir.fee_type_c = 'Quarterly Fee' then
            'EOQ Balance'
    end::varchar(200)                                                    as bill_on_balance_type
    , null::varchar(200)                                                 as payment_terms
    , ir.payment_method_fee_c::number(20 , 5)                            as payment_method_fee


    -- [accounting]
    , 'REV'::varchar(200)                                                as account_class
    , null::varchar(200)                                                 as coa_segment_1_legal_entity_id
    , '1112'::varchar(200)                                               as coa_segment_3_accounting_id
    , null::varchar(200)                                                 as coa_segment_4_team_id
    , case

        when ir.fee_type_c in (
                'Fixed Income Fee'
                , 'Advisory Fee'
                , 'Options Fee'
                , 'Consulting Fee'
                , 'Financial Planning Fee'
            )
            then--<- review "Consulting Fee" and "Financial Planning Fee"
                '40100'

        when ir.fee_type_c in (
                'Retirement Services Fee'
            )
            then--<- review "Consulting Fee" and "Financial Planning Fee"
                '43001'

        when ir.fee_type_c in (
                'Tax Prep Fee'
            )
            then
                '42001'

        when cte_f.sol_detail is not null and cte_f.sol_detail ilike '(SOLICITOR)'
            then
                '40002'--Other Referral Partners (CPAs)/Solicitors

        when ir.fee_type_c in ('Quarterly Fee' , 'Fee Adjustment' , 'Lost Client Fee')
            then
                '40001'-- traditional
    end::varchar(200)                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , ovrd_fee_type.revenue_category::varchar(200)                       as revenue_category

    , case
        when ir.fee_type_c ilike any
            ('Quarterly Fee' , 'Fee Adjustment' , 'Lost Client Fee' , 'Fixed Income Fee' , 'Options Fee')
            then 'Wealth Mgmt Fees'
        when ir.fee_type_c ilike any ('Consulting Fee' , 'Financial Planning Fee')
            then 'Financial Planning Fee'
        when ir.fee_type_c ilike 'Tax Prep Fee'
            then 'Tax Prep Fee'
        when ir.fee_type_c ilike 'Retirement Services Fee'
            then 'Retirement Services Fee'
    end::varchar(200)                                                    as revenue_type



    -- [crm]
    , 'dynamics'::varchar(200)                                           as system_name_crm
    , 'tamarac_cpg'::varchar(200)                                        as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::varchar(200) as system_key_crm
    , da.tam_finance_account_id::varchar(200)                            as account_id_crm
    , hh.account_id::varchar(200)                                        as client_id_crm
    , ir.company_family_c::varchar(200)                                  as client_id_original_crm
    , null::varchar(200)                                                 as client_id_unique_compass
    , coalesce(
        hh.name
        , 'Orphaned Dynamics Household'
    )
    ::varchar(200)                                                       as client_name
    , ir.client_name_c::varchar(200)                                     as client_name_original_crm
    , null::varchar(200)                                                 as client_lead_source
    , null::varchar(5000)                                                as client_key_tags_crm



    -- [transactions]
    , case
        when ir.fee_type_c = 'Lost Client Fee'
            then 'Return'
        else 'Invoice'
    end::varchar(200)                                                    as transaction_type
    , 'Line'::varchar(200)                                               as transaction_line_type
    , 1::int                                                             as transaction_line_quantity
    , 'USD'::varchar(200)                                                as currency_code
    , 'User'::varchar(200)                                               as currency_conversion_type
    , ir.net_fee_c::number(20 , 5)                                       as unit_selling_price





    -- [exclusion]
    , array_to_string(
        array_construct_compact(case
            -- speciality tax exlusion
            when mh.record_type_id = '0123c000000tyRyAAI' and ir.third_party_calculation_c = true
                then 'Specialty tax, Third party calculation;'
            when mh.record_type_id = '0123c000000tyRyAAI'
                then 'Specialty tax;'
            when ir.third_party_calculation_c = true
                then 'Third party calculation;'
        end) , ' '
    )::varchar(2000)                                                     as excluded_reasons
    , case when excluded_reasons = '' then 0 else 1 end::int             as is_excluded


    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , null::varchar(200)                                                 as _trans_key
    , ir._created_at::timestamp_ntz(9)                                   as _source_loaded_at
    , null::varchar(200)                                                 as _source_file
    , null::varchar(200)                                                 as _box_file_id
    , object_construct_keep_null(
        'upload_account_id' , ba.upload_account_id
        , 'tam_finance_account_id' , da.tam_finance_account_id
        , 'account_id' , hh.account_id
        , 'is_cpg' , ir.is_cpg
    )                                                                    as _extra_fields

-- These are fields that are likely specific to this source
-- and are intended to help with one off investigations or
-- special analysis.
-- , object_construct_keep_null(
--     'account_id' , coalesce(acc.estate_item_id , acc2.estate_item_id)
--     , 'client_id' , coalesce(acc.client_id , acc2.client_id)
--     , 'client_id_joins_on_origin' , iff(acc.client_id is not null , 1 , 0)
--     , 'client_id_joins_on_head' , iff(acc2.client_id is not null , 1 , 0)
--     , 'client_name' , coalesce(acc.household_name , acc2.household_name)
-- )

--select count(*)
from {{ ref('int_bills_salesforce_compass_cpg_split') }} as ir
left join edw.ref.dates as dt
    on coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.date_key
-- We join on date as first preference for account attributes.
-- This is because over time the account record can change (i.e. advisor assignment).
-- -- We want to know what it looked like at the time of billing.
inner join {{ ref('tamarac_state_college_history__base_accounts') }} as ba--GWH: ensure only Tamarac CPG Accounts are included
    on replace(ir.account_number_c , '-' , '') = replace(ba.account_number , '-' , '')
    and ir.invoice_date_c = ba.effective_date
    and ba.rn = 1
    and ba.entity_type in ('Single Account')

inner join dynamics_finance_accounts_cte as da--GWH: ensure only Tamarac CPG Accounts are included
    on ba.upload_account_id = da.tam_upload_id
    and date(da.effective_at) = ir.invoice_date_c
    and da.is_head_for_day = 1

left join {{ ref('dynamics_tamarac_cpg__stg_accounts') }} as hh
    on da._tam_account_id_value = hh.account_id
    and ir.invoice_date_c = date(hh.effective_at)
    and hh.is_head_for_day = 1

left join cpg_split_detail_cte_final as cte_f
    on hh.account_id = cte_f.hh_id
    and ir.invoice_date_c = date(cte_f.effective_at)

-- Excludes service types categorized as tax preparation
left join fivetran.salesforce_compass.mhservice_c as mh
    on ir.service_rendered_c = mh.id
left join datalake.aux.stg_financials_fee_type as ovrd_fee_type
    on ir.system_key = ovrd_fee_type.system_key
    and lower(ir.fee_type_c) = lower(ovrd_fee_type.fee_type)
where true
    and ir.invoice_date_c >= '09/30/2024'
    and ir.is_cpg = 1
