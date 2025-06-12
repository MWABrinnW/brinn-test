{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['revenue_period_end_date', 'system_key']
) }}

with stale_check as (
    {%- if is_incremental() %}
        select
            case
                -- Compare source table max timestamp after TZ conversion to destination max timestamp.
                when (
                    select max(_created_at)::timestamp_ntz
                    from {{ ref('int_bills_salesforce_compass_cpg_split') }}
                ) > (select max(_created_at) from {{ this }})
                    then 1
                else 0
            end::int as is_stale
    {%- else %}
        select 1::int as is_stale
    {%- endif %}
)

------------------------------------------------------------

, account_date_map as (
    select
        a.estate_item_c                                                 as estate_item_c
        , a.invoice_date_c                                              as invoice_date_c
        , a.revenue_as_of_date_c                                        as revenue_as_of_date_c
        , least_ignore_nulls(a.invoice_date_c , a.revenue_as_of_date_c) as record_date
        , max(replace(a.account_number_c , '-' , ''))                   as account_number
    from {{ ref('int_bills_salesforce_compass_cpg_split') }} as a
    where 1 = 1
        and 1 = (select max(is_stale) from stale_check)
        and (
            a.is_cpg = 0
            or (a.is_cpg = 1 and invoice_date_c < '9/30/2024')
        )
    group by all
    order by 1
)

, cpg_accounts as (
    select
        a.effective_date::date                 as effective_date
        , replace(a.account_number , '-' , '') as account_number
        , a.upload_account_id                  as upload_account_id
        , a.advisor                            as advisor
    from {{ ref('tamarac_state_college_history__base_accounts') }} as a
    left join account_date_map as adm_invoice_date
        on a.effective_date = adm_invoice_date.invoice_date_c
        and replace(a.account_number , '-' , '') = adm_invoice_date.account_number
    left join account_date_map as adm_rev_date
        on a.effective_date = adm_rev_date.revenue_as_of_date_c
        and replace(a.account_number , '-' , '') = adm_rev_date.account_number
    where 1 = 1
        and a.entity_type = 'Single Account'
        and (
            adm_invoice_date.estate_item_c is not null
            or adm_rev_date.estate_item_c is not null
        )
        and 1 = (select max(is_stale) from stale_check)
    qualify row_number() over (
            partition by effective_date , replace(a.account_number , '-' , '')
            order by _created_at desc
        ) = 1
)

, sf_compass_accounts as (
    select
        a.effective_at              as effective_at
        , a.household_location_code as household_location_code
        , a.account_number          as account_number
        , a.orion_client_id         as orion_client_id
        , a.account_name            as account_name
        , a.registration_type       as registration_type
        , a.investment_strategy     as investment_strategy
        , a.employee_number         as employee_number
        , a.client_manager          as client_manager
        , a.aum_classification      as aum_classification
        , a.household_id            as household_id
        , a.household_name          as household_name
        , a.household_lead_source   as household_lead_source
        , a.household_location_id   as household_location_id
        , a.fee_schedule            as fee_schedule
        , a.unique_identifier       as unique_identifier
        , a.key_tags                as key_tags
        , a.id                      as id
        , a.estate_item_id          as estate_item_id
        , a.client_id               as client_id
        , adm.record_date           as record_date
    from {{ ref('bld_salesforce_compass_accounts') }} as a
    left join account_date_map as adm
        on a.id = adm.estate_item_c
        and a.effective_at::date = adm.record_date
    where 1 = 1
        --and adm.estate_item_c is not null
        and 1 = (select max(is_stale) from stale_check)
        and (
            adm.estate_item_c is not null
            -- Pull in the head record
            or a.effective_at::date = (select max(effective_at::date) from {{ ref('bld_salesforce_compass_accounts') }})
        )
    qualify row_number() over (
            partition by a.effective_at::date , a.id
            order by a.effective_at desc
        ) = 1
)

