with compass_data_all as (
    select
        ei.id                                              as estate_item_id
        , ei.identifier_c                                  as dirty_account_number
        , replace(ltrim(ei.identifier_c , '0') , '-' , '') as identifier
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
        , ei.custodian_c                                   as custodian_c
        , ei._created_at                                   as _created_at
        , ei.is_latest                                     as latest
        , ei.effective_at
    from {{ ref('salesforce_compass__base_estate_item_c') }} as ei


    left join {{ ref('salesforce_compass__base_account' ) }} as hh
        on ei.household_c = hh.id
        and date(ei.effective_at) = date(hh.effective_at)


    left join {{ ref('salesforce_compass__base_user') }} as ur
        on hh.owner_id = ur.id
        and ur.is_latest = 1--added 4/2/2024 to force join, does this work?

    left join {{ ref('salesforce_compass__base_model_c') }} as md
        on ei.model_on_account_c = md.id

    left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
        on date(ei.effective_at) = date(fs.effective_at)
        and ei.fee_schedule_c = fs.id

    left join {{ ref('salesforce_compass__base_custodian_c') }} as cc
        on ei.custodian_c = cc.id

    where ei.is_deleted = false
        and date(ei.effective_at) in (
            select
                case
                    when bi.asofdate <= '2024-01-31'
                        then
                            '2024-01-31'
                    else
                        bi.asofdate
                end
                    as sf_join_date
            from {{ ref('orion__base_vw_billinstance') }} as bi
            where bi.fkalclient = 1945
                and bi.asofdate >= '2023-12-31'
                and bi.ismockbill != 1
            group by all
        )--TEMP ONLY, will need to be revisitied
        and ei.is_latest = 1
    group by all
)

