with revenue_qtr_end_date as (
    select
        bb.account_number
        , bb.fee_effective_date
        , bb.transaction_type
        , dt.date_key
        , dt.quarter_end_date
        , dt.prior_quarter_end_date
        , dt.prior_quarter_yyyyqx
        , case
            when bb.transaction_type = 'Periodic Fee'
                then
                    dt.prior_quarter_end_date
            else
                bb.fee_effective_date
        end
            as sf_join_date
    from {{ ref('sei_manasquan__base_bills') }} as bb
    left join {{ ref('dates') }} as dt
        on bb.fee_effective_date = dt.date_key
    group by all
)
,
compass_data_all as (
    select
        ei.system_name                                     as system_name
        , ei.system_instance                               as system_instance
        , ei.system_key                                    as system_key
        , ei.id                                            as estate_item_id
        , ei.identifier_c                                  as dirty_account_number
        , replace(ltrim(ei.identifier_c , '0') , '-' , '') as identifier--noqa: RF04
        , ei.current_value_c                               as current_value
        , hh.id                                            as hh_id
        , hh.name                                          as hh_name
        , hh.unique_identifier_c                           as compass_id
        , ei.aum_classification_c                          as aum_ident
        , date(ei.effective_at)                            as eff_date_estate_item
        , md.name                                          as mi_strategy
        , fs.name                                          as fee_schedule_fs
        , ur.id                                            as cm_id
        , ur.name                                          as associate_name
        , ur.employee_number                               as employee_number
        , hh.lead_source_c                                 as lead_source
        , ei._created_at
        , ei.is_latest
    from {{ ref('salesforce_compass__base_estate_item_c') }} as ei
    left join {{ ref('salesforce_compass__base_account') }} as hh
        on ei.household_c = hh.id
        and date(ei.effective_at) = date(hh.effective_at)

    left join {{ ref('salesforce_compass__base_user') }} as ur
        on hh.owner_id = ur.id
        and ur.is_latest = 1

    left join {{ ref('salesforce_compass__base_model_c') }} as md
        on ei.model_on_account_c = md.id

    left join revenue_qtr_end_date as rq_1
        on date(ei.effective_at) = rq_1.sf_join_date
        and ei.identifier_c = rq_1.account_number

    left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
        on date(ei.effective_at) = date(fs.effective_at)
        and ei.fee_schedule_c = fs.id

    where ei.is_deleted = false
        and date(ei.effective_at) = rq_1.sf_join_date
        and ei.is_latest = 1
    group by all
)

