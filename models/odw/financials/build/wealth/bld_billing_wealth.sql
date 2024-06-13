{{ config(
    materialized='table'
) }}


with cte_associate as (
    select
        *
        , row_number() over (partition by file_number order by file_number) as row_number
    from {{ source('finance', 'vw_associate_accounting_code_reference') }}
    qualify row_number = 1
)

, cte_normalize as (
    select
        sw.*
        , case
            when sw.billing_frequency_source ilike 'Monthly' or sw.billing_frequency_source ilike 'Quarterly'
                then sw.billing_frequency_source
            when fft.billing_frequency is not null
                then fft.billing_frequency
        end::varchar(200) as billing_frequency
    from
        {{ ref('int_billing_wealth_01_union') }} as sw
    left join {{ ref('aux__stg_financials_fee_type') }} as fft
        on sw.system_key = fft.system_key
        and sw.fee_type = fft.fee_type
)

select
-- [system attributes]
    sw.system_name::varchar(200)                                                                         as system_name
    , sw.system_instance::varchar(200)                                                                   as system_instance
    , sw.system_key::varchar(200)                                                                        as system_key

    -- [location]
    , loc.location_code                                                                                  as location_code
    , loc.office_name                                                                                    as office_name
    , loc2.location_code::varchar(200)                                                                   as client_location_code
    , loc2.office_name::varchar(200)                                                                     as client_office_name

    -- [financial dates]
    , sw.invoice_created_at::datetime                                                                    as invoice_created_at
    , sw.invoice_date::date                                                                              as invoice_date
    , case
        when sw.billing_frequency ilike 'Quarterly' and sw.is_mid_cycle_invoice = 0
            then
                case
                    when sw.billing_style ilike 'Advance'
                        then
                            last_day(dateadd('Quarter' , 1 , sw.invoice_date) , 'Quarter')
                    when sw.billing_style ilike 'Arrears' then
                        last_day(dateadd('Quarter' , 0 , sw.invoice_date) , 'Quarter')
                end
        when sw.billing_frequency ilike 'Quarterly' and sw.is_mid_cycle_invoice = 1
            then
                case
                    when sw.billing_style ilike 'Advance'
                        then
                            last_day(dateadd('Quarter' , 0 , sw.invoice_date) , 'Quarter')
                    when sw.billing_style ilike 'Arrears' then
                        last_day(dateadd('Quarter' , 0 , sw.invoice_date) , 'Quarter')
                end
        when sw.billing_frequency ilike 'Monthly' then
            case
                when sw.billing_style ilike 'Advance'
                    then
                        last_day(dateadd('Month' , 1 , sw.invoice_date) , 'Month')
                when sw.billing_style ilike 'Arrears' then
                    last_day(dateadd('Month' , 0 , sw.invoice_date) , 'Month')
            end
    end::date
        as revenue_period_end_date
    , dateadd(day , -1 , dateadd('Quarter' , 1 , date_trunc('Quarter' , revenue_period_end_date)))::date
        as revenue_quarter_end_date

    -- [invoice]
    , sw.invoice_number_source::varchar(200)                                                             as invoice_number_source
    , sw.billing_statement_id_source::varchar(200)
        as billing_statement_id_source
    , sw.billing_statement_id_crm::varchar(200)
        as billing_statement_id_crm
    , initcap(sw.invoice_status::varchar(200))                                                           as invoice_status
    , sw.is_mid_cycle_invoice::int                                                                       as is_mid_cycle_invoice
    , sw.account_number::varchar(200)                                                                    as account_number
    , sw.account_number_formatted::varchar(200)
        as account_number_formatted
    , sw.billing_account_number::varchar(200)                                                            as billing_account_number
    , sw.account_id_pms::varchar(200)                                                                    as account_id_pms
    , sw.registrant_name::varchar(200)                                                                   as registrant_name
    , sw.account_name::varchar(200)                                                                      as account_name
    , sw.type_of_account::varchar(200)                                                                   as type_of_account
    , sw.client_id_pms::varchar(200)                                                                     as client_id_pms
    , sw.aum_classification_status::varchar(200)
        as aum_classification_status
    , sw.model_investment_strategy::varchar(200)
        as model_investment_strategy
    , sw.custodian::varchar(200)                                                                         as custodian
    , sw.billing_custodian::varchar(200)                                                                 as billing_custodian
    , sw.partner_firm::varchar(200)                                                                      as partner_firm
    , sw.partner_firm_original::varchar(200)                                                             as partner_firm_original

    -- [advisor]
    , sw.client_manager_source::varchar(200)                                                             as client_manager_source
    , sw.client_manager_original_crm::varchar(200)
        as client_manager_original_crm
    , sw.client_manager_primary::varchar(200)                                                            as client_manager_primary
    , sw.client_manager_type::varchar(200)                                                               as client_manager_type
    , sw.associate_id::varchar(200)                                                                      as associate_id

    -- [assets and fees]
    , initcap(sw.fee_type::varchar(200))                                                                 as fee_type
    , initcap(sw.fee_schedule_source::varchar(200))                                                      as fee_schedule_source
    , initcap(sw.fee_schedule_type::varchar(200))                                                        as fee_schedule_type
    , initcap(sw.fee_schedule::varchar(200))                                                             as fee_schedule
    , sw.assets_as_of_date::date                                                                         as assets_as_of_date
    , sw.fee_calculation_date::date                                                                      as fee_calculation_date
    , case
        when lower(sw.billing_frequency_source) ilike 'Monthly'
            then sw.effective_fee_rate * 12
        when lower(sw.billing_frequency_source) ilike 'Quarterly'
            then sw.effective_fee_rate * 4
        when sw.billing_frequency_source is null
            then sw.effective_fee_rate
    end::number(20 , 5)                                                                                  as effective_fee_rate
    , sw.total_account_value::number(20 , 5)                                                             as total_account_value
    , sw.billable_value::number(20 , 5)                                                                  as billable_value
    , sw.fee_excluded_assets::number(20 , 5)                                                             as fee_excluded_assets
    , sw.client_fee_gross::number(20 , 5)                                                                as client_fee_gross
    , sw.client_fee_rebates::number(20 , 5)                                                              as client_fee_rebates
    , sw.client_net_contribution_fee::number(20 , 5)
        as client_net_contribution_fee
    , sw.client_adjustments_fee::number(20 , 5)                                                          as client_adjustments_fee
    , sw.client_write_off_fee::number(20 , 5)                                                            as client_write_off_fee
    , sw.client_fee_net::number(20 , 5)                                                                  as client_fee_net
    , sw.collection_date::date                                                                           as collection_date
    , coalesce(sw.third_party_calculation::boolean , false)
        as third_party_calculation

    -- [billing terms and payment]
    , initcap(sw.billing_style::varchar(200))                                                            as billing_style
    , initcap(sw.billing_frequency::varchar(200))                                                        as billing_frequency
    , initcap(sw.billing_method::varchar(200))                                                           as billing_method
    , initcap(sw.bill_on_balance_type::varchar(200))                                                     as bill_on_balance_type
    , initcap(sw.payment_terms::varchar(200))                                                            as payment_terms
    , initcap(sw.payment_method_fee::number(20 , 5))                                                     as payment_method_fee

    -- [accounting]
    , lower(sw.account_class::varchar(200))                                                              as account_class
    , coalesce(sw.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean                     as recurring_revenue
    , coalesce(sw.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean
        as impacted_by_financial_markets
    , concat(substr(cd.revenue_coding , 0 , 2) , 0)::varchar(200)
        as coa_segment_1_legal_entity_id
    , '000'::varchar(200)
        as coa_segment_2_product_id
    , coalesce(sw.coa_segment_3_accounting_id , substr(cd.revenue_coding , 10 , 4))::varchar(200)
        as coa_segment_3_accounting_id
    , substr(cd.revenue_coding , 15 , 4)::varchar(200)                                                   as coa_segment_4_team_id
    , coalesce(sw.coa_segment_5_natural_account_id , null)::varchar(200)
        as coa_segment_5_natural_account_id
    , '000'::varchar(200)
        as coa_segment_6_initiative_id
    , '000'::varchar(200)
        as coa_segment_7_intercompany_id
    , '000'::varchar(200)
        as coa_segment_8_future_id
    , concat(
        concat(substr(cd.revenue_coding , 0 , 2) , '0')-- coa_segment_1_legal_entity_id
        , '-' , '000'-- coa_segment_2_product_id
        , '-' , coalesce(sw.coa_segment_3_accounting_id , substr(cd.revenue_coding , 10 , 4))-- coa_segment_3_accounting_id
        , '-' , substr(cd.revenue_coding , 15 , 4)-- coa_segment_4_team_id
        , '-' , coalesce(sw.coa_segment_5_natural_account_id , null)-- coa_segment_5_natural_account_id
        , '-' , '000'-- coa_segment_6_initiative_id
        , '-' , '000'-- coa_segment_7_intercompany_id
        , '-' , '000'-- coa_segment_8_future_id
    )                                                                                                    as coa_account_number
    , fft.revenue_category::varchar(200)                                                                 as revenue_category
    , initcap(sw.revenue_type::varchar(200))                                                             as revenue_type

    -- [crm]
    , sw.system_name_crm::varchar(200)                                                                   as system_name_crm
    , sw.system_instance_crm::varchar(200)                                                               as system_instance_crm
    , sw.system_key_crm::varchar(200)                                                                    as system_key_crm
    , sw.account_id_crm::varchar(200)                                                                    as account_id_crm
    , sw.client_id_crm::varchar(200)                                                                     as client_id_crm
    , sw.client_id_original_crm::varchar(200)                                                            as client_id_original_crm
    , sw.client_id_unique_compass::varchar(200)
        as client_id_unique_compass
    , sw.client_name::varchar(200)                                                                       as client_name
    , sw.client_name_original_crm::varchar(200)
        as client_name_original_crm
    , initcap(sw.client_lead_source::varchar(200))                                                       as client_lead_source
    , initcap(sw.client_key_tags_crm::varchar(200))                                                      as client_key_tags_crm

    -- [transactions]
    , initcap(sw.transaction_type::varchar(200))                                                         as transaction_type
    , initcap(sw.transaction_line_type::varchar(200))                                                    as transaction_line_type
    , sw.transaction_line_quantity::number(20 , 5)
        as transaction_line_quantity
    , sw.currency_code::varchar(200)                                                                     as currency_code
    , sw.currency_conversion_type::varchar(200)
        as currency_conversion_type
    , sw.unit_selling_price::number(20 , 5)                                                              as unit_selling_price

    -- [exclusion]
    , sw.is_excluded::int                                                                                as is_excluded
    , initcap(sw.excluded_reason::varchar(200))                                                          as excluded_reason


    -- [referential]
    , sw._invoice_key::varchar(200)                                                                      as _invoice_key
    , sw._created_at::datetime                                                                           as _created_at
    , sw._source_file::varchar(200)                                                                      as _source_file
    , sw._box_file_id::varchar(200)                                                                      as _box_file_id
    , sw._extra_fields::variant                                                                          as _extra_fields

from
    cte_normalize as sw
left join
    cte_associate as cd
    on sw.associate_id = cd.file_number
left join {{ ref('locations') }} as loc
    on coalesce(sw.coa_segment_3_accounting_id , substr(cd.revenue_coding , 10 , 4)) = loc.accounting_id
    and sw.invoice_date between loc.start_date and coalesce(loc.end_date , '2099-12-31')
left join {{ ref('locations') }} as loc2
    on sw.client_location_code = loc2.location_code
    and sw.invoice_date between loc2.start_date and coalesce(loc2.end_date , '2099-12-31')
left join {{ ref('aux__stg_financials_fee_type') }} as fft
    on sw.system_key = fft.system_key
    and lower(sw.fee_type) = lower(fft.fee_type)
where true
    {% if is_incremental() %}
        -- This filter will only be applied on an incremental run
        -- (uses >= to include records whose timestamp occurred since the last run of this model)
        and sw._created_at >= (select coalesce(max(_created_at) , '1900-01-01') from {{ this }})
    {% endif %}

{% if target.name == 'prod' %}
        and sw.system_key in ('addepar__corbenic', 'salesforce__compass')
    {% endif %}
order by
    system_name
    , _invoice_key
    , revenue_period_end_date
