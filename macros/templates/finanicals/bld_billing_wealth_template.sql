{%- macro build_billing_wealth_template(src_models, nml_models) -%}
, locations as (
    select
        accounting_id       as accounting_id
        , location_code     as location_code
        , office_name       as office_name
        , start_date        as start_date
        , row_number() over (
            partition by accounting_id
            order by start_date desc
        )                   as rn
    from {{ ref('locations') }}
    where 1 = 1
        and exists(select 1 from systems_to_refresh where is_stale = 1)
    qualify rn = 1
)

, associate_rev_coding as (
    select
        associate_id_adp            as associate_id_adp
        , associate_id_oracle       as associate_id_oracle
        , start_date                as start_date
        , end_date                  as end_date
        , seg_1                     as seg_1
        , seg_2                     as seg_2
        , seg_3                     as seg_3
        , seg_4                     as seg_4
        , seg_5                     as seg_5
        , seg_6                     as seg_6
        , seg_7                     as seg_7
        , seg_8                     as seg_8
        -- accounts for rare instances that an client manager has two records for the same period, differerent state values for tax requirements
        , row_number() over (
            partition by associate_id_adp , associate_id_oracle , start_date , end_date
            order by _id
        )                           as rn
    from {{ ref('bld_associate_revenue_coding') }}
    where 1 = 1
        and exists(select 1 from systems_to_refresh where is_stale = 1)
        and is_latest = 1
    qualify rn = 1
)

, data_to_build as (
    {%- for nml_model in nml_models %}
    select *
    from {{ ref(nml_model) }}
    where 1 = 1
        and exists(select 1 from systems_to_refresh where is_stale = 1)
        and system_key in (select distinct system_key from systems_to_refresh where is_stale = 1)

    {%- if not loop.last %}

    union all

    {%- endif %}
{%- endfor %}
)

