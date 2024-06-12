with revenue_qtr_end_date as (
    select
        bb._id                       as ref_id_1
        , bb.date
        , bb.comments
        , bb.account                 as account_rq
        , dts.date_key               as date_key
        , dts.quarter_end_date       as quarter_end_date
        , dts.prior_quarter_end_date as prior_quarter_end_date
        , dts.prior_quarter_yyyyqx   as prior_quarter
        , case
            when left(bb.comments , 1) = 'Q' and right(bb.comments , 4) = 'Fees'
                then
                    dts.prior_quarter_end_date
            else
                dts.quarter_end_date
        end
            as sf_join_date
    from {{ ref('axys_granite_history__base_bills') }} as bb
    left join edw.ref.dates as dts
        on bb.date = dts.date_key
)

, compass_data_all as (
    select
        rq_2.ref_id_1                                      as ref_id_2
        , ei.id                                            as estate_item_id
        , ei.identifier_c                                  as dirty_account_number
        , replace(ltrim(ei.identifier_c , '0') , '-' , '') as identifier--noqa: RF04
        , ei.current_value_c                               as current_value
        , ei.account_type_c                                as typeofaccount
        , hh.id                                            as hh_id
        , hh.name                                          as hh_name
        , cc.name                                          as custodian
        , hh.unique_identifier_c                           as compass_id
        , ei.aum_classification_c                          as aum_ident
        , date(ei.effective_at)                            as eff_date_estate_item
        , md.name                                          as mi_strategy
        , fs.name                                          as fee_schedule_fs
        , ur.id                                            as cm_id
        , ur.name                                          as associate_name
        , ur.employee_number                               as employee_number
        , hh.lead_source_c                                 as lead_source
        , rq_2.quarter_end_date                            as rq_quarter_end_date
        , rq_2.sf_join_date                                as rq_sf_join_date
        , ei.custodian_c
        , ei._created_at
        , ei.is_latest                                     as latest
    from {{ ref('salesforce_compass__base_estate_item_c') }} as ei

    left join revenue_qtr_end_date as rq_2
        on ei.identifier_c = rq_2.account_rq
        and date(ei.effective_at) = rq_2.sf_join_date

    left join {{ ref('salesforce_compass__base_account') }} as hh
        on ei.household_c = hh.id
        and date(ei.effective_at) = date(hh.effective_at)


    left join {{ ref('salesforce_compass__base_user') }} as ur
        on hh.owner_id = ur.id
        and ur.is_latest = 1

    left join {{ ref('salesforce_compass__base_model_c') }} as md
        on ei.model_on_account_c = md.id


    left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
        on date(ei.effective_at) = date(fs.effective_at)
        and ei.fee_schedule_c = fs.id

    left join {{ ref('salesforce_compass__base_custodian_c') }} as cc
        on ei.custodian_c = cc.id

    where ei.is_deleted = false
        and date(ei.effective_at) = rq_2.sf_join_date
        and ei.is_latest = 1
    group by all
)

select

