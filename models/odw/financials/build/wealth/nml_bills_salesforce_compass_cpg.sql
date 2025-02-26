select

    -- [pms attributes]
    ir.system_name::text(200)                                         as system_name
    , ir.system_instance::text(200)                                   as system_instance
    , ir.system_key::text(200)                                        as system_key
    , ir.firm_source::text(200)                                       as firm_source


    -- [location
    , '112'::text(200)                                                as client_location_code

    -- [invoice]
    , ir.name::text(200)                                              as invoice_number_source
    , ir.created_date::timestamp_ntz                                  as invoice_created_at
    , ir.invoice_date_c::date                                         as invoice_date
    , ir.orion_bill_id_c::text(200)                                   as billing_statement_id_source
    , ir.id::text(200)                                                as billing_statement_id_crm
    , ir.status_c::text(200)                                          as invoice_status
    , case
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.quarter_end_date
            then 0
        when coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date != dt.quarter_end_date
            then 1
    end::int                                                          as is_intra_period_invoice
    , trim(upper(ir.account_number_c))::text(200)                     as account_number

    , ir.account_number_c::text(200)                                  as account_number_formatted
    , ir.billing_account_number_c::text(200)                          as billing_account_number
    , ba.upload_account_id::text(200)                                 as account_id_pms
    , ir.registration_name_c::text(200)                               as registrant_name
    , ba.account_name::text(200)                                      as account_name
    , coalesce(
        ba.account_type
        , ir.account_type_c
    )::text(200)                                                      as type_of_account
    , ba.primary_household_id::text(200)                              as client_id_pms
    , iff(ba.aum_indicator = 1 , 'AUM - Assets Under Management' , 'Data Aggregation / Reporting Only')
    ::text(200)                                                       as aum_classification_status
    , trim(ba.target_allocation)::text(200)                           as model_investment_strategy
    , ir.custodian_c::text(200)                                       as custodian
    , ir.billing_custodian_c::text(200)                               as billing_custodian
    , ir.branch_c::text(200)                                          as partner_firm
    , ir.branch_2_c::text(200)                                        as partner_firm_original


    -- [advisor]
    -- Historical Client Manager (from upsert into Salesforce)
    , ir.quarterback_2_c::text(200)                                   as advisor_source
    -- Historical client manager (from compass account object, historical records)
    , coalesce(
        acc.advisor , acc2.advisor
        , ba.primary_advisor
        , ba.household_advisor
    )::text(200)
        as advisor_original
    -- Historical associate ID (from compass account object, historical records)
    , null::text(200)                                                 as associate_id_original
    -- Current client manager (from compass account object, is_head) or billing review current QB
    , coalesce(
        acc.advisor , acc2.advisor
        , ba.primary_advisor
        , ba.household_advisor
    )::text(200)                                                      as advisor_primary
    -- Current associate id (from compass account object, is_head)
    , null::text(200)                                                 as associate_id_primary
    , '1099'::text(200)                                               as advisor_type

    -- [assets and fees]
    , ir.fee_type_c::text(200)                                        as fee_type
    , coalesce(
        ba.billing_definitions
        , ir.fee_schedule_c
    )
    ::text(200)
        as fee_schedule_source
    , null::text(200)                                                 as fee_schedule_type
    , null::text(200)                                                 as fee_schedule
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
    , ir.billing_style_c::text(200)                                   as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , coalesce(
        ir.fee_frequency_c
        , ovrd_fee_type.billing_frequency
    )::text(200
    )                                                                 as billing_frequency
    , ir.billing_method_c::text(200)                                  as billing_method
    , case
        when ir.fee_type_c = 'Quarterly Fee' then
            'EOQ Balance'
    end::text(200)                                                    as bill_on_balance_type
    , null::text(200)                                                 as payment_terms
    , ir.payment_method_fee_c::number(20 , 5)                         as payment_method_fee


    -- [accounting]
    , 'REV'::text(200)                                                as account_class
    , null::text(200)                                                 as coa_segment_1_legal_entity_id
    , '1112'::text(200)                                               as coa_segment_3_accounting_id
    , null::text(200)                                                 as coa_segment_4_team_id
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
        -- finance is changd how cpg is reported
        when fee_calculation_date < '2024-12-31'
            then
                case
                    when coalesce(acc.advisor , acc2.advisor) is not null
                        and coalesce(acc.advisor , acc2.advisor) ilike '%(SOLICITOR)%'
                        then
                            '40002'--Other Referral Partners (CPAs)/Solicitors

                    when ir.fee_type_c in ('Quarterly Fee' , 'Fee Adjustment' , 'Lost Client Fee')
                        then
                            '40001'-- traditional
                end
        -- finance is changd how cpg is reported, new natural account tamp
        when fee_calculation_date >= '2024-12-31'
            then '40104'
    end::text(200)                                                    as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , ovrd_fee_type.revenue_category::text(200)                       as revenue_category

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
    end::text(200)                                                    as revenue_type



    -- [crm]
    , 'dynamics'::text(200)                                           as system_name_crm
    , 'tamarac_cpg'::text(200)                                        as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text(200) as system_key_crm
    , coalesce(acc.account_id , acc2.account_id)::text(200)           as account_id_crm
    , coalesce(acc.household_id , acc2.household_id)::text(200)       as client_id_crm
    , ir.company_family_c::text(200)                                  as client_id_original_crm
    , null::text(200)                                                 as client_id_unique_compass
    , coalesce(
        acc.household_name , acc2.household_name
        , 'Orphaned Dynamics Household'
    )
    ::text(200)                                                       as client_name
    , ir.client_name_c::text(200)                                     as client_name_original_crm
    , null::text(200)                                                 as client_lead_source
    , null::text(5000)                                                as client_key_tags_crm



    -- [transactions] -----------------------------------------------------------------------------
    , case
        when ir.fee_type_c = 'Lost Client Fee'
            then 'Return'
        else 'Invoice'
    end::text(200)                                                    as transaction_type
    , 'Line'::text(200)                                               as transaction_line_type
    , 1::int                                                          as transaction_line_quantity
    , 'USD'::text(200)                                                as currency_code
    , 'User'::text(200)                                               as currency_conversion_type
    , ir.net_fee_c::number(20 , 5)                                    as unit_selling_price


    -- [exclusion] --------------------------------------------------------------------------------
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
    )::text(2000)                                                     as excluded_reasons
    , case when excluded_reasons = '' then 0 else 1 end::int          as is_excluded


    -- [finanical dates] dependencies on upstream identifiers -------------------------------------
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , null::text(200)                                                 as _trans_key
    , ir._created_at::timestamp_ntz(9)                                as _source_loaded_at
    , null::text(200)                                                 as _source_file
    , null::text(200)                                                 as _box_file_id
    , object_construct_keep_null(
        'upload_account_id' , ba.upload_account_id
        , 'tam_finance_account_id' , coalesce(acc.account_id , acc2.account_id)
        , 'is_cpg' , ir.is_cpg
    )                                                                 as _extra_fields

