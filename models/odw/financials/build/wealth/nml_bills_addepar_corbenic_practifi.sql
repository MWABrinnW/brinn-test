with cte_crm as (
    select
        al.system_name                                                                                as system_name
        , al.system_instance                                                                          as system_instance
        , al.system_key                                                                               as system_key
        , al.id                                                                                       as pract_asset_liability_id
        , al.name                                                                                     as pract_acct_name
        , al.practifi_account_number_c                                                                as pract_acct_num
        , al.practifi_client_c                                                                        as pract_client_id_18
        , al.practifi_external_id_2_c                                                                 as practifi_external_id_2_c
        , pa.id                                                                                       as pract_hh_id
        , pa.name                                                                                     as pract_hh_name
        , substr(al.practifi_external_id_2_c , 0 , position('|' , al.practifi_external_id_2_c) - 1)   as addepar_hh_id
        , substr(al.practifi_external_id_2_c , position('|' , al.practifi_external_id_2_c) + 1 , 999) as addepar_acct_id
    from {{ ref('salesforce_corbenic__base_practifi_asset_liability_c') }} as al
    inner join {{ ref('salesforce_corbenic__base_account') }} as pa
        on al.practifi_client_c = pa.id
        and date(al.effective_at) = date(pa.effective_at)
    where al.is_head = 1
        and al.is_latest = 1
        and al.practifi_account_number_c is not null
)

