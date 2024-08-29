{{
    config(
    materialized='table'
) }}


with cte_get_billing_freq as (
    select
        nml.*
        , coalesce(nml.billing_frequency_source , ovrd_fee_type.billing_frequency)::varchar(200) as billing_frequency
    from
        {{ ref('int_billing_wealth_01_union') }} as nml
    left join {{ ref('aux__stg_financials_fee_type') }} as ovrd_fee_type
        on nml.system_key = ovrd_fee_type.system_key
        and lower(nml.fee_type) = lower(ovrd_fee_type.fee_type)
    where true
    {% if target.name == 'dev' or target.name == 'ci' %}
        and nml.fee_calculation_date < dateadd(month, -3, date_trunc('month', current_date))
    {% elif target.name == 'prod' %}
        and nml.system_key in ('addepar__corbenic', 'black_diamond__houston', 'salesforce__compass', 'sei__manasquan')
    {% endif %}


)

, cte_normalize as (
    select
        *
        , case
            -- quarterly bills and on-cycle
            when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 0
                then
                    case
                        -- if advance, get next quarter end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Quarter' , 1 , fee_calculation_date) , 'Quarter')
                        -- if arrears, get current quarter end date
                        when billing_style ilike 'Arrears' then
                            last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                    end
            -- quarterly bills and NOT on-cycle
            when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 1
                then
                    case
                        -- if advance, get current quarter end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                        -- if arrears, get current quarter end date
                        when billing_style ilike 'Arrears' then
                            last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                    end
            -- monthly bills, intra period is NOT evaluated
            when billing_frequency ilike 'Monthly'
                then
                    case
                    -- if advance, get next month end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Month' , 1 , fee_calculation_date) , 'Month')
                        -- if arrears, get current month end date
                        when billing_style ilike 'Arrears'
                            then
                                last_day(dateadd('Month' , 0 , fee_calculation_date) , 'Month')
                    end
            -- NOT quarterly or monthly bills, get current month end date (i.e., one-time, semi-annual, annual)
            else last_day(dateadd('Month' , 0 , fee_calculation_date) , 'Month')
        end::date
            as revenue_period
    from cte_get_billing_freq
)