select
    -- [system attributes]
    'orion'::varchar(200)                                            as system_name
    , 'san_jose'::varchar(200)                                       as system_instance
    , concat(system_name , '__' , system_instance)::varchar(200)     as system_key

    -- [location]
    , null::varchar(200)                                             as client_location_code

    -- [financial dates]
    , null::timestamp_ntz                                            as invoice_created_at
    , null::date                                                     as invoice_date

    --[invoice]
    , null::varchar(200)                                             as invoice_number_source
    , null::varchar(200)                                             as billing_statement_id_source
    , null::varchar(200)                                             as billing_statement_id_crm
    , 'TBD IC/Accounting/Billing team to provide'::varchar(200)      as invoice_status
    , null::int                                                      as is_mid_cycle_invoice
    , replace(ltrim(ac.acctcode , '0') , '-' , '')::varchar(200)     as account_number
    , ac.acctcode::varchar(200)                                      as account_number_formatted
    , ba.fkpayforaccount::varchar(200)                               as billing_account_number
    , ba.pkbillaccountitem::varchar(200)                             as account_id_pms
    , cd.hh_name::varchar(200)                                       as registrant_name
    , cd.hh_name::varchar(200)                                       as account_name
    , cd.typeofaccount::varchar(200)                                 as type_of_account
    , null::varchar(200)                                             as client_id_pms
    , cd.aum_ident::varchar(200)                                     as aum_classification_status
    , cd.mi_strategy::varchar(200)                                   as model_investment_strategy
    , cd.custodian::varchar(200)                                     as custodian
    , null::varchar(200)                                             as billing_custodian--not mapped
    , null::varchar(200)                                             as partner_firm--not mapped
    , null::varchar(200)                                             as partner_firm_original

    -- [advisor]
    , cd.associate_name::varchar(200)                                as client_manager_source
    , cd.associate_name::varchar(200)                                as client_manager_original_crm
    , cd.associate_name::varchar(200)                                as client_manager_primary
    , 'W-2'::varchar(200)                                            as client_manager_type
    , cd.employee_number::varchar(200)                               as associate_id

    -- [assets and fees]
    , bt.stypedesc::varchar(200)                                     as fee_type
    , ba.feeschedule::varchar(200)                                   as fee_schedule_source
    , null::varchar(200)                                             as fee_schedule_type
    , ba.feeschedule::varchar(200)                                   as fee_schedule
    , ba.asofdate::varchar(200)                                      as assets_as_of_date
    , ba.dtcalcdate::varchar(200)                                    as fee_calculation_date
    , ba.feeperc::decimal(20 , 5)                                    as effective_fee_rate
    , ba.ctotalmktvalue::decimal(20 , 5)                             as total_account_value
    , ba.ctotalmktvalue::decimal(20 , 5)                             as billable_value
    , null::decimal(20 , 5)                                          as fee_excluded_assets
    , ba.cinitialamt::decimal(20 , 5)                                as client_fee_gross
    , null::decimal(20 , 5)                                          as client_fee_rebates
    , null::decimal(20 , 5)                                          as client_net_contribution_fee
    , null::decimal(20 , 5)                                          as client_adjustments_fee
    , null::decimal(20 , 5)                                          as client_write_off_fee
    , ba.cinitialamt::decimal(20 , 5)                                as client_fee_net
    , null::date                                                     as collection_date-- not mapped
    , null::boolean                                                  as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::varchar(200)                                        as billing_style
    , case
        when ba.billfrequency = 12 then 'Monthly'
        when ba.billfrequency = 3 then 'Quarterly'
        when ba.billfrequency = 6 then 'Semi-Annually'
        else 'Annually'
    end::varchar(200)                                                as billing_frequency_source
    , ba.paymethod::varchar(200)                                     as billing_method
    , null::varchar(200)                                             as bill_on_balance_type
    , null::varchar(200)                                             as payment_terms
    , null::varchar(200)                                             as payment_method_fee

    -- [accounting]
    , 'REV'::varchar(200)                                            as account_class
    , '1207'::varchar(200)                                           as coa_segment_3_accounting_id
    , null::varchar(200)                                             as coa_segment_5_natural_account_id
    , 'Wealth Management'::varchar(200)                              as revenue_type

    -- [crm]
    , 'SAN JOSE SALESFORCE COMPASS'::varchar(200)                    as system_name_crm
    , 'datalake.salesforce_compass.base_estate_item_c'::varchar(200) as system_instance_crm
    , null::varchar(200)                                             as system_key_crm
    , cd.estate_item_id::varchar(200)                                as account_id_crm
    , cd.hh_id::varchar(200)                                         as client_id_crm
    , cd.hh_id::varchar(200)                                         as client_id_original_crm
    , cd.compass_id::varchar(200)                                    as client_id_unique_compass
    , cd.hh_name::varchar(200)                                       as client_name
    , cd.hh_name::varchar(200)                                       as client_name_original_crm
    , cd.lead_source::varchar(200)                                   as client_lead_source
    , null::varchar(200)                                             as client_key_tags_crm


    -- [transactions]
    , null::varchar(200)                                             as transaction_type
    , null::varchar(200)                                             as transaction_line_type
    , 1::int                                                         as transaction_line_quantity
    , 'USD'::varchar(200)                                            as currency_code
    , 'User'::varchar(200)                                           as currency_conversion_type
    , 1::number(20 , 5)                                              as unit_selling_price

    -- [exclusion]
    -- No records are being excluded, default to 0
    , 0::int                                                         as is_excluded
    , null::varchar(200)                                             as excluded_reason

    -- [referential]
    , null::varchar(200)                                             as _invoice_key
    , current_timestamp()::timestamp_ntz(9)                          as _created_at
    , null::varchar(200)                                             as _source_file
    , null::varchar(200)                                             as _box_file_id

    -- [extra fields]
    , null::variant                                                  as _extra_fields

from {{ ref('orion__base_vw_billaccountitem') }} as ba

left join {{ ref('orion__base_vw_billinstance') }} as bi
    on ba.fkbillinstance = bi.pkbillinstance
-- AND ba.asofdate=bi.asofdate
-- AND bi.ismockbill=0

left join {{ ref('orion__base_vw_account') }} as ac
    on ba.fkbillaccount = ac.pkaccount
    and ba.fkalclient = ac.fkalclient
    and ba.effective_date = ac.effective_date
-- AND ac.fkalclient=1945
-- AND ac.IS_HEAD = 1


left join {{ ref('orion__base_vw_clientinfo') }} as ci
    on ba.fkalclient = ci.pkalclient
    and ci.pkalclient = 1945--HAYES FINANCIAL

left join {{ ref('orion__base_vw_billtype') }} as bt
    on ba.fkbilltype = bt.pkbilltype
    and bt.fkalclient = 1945

--Household data
left join compass_data_all as cd
    on ac.acctcode = cd.dirty_account_number
    and date(cd.effective_at) = greatest(bi.asofdate , '2024-01-31')

where ba.fkalclient = 1945
    and bi.asofdate >= '2023-12-31'
    and bi.ismockbill != 1