-- [system attributes]
    b.system_name::varchar(200)                                as system_name
    , b.system_instance::varchar(200)                          as system_instance
    , b.system_key::varchar(200)                               as system_key

    -- [location]
    , null::varchar(200)                                       as client_location_code

    -- [financial dates]
    , null::timestamp_ntz                                      as invoice_created_at
    , b.date::date                                             as invoice_date

    -- [invoice]
    , null::varchar(200)                                       as invoice_number_source
    , null::varchar(200)                                       as billing_statement_id_source
    , null::varchar(200)                                       as billing_statement_id_crm
    , null::varchar(200)                                       as invoice_status
    , 0::int                                                   as is_mid_cycle_invoice
    , replace(ltrim(b.account , '0') , '-' , '')::varchar(200) as account_number
    , b.account::varchar(200)                                  as account_number_formatted
    , b.account::varchar(200)                                  as billing_account_number
    , a.portfoliocode::varchar(200)                            as account_id_pms
    , a.acctname::varchar(200)                                 as registrant_name
    , a.acctname::varchar(200)                                 as account_name
    , c.typeofaccount::varchar(200)                            as type_of_account
    , null::varchar(200)                                       as client_id_pms
    , c.aum_ident::varchar(200)                                as aum_classification_status
    , coalesce(c.mi_strategy , a.goal)::varchar(200)           as model_investment_strategy
    , c.custodian::varchar(200)                                as custodian
    , null::varchar(200)                                       as billing_custodian
    , null::varchar(200)                                       as partner_firm
    , null::varchar(200)                                       as partner_firm_original

    -- [advisor]
    , c.associate_name::varchar(200)                           as client_manager_source
    , c.associate_name::varchar(200)                           as client_manager_original_crm
    , null::varchar(200)                                       as client_manager_primary
    , 'W-2'::varchar(200)                                      as client_manager_type
    , c.employee_number::varchar(200)                          as associate_id

    -- [assets and fees]
    , b.comments::varchar(200)                                 as fee_type
    , c.fee_schedule_fs::varchar(200)                          as fee_schedule_source
    , null::varchar(200)                                       as fee_schedule_type
    , null::varchar(200)                                       as fee_schedule
    , c.rq_sf_join_date                                        as assets_as_of_date
    , null::date                                               as fee_calculation_date
    , null::decimal(20 , 5)                                    as effective_fee_rate
    , c.current_value::decimal(20 , 5)                         as total_account_value
    , c.current_value::decimal(20 , 5)                         as billable_value
    , (c.current_value - c.current_value)::decimal(20 , 5)     as fee_excluded_assets
    , b.amount::decimal(20 , 5)                                as client_fee_gross
    , null::decimal(20 , 5)                                    as client_fee_rebates
    , null::decimal(20 , 5)                                    as client_net_contribution_fee
    , null::decimal(20 , 5)                                    as client_adjustments_fee
    , null::decimal(20 , 5)                                    as client_write_off_fee
    , b.amount::decimal(20 , 5)                                as client_fee_net
    , null::date                                               as collection_date
    , null::boolean                                            as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::varchar(200)                                  as billing_style
    , 'Quarterly'::varchar(200)                                as billing_frequency_source
    , b.tran                                                   as billing_method
    , null::varchar(200)                                       as bill_on_balance_type
    , null::varchar(200)                                       as payment_terms
    , case
        when b.tran = 'dp'
            then
                0
    end::decimal(20 , 5)                                       as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                      as account_class
    , null::varchar(200)                                       as coa_segment_3_accounting_id
    , null::varchar(200)                                       as coa_segment_5_natural_account_id
    , 'Wealth Management'::varchar(200)                        as revenue_type

    -- [crm]
    , null::varchar(200)                                       as system_name_crm
    , null::varchar(200)                                       as system_instance_crm
    , null::varchar(200)                                       as system_key_crm
    , c.estate_item_id::varchar(200)                           as account_id_crm
    , c.hh_id::varchar(200)                                    as client_id_crm
    , c.hh_id::varchar(200)                                    as client_id_original_crm
    , c.compass_id::varchar(200)                               as client_unique_id_compass
    , c.hh_name::varchar(200)                                  as client_name
    , c.hh_name::varchar(200)                                  as client_name_original_compass
    , c.lead_source::varchar(200)                              as client_lead_source
    , null::varchar(200)                                       as client_key_tags_crm


    -- [transactions]
    , null::varchar(200)                                       as transaction_type
    , 'Line'::varchar(200)                                     as transaction_line_type
    , 1::int                                                   as transaction_line_quantity
    , 'USD'::varchar(200)                                      as currency_code
    , 'User'::varchar(200)                                     as currency_conversion_type
    , 1::decimal(20 , 5)                                       as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, default to 0
    , 0::int                                                   as is_excluded
    , null::varchar(200)                                       as excluded_reason

    -- [referential]
    , b.system_key
    || '|' || b.date
    || '|' || 'INVOICE_NUMBER'::varchar(200)                   as _invoice_key
    , b._created_at::timestamp_ntz(9)                          as _created_at
    , b._box_file_name::varchar(200)                           as _source_file
    , null::varchar(200)                                       as _box_file_id

    -- These are fields that are likely specific to this source
    -- and are intended to help with one off investigations or
    -- special analysis.
    , null::variant                                            as _extra_fields

from {{ ref('axys_granite_history__base_bills') }} as b

--account level data
left join {{ ref('axys_granite_history__base_accounts') }} as a
    on b.portfolio = a.portfoliocode
    and a.is_head = 1
--AND b.date = a.reportdate

-- LEFT JOIN revenue_qtr_end_date rq
--     ON b.date=rq.DATE_KEY
--     AND b.account=rq.ACCOUNT_RQ

--Household data
left join compass_data_all as c
    on b.account = c.dirty_account_number
    -- and b.DATE= c.RQ_SF_JOIN_DATE
    and b._id = c.ref_id_2
