with stg_account_master as (
    select
        *
        , max(effective_date)
            over (partition by year(effective_date) , month(effective_date)) as last_effective_date_of_month
        , row_number()
            over (
                partition by effective_date , account_number
                order by iff(close_date is null , 0 , 1) asc
            )                                                                as rn
    from {{ ref('envestnet_manasquan__stg_account_master') }}
    where true
    qualify rn = 1
)

select
    -- [pms attributes]
    b.system_name::text(200)                                                     as system_name
    , b.system_instance::text(200)                                               as system_instance
    , b.system_key::text(200)                                                    as system_key
    , b.firm_source::text(200)                                                   as firm_source


    -- [location]
    , coalesce(
        a_hist.household_location_code
        , a_head.household_location_code
    )::text(200)                                                                 as client_location_code

    -- [invoice]
    , null::text(200)                                                            as invoice_number_source
    , b.invoice_date::timestamp_ntz                                              as invoice_created_at
    , b.invoice_date::date                                                       as invoice_date
    , null::text(200)                                                            as billing_statement_id_source
    , null::text(200)                                                            as billing_statement_id_crm
    , null::text(200)                                                            as invoice_status
    , 0::int                                                                     as is_intra_period_invoice
    , b.account_number::text(200)                                                as account_number
    , b.account_number_formatted::text(200)                                      as account_number_formatted
    , trim(replace(b.debited_account , '-' , ''))::text(200)                     as billing_account_number
    , am.account_id::text(200)                                                   as account_id_pms
    , am.account_name::text(200)                                                 as registrant_name
    , am.account_name::text(200)                                                 as account_name
    , coalesce(a_hist.registration_type , a_head.registration_type)::text(200)   as type_of_account
    , am.customer_id::text(200)                                                  as client_id_pms
    , coalesce(a_hist.aum_classification , a_head.aum_classification)::text(200) as aum_classification_status
    , coalesce(
        a_hist.investment_strategy
        , a_head.investment_strategy
    )::text(200)                                                                 as model_investment_strategy
    , am.custodian::text(200)                                                    as custodian
    , b.debit_custodian::text(200)                                               as billing_custodian
    , null::text(200)                                                            as partner_firm
    , null::text(200)                                                            as partner_firm_original

    -- [advisor]
    , null::text(200)                                                            as advisor_source
    , coalesce(a_hist.client_manager , a_head.client_manager)::text(200)         as advisor_original
    , coalesce(a_hist.employee_number , a_head.employee_number)::text(200)       as associate_id_original
    , coalesce(a_head.client_manager , a_hist.client_manager)::text(200)         as advisor_primary
    , coalesce(a_head.employee_number , a_hist.employee_number)::text(200)       as associate_id_primary
    , 'W-2'::text(200)                                                           as advisor_type

    -- [assets and fees]
    , b.billing_cycle::text(200)                                                 as fee_type
    , null::text(200)                                                            as fee_schedule_source
    , null::text(200)                                                            as fee_schedule_type
    , fs.name::text(200)                                                         as fee_schedule
    , b.invoice_date::date                                                       as assets_as_of_date
    , b.invoice_date::date                                                       as fee_calculation_date
    ,
    case
        when b.billable_value = 0
            then 0
        else (b.total_fee_amount / b.billable_value) * 100
    end::decimal(29 , 8)                                                         as effective_fee_rate
    , coalesce(am.total_market_value , b.billable_value)::decimal(20 , 5)        as total_account_value
    , b.billable_value::decimal(20 , 5)                                          as billable_value
    , (am.total_market_value - b.billable_value)::decimal(20 , 5)                as fee_excluded_assets
    , case
        when b.total_fee_amount > 0
            then b.total_fee_amount
        else 0
    end::decimal(20 , 5)                                                         as client_fee_gross
    , case
        when b.total_fee_amount < 0
            then b.total_fee_amount
        else 0
    end::decimal(20 , 5)                                                         as client_fee_rebates
    , null::decimal(20 , 5)                                                      as client_net_contribution_fee
    , null::decimal(20 , 5)                                                      as client_adjustments_fee
    , null::decimal(20 , 5)                                                      as client_write_off_fee
    , b.total_fee_amount::decimal(20 , 5)                                        as client_fee_net
    , null::decimal(20 , 2)                                                      as referral_fee

    , null::date                                                                 as collection_date
    , null::boolean                                                              as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::text(200)                                                       as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , coalesce(b.billing_cycle , 'Quarterly')::text(200)                         as billing_frequency
    , b.debit_type::text(200)                                                    as billing_method
    , null::text(200)                                                            as bill_on_balance_type
    , null::text(200)                                                            as payment_terms
    , null::decimal(20 , 5)                                                      as payment_method_fee

    -- [accounting]
    , 'REV'::text(200)                                                           as account_class
    , '110'::text(200)                                                           as coa_segment_1_legal_entity_id
    , null::text(200)                                                            as coa_segment_3_accounting_id
    , null::text(200)                                                            as coa_segment_4_team_id
    , case
        when coalesce(a_hist.household_lead_source , a_head.household_lead_source) ilike '%RPP%'
            then '40000'
        when coalesce(a_hist.household_lead_source , a_head.household_lead_source) ilike '%Solicitor%'
            then '40002'
        else '40001'
    end::text(200)                                                               as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::text(200)                                             as revenue_category
    , 'Wealth Mgmt Fees'::text(200)                                              as revenue_type

    -- [crm]
    , 'salesforce'::text(200)                                                    as system_name_crm
    , 'compass'::text(200)                                                       as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text(200)            as system_key_crm
    , coalesce(a_hist.id , a_head.id)::text(200)                                 as account_id_crm
    , coalesce(a_hist.client_id , a_head.client_id)::text(200)                   as client_id_crm
    , coalesce(a_hist.client_id , a_head.client_id)::text(200)                   as client_id_original_crm
    , coalesce(a_hist.unique_identifier , a_head.unique_identifier)::text(200)   as client_id_unique_compass
    , coalesce(a_hist.household_name , a_head.household_name)::text(200)         as client_name
    , coalesce(a_hist.household_name , a_head.household_name)::text(200)         as client_name_original_crm
    , coalesce(
        a_hist.household_lead_source
        , a_head.household_lead_source
    )::text(200)                                                                 as client_lead_source
    , coalesce(a_hist.key_tags , a_head.key_tags)::text(5000)                    as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text(200)                                                       as transaction_type
    , 'Line'::text(200)                                                          as transaction_line_type
    , 1::int                                                                     as transaction_line_quantity
    , 'USD'::text(200)                                                           as currency_code
    , 'User'::text(200)                                                          as currency_conversion_type
    , b.total_fee_amount::number(20 , 5)                                         as unit_selling_price

    -- [exclusion]
    , array_to_string(
    -- account numbers that are invalid
        array_construct_compact(
            case when b.account_number like 'REUSE%' then 'Account invalid, reuse of an existing account number;'
                when b.account_number = 'MICHAEL. ROLLOVER IRA. BROKERAGE' then 'Account invalid;'
                when b.account_number = 'FIDELITY IWS' then 'Account invalid;'
            end
        )
        , ' '
    )::text(2000)                                                                as excluded_reasons

    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                     as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , (trim(replace(b.account_number , '-' , null)) || '-' || b._id)::text(200)  as _trans_key
    , b._created_at::timestamp_ntz(9)                                            as _source_loaded_at
    , b._box_file_name::text(200)                                                as _source_file
    , b._box_file_id::text(200)                                                  as _box_file_id

    -- [extra fields]
    , null::object                                                               as _extra_fields


from {{ ref('envestnet_manasquan__stg_bills') }} as b
left join {{ ref('salesforce_compass_accounts') }} as a_hist
    on a_hist.effective_at::date = b.invoice_date
    and a_hist.account_number = ltrim(regexp_replace(replace(trim(upper(b.account_number)) , '-' , '') , '\\s+' , ' ') , '0')
left join {{ ref('salesforce_compass_accounts') }} as a_head
    on a_head.is_head = 1
    and a_head.account_number = ltrim(regexp_replace(replace(trim(upper(b.account_number)) , '-' , '') , '\\s+' , ' ') , '0')
left join stg_account_master as am
    on am.effective_date = am.last_effective_date_of_month-- only use data from last day of the month
    and b.account_number = am.account_number
    and month(am.effective_date) = month(b.invoice_date)
    and year(am.effective_date) = year(b.invoice_date)
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on b.invoice_date = fs.effective_at::date
    and coalesce(a_hist.fee_schedule , a_head.fee_schedule) = fs.id
    and fs.is_latest = 1
where true
    and b.is_head = 1
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