select
    -- [system attributes]
    nml.system_name::varchar(200)                                                                   as system_name
    , nml.system_instance::varchar(200)                                                             as system_instance
    , nml.system_key::varchar(200)                                                                  as system_key

    -- [location]
    , case
        when ass.advisor_nonadvisor ilike 'Advisor'
            then loc_adv.location_code
        else loc_cli.location_code
    end::varchar(200)                                                                               as location_code
    , case
        when ass.advisor_nonadvisor ilike 'Advisor'
            then loc_adv.office_name
        else loc_cli.office_name
    end::varchar(200)                                                                               as office_name
    , loc_cli.location_code::varchar(200)                                                           as client_location_code
    , loc_cli.office_name::varchar(200)                                                             as client_office_name

    -- [financial dates]
    , nml.invoice_created_at::datetime                                                              as invoice_created_at
    , nml.invoice_date::date                                                                        as invoice_date
    , nml.revenue_period::date                                                                      as revenue_period_end_date
    , dateadd(day , -1 , dateadd('Quarter' , 1 , date_trunc('Quarter' , nml.revenue_period)))::date as revenue_quarter_end_date

    -- [invoice]
    , nml.invoice_number_source::varchar(200)                                                       as invoice_number_source
    , nml.billing_statement_id_source::varchar(200)
        as billing_statement_id_source
    , nml.billing_statement_id_crm::varchar(200)
        as billing_statement_id_crm
    , initcap(nml.invoice_status::varchar(200))                                                     as invoice_status
    , nml.is_intra_period_invoice::int
        as is_intra_period_invoice
    , nml.account_number::varchar(200)                                                              as account_number
    , nml.account_number_formatted::varchar(200)
        as account_number_formatted
    , nml.billing_account_number::varchar(200)                                                      as billing_account_number
    , nml.account_id_pms::varchar(200)                                                              as account_id_pms
    , nml.registrant_name::varchar(200)                                                             as registrant_name
    , nml.account_name::varchar(200)                                                                as account_name
    , nml.type_of_account::varchar(200)                                                             as type_of_account
    , nml.client_id_pms::varchar(200)                                                               as client_id_pms
    , nml.aum_classification_status::varchar(200)
        as aum_classification_status
    , nml.model_investment_strategy::varchar(200)
        as model_investment_strategy
    , nml.custodian::varchar(200)                                                                   as custodian
    , nml.billing_custodian::varchar(200)                                                           as billing_custodian
    , nml.partner_firm::varchar(200)                                                                as partner_firm
    , nml.partner_firm_original::varchar(200)                                                       as partner_firm_original

    -- [advisor]
    , nml.client_manager_source::varchar(200)                                                       as client_manager_source
    , nml.client_manager_original_crm::varchar(200)
        as client_manager_original_crm
    , nml.client_manager_primary::varchar(200)                                                      as client_manager_primary
    , nml.client_manager_type::varchar(200)                                                         as client_manager_type
    , nml.associate_id::varchar(200)                                                                as associate_id

    -- [assets and fees]
    , initcap(nml.fee_type::varchar(200))                                                           as fee_type
    , initcap(nml.fee_schedule_source::varchar(200))                                                as fee_schedule_source
    , initcap(nml.fee_schedule_type::varchar(200))                                                  as fee_schedule_type
    , initcap(nml.fee_schedule::varchar(200))                                                       as fee_schedule
    , nml.assets_as_of_date::date                                                                   as assets_as_of_date
    , nml.fee_calculation_date::date                                                                as fee_calculation_date
    , case
        when lower(nml.billing_frequency_source) ilike 'Monthly'
            then nml.effective_fee_rate * 12
        when lower(nml.billing_frequency_source) ilike 'Quarterly'
            then nml.effective_fee_rate * 4
        when nml.billing_frequency_source is null
            then nml.effective_fee_rate
    end::number(20 , 5)                                                                             as effective_fee_rate
    , nml.total_account_value::number(20 , 5)                                                       as total_account_value
    , nml.billable_value::number(20 , 5)                                                            as billable_value
    , nml.fee_excluded_assets::number(20 , 5)                                                       as fee_excluded_assets
    , nml.client_fee_gross::number(20 , 5)                                                          as client_fee_gross
    , nml.client_fee_rebates::number(20 , 5)                                                        as client_fee_rebates
    , nml.client_net_contribution_fee::number(20 , 5)
        as client_net_contribution_fee
    , nml.client_adjustments_fee::number(20 , 5)                                                    as client_adjustments_fee
    , nml.client_write_off_fee::number(20 , 5)                                                      as client_write_off_fee
    , nml.client_fee_net::number(20 , 5)                                                            as client_fee_net
    , nml.collection_date::date                                                                     as collection_date
    , coalesce(nml.third_party_calculation::boolean , false)
        as third_party_calculation

    -- [billing terms and payment]
    , initcap(nml.billing_style::varchar(200))                                                      as billing_style
    , initcap(nml.billing_frequency::varchar(200))                                                  as billing_frequency
    , initcap(nml.billing_method::varchar(200))                                                     as billing_method
    , initcap(nml.bill_on_balance_type::varchar(200))                                               as bill_on_balance_type
    , initcap(nml.payment_terms::varchar(200))                                                      as payment_terms
    , initcap(nml.payment_method_fee::number(20 , 5))                                               as payment_method_fee

    -- [accounting]
    , lower(nml.account_class::varchar(200))                                                        as account_class
    , coalesce(nml.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean               as recurring_revenue
    , coalesce(nml.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean
        as impacted_by_financial_markets
    , coalesce(
        nml.coa_segment_1_legal_entity_id
        , ass_coa.seg_1)::varchar(200)
        as coa_segment_1_legal_entity_id
    , '000'::varchar(200)
        as coa_segment_2_product_id
    , coalesce(
        nml.coa_segment_3_accounting_id
        , case
            when ass.advisor_nonadvisor ilike 'Advisor'
                then ass_coa.seg_3
            else loc_cli.accounting_id
        end
    )::varchar(200)                                                                                 as coa_segment_3_accounting_id
    , ass_coa.seg_4::varchar(200)                                                                   as coa_segment_4_team_id
    , coalesce(nml.coa_segment_5_natural_account_id , null)::varchar(200)
        as coa_segment_5_natural_account_id
    , '000'::varchar(200)
        as coa_segment_6_initiative_id
    , '000'::varchar(200)
        as coa_segment_7_intercompany_id
    , '000'::varchar(200)
        as coa_segment_8_future_id
    , concat(
        coa_segment_1_legal_entity_id
        , '-' , coa_segment_2_product_id
        , '-' , coa_segment_3_accounting_id
        , '-' , coa_segment_4_team_id
        , '-' , coa_segment_5_natural_account_id
        , '-' , coa_segment_6_initiative_id
        , '-' , coa_segment_7_intercompany_id
        , '-' , coa_segment_8_future_id
    )                                                                                               as coa_account_number
    , coalesce(
        nml.revenue_category
        , ovrd_fee_type.revenue_category
    )::varchar(200
    )                                                                                               as revenue_category
    , initcap(nml.revenue_type::varchar(200))                                                       as revenue_type

    -- [crm]
    , nml.system_name_crm::varchar(200)                                                             as system_name_crm
    , nml.system_instance_crm::varchar(200)                                                         as system_instance_crm
    , nml.system_key_crm::varchar(200)                                                              as system_key_crm
    , nml.account_id_crm::varchar(200)                                                              as account_id_crm
    , nml.client_id_crm::varchar(200)                                                               as client_id_crm
    , nml.client_id_original_crm::varchar(200)                                                      as client_id_original_crm
    , nml.client_id_unique_compass::varchar(200)
        as client_id_unique_compass
    , nml.client_name::varchar(200)                                                                 as client_name
    , nml.client_name_original_crm::varchar(200)
        as client_name_original_crm
    , initcap(nml.client_lead_source::varchar(200))                                                 as client_lead_source
    , initcap(nml.client_key_tags_crm::varchar(5000))                                               as client_key_tags_crm

    -- [transactions]
    , initcap(nml.transaction_type::varchar(200))                                                   as transaction_type
    , initcap(nml.transaction_line_type::varchar(200))                                              as transaction_line_type
    , nml.transaction_line_quantity::number(20 , 5)
        as transaction_line_quantity
    , nml.currency_code::varchar(200)                                                               as currency_code
    , nml.currency_conversion_type::varchar(200)
        as currency_conversion_type
    , nml.unit_selling_price::number(20 , 5)                                                        as unit_selling_price

    -- [exclusion]
    , nml.is_excluded::int                                                                          as is_excluded
    , initcap(nml.excluded_reason::varchar(200))                                                    as excluded_reason

    -- [referential]
    , (
        nml.system_key::varchar(50)
        || ' | ' || nml.revenue_period::varchar(10)
        || ' | ' || coalesce(nml._trans_key::varchar(100) , nml.invoice_number_source::varchar(100))
    )::varchar(200)                                                                                 as _invoice_key
    , nml._created_at::datetime                                                                     as _created_at
    , nml._source_file::varchar(200)                                                                as _source_file
    , nml._box_file_id::varchar(200)                                                                as _box_file_id
    , nml._extra_fields::variant                                                                    as _extra_fields

from
    cte_normalize as nml
left join {{ ref('bld_associates') }} as ass
    on nml.associate_id = ass.employee_num
    and (ass.effective_at::date) = coalesce(nml.invoice_date , nml.revenue_period)

left join {{ source('reporting_ext', 'associate_revenue_coding') }} as ass_coa
    on (
        nml.associate_id = ass_coa.associate_id_adp
        or nml.associate_id = ass_coa.associate_id_oracle
    )
    and nml.invoice_date between coalesce(ass_coa.start_date , '1999-01-01')
    and coalesce(ass_coa.end_date , '2099-12-31')
    and ass_coa.is_latest = 1
-- Joins to 'edw locations' on 'accounting id, segment 3', obtains advisor location
left join {{ ref('locations') }} as loc_adv
    on coalesce(nml.coa_segment_3_accounting_id , ass_coa.seg_3) = loc_adv.accounting_id
    and nml.invoice_date between loc_adv.start_date and coalesce(loc_adv.end_date , '2099-12-31')
-- Joins to 'edw locations' on 'client location', used to obtain client location accounting id segment when non-advisor
left join {{ ref('locations') }} as loc_cli
    on nml.client_location_code = loc_cli.location_code
    and nml.invoice_date between loc_cli.start_date and coalesce(loc_cli.end_date , '2099-12-31')
left join {{ ref('aux__stg_financials_fee_type') }} as ovrd_fee_type
    on nml.system_key = ovrd_fee_type.system_key
    and lower(nml.fee_type) = lower(ovrd_fee_type.fee_type)
where true
order by
    system_key
    , revenue_period_end_date
    , _invoice_key