-- source cpg invoices from intermediate model; where clause "is_cpg = 1" and "invoice_date"
from {{ ref('int_bills_salesforce_compass_cpg_split') }} as ir
left join edw.ref.dates as dt
    on coalesce(ir.calculation_as_of_date_c , ir.invoice_date_c)::date = dt.date_key

inner join {{ ref('tamarac_state_college_history__base_accounts') }} as ba
    on replace(ir.account_number_c , '-' , '') = replace(ba.account_number , '-' , '')
    and ir.invoice_date_c = ba.effective_date
    and ba.rn = 1
    and ba.entity_type in ('Single Account')

-- join to the dynamics crm "effective_date" and then on "is_head" if the first join does not return a result.
inner join {{ ref('dynamics_tamarac_cpg__int_accounts') }} as acc
    on ba.upload_account_id = acc.crm_pms_account_id
    and ir.invoice_date_c::date = acc.effective_date

inner join {{ ref('dynamics_tamarac_cpg__int_accounts') }} as acc2
    on ba.upload_account_id = acc2.crm_pms_account_id
    and acc2.is_head = 1

-- excludes service types categorized as tax preparation
left join fivetran.salesforce_compass.mhservice_c as mh
    on ir.service_rendered_c = mh.id
left join datalake.aux.stg_financials_fee_type as ovrd_fee_type
    on ir.system_key = ovrd_fee_type.system_key
    and lower(ir.fee_type_c) = lower(ovrd_fee_type.fee_type)

-- isolates cpg invoices
where true
    and ir.invoice_date_c >= '09/30/2024'
    and ir.is_cpg = 1