, supplemented as (
    select
        -- [system attributes]
        a.system_name::text                                                             as system_name
        , a.system_instance::text                                                       as system_instance
        , a.system_key::text                                                            as system_key
        , a.firm_source::text                                                           as firm_source

        -- [location]
        , case
            when assoc.advisor_nonadvisor ilike 'Advisor'
                then loc_adv.location_code
            else a.client_location_code
        end::text                                                                       as location_code
        , case
            when assoc.advisor_nonadvisor ilike 'Advisor'
                then loc_adv.office_name
            else loc_client.office_name
        end::text                                                                       as office_name
        , a.client_location_code::text                                                  as client_location_code
        , loc_client.office_name::text                                                  as client_office_name

        -- [financial dates]
        , a.invoice_created_at::datetime                                                as invoice_created_at
        , a.invoice_date::date                                                          as invoice_date
        , a.revenue_period_end_date::date                                               as revenue_period_end_date
        , dateadd(
            day
            , -1
            , dateadd('Quarter' , 1 , date_trunc('Quarter' , a.revenue_period_end_date))
        )::date                                                                           as revenue_quarter_end_date

        -- [invoice]
        , a.invoice_number_source::text                                                 as invoice_number_source
        , a.billing_statement_id_source::text                                           as billing_statement_id_source
        , a.billing_statement_id_crm::text                                              as billing_statement_id_crm
        , initcap(a.invoice_status::text)                                               as invoice_status
        , a.is_intra_period_invoice::int                                                as is_intra_period_invoice
        , a.account_number::text                                                        as account_number
        , a.account_number_formatted::text                                              as account_number_formatted
        , a.billing_account_number::text                                                as billing_account_number
        , a.account_id_pms::text                                                        as account_id_pms
        , a.registrant_name::text                                                       as registrant_name
        , a.account_name::text                                                          as account_name
        , a.type_of_account::text                                                       as type_of_account
        , a.client_id_pms::text                                                         as client_id_pms
        , a.aum_classification_status::text                                             as aum_classification_status
        , a.model_investment_strategy::text                                             as model_investment_strategy
        , invst.model_grouping_assignment::text                                         as model_grouping_assignment
        , a.custodian::text                                                             as custodian
        , a.billing_custodian::text                                                     as billing_custodian
        , a.partner_firm::text                                                          as partner_firm
        , a.partner_firm_original::text                                                 as partner_firm_original

        -- [advisor]
        , a.advisor_source::text                                                        as advisor_source
        , a.advisor_original::text                                                      as advisor_original
        , a.associate_id_original::text                                                 as associate_id_original
        , a.advisor_primary::text                                                       as advisor_primary
        , a.associate_id_primary::text                                                  as associate_id_primary
        , a.advisor_type::text                                                          as advisor_type
        , coalesce(advisor_original , advisor_primary)::text                              as advisor
        , coalesce(associate_id_original , associate_id_primary)::text                    as associate_id

        -- [assets and fees]
        , initcap(a.fee_type::text)                                                     as fee_type
        , initcap(a.fee_schedule_source::text)                                          as fee_schedule_source
        , initcap(a.fee_schedule_type::text)                                            as fee_schedule_type
        , initcap(a.fee_schedule::text)                                                 as fee_schedule
        , a.assets_as_of_date::date                                                     as assets_as_of_date
        , a.fee_calculation_date::date                                                  as fee_calculation_date
        , case
            when lower(a.billing_frequency) ilike 'Monthly'
                then a.effective_fee_rate * 12
            when lower(a.billing_frequency) ilike 'Quarterly'
                then a.effective_fee_rate * 4
            when a.billing_frequency is null
                then a.effective_fee_rate
        end::number(18 , 5)                                                               as effective_fee_rate
        , a.total_account_value::number(18 , 5)                                         as total_account_value
        , a.billable_value::number(18 , 5)                                              as billable_value
        , a.fee_excluded_assets::number(18 , 5)                                         as fee_excluded_assets
        , a.client_fee_gross::number(18 , 5)                                            as client_fee_gross
        , a.client_fee_rebates::number(18 , 5)                                          as client_fee_rebates
        , a.client_net_contribution_fee::number(18 , 5)                                 as client_net_contribution_fee
        , a.client_adjustments_fee::number(18 , 5)                                      as client_adjustments_fee
        , a.client_write_off_fee::number(18 , 5)                                        as client_write_off_fee
        , a.client_fee_net::number(18 , 5)                                              as client_fee_net
        , a.referral_fee::number(18 , 2)                                                as referral_fee
        , a.collection_date::date                                                       as collection_date
        , coalesce(a.third_party_calculation::boolean , false)                          as third_party_calculation

        -- [billing terms and payment]
        , initcap(a.billing_style::text)                                                as billing_style
        , initcap(a.billing_frequency::text)                                            as billing_frequency
        , initcap(a.billing_method::text)                                               as billing_method
        , initcap(a.bill_on_balance_type::text)                                         as bill_on_balance_type
        , initcap(a.payment_terms::text)                                                as payment_terms
        , a.payment_method_fee::number(18 , 5)                                          as payment_method_fee

        -- [accounting]
        , lower(a.account_class::text)                                                  as account_class
        , coalesce(a.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean as recurring_revenue
        , coalesce(a.fee_type in ('Quarterly Fee' , 'Management fee') , false)::boolean as impacted_by_financial_markets
        , a.revenue_category::text                                                      as revenue_category
        , initcap(a.revenue_type::text)                                                 as revenue_type

        -- [crm]
        , a.system_name_crm::text                                                       as system_name_crm
        , a.system_instance_crm::text                                                   as system_instance_crm
        , a.system_key_crm::text                                                        as system_key_crm
        , a.account_id_crm::text                                                        as account_id_crm
        , a.client_id_crm::text                                                         as client_id_crm
        , a.client_id_original_crm::text                                                as client_id_original_crm
        , a.client_id_unique_compass::text                                              as client_id_unique_compass
        , a.client_name::text                                                           as client_name
        , a.client_name_original_crm::text                                              as client_name_original_crm
        , initcap(a.client_lead_source::text)                                           as client_lead_source
        , initcap(a.client_key_tags_crm::text)                                          as client_key_tags_crm

        -- [transactions]
        , initcap(a.transaction_type::text)                                             as transaction_type
        , initcap(a.transaction_line_type::text)                                        as transaction_line_type
        , a.transaction_line_quantity::int                                              as transaction_line_quantity
        , a.currency_code::text                                                         as currency_code
        , a.currency_conversion_type::text                                              as currency_conversion_type
        , a.unit_selling_price::number(18 , 5)                                          as unit_selling_price

        -- [exclusion]
        , a.excluded_reasons::text                                                      as excluded_reasons
        , a.is_excluded::int                                                            as is_excluded

        -- [referential]
        , (
            a.system_key::text(50)
            || ' | ' || a.revenue_period_end_date::text(10)
            || ' | ' || coalesce(a._trans_key::text , a.invoice_number_source::text)
        )::text                                                                           as _invoice_key
        , a._source_loaded_at::datetime                                                   as _source_loaded_at
        , a._source_file::text                                                            as _source_file
        , a._box_file_id::text                                                            as _box_file_id
        , a._extra_fields::variant                                                        as _extra_fields
        --==================================================
        -- 01_union
        , loc_client.accounting_id                                                        as client_location_accounting_id
        , assoc.advisor_nonadvisor                                                        as advisor_nonadvisor
        , coalesce(assoc_coding_adp.seg_1 , assoc_coding_oracle.seg_1)                    as associate_coa_segment_1
        , coalesce(assoc_coding_adp.seg_2 , assoc_coding_oracle.seg_2)                    as associate_coa_segment_2
        , coalesce(assoc_coding_adp.seg_3 , assoc_coding_oracle.seg_3)                    as associate_coa_segment_3
        , coalesce(assoc_coding_adp.seg_4 , assoc_coding_oracle.seg_4)                    as associate_coa_segment_4
        , coalesce(assoc_coding_adp.seg_5 , assoc_coding_oracle.seg_5)                    as associate_coa_segment_5
        , coalesce(assoc_coding_adp.seg_6 , assoc_coding_oracle.seg_6)                    as associate_coa_segment_6
        , coalesce(assoc_coding_adp.seg_7 , assoc_coding_oracle.seg_7)                    as associate_coa_segment_7
        , coalesce(assoc_coding_adp.seg_8 , assoc_coding_oracle.seg_8)                    as associate_coa_segment_8
        ------------------------------------------------

        , coalesce(
            a.coa_segment_1_legal_entity_id , associate_coa_segment_1
        )::text                                                                           as coa_segment_1_legal_entity_id
        , '000'::text                                                                     as coa_segment_2_product_id
        -----------------------------------------------------
        -- 02_coa
        , coalesce(
            a.coa_segment_3_accounting_id
            , case
                when assoc.advisor_nonadvisor ilike 'Advisor' and associate_coa_segment_3 is not null
                    then associate_coa_segment_3
                else client_location_accounting_id
            end
        )::text                                                                           as coa_segment_3_accounting_id
        -----------------------------------------------------
        , associate_coa_segment_4::text                                                   as coa_segment_4_team_id
        , a.coa_segment_5_natural_account_id                                              as coa_segment_5_natural_account_id
        , '000'::text                                                                     as coa_segment_6_initiative_id
        , '000'::text                                                                     as coa_segment_7_intercompany_id
        , '000'::text                                                                     as coa_segment_8_future_id
        , concat_ws(
            '-',
            coalesce(coa_segment_1_legal_entity_id, '000'),
            coalesce(coa_segment_2_product_id, '000'),
            coalesce(
                a.coa_segment_3_accounting_id,
                case
                    when assoc.advisor_nonadvisor ilike 'advisor' and associate_coa_segment_3 is not null
                        then associate_coa_segment_3
                    else client_location_accounting_id
                end,
                '0000'
            ),
            coalesce(coa_segment_4_team_id, '0000'),
            coalesce(a.coa_segment_5_natural_account_id, '00000'),
            coalesce(coa_segment_6_initiative_id, '000'),
            coalesce(coa_segment_7_intercompany_id, '000'),
            coalesce(coa_segment_8_future_id, '000')
            )                                                                             as coa_account_number
    from data_to_build a
    --------
    left join locations as loc_client
        on a.client_location_code = loc_client.location_code
    left join {{ ref('bld_associates') }} as assoc
        on coalesce(a.associate_id_original , a.associate_id_primary) = assoc.employee_num
        and a.fee_calculation_date = assoc.effective_at::date
    -- revenue coding associate ids from adp
    left join associate_rev_coding as assoc_coding_adp
        on coalesce(a.associate_id_original , a.associate_id_primary) = assoc_coding_adp.associate_id_adp
        and a.fee_calculation_date between coalesce(assoc_coding_adp.start_date , '1999-01-01')
        and coalesce(assoc_coding_adp.end_date , '2099-12-31')
    -- revenue coding associate ids from oracle
    left join associate_rev_coding as assoc_coding_oracle
        on coalesce(a.associate_id_original , a.associate_id_primary) = assoc_coding_oracle.associate_id_oracle
        and a.fee_calculation_date between coalesce(assoc_coding_oracle.start_date , '1999-01-01')
        and coalesce(assoc_coding_oracle.end_date , '2099-12-31')
    left join {{ ref('aux__int_model_master_monthly') }} as invst
        on a.model_investment_strategy = invst.model
    --------
    left join locations as loc_adv
        on coalesce(
            a.coa_segment_3_accounting_id
            , case
                when assoc.advisor_nonadvisor ilike 'Advisor' and associate_coa_segment_3 is not null
                    then associate_coa_segment_3
                else client_location_accounting_id
            end
        ) = loc_adv.accounting_id
    where 1 = 1
        and exists(select 1 from systems_to_refresh where is_stale = 1)
)

select
    *
    , current_timestamp()::timestamp_ntz as _created_at
from supplemented
where 1 = 1
    and exists(select 1 from systems_to_refresh where is_stale = 1)
order by revenue_period_end_date, system_key
{%- endmacro %}
