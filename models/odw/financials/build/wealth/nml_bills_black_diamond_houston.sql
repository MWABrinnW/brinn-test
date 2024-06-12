with compass_data_all as (
    select
        ei.system_name                                     as system_name
        , ei.system_instance                               as system_instance
        , ei.system_key                                    as system_key
        , ei.id                                            as estate_item_id
        , ei.identifier_c                                  as dirty_account_number
        , replace(ltrim(ei.identifier_c , '0') , '-' , '') as identifier
        , hh.id                                            as hh_id
        , hh.name                                          as hh_name
        , hh.unique_identifier_c                           as compass_id
        , ei.aum_classification_c                          as aum_ident
        , md.name                                          as mi_strategy
        , ur.id                                            as cm_id
        , ur.name                                          as associate_name
        , ur.employee_number                               as employee_number
        , hh.lead_source_c                                 as lead_source
    from {{ ref('salesforce_compass__base_estate_item_c') }} as ei
    left join {{ ref('salesforce_compass__base_account' ) }} as hh
        on ei.household_c = hh.id
        and ei.is_head = hh.is_head
    left join {{ ref('salesforce_compass__base_user') }} as ur
        on hh.owner_id = ur.id
        and hh.is_head = ur.is_head
    left join {{ ref('salesforce_compass__base_model_c') }} as md
        on ei.model_on_account_c = md.id
        and ei.is_head = md.is_head
    where ei.is_head = 1
        and ei.is_deleted = false
)