select

    -- [pms attributes]
    b.system_name::varchar(200)                                                  as system_name
    , b.system_instance::varchar(200)                                            as system_instance
    , b.system_key::varchar(200)                                                 as system_key


    -- [location]
    , 'L-10001'::varchar(200)                                                    as client_location_code

    -- [invoice]
    , b.billing_id::varchar(200)                                                 as invoice_number_source
    , null::timestamp_ntz                                                        as invoice_created_at
    , b.billing_date::date                                                       as invoice_date
    , null::varchar(200)                                                         as billing_statement_id_source
    , null::varchar(200)                                                         as billing_statement_id_crm
    , null::varchar(200)                                                         as invoice_status
    , 0::int                                                                     as is_intra_period_invoice
    , trim(upper(b.holding_account_number))::varchar(200)                        as account_number
    , b.holding_account_number::varchar(200)                                     as account_number_formatted
    , b.billing_bill_to_account_number::varchar(200)                             as billing_account_number
    , b.entity_id::varchar(200)                                                  as account_id_pms
    , a.top_level_owner::varchar(200)                                            as registrant_name
    , b.name::varchar(200)                                                       as account_name
    , a.cwm_account_type::varchar(200)                                           as type_of_account
    , a.top_level_owner_entity_id::varchar(200)                                  as client_id_pms
    -- confirm this matches FA Master
    , case
        when a.holding_account_number in (
                'DLRU158'
                , 'MRDRW830'
                , 'MLRF164'
                , 'MRP181'
                , 'MRBP602'
                , 'X65898133'
                , '652582799'
                , 'Z19318191'
                , '85281160'
                , '85281159'
                , '1050002'
                , '221549912'
                , '74572'
                , '26047'
                , '217519565'
                , '0000P55037'
                , '0000P32547'
            )
            then
                'Data Aggregation / Reporting Only'
        when b.cwm_custodian in ('BAA' , 'BAA/ Raymond James' , 'BAA/Fidelity')
            then
                'Data Aggregation / Reporting Only'
        else
            'AUM - Assets Under Management'
    end::varchar(200)
        as aum_classification_status
    , a.cwm_strategy::varchar(200)                                               as model_investment_strategy
    , b.cwm_custodian::varchar(200)                                              as custodian
    , null::varchar(200)                                                         as billing_custodian
    , null::varchar(200)                                                         as partner_firm
    , null::varchar(200)                                                         as partner_firm_original


    -- [advisor]
    , b.cwm_lead_advisor::varchar(200)                                           as client_manager_source
    , case
        when trim(a.cwm_lead_advisor) = 'DG' then 'David Givler II'
        when trim(a.cwm_lead_advisor) = 'BG' then 'Brad Griswold'
        when trim(a.cwm_lead_advisor) = 'WV' then 'William Velekei'
        when trim(a.cwm_lead_advisor) = 'MB' then 'Mark Borda'
        when trim(a.cwm_lead_advisor) = 'SL' then 'Sean Linderman'
        when trim(a.cwm_lead_advisor) = 'KB' then 'Katie Brown'
        when trim(a.cwm_lead_advisor) = 'DM' then 'Dennis Morton'
        when trim(a.cwm_lead_advisor) = 'HA' then 'House Accounts'
        else trim(a.cwm_lead_advisor)
    end::varchar(200)                                                            as client_manager_original
    , case
        when trim(b.cwm_lead_advisor) = 'DG' then '002732'
        when trim(b.cwm_lead_advisor) = 'BG' then '002733'
        when trim(b.cwm_lead_advisor) = 'WV' then '002735'
        when trim(b.cwm_lead_advisor) = 'MB' then '002729'
        when trim(a.cwm_lead_advisor) = 'SL' then null
        when trim(a.cwm_lead_advisor) = 'KB' then null
        when trim(a.cwm_lead_advisor) = 'DM' then null
        when trim(b.cwm_lead_advisor) = 'HA' then 'House Accounts'
        else trim(b.cwm_lead_advisor)
    end::varchar(200)                                                            as associate_id_original
    , client_manager_original                                                    as client_manager_primary
    , associate_id_original::varchar(200)                                        as associate_id_primary
    , 'W-2'::varchar(200)                                                        as client_manager_type

    -- [assets and fees]
    -- fee type requires null handling, deteremines revenue category
    , lower(coalesce(trim(b.billing_fee_type) , 'management fee'))::varchar(200) as fee_type
    , a.fee_schedule_legacy::varchar(200)                                        as fee_schedule_source
    , null::varchar(200)                                                         as fee_schedule_type
    , null::varchar(200)                                                         as fee_schedule
    , b.billing_date::date                                                       as assets_as_of_date
    , b.billing_date::date                                                       as fee_calculation_date
    , case
        when b.billing_assets_billed_on = 0 or b.billing_fee_value = 0 then null
        else b.billing_fee_value / b.billing_assets_billed_on::decimal(20 , 5)
    end::decimal(29 , 8)                                                         as effective_fee_rate
    , b.value::decimal(20 , 5)                                                   as total_account_value
    , b.billing_assets_billed_on::decimal(20 , 5)                                as billable_value
    , (b.value - b.billing_assets_billed_on)::decimal(20 , 5)                    as fee_excluded_assets
    , b.billing_gross_fee::decimal(20 , 5)                                       as client_fee_gross
    , 0::decimal(20 , 5)                                                         as client_fee_rebates
    , 0::decimal(20 , 5)                                                         as client_net_contribution_fee
    , b.billing_prorated_fee::decimal(20 , 5)                                    as client_adjustments_fee
    , 0::decimal(20 , 5)                                                         as client_write_off_fee
    , b.billing_fee_value::decimal(20 , 5)                                       as client_fee_net
    , null::decimal(20 , 2)                                                      as referral_fee

    , null::date                                                                 as collection_date
    , null::boolean                                                              as third_party_calculation

    -- [billing terms and payment]
    , case
        when b.billing_schedule_timing ilike '%advance%' then 'Advance'
        when b.billing_schedule_timing ilike '%arrears%' then 'Arrears'
        else 'Advance'
    end::varchar(200)                                                            as billing_style
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , lower(coalesce(b.billing_schedule_interval , 'monthly'))::varchar(200)     as billing_frequency
    , a.billing_payment_method::varchar(200)                                     as billing_method

    , case
        when fee_type ilike '%management fee%'
            then 'EOM Balance'
    end::varchar(200)                                                            as bill_on_balance_type
    , null::varchar(200)                                                         as payment_terms
    , null::number(20 , 5)                                                       as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                                        as account_class
    , null::varchar(200)                                                         as coa_segment_1_legal_entity_id
    , '1197'::varchar(200)                                                       as coa_segment_3_accounting_id
    , case
        when fee_type ilike '%management fee%'
            then '40001'
    end::varchar(200)                                                            as coa_segment_5_natural_account_id
    -- sourced from "aux__stg_financials_fee_type" if not hardcoded
    , 'Wealth Management'::varchar(200)                                          as revenue_category
    , 'Wealth Mgmt Fees'::varchar(200)                                           as revenue_type

    -- [crm]
    , c.system_name::varchar(200)                                                as system_name_crm
    , c.system_instance::varchar(200)                                            as system_instance_crm
    , c.system_key::varchar(200)                                                 as system_key_crm
    , c.pract_asset_liability_id::varchar(200)                                   as account_id_crm
    , c.pract_hh_id::varchar(200)                                                as client_id_crm
    , null::varchar(200)                                                         as client_id_original_crm
    , null::varchar(200)                                                         as client_id_unique_compass
    , c.pract_hh_name::varchar(200)                                              as client_name
    , c.pract_hh_name::varchar(200)                                              as client_name_original_crm
    , null::varchar(200)                                                         as client_lead_source
    , null::varchar(5000)                                                        as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::varchar(200)                                                    as transaction_type
    , 'Line'::varchar(200)                                                       as transaction_line_type
    , 1::int                                                                     as transaction_line_quantity
    , 'USD'::varchar(200)                                                        as currency_code
    , 'User'::varchar(200)                                                       as currency_conversion_type
    , b.billing_fee_value::number(20 , 5)                                        as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, default to 0
    , ''::varchar(200)                                                           as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                     as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , concat(b.billing_id , '-' , b.holding_account_number)::varchar(200)        as _trans_key
    , b._created_at::timestamp_ntz(9)                                            as _source_loaded_at
    , b._source_file::varchar(200)                                               as _source_file
    , null::varchar(200)                                                         as _box_file_id

    -- These are fields that are likely specific to this source
    -- and are intended to help with one off investigations or
    -- special analysis.
    , null::object                                                               as _extra_fields
from
    {{ ref('addepar_corbenic_history__base_bills') }} as b
left join {{ ref('addepar_corbenic_history__base_accounts') }} as a
    on b.holding_account_number = a.holding_account_number
    and a.is_head = 1
left join cte_crm as c
    on b.holding_account_number = c.pract_acct_num
where b.is_head = 1
    and b.billing_date::date < '2024-10-01'
    -- uncomment if "billing_frequency" or "revenue_category" is not hardcoded.
{# left join {{ ref('aux__stg_financials_fee_type') }} as ovrd_fee_type
        on bb.system_key = ovrd_fee_type.system_key
        and lower(bb.fee_type_description) = lower(ovrd_fee_type.fee_type) #}

order by
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