select
    -- [pms attributes]
    ir.system_name::text(500)                                         as system_name
    , ir.system_instance::text(500)                                   as system_instance
    , ir.system_key::text(500)                                        as system_key
    , ir.firm_source::text(500)                                       as firm_source

    -- [location]
    , coalesce(
        acc.household_location_code
        , acc2.household_location_code
    )::text(500)                                                      as client_location_code

    -- [invoice]
    , ir.name::text(500)                                              as invoice_number_source
    , convert_timezone(
        'America/Chicago' , ir.created_date
    )::timestamp_ntz                                                  as invoice_created_at
    , ir.invoice_date_c::date                                         as invoice_date
    , ir.orion_bill_id_c::text(500)                                   as billing_statement_id_source
    , ir.id::text(500)                                                as billing_statement_id_crm
    , ir.status_c::text(500)                                          as invoice_status
    , case
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.quarter_end_date
            then 0
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date != dt.quarter_end_date
            then 1
    end::int                                                          as is_intra_period_invoice
    , coalesce(
        acc.account_number
        , acc2.account_number
        , trim(upper(ir.account_number_c))
    )::text(500)                                                      as account_number
    , ir.account_number_c::text(500)                                  as account_number_formatted
    , ir.billing_account_number_c::text(500)                          as billing_account_number
    , ir.orion_account_id_c::text(500)                                as account_id_pms
    , ir.registration_name_c::text(500)                               as registrant_name
    , coalesce(acc.account_name , acc2.account_name)::text(500)       as account_name
    , coalesce(
        ir.account_type_c
        , acc.registration_type
        , acc2.registration_type
    )::text(500)                                                      as type_of_account
    , coalesce(
        ir.orion_house_id_c
        , acc.orion_client_id
        , acc2.orion_client_id
    )::text(500)                                                      as client_id_pms
    , coalesce(
        ir.aum_classification_c
        , acc.aum_classification
        , acc2.aum_classification
    )::text(500)                                                      as aum_classification_status
    , coalesce(
        ir.model_on_account_c
        , acc.investment_strategy
        , acc2.investment_strategy
    )::text(500)                                                      as model_investment_strategy
    , ir.custodian_c::text(500)                                       as custodian
    , ir.billing_custodian_c::text(500)                               as billing_custodian
    , ir.branch_c::text(500)                                          as partner_firm
    , ir.branch_2_c::text(500)                                        as partner_firm_original

    -- [advisor]
    -- Historical Client Manager (from upsert into Salesforce)
    , ir.quarterback_2_c::text(500)                                   as advisor_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::text(500)                                   as advisor_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::text(500)                                  as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , acc2.client_manager::text(500)                                  as advisor_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::text(500)                                 as associate_id_primary
    , 'W-2'::text(500)                                                as advisor_type

    -- [assets and fees]
    , ir.fee_type_c::text(500)                                        as fee_type
    , coalesce(acc.fee_schedule , acc2.fee_schedule)::text(500)       as fee_schedule_source
    , null::text(500)                                                 as fee_schedule_type
    , null::text(500)                                                 as fee_schedule
    , coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date as assets_as_of_date
    , coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date as fee_calculation_date
    , case
        when ir.billable_value_c = 0 or ir.net_fee_c = 0 then null
        else ir.net_fee_c / ir.billable_value_c::number(20 , 5)
    end                                                               as effective_fee_rate
    , ir.total_account_value_c::number(20 , 5)                        as total_account_value
    , ir.billable_value_c::number(20 , 5)                             as billable_value
    , ir.fee_excluded_assets_c::number(20 , 5)                        as fee_excluded_assets
    , ir.gross_fee_c::number(20 , 5)                                  as client_fee_gross
    , ir.fee_rebates_c::number(20 , 5)                                as client_fee_rebates
    , ir.net_contributions_fee_c::number(20 , 5)                      as client_net_contribution_fee
    , ir.adjustments_fee_c::number(20 , 5)                            as client_adjustments_fee
    , ir.write_off_fee_c::number(20 , 5)                              as client_write_off_fee
    , ir.net_fee_c::number(20 , 5)                                    as client_fee_net
    , ir.referral_fee_c::decimal(20 , 2)                              as referral_fee
    , ir.collection_date_c::date                                      as collection_date
    , ir.third_party_calculation_c::boolean                           as third_party_calculation

    -- [billing terms and payment]
    , ir.billing_style_c::text(500)                                   as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , coalesce(
        ir.fee_frequency_c
        , ovrd_fee_type.billing_frequency
    )::text(500
    )                                                                 as billing_frequency
    , ir.billing_method_c::text(500)                                  as billing_method
    , case
        when ir.fee_type_c = 'Quarterly Fee' then
            'EOQ Balance'
    end::text(500)                                                    as bill_on_balance_type
    , null::text(500)                                                 as payment_terms
    , ir.payment_method_fee_c::number(20 , 5)                         as payment_method_fee

    -- [accounting]
    , 'REV'::text(500)                                                as account_class
    , null::text(500)                                                 as coa_segment_1_legal_entity_id
    , null::text(500)                                                 as coa_segment_3_accounting_id
    , null::text(500)                                                 as coa_segment_4_team_id
    , case
        when client_location_code = '112' and cpg_ba.advisor = 'Rob Thomas/Direct'
            then

                case
                    when coalesce(acc.household_lead_source , acc2.household_lead_source) in (
                            'Referral Partner - WAS'
                            , 'Referral Partner - SAN'
                            , 'Referral Partner - Scottrade'
                            , 'Referral Partner - TD'
                        )
                        then
                            '40000'--RPP
                    when coalesce(acc.household_lead_source , acc2.household_lead_source) like '%Referral Partner -%'
                        then
                            '40002'--Other Referral Partners (CPAs)/Solicitors
                    else
                        '40001'
                end

        when client_location_code = '112' and cpg_ba.advisor like '%/SAN'
            then

                case
                    when coalesce(acc.household_lead_source , acc2.household_lead_source) in (
                            'Referral Partner - WAS'
                            , 'Referral Partner - SAN'
                            , 'Referral Partner - Scottrade'
                            , 'Referral Partner - TD'
                        )
                        then
                            '40000'--RPP
                    when coalesce(acc.household_lead_source , acc2.household_lead_source) like '%Referral Partner -%'
                        then
                            '40002'--OTher Referral Partners (CPAs)/Solicitors
                    else
                        '40001'
                end

        when client_location_code = '112' and cpg_ba.advisor is not null
            then
                '40002'--OTher Referral Partners (CPAs)/Solicitors

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
                '45001'

        when coalesce(acc.household_lead_source , acc2.household_lead_source) in (
                'Referral Partner - WAS' , 'Referral Partner - SAN' , 'Referral Partner - Scottrade' , 'Referral Partner - TD'
            )
            then
                '40000'--RPP

        when coalesce(acc.household_lead_source , acc2.household_lead_source) like '%Referral Partner -%'
            then
                '40002'--Other Referral Partners (CPAs)/Solicitors

        when ir.fee_type_c in ('Quarterly Fee' , 'Fee Adjustment' , 'Lost Client Fee')
            then
                '40001'-- traditional
    end::text(500)                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , ovrd_fee_type.revenue_category::text(500)                       as revenue_category

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
    end::text(500)                                                    as revenue_type

    -- [crm]
    , 'salesforce'::text(500)                                         as system_name_crm
    , 'compass'::text(500)                                            as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text(500) as system_key_crm
    , ir.estate_item_c::text(500)                                     as account_id_crm
    , coalesce(
        ir.company_family_c
        , acc.household_id
        , acc2.household_id
    )::text(500)                                                      as client_id_crm
    , ir.company_family_c::text(500)                                  as client_id_original_crm
    , coalesce(

        acc.unique_identifier
        , acc2.unique_identifier

    )::text(500)                                                      as client_id_unique_compass
    , coalesce(

        acc.household_name
        , acc2.household_name
    )::text(500)                                                      as client_name
    , ir.client_name_c::text(500)                                     as client_name_original_crm
    , coalesce(

        acc.household_lead_source
        , acc2.household_lead_source

    )::text(500)                                                      as client_lead_source
    , coalesce(

        acc.key_tags
        , acc2.key_tags

    )::text(5000)                                                     as client_key_tags_crm

    -- [transactions]
    , case
        when ir.fee_type_c = 'Lost Client Fee'
            then 'Return'
        else 'Invoice'
    end::text(500)                                                    as transaction_type
    , 'Line'::text(500)                                               as transaction_line_type
    , 1::int                                                          as transaction_line_quantity
    , 'USD'::text(500)                                                as currency_code
    , 'User'::text(500)                                               as currency_conversion_type
    , ir.net_fee_c::number(20 , 5)                                    as unit_selling_price

    {# --[gavins adds]
    ,ir.short_name_c::text(500) as short_name
    ,ir.branch_c::text(500) as branch_primary
    ,ir.branch_2_c::text(500) as branch_secondary
    ,ir.collection_date_c::date as collection_date
    ,ir.quarterback_2_c::text(500) as quarterback_secondary
    ,ir.quarterback_c::text(500) as quarterback_primary
    ,ir.old_name_c::text(500) as old_name
    ,acc.household_location_id::text(500) as mariner_location #}

    -- exlucsion
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
    )::text(5000)                                                     as excluded_reasons
    , case when excluded_reasons = '' then 0 else 1 end::int          as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , null::text(500)                                                 as _trans_key
    , current_timestamp()::timestamp_ntz(9)                           as _created_at
    , ir._created_at::timestamp_ntz(9)                                as _source_loaded_at
    , null::text(500)                                                 as _source_file
    , null::text(500)                                                 as _box_file_id

    -- These are fields that are likely specific to this source
    -- and are intended to help with one off investigations or
    -- special analysis.
    , object_construct_keep_null(
        'join_crm_sf_eff_date' , acc.id
        , 'join_crm_sf_is_head' , acc2.id
        , 'join_pms_tam_base_accts' , cpg_ba.account_number
        , 'join_crm_sf_mhservice_id' , mh.id
        , 'join_aux_fin_fee_type' , ovrd_fee_type.system_key
        , 'account_id' , coalesce(acc.estate_item_id , acc2.estate_item_id)
        , 'client_id' , coalesce(acc.client_id , acc2.client_id)
        , 'client_name' , coalesce(acc.household_name , acc2.household_name)
        , 'is_cpg' , ir.is_cpg
    )                                                                 as _extra_fields
