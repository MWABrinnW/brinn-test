with black_diamond_relationship as (
    select
        account_id
        , effective_date
        , listagg(distinct (relationship_id) , ',') as rel_id
    from {{ ref('black_diamond_uhnw__base_relationships') }}
    where true
        and effective_date in (select distinct cash_available_date from {{ ref('black_diamond_uhnw__base_bills') }})
    group by account_id , effective_date
)
,
saleforce_salentica as (
    select
        sfba.primary_advisor_c                     as advisor
        , sfba.fee_type_c                          as fee_schedule_type
        , sfba.system_key                          as system_key
        , sfs.salentica_lmnts_pms_account_number_c as salentica_pms_account_number
        , sfba.name                                as name
        , sfba.owner_id                            as owner_id
        , sfs.id                                   as id
        , ur.name                                  as sf_advisor_name
        , date(sfba.effective_at)                  as sf_effective_date
    from {{ ref('salesforce_adviceperiod__base_account') }} as sfba
    left join {{ ref('salesforce_adviceperiod__base_salentica_lmnts_financial_account_c') }} as sfs
        on sfba.id = sfs.salentica_lmnts_relationship_c
        and date(sfba.effective_at) = date(sfs.effective_at)
    left join {{ source('fivetran_salesforce_adviceperiod', 'user') }} as ur
        on sfba.owner_id = ur.id
    where true
        and date(sfba.effective_at) in (select distinct cash_available_date from {{ ref('black_diamond_uhnw__base_bills') }})
        and sfs.is_latest = 1
        and sfba.is_latest = 1
)