select
-- [system attributes]
    ac.system_name::varchar(200)                                                as system_name
    , ac.system_instance::varchar(200)                                          as system_instance
    , ac.system_key::varchar(200)                                               as system_key

    -- [location]
    , null::varchar(200)                                                        as client_location_code

    -- [financial dates]
    , null::timestamp_ntz                                                       as invoice_created_at
    , ac.period_end_date::date                                                  as invoice_date

    --[invoice]
    , null::varchar(200)                                                        as invoice_number_source
    , null::varchar(200)                                                        as billing_statement_id_source
    , null::varchar(200)                                                        as billing_statement_id_crm
    , null::varchar(200)                                                        as invoice_status
    , 0::int                                                                    as is_mid_cycle_invoice
    , replace(ltrim(ac.billing_account_number , '0') , '-' , '')::varchar(200)  as account_number
    , ac.billing_account_number::varchar(200)                                   as account_number_formatted
    , ac.billing_account_number::varchar(200)                                   as billing_account_number
    , ba.id::varchar(200)                                                       as account_id_pms
    , ba.custodial_account_name::varchar(200)                                   as registrant_name
    , ac.account_name::varchar(200)                                             as account_name
    , null::varchar(200)                                                        as type_of_account
    , null::varchar(200)                                                        as client_id_pms
    , null::varchar(200)                                                        as aum_classification_status
    , cd.mi_strategy::varchar(200)                                              as model_investment_strategy
    , ac.custodian::varchar(200)                                                as custodian
    , null::varchar(200)                                                        as billing_custodian
    , null::varchar(200)                                                        as partner_firm
    , null::varchar(200)                                                        as partner_firm_original

    -- [advisor]
    , ac.manager_name_invoices::varchar(200)                                    as client_manager_source
    , cd.associate_name::varchar(200)                                           as client_manager_original_crm
    , cd.associate_name::varchar(200)                                           as client_manager_primary
    , 'W-2'::varchar(200)                                                       as client_manager_type
    , cd.employee_number::varchar(200)                                          as associate_id

    -- [assets and fees]
    , 'Quarterly Fee'::varchar(200)                                             as fee_type
    , ac.rate_bps::varchar(200)                                                 as fee_schedule_source
    , ac.fee_schedule_name::varchar(200)                                        as fee_schedule_type
    , null::varchar(200)                                                        as fee_schedule
    , ac.as_of_date::varchar(200)                                               as assets_as_of_date
    , ac.as_of_date::varchar(200)                                               as fee_calculation_date
    , ac.rate_percentage::decimal(20 , 5)                                       as effective_fee_rate
    , ac.account_value::decimal(20 , 5)                                         as total_account_value
    , ac.billed_value::decimal(20 , 5)                                          as billable_value
    , (ac.account_value - ac.billed_value)::decimal(20 , 5)                     as fee_excluded_assets
    , case
        when ac.fee_or_rebate_amount > 0
            then
                ac.fee_or_rebate_amount
        else 0::decimal(20 , 5)
    end                                                                         as client_fee_gross
    , case
        when ac.fee_or_rebate_amount < 0
            then
                ac.fee_or_rebate_amount
        else 0::decimal(20 , 5)
    end                                                                         as client_fee_rebates
    , null::decimal(20 , 5)                                                     as client_net_contribution_fee
    , null::decimal(20 , 5)                                                     as client_adjustments_fee
    , null::decimal(20 , 5)                                                     as client_write_off_fee
    , ac.total_period_fee::decimal(20 , 5)                                      as client_fee_net
    , null::date                                                                as collection_date
    , null::boolean                                                             as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::varchar(200)                                                   as billing_style
    , 'Quarterly'::varchar(200)                                                 as billing_frequency_source
    , null::varchar(200)                                                        as billing_method
    , null::varchar(200)                                                        as bill_on_balance_type
    , null::varchar(200)                                                        as payment_terms
    , null::varchar(200)                                                        as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                       as account_class
    , null::varchar(200)                                                        as coa_segment_3_accounting_id
    , null::varchar(200)                                                        as coa_segment_5_natural_account_id
    , 'Wealth Management'::varchar(200)                                         as revenue_type

    -- [crm]
    , cd.system_name::varchar(200)                                              as system_name_crm
    , cd.system_instance::varchar(200)                                          as system_instance_crm
    , cd.system_key::varchar(200)                                               as system_key_crm
    , cd.estate_item_id::varchar(200)                                           as account_id_crm
    , cd.hh_id::varchar(200)                                                    as client_id_crm
    , null::varchar(200)                                                        as client_id_original_crm
    , cd.compass_id::varchar(200)                                               as client_id_unique_compass
    , cd.hh_name::varchar(200)                                                  as client_name
    , null::varchar(200)                                                        as client_name_original_crm
    , cd.lead_source::varchar(200)                                              as client_lead_source
    , null::varchar(200)                                                        as client_key_tags_crm


    -- [transactions]
    , case
        when ac.fee_or_rebate_amount > 0
            then
                'Invoice'
        else 'Return'
    end                                                                         as transaction_type
    , null::varchar(200)                                                        as transaction_line_type
    , 1::int                                                                    as transaction_line_quantity
    , 'USD'::varchar(200)                                                       as currency_code
    , 'User'::varchar(200)                                                      as currency_conversion_type
    , 1::number(20 , 5)                                                         as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, default to 0
    , 0::int                                                                    as is_excluded
    , null::varchar(200)                                                        as excluded_reason

    -- [referential]
    , ac.system_key
    || '|' || ac.period_end_date::date
    || '|'
    || replace(ltrim(ac.billing_account_number , '0') , '-' , '')::varchar(200) as _invoice_key
    , ac._created_at::timestamp_ntz(9)                                          as _created_at
    , ac._box_file_name::varchar(200)                                           as _source_file
    , ac._box_file_id::varchar(200)                                             as _box_file_id

    -- [extra fields]
    , null::variant                                                             as _extra_fields

--Black Diamond billing data
from {{ ref('black_diamond_houston_history__base_bills') }} as ac
--black diamond account data
left join {{ ref('black_diamond_houston_history__base_accounts') }} as ba
    on ac.billing_account_number = ba.account_number
    and ba.is_head = 1
--household data
left join compass_data_all as cd
    on ba.account_number = cd.identifier

--max period selection
where ac.period_end_date = (select max(period_end_date) from {{ ref('black_diamond_houston_history__base_bills') }})