select
-- [system attributes]
    ac.system_name::varchar(200)                                       as system_name
    , ac.system_instance::varchar(200)                                 as system_instance
    , ac.system_key::varchar(200)                                      as system_key

    -- [location]
    , null::varchar(200)                                               as client_location_code

    -- [financial dates]
    , null::timestamp_ntz                                              as invoice_created_at
    , ac.fee_effective_date::date                                      as invoice_date

    -- [invoice]
    , ac.transaction_identifier::varchar(200)                          as invoice_number_source
    , null::varchar(200)                                               as billing_statement_id_source
    , null::varchar(200)                                               as billing_statement_id_crm
    , null::varchar(200)                                               as invoice_status
    , 0::int                                                           as is_mid_cycle_invoice
    , replace(ltrim(ac.account_number , '0') , '-' , '')::varchar(200) as account_number
    , ac.account_number::varchar(200)                                  as account_number_formatted
    , ac.account_number::varchar(200)                                  as billing_account_number
    , null::varchar(200)                                               as account_id_pms
    , ac.account_display_name::varchar(200)                            as registrant_name
    , ac.account_display_name::varchar(200)                            as account_name
    , null::varchar(200)                                               as type_of_account
    , null::varchar(200)                                               as client_id_pms
    , cd.aum_ident::varchar(200)                                       as aum_classification_status
    , cd.mi_strategy::varchar(200)                                     as model_investment_strategy
    , 'SEI'::varchar(200)                                              as custodian
    , null::varchar(200)                                               as billing_custodian
    , null::varchar(200)                                               as partner_firm
    , null::varchar(200)                                               as partner_firm_original

    -- [advisor]
    , cd.associate_name::varchar(200)                                  as client_manager_source
    , cd.associate_name::varchar(200)                                  as client_manager_original_crm
    , cd.associate_name::varchar(200)                                  as client_manager_primary
    , 'W-2'::varchar(200)                                              as client_manager_type
    , cd.employee_number::varchar(200)                                 as associate_id

    -- [assets and fees]
    , 'Quarterly Fee'::varchar(200)                                    as fee_type
    , cd.fee_schedule_fs::varchar(200)                                 as fee_schedule_source
    , null::varchar(200)                                               as fee_schedule_type
    , null::varchar(200)                                               as fee_schedule
    , rq.sf_join_date::varchar(200)                                    as assets_as_of_date
    , rq.sf_join_date::varchar(200)                                    as fee_calculation_date
    , null::decimal(20 , 5)                                            as effective_fee_rate
    , cd.current_value::decimal(20 , 5)                                as total_account_value
    , cd.current_value::decimal(20 , 5)                                as billable_value
    , null::number(20 , 5)                                             as fee_excluded_assets
    , (ac.fees_collected)::decimal(20 , 5)                             as client_fee_gross
    , null::decimal(20 , 5)                                            as client_fee_rebates
    , null::decimal(20 , 5)                                            as client_net_contribution_fee
    , null::decimal(20 , 5)                                            as client_adjustments_fee
    , null::decimal(20 , 5)                                            as client_write_off_fee
    , (ac.fees_collected)::decimal(20 , 5)                             as client_fee_net
    , null::date                                                       as collection_date
    , null::boolean                                                    as third_party_calculation

    -- [billing terms and payment]
    , 'Arrears'::varchar(200)                                          as billing_style
    , 'Quarterly'::varchar(200)                                        as billing_frequency_source
    , null::varchar(200)                                               as billing_method
    , null::varchar(200)                                               as bill_on_balance_type
    , null::varchar(200)                                               as payment_terms
    , null::varchar(200)                                               as payment_method_fee

    -- [accounting]
    , 'REV'                                                            as account_class
    , null::varchar(200)                                               as coa_segment_3_accounting_id
    , null::varchar(200)                                               as coa_segment_5_natural_account_id
    , 'Wealth Management'::varchar(200)                                as revenue_type

    -- [crm]
    , cd.system_name::varchar(200)                                     as system_name_crm
    , cd.system_instance::varchar(200)                                 as system_instance_crm
    , cd.system_key::varchar(200)                                      as system_key_crm
    , cd.estate_item_id::varchar(200)                                  as account_id_crm
    , cd.hh_id::varchar(200)                                           as client_id_crm
    , cd.hh_id::varchar(200)                                           as client_id_original_crm
    , null::varchar(200)                                               as client_id_unique_compass
    , cd.hh_name::varchar(200)                                         as client_name
    , cd.hh_name::varchar(200)                                         as client_name_original_crm
    , cd.lead_source::varchar(200)                                     as client_lead_source
    , null::varchar(200)                                               as client_key_tags_crm


    -- [transactions]
    , null::varchar(200)                                               as transaction_type
    , null::varchar(200)                                               as transaction_line_type
    , 1::int                                                           as transaction_line_quantity
    , 'USD'::varchar(200)                                              as currency_code
    , 'User'::varchar(200)                                             as currency_conversion_type
    , 1::number(20 , 5)                                                as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, default to 0
    , 0::int                                                           as is_excluded
    , null::varchar(200)                                               as excluded_reason

    -- [referential]
    , ac.system_key
    || '|' || ac.transaction_date::date
    || '|' || 'invoice_number_source'::varchar(200)                    as _invoice_key
    , ac._created_at::timestamp_ntz(9)                                 as _created_at
    , ac._box_file_name::varchar(200)                                  as _source_file
    , ac._box_file_id::varchar(200)                                    as _box_file_id


    -- [extra fields]
    , null::variant                                                    as _extra_fields

--,rq.quarter_end_date  AS  INVOICE_QUARTER
--,rq.prior_quarter_end_date AS REVENUE_QUARTER
--,rq.prior_quarter_yyyyqx AS REVENUE_QUARTER_FORMATTED
--,'Quarterly Fee' as REVENUE_LINE_DESCRIPTION
--,cd.ASSOCIATE_NAME as CLIENT_MANAGER
--,(ac.fees_collected * -1) as FEE_AMOUNT_COLLECTED
--,ac.settlement_date as COLLECTION_DATE
--,cd.HH_ID as CLIENT_ID_ORIGINAL_COMPASS
--,1 as RECURRING_REVENUE


--Envestnet billing data
from {{ ref('sei_manasquan__base_bills') }} as ac

left join revenue_qtr_end_date as rq
    on ac.fee_effective_date = rq.date_key
    and ac.account_number = rq.account_number


left join compass_data_all as cd
    on rq.account_number = cd.dirty_account_number
    and rq.prior_quarter_end_date = cd.eff_date_estate_item