select
    -- [pms attributes]
    bb.system_name::varchar(200)                                                 as system_name
    , bb.system_instance::varchar(200)                                           as system_instance
    , bb.system_key::varchar(200)                                                as system_key

    -- [location]
    , '640'::varchar(200)                                                        as client_location_code

    -- [invoice]
    , null::varchar(200)                                                         as invoice_number_source
    , bb.as_of_date::timestamp_ntz                                               as invoice_created_at
    , dateadd('day' , -1 , date_trunc('quarter' , bb.cash_available_date))::date as invoice_date
    , null::varchar(200)                                                         as billing_statement_id_source
    , null::varchar(200)                                                         as billing_statement_id_crm
    , null::varchar(200)                                                         as invoice_status
    , 0::int                                                                     as is_intra_period_invoice
    , replace(ltrim(bb.account_number , '0') , '-' , '')::varchar(200)           as account_number
    , bb.account_number::varchar(200)                                            as account_number_formatted
    , case
        when bb.billing_account_number = 'Pay by Invoice'
            then bb.account_number
        else bb.billing_account_number
    end::varchar(200)                                                            as billing_account_number
    , bb.external_id::varchar(200)                                               as account_id_pms
    , bb.account_long_name::varchar(200)                                         as registrant_name
    , bb.account_name::varchar(200)                                              as account_name
    , ba.account_registration_type::varchar(200)                                 as type_of_account
    , br.rel_id::varchar(200)                                                    as client_id_pms
    , ba.aum_aua_ro::varchar(200)                                                as aum_classification_status
    , bm.benchmark_name::varchar(200)                                            as model_investment_strategy
    , bb.custodian::varchar(200)                                                 as custodian
    , coalesce(bb.billing_account_custodian , bb.custodian)::varchar(200)        as billing_custodian
    , null::varchar(200)                                                         as partner_firm
    , null::varchar(200)                                                         as partner_firm_original

    -- [advisor]
    , coalesce(ba.team , bb.team)::varchar(200)                                  as client_manager_source--Gavin looking into case statement against "Lab", etc...
    , sf.sf_advisor_name::varchar(200)                                           as client_manager_original
    , null::varchar(200)                                                         as associate_id_original
    , sf.sf_advisor_name::varchar(200)                                           as client_manager_primary
    , null::varchar(200)                                                         as associate_id_primary
    , null::varchar(200)                                                         as client_manager_type--Gavin formulating logic for associates outside Steve Lockshin as W2 since he's not affiliated with

    -- [assets and fees]
    , 'Quarterly Advance'::varchar(200)                                          as fee_type
    , bb.fee_schedule_name::varchar(200)                                         as fee_schedule_source
    , sf.fee_schedule_type::varchar(200)                                         as fee_schedule_type
    , bb.fee_schedule_name::varchar(200)                                         as fee_schedule
    , invoice_date                                                               as assets_as_of_date
    , invoice_date                                                               as fee_calculation_date
    , bb.rate_percentage::decimal(29 , 8)                                        as effective_fee_rate
    , bb.account_value::decimal(20 , 5)                                          as total_account_value
    , coalesce(bb.billed_value , bb.account_value)::decimal(20 , 5)              as billable_value
    , (bb.account_value - bb.billed_value)::decimal(20 , 5)                      as fee_excluded_assets
    , case
        when coalesce(bb.fee_or_rebate_amount , bb.total_period_fee) >= 0
            then
                coalesce(bb.fee_or_rebate_amount , bb.total_period_fee)
        else 0
    end::decimal(20 , 5)                                                         as client_fee_gross
    , case
        when coalesce(bb.fee_or_rebate_amount , bb.total_period_fee) < 0
            then coalesce(bb.fee_or_rebate_amount , bb.total_period_fee)
        else 0
    end::decimal(20 , 5)                                                         as client_fee_rebates
    , null::decimal(20 , 5)                                                      as client_net_contribution_fee
    , null::decimal(20 , 5)                                                      as client_adjustments_fee
    , null::decimal(20 , 5)                                                      as client_write_off_fee
    , bb.total_period_fee::decimal(20 , 5)                                       as client_fee_net
    , null::date                                                                 as collection_date
    , 0::boolean                                                                 as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::varchar(200)                                                    as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Quarterly'::varchar(200)                                                  as billing_frequency
    , case
        when bb.billing_account_number = bb.account_number
            then 'Direct'
        else 'Indirect'
    end::varchar(200)
        as billing_method
    , null::varchar(200)                                                         as bill_on_balance_type
    , null::varchar(200)                                                         as payment_terms
    , null::number(20 , 5)                                                       as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                        as account_class
    , '110'::varchar(200)                                                        as coa_segment_1_legal_entity_id
    , '6640'::varchar(200)                                                       as coa_segment_3_accounting_id
    , '40001'::varchar(200)                                                      as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::varchar(200)                                          as revenue_category
    , 'Wealth Mgmt Fees'::varchar(200)                                           as revenue_type

    -- [crm]
    , 'salesforce'::varchar(200)                                                 as system_name_crm
    , 'adviceperiod'::varchar(200)                                               as system_instance_crm
    , sf.system_key::varchar(200)                                                as system_key_crm
    , sf.id::varchar(200)                                                        as account_id_crm
    , sf.owner_id::varchar(200)                                                  as client_id_crm
    , sf.owner_id::varchar(200)                                                  as client_id_original_crm
    , null::varchar(200)                                                         as client_id_unique_compass
    , sf.name::varchar(200)                                                      as client_name
    , sf.name::varchar(200)                                                      as client_name_original_crm
    , null::varchar(200)                                                         as client_lead_source
    , null::varchar(5000)                                                        as client_key_tags_crm

    -- [transactions]
    , null::varchar(200)                                                         as transaction_type
    , null::varchar(200)                                                         as transaction_line_type
    , 1::int                                                                     as transaction_line_quantity
    , 'USD'::varchar(200)                                                        as currency_code
    , 'User'::varchar(200)                                                       as currency_conversion_type
    , null::number(20 , 5)                                                       as unit_selling_price

    -- [exclusion]
    , null::int                                                                  as is_excluded
    , null::varchar(200)                                                         as excluded_reason

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , null::varchar(200)                                                         as _trans_key
    , bb._created_at::timestamp_ntz(9)                                           as _source_loaded_at
    , bb._box_file_name::varchar(200)                                            as _source_file
    , bb._box_file_id::varchar(200)                                              as _box_file_id

    -- [extra fields]
    , null::object                                                               as _extra_fields

from {{ ref('black_diamond_uhnw__base_bills') }} as bb
left join {{ ref('black_diamond_uhnw__base_accounts') }} as ba
    on trim(replace(bb.external_id , '-' , '')) = trim(replace(ba.id , '-' , ''))
    and bb.cash_available_date = ba.effective_date
    and ba.billable = true
left join saleforce_salentica as sf
    on bb.external_id = sf.salentica_pms_account_number
    and bb.cash_available_date = sf.sf_effective_date
left join black_diamond_relationship as br
    on bb.external_id = br.account_id
    and bb.cash_available_date = br.effective_date
left join {{ ref('black_diamond_uhnw__base_account_benchmarks') }} as bm
    on trim(replace(bb.account_number , '-' , '')) = trim(replace(bm.account_number , '-' , ''))
    and bm.is_head = 1
order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
