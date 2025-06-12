with accounts as (
    select
        a.effective_date                                                         as effective_date
        , a.account_id                                                           as account_id
        , a.account_number                                                       as account_number
        , a.account_name                                                         as account_name
        , a.customer_id                                                          as customer_id
        , a.custodian                                                            as custodian
        , a.total_market_value                                                   as total_market_value
        , max(a.effective_date)
            over (partition by year(a.effective_date) , month(a.effective_date)) as last_effective_date_of_month
        , row_number()
            over (
                partition by a.effective_date , a.account_number
                order by iff(a.close_date is null , 0 , 1) asc
            )                                                                    as rn
    from {{ ref('envestnet_manasquan__stg_account_master') }} as a
    inner join {{ ref('dates') }} as dt
        on a.effective_date = dt.month_last_market_date
    where 1 = 1
    qualify a.effective_date = max(a.effective_date)
            over (partition by year(a.effective_date) , month(a.effective_date))
        and rn = 1
)

select
    -- [pms attributes]
    b.system_name::text(500)                                                     as system_name
    , b.system_instance::text(500)                                               as system_instance
    , b.system_key::text(500)                                                    as system_key
    , b.firm_source::text(500)                                                   as firm_source

    -- [location]
    , coalesce(
        a_hist.household_location_code
        , a_head.household_location_code
    )::text(500)                                                                 as client_location_code

    -- [invoice]
    , null::text(500)                                                            as invoice_number_source
    , b.invoice_date::timestamp_ntz                                              as invoice_created_at
    , b.invoice_date::date                                                       as invoice_date
    , null::text(500)                                                            as billing_statement_id_source
    , null::text(500)                                                            as billing_statement_id_crm
    , null::text(500)                                                            as invoice_status
    , 0::int                                                                     as is_intra_period_invoice
    , b.account_number::text(500)                                                as account_number
    , b.account_number_formatted::text(500)                                      as account_number_formatted
    , trim(replace(b.debited_account , '-' , ''))::text(500)                     as billing_account_number
    , acc.account_id::text(500)                                                  as account_id_pms
    , acc.account_name::text(500)                                                as registrant_name
    , acc.account_name::text(500)                                                as account_name
    , coalesce(a_hist.registration_type , a_head.registration_type)::text(500)   as type_of_account
    , acc.customer_id::text(500)                                                 as client_id_pms
    , coalesce(a_hist.aum_classification , a_head.aum_classification)::text(500) as aum_classification_status
    , coalesce(
        a_hist.investment_strategy
        , a_head.investment_strategy
    )::text(500)                                                                 as model_investment_strategy
    , acc.custodian::text(500)                                                   as custodian
    , b.debit_custodian::text(500)                                               as billing_custodian
    , null::text(500)                                                            as partner_firm
    , null::text(500)                                                            as partner_firm_original

    -- [advisor]
    , null::text(500)                                                            as advisor_source
    , coalesce(a_hist.client_manager , a_head.client_manager)::text(500)         as advisor_original
    , coalesce(a_hist.employee_number , a_head.employee_number)::text(500)       as associate_id_original
    , coalesce(a_head.client_manager , a_hist.client_manager)::text(500)         as advisor_primary
    , coalesce(a_head.employee_number , a_hist.employee_number)::text(500)       as associate_id_primary
    , 'W-2'::text(500)                                                           as advisor_type

    -- [assets and fees]
    , b.billing_cycle::text(500)                                                 as fee_type
    , coalesce(a_hist.fee_schedule , a_head.fee_schedule)::text(500)             as fee_schedule_source
    , null::text(500)                                                            as fee_schedule_type
    , null::text(500)                                                            as fee_schedule
    , b.invoice_date::date                                                       as assets_as_of_date
    , b.invoice_date::date                                                       as fee_calculation_date
    ,
    case
        when b.billable_value = 0
            then 0
        else (b.total_fee_amount / b.billable_value) * 100
    end::decimal(29 , 8)                                                         as effective_fee_rate
    , coalesce(acc.total_market_value , b.billable_value)::decimal(20 , 5)       as total_account_value
    , b.billable_value::decimal(20 , 5)                                          as billable_value
    , (acc.total_market_value - b.billable_value)::decimal(20 , 5)               as fee_excluded_assets
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
    , 'Advance'::text(500)                                                       as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , coalesce(b.billing_cycle , 'Quarterly')::text(500)                         as billing_frequency
    , b.debit_type::text(500)                                                    as billing_method
    , null::text(500)                                                            as bill_on_balance_type
    , null::text(500)                                                            as payment_terms
    , null::decimal(20 , 5)                                                      as payment_method_fee

    -- [accounting]
    , 'REV'::text(500)                                                           as account_class
    , '110'::text(500)                                                           as coa_segment_1_legal_entity_id
    , null::text(500)                                                            as coa_segment_3_accounting_id
    , null::text(500)                                                            as coa_segment_4_team_id
    , case
        when coalesce(a_hist.household_lead_source , a_head.household_lead_source) ilike '%RPP%'
            then '40000'
        when coalesce(a_hist.household_lead_source , a_head.household_lead_source) ilike '%Solicitor%'
            then '40002'
        else '40001'
    end::text(500)                                                               as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::text(500)                                             as revenue_category
    , 'Wealth Mgmt Fees'::text(500)                                              as revenue_type

    -- [crm]
    , 'salesforce'::text(500)                                                    as system_name_crm
    , 'compass'::text(500)                                                       as system_instance_crm
    , concat(system_name_crm , '__' , system_instance_crm)::text(500)            as system_key_crm
    , coalesce(a_hist.id , a_head.id)::text(500)                                 as account_id_crm
    , coalesce(a_hist.client_id , a_head.client_id)::text(500)                   as client_id_crm
    , coalesce(a_hist.client_id , a_head.client_id)::text(500)                   as client_id_original_crm
    , coalesce(a_hist.unique_identifier , a_head.unique_identifier)::text(500)   as client_id_unique_compass
    , coalesce(a_hist.household_name , a_head.household_name)::text(500)         as client_name
    , coalesce(a_hist.household_name , a_head.household_name)::text(500)         as client_name_original_crm
    , coalesce(
        a_hist.household_lead_source
        , a_head.household_lead_source
    )::text(500)                                                                 as client_lead_source
    , coalesce(a_hist.key_tags , a_head.key_tags)::text(5000)                    as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text(500)                                                       as transaction_type
    , 'Line'::text(500)                                                          as transaction_line_type
    , 1::int                                                                     as transaction_line_quantity
    , 'USD'::text(500)                                                           as currency_code
    , 'User'::text(500)                                                          as currency_conversion_type
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
    )::text(5000)                                                                as excluded_reasons

    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                     as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , (trim(replace(b.account_number , '-' , null)) || '-' || b._id)::text(500)  as _trans_key
    , b._created_at::timestamp_ntz(9)                                            as _source_loaded_at
    , b._box_file_name::text(500)                                                as _source_file
    , b._box_file_id::text(500)                                                  as _box_file_id

    -- [extra fields]
    , object_construct_keep_null(
        'join_pms_env_base_accts_eff_date' , iff(acc.account_number is not null , 1 , 0)
        , 'join_crm_sf_eff_date' , iff(a_hist.account_number is not null , 1 , 0)
        , 'join_crm_sf_is_head' , iff(a_head.account_number is not null , 1 , 0)
    )::variant                                                                   as _extra_fields

from {{ ref('envestnet_manasquan__stg_bills') }} as b
left join {{ ref('salesforce_compass_accounts') }} as a_hist
    on a_hist.effective_at::date = b.invoice_date
    and b.account_number = a_hist.account_number
left join {{ ref('salesforce_compass_accounts') }} as a_head
    on a_head.is_head = 1
    and b.account_number = a_head.account_number
left join accounts as acc
    on b.account_number = acc.account_number
    and month(b.invoice_date) = month(acc.effective_date)
    and year(b.invoice_date) = year(acc.effective_date)
where true
    and b.is_head = 1
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , b.account_number)
