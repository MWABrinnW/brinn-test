with cte_loc_adv as (
    select
        accounting_id
        , location_code
        , office_name
        , start_date
        , row_number() over (
            partition by accounting_id
            order by start_date desc
        ) as rn
    from {{ ref('locations') }}
    qualify rn = 1
)

-- returns accounting id (segment 3) for the advisor; otherwise from the client location
, cte_coa_seg_3 as (
    select
        *
        , coalesce(
            coa_segment_3_accounting_id
            , case
                when advisor_nonadvisor ilike 'Advisor' and associate_coa_segment_3 is not null
                    then associate_coa_segment_3
                else client_location_accounting_id
            end
        )::text(200) as _coa_segment_3_accounting_id
    from {{ ref('int_billing_wealth_01_union') }}
)

select
    -- [system attributes]
    nml.system_name::text                                                             as system_name
    , nml.system_instance::text                                                       as system_instance
    , nml.system_key::text                                                            as system_key
    , nml.firm_source::text                                                           as firm_source

    -- [location]
    , case
        when nml.advisor_nonadvisor ilike 'Advisor'
            then loc_adv.location_code
        else nml.client_location_code
    end::text                                                                         as location_code
    , case
        when nml.advisor_nonadvisor ilike 'Advisor'
            then loc_adv.office_name
        else nml.client_office_name
    end::text                                                                         as office_name
    , nml.client_location_code::text                                                  as client_location_code
    , nml.client_office_name::text                                                    as client_office_name

    -- [financial dates]
    , nml.invoice_created_at::datetime                                                as invoice_created_at
    , nml.invoice_date::date                                                          as invoice_date
    , nml.revenue_period_end_date::date                                               as revenue_period_end_date
    , dateadd(
        day
        , -1
        , dateadd('Quarter' , 1 , date_trunc('Quarter' , nml.revenue_period_end_date))
    )::date                                                                           as revenue_quarter_end_date

    -- [invoice]
    , nml.invoice_number_source::text                                                 as invoice_number_source
    , nml.billing_statement_id_source::text                                           as billing_statement_id_source
    , nml.billing_statement_id_crm::text                                              as billing_statement_id_crm
    , initcap(nml.invoice_status::text)                                               as invoice_status
    , nml.is_intra_period_invoice::int                                                as is_intra_period_invoice
    , nml.account_number::text                                                        as account_number
    , nml.account_number_formatted::text                                              as account_number_formatted
    , nml.billing_account_number::text                                                as billing_account_number
    , nml.account_id_pms::text                                                        as account_id_pms
    , nml.registrant_name::text                                                       as registrant_name
    , nml.account_name::text                                                          as account_name
    , nml.type_of_account::text                                                       as type_of_account
    , nml.client_id_pms::text                                                         as client_id_pms
    , nml.aum_classification_status::text                                             as aum_classification_status
    , nml.model_investment_strategy::text                                             as model_investment_strategy
    , nml.model_grouping_assignment::text                                             as model_grouping_assignment
    , nml.custodian::text                                                             as custodian
    , nml.billing_custodian::text                                                     as billing_custodian
    , nml.partner_firm::text                                                          as partner_firm
    , nml.partner_firm_original::text                                                 as partner_firm_original

    -- [advisor]
    , nml.advisor_source::text                                                        as advisor_source
    , nml.advisor_original::text                                                      as advisor_original
    , nml.associate_id_original::text                                                 as associate_id_original
    , nml.advisor_primary::text                                                       as advisor_primary
    , nml.associate_id_primary::text                                                  as associate_id_primary
    , nml.advisor_type::text                                                          as advisor_type
    , coalesce(advisor_original , advisor_primary)::text                              as advisor
    , coalesce(associate_id_original , associate_id_primary)::text                    as associate_id

    -- [assets and fees]
    , initcap(nml.fee_type::text)                                                     as fee_type
    , initcap(nml.fee_schedule_source::text)                                          as fee_schedule_source
    , initcap(nml.fee_schedule_type::text)                                            as fee_schedule_type
    , initcap(nml.fee_schedule::text)                                                 as fee_schedule
    , nml.assets_as_of_date::date                                                     as assets_as_of_date
    , nml.fee_calculation_date::date                                                  as fee_calculation_date
    , case
        when lower(nml.billing_frequency) ilike 'Monthly'
            then nml.effective_fee_rate * 12
        when lower(nml.billing_frequency) ilike 'Quarterly'
            then nml.effective_fee_rate * 4
        when nml.billing_frequency is null
            then nml.effective_fee_rate
    end::number(18 , 5)                                                               as effective_fee_rate
    , nml.total_account_value::number(18 , 5)                                         as total_account_value
    , nml.billable_value::number(18 , 5)                                              as billable_value
    , nml.fee_excluded_assets::number(18 , 5)                                         as fee_excluded_assets
    , nml.client_fee_gross::number(18 , 5)                                            as client_fee_gross
    , nml.client_fee_rebates::number(18 , 5)                                          as client_fee_rebates
    , nml.client_net_contribution_fee::number(18 , 5)                                 as client_net_contribution_fee
    , nml.client_adjustments_fee::number(18 , 5)                                      as client_adjustments_fee
    , nml.client_write_off_fee::number(18 , 5)                                        as client_write_off_fee
    , nml.client_fee_net::number(18 , 5)                                              as client_fee_net
    , nml.referral_fee::number(18 , 2)                                                as referral_fee
    , nml.collection_date::date                                                       as collection_date
    , coalesce(nml.third_party_calculation::boolean , false)                          as third_party_calculation

    -- [billing terms and payment]
    , initcap(nml.billing_style::text)                                                as billing_style
    , initcap(nml.billing_frequency::text)                                            as billing_frequency
    , initcap(nml.billing_method::text)                                               as billing_method
    , initcap(nml.bill_on_balance_type::text)                                         as bill_on_balance_type
    , initcap(nml.payment_terms::text)                                                as payment_terms
    , nml.payment_method_fee::number(18 , 5)                                          as payment_method_fee

    -- [accounting]
    , lower(nml.account_class::text)                                                  as account_class
    , coalesce(nml.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean as recurring_revenue
    , coalesce(nml.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean as impacted_by_financial_markets
    , coalesce(
        nml.coa_segment_1_legal_entity_id , nml.associate_coa_segment_1
    )::text                                                                           as coa_segment_1_legal_entity_id
    , '000'::text                                                                     as coa_segment_2_product_id
    , nml._coa_segment_3_accounting_id::text                                          as coa_segment_3_accounting_id
    , nml.associate_coa_segment_4::text                                               as coa_segment_4_team_id
    , coalesce(nml.coa_segment_5_natural_account_id , null)::text                     as coa_segment_5_natural_account_id
    , '000'::text                                                                     as coa_segment_6_initiative_id
    , '000'::text                                                                     as coa_segment_7_intercompany_id
    , '000'::text                                                                     as coa_segment_8_future_id
    , concat_ws(
        '-'
        , coa_segment_1_legal_entity_id
        , coa_segment_2_product_id
        , coa_segment_3_accounting_id
        , coa_segment_4_team_id
        , coa_segment_5_natural_account_id
        , coa_segment_6_initiative_id
        , coa_segment_7_intercompany_id
        , coa_segment_8_future_id
    )                                                                                 as coa_account_number
    , nml.revenue_category::text                                                      as revenue_category
    , initcap(nml.revenue_type::text)                                                 as revenue_type

    -- [crm]
    , nml.system_name_crm::text                                                       as system_name_crm
    , nml.system_instance_crm::text                                                   as system_instance_crm
    , nml.system_key_crm::text                                                        as system_key_crm
    , nml.account_id_crm::text                                                        as account_id_crm
    , nml.client_id_crm::text                                                         as client_id_crm
    , nml.client_id_original_crm::text                                                as client_id_original_crm
    , nml.client_id_unique_compass::text                                              as client_id_unique_compass
    , nml.client_name::text                                                           as client_name
    , nml.client_name_original_crm::text                                              as client_name_original_crm
    , initcap(nml.client_lead_source::text)                                           as client_lead_source
    , initcap(nml.client_key_tags_crm::text)                                          as client_key_tags_crm

    -- [transactions]
    , initcap(nml.transaction_type::text)                                             as transaction_type
    , initcap(nml.transaction_line_type::text)                                        as transaction_line_type
    , nml.transaction_line_quantity::int                                              as transaction_line_quantity
    , nml.currency_code::text                                                         as currency_code
    , nml.currency_conversion_type::text                                              as currency_conversion_type
    , nml.unit_selling_price::number(18 , 5)                                          as unit_selling_price

    -- [exclusion]
    , nml.excluded_reasons::text                                                      as excluded_reasons
    , nml.is_excluded::int                                                            as is_excluded

    -- [referential]
    , (
        nml.system_key::text(50)
        || ' | ' || nml.revenue_period_end_date::text(10)
        || ' | ' || coalesce(nml._trans_key::text(100) , nml.invoice_number_source::text(100))
    )::text                                                                           as _invoice_key
    , nml._source_loaded_at::datetime                                                 as _source_loaded_at
    , nml._source_file::text                                                          as _source_file
    , nml._box_file_id::text                                                          as _box_file_id
    , nml._extra_fields::variant                                                      as _extra_fields

from
    cte_coa_seg_3 as nml
-- Joins to 'edw locations' on 'accounting id, segment 3', obtains advisor location
left join cte_loc_adv as loc_adv
    on nml._coa_segment_3_accounting_id = loc_adv.accounting_id
order by
    system_key
    , revenue_period_end_date
    , _invoice_key