from {{ ref('int_bills_salesforce_compass_cpg_split') }} as ir
left join {{ ref('dates') }} as dt
    on coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.date_key
-- We join on date as first preference for account attributes.
-- This is because over time the account record can change (i.e. advisor assignment).
-- We want to know what it looked like at the time of billing.
left join sf_compass_accounts as acc-- historcial
    on ir.estate_item_c = acc.id
    and least_ignore_nulls(ir.invoice_date_c , ir.revenue_as_of_date_c) = acc.effective_at::date
-- If the join with date to the account record fails, we will go ahead
-- and use the latest available version of the record.
left join sf_compass_accounts as acc2
    on ir.estate_item_c = acc2.id
    and acc2.effective_at::date = (select max(effective_at::date) from sf_compass_accounts)
left join cpg_accounts as cpg_ba
    on coalesce(acc.account_number , acc2.account_number) = cpg_ba.account_number
    and ir.invoice_date_c = cpg_ba.effective_date
-- Excludes service types categorized as tax preparation
left join {{ ref('salesforce_compass__base_mh_service') }} as mh
    on ir.service_rendered_c = mh.id
left join {{ ref('aux__stg_financials_fee_type') }} as ovrd_fee_type
    on ir.system_key = ovrd_fee_type.system_key
    and lower(ir.fee_type_c) = lower(ovrd_fee_type.fee_type)
where true
    and (
        ir.is_cpg = 0
        or (ir.is_cpg = 1 and ir.invoice_date_c < '9/30/2024')
    )
    and 1 = (select max(is_stale) from stale_check)
order by
    revenue_period_end_date
    , ir.system_key
    , coalesce(_trans_key , coalesce(
        acc.account_number
        , acc2.account_number
        , trim(upper(ir.account_number_c))
    ))
