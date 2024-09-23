select

    -- [system attributes]
    ir.system_name::varchar(200)                                         as system_name
    , ir.system_instance::varchar(200)                                   as system_instance
    , ir.system_key::varchar(200)                                        as system_key

    -- [location]
    , coalesce(
        acc.household_location_code
        , acc2.household_location_code
    )::varchar(200)                                                      as client_location_code

    -- [financial dates]
    , ir.created_date::timestamp_ntz                                     as invoice_created_at
    , ir.invoice_date_c::date                                            as invoice_date
    , null::date                                                         as revenue_period_end_date

    -- [invoice]
    , ir.name::varchar(200)                                              as invoice_number_source
    , ir.orion_bill_id_c::varchar(200)                                   as billing_statement_id_source
    , ir.id::varchar(200)                                                as billing_statement_id_crm
    , ir.status_c::varchar(200)                                          as invoice_status
    , case
        when ir.invoice_date_c = dt.quarter_end_date
            then 0
        when ir.invoice_date_c != dt.quarter_end_date
            then 1
    end::int                                                             as is_intra_period_invoice
    , coalesce(
        acc.account_number
        , acc2.account_number
        , trim(upper(ir.account_number_c))
    )::varchar(200)                                                      as account_number
    , ir.account_number_c::varchar(200)                                  as account_number_formatted
    , ir.billing_account_number_c::varchar(200)                          as billing_account_number
    , ir.orion_account_id_c::varchar(200)                                as account_id_pms
    , ir.registration_name_c::varchar(200)                               as registrant_name
    , coalesce(acc.account_name , acc2.account_name)::varchar(200)       as account_name
    , coalesce(
        ir.account_type_c
        , acc.registration_type
        , acc2.registration_type
    )::varchar(200)                                                      as type_of_account
    , coalesce(
        ir.orion_house_id_c
        , acc.orion_client_id
        , acc2.orion_client_id
    )::varchar(200)                                                      as client_id_pms
    , coalesce(
        ir.aum_classification_c
        , acc.aum_classification
        , acc2.aum_classification
    )::varchar(200)                                                      as aum_classification_status
    , coalesce(
        ir.model_on_account_c
        , acc.investment_strategy
        , acc2.investment_strategy
    )::varchar(200)                                                      as model_investment_strategy
    , ir.custodian_c::varchar(200)                                       as custodian
    , ir.billing_custodian_c::varchar(200)                               as billing_custodian
    , ir.branch_c::varchar(200)                                          as partner_firm
    , ir.branch_2_c::varchar(200)                                        as partner_firm_original

    -- [advisor]
    -- Historical Client Manager (from upsert into Salesforce)
    , ir.quarterback_2_c::varchar(200)                                   as client_manager_source
    -- Historical client manager (from compass account object, historical records)
    , acc.client_manager::varchar(200)                                   as client_manager_original
    -- Historical associate ID (from compass account object, historical records)
    , acc.employee_number::varchar(200)                                  as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , acc2.client_manager::varchar(200)                                  as client_manager_primary
    -- Current associate id (from compass account object, is_head)
    , acc2.employee_number::varchar(200)                                 as associate_id_primary
    , 'W-2'::varchar(200)                                                as client_manager_type

    -- [assets and fees]
    , ir.fee_type_c::varchar(200)                                        as fee_type
    , ir.fee_schedule_c::varchar(200)                                    as fee_schedule_source
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
    , ir.collection_date_c::date                                         as collection_date
    , ir.third_party_calculation_c::boolean                              as third_party_calculation

    -- [billing terms and payment]
    , ir.billing_style_c::varchar(200)                                   as billing_style
    , ir.fee_frequency_c::varchar(200)                                   as billing_frequency_source
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
    , null::varchar(200)                                                 as coa_segment_3_accounting_id
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    , case
        when client_location_code = '112' and cpg_acc.advisor = 'Rob Thomas/Direct'
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

        when client_location_code = '112' and cpg_acc.advisor like '%/SAN'
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

        when client_location_code = '112' and cpg_acc.advisor is not null
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
                '42001'

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
    end::varchar(200)                                                    as coa_segment_5_natural_account_id
    , null::varchar(200)                                                 as revenue_category
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
    , 'salesforce'::varchar(200)                                         as system_name_crm
    , 'compass'::varchar(200)                                            as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::varchar(200) as system_key_crm
    , ir.estate_item_c::varchar(200)                                     as account_id_crm
    , coalesce(
        ir.company_family_c
        , acc.household_id
        , acc2.household_id
    )::varchar(200)                                                      as client_id_crm
    , ir.company_family_c::varchar(200)                                  as client_id_original_crm
    , coalesce(

        acc.unique_identifier
        , acc2.unique_identifier

    )::varchar(200)                                                      as client_id_unique_compass
    , coalesce(

        acc.household_name
        , acc2.household_name
    )::varchar(200)                                                      as client_name
    , ir.client_name_c::varchar(200)                                     as client_name_original_crm
    , coalesce(

        acc.household_lead_source
        , acc2.household_lead_source

    )::varchar(200)                                                      as client_lead_source
    , coalesce(

        acc.key_tags
        , acc2.key_tags

    )::varchar(5000)                                                     as client_key_tags_crm

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


    {# --[gavins adds]
    ,ir.short_name_c::varchar(200) as short_name
    ,ir.branch_c::varchar(200) as branch_primary
    ,ir.branch_2_c::varchar(200) as branch_secondary
    ,ir.collection_date_c::date as collection_date
    ,ir.quarterback_2_c::varchar(200) as quarterback_secondary
    ,ir.quarterback_c::varchar(200) as quarterback_primary
    ,ir.old_name_c::varchar(200) as old_name
    ,acc.household_location_id::varchar(200) as mariner_location #}

    -- [exclusion]
    , case
        when mh.record_type_id = '0123c000000tyRyAAI' or ir.third_party_calculation_c = true
            then 1
        else 0
    end::int                                                             as is_excluded

    , case
        when mh.record_type_id = '0123c000000tyRyAAI' and ir.third_party_calculation_c = true
            then 'Specialty Tax, Third Party Calculation'
        when mh.record_type_id = '0123c000000tyRyAAI'
            then 'Specialty Tax'
        when ir.third_party_calculation_c = true
            then 'Third Party Calculation'
    end::varchar(200)                                                    as excluded_reason

    -- [referential]
    , null::varchar(200)                                                 as _trans_key
    , ir._created_at::timestamp_ntz(9)                                   as _created_at
    , null::varchar(200)                                                 as _source_file
    , null::varchar(200)                                                 as _box_file_id

    -- These are fields that are likely specific to this source
    -- and are intended to help with one off investigations or
    -- special analysis.
    , object_construct_keep_null(
        'account_id' , coalesce(acc.estate_item_id , acc2.estate_item_id)
        , 'client_id' , coalesce(acc.client_id , acc2.client_id)
        , 'client_id_joins_on_origin' , iff(acc.client_id is not null , 1 , 0)
        , 'client_id_joins_on_head' , iff(acc2.client_id is not null , 1 , 0)
        , 'client_name' , coalesce(acc.household_name , acc2.household_name)
    )                                                                    as _extra_fields
from {{ ref('salesforce_compass__base_invoice_review_c') }} as ir
left join {{ ref('dates') }} as dt
    on ir.invoice_date_c = dt.date_key
-- We join on date as first preference for account attributes.
-- This is because over time the account record can change (i.e. advisor assignment).
-- We want to know what it looked like at the time of billing.
left join {{ ref('salesforce_compass_accounts') }} as acc-- historcial
    on ir.estate_item_c = acc.id
    and least(ir.invoice_date_c , ir.revenue_as_of_date_c) = acc.effective_date
    and acc.is_latest = 1
-- If the join with date to the account record fails, we will go ahead
-- and use the latest available version of the record.
left join {{ ref('salesforce_compass_accounts') }} as acc2--current
    on ir.estate_item_c = acc2.id
    and acc2.is_head = 1
left join {{ ref('dim_custodian_accounts') }} as dca
    on coalesce(acc.custodian_key , acc2.custodian_key) = dca.custodian
    and coalesce(acc.account_number , acc2.account_number) = dca.account_number
{# left join {{ ref('bld_custodian_accounts') }} as ca
  on coalesce(acc.custodian_key , acc2.custodian_key) = ca.custodian
  and coalesce(acc.account_number , acc2.account_number) = ca.account_number
  and least(ir.invoice_date_c , ir.revenue_as_of_date_c , dca.max_effective_date) = ca.effective_date #}
left join {{ ref('tamarac_state_college_history__base_accounts') }} as cpg_acc
    on coalesce(acc.account_number , acc2.account_number) = replace(cpg_acc.account_number , '-' , '')
    and ir.revenue_as_of_date_c = cpg_acc.effective_date
    and cpg_acc.rn = 1
-- Excludes service types categorized as tax preparation
left join fivetran.salesforce_compass.mhservice_c as mh
    on ir.service_rendered_c = mh.id
where true
    and ir.is_head = 1
    and ir.is_latest = 1
    and ir.is_deleted = 0
    and ir._fivetran_deleted = 0
    and ir.invoice_date_c >= '12/31/2021'-- move downstream
order by ir.revenue_as_of_date_c desc , coalesce(
    acc.account_number
    , acc2.account_number
    , ir.account_number_c
)
