{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['revenue_period_end_date']
) }}

with stale_check as (
    {%- if is_incremental() %}
        select
            case
                -- Compare source table max timestamp after TZ conversion to destination max timestamp.
                when (
                    select max(_created_at)
                    from {{ ref('black_diamond_baystate__base_bills') }}
                ) > (select max(_created_at) from {{ this }})
                    then 1
                else 0
            end::int as is_stale
    {%- else %}
        select 1::int as is_stale
    {%- endif %}
)

-------------------------------------------------------------------

, bills as (
    select
        system_name
        , system_instance
        , system_key
        , firm_source
        , _id
        , account_number
        , as_of_date
        , cash_available_date
        , custodian
        , rep_code
        , advisor_commission_split_code
        , external_id
        , account_name
        , account_long_name
        , style
        , fee_schedule_name
        , rate_percentage
        , account_value
        , fee_or_rebate_amount
        , total_period_fee
        , billing_account_number
        , billing_account_custodian
        , _box_file_name
        , _box_file_id
    from {{ ref('black_diamond_baystate__base_bills') }}
    where 1 = 1
        and is_head = 1
        and 1 = (select max(is_stale) from stale_check)
)

, account_date_map as (
    select
        cash_available_date
        , external_id
    from bills
    group by all
)

, bd_accounts as (
    select
        effective_date
        , account_number
        , account_registration_type
        , total_emv
        , advisor_commission_split_code
        , id
        , is_head
    from {{ ref('black_diamond_baystate__base_accounts') }}
    where 1 = 1
        and 1 = (select max(is_stale) from stale_check)
        and (
            effective_date in (select distinct cash_available_date from bills)
            or effective_date = (select max(effective_date) from {{ ref('black_diamond_baystate__base_accounts') }})
        )
    qualify row_number() over (
            partition by effective_date , account_number
            order by _created_at desc
        ) = 1
)

, cte_pms_client_info_1 as (
    select
        effective_date                               as effective_date
        , account_id                                 as account_id
        , is_head                                    as is_head
        , listagg(distinct relationship_name , '; ') as pms_client_names
        , listagg(distinct relationship_id , '; ')   as pms_client_ids
    from {{ ref('black_diamond_baystate__base_relationships') }}
    where 1 = 1
        and 1 = (select max(is_stale) from stale_check)
        and (
            effective_date in (select distinct cash_available_date from bills)
            or effective_date = (select max(effective_date) from {{ ref('black_diamond_baystate__base_relationships') }})
        )
    group by 1 , 2 , 3
)

, cte_split_detail_1 as (
    select
        a.effective_at::date as effective_date
        , b.name             as code_name
        , c.name             as name
        , c.id               as sol_id
        , a.percentage_c     as percentage_c
        , a._created_at      as sp_crdt
        , b._created_at      as sd_crdt
        , c._created_at      as ct_crdt
        , max(a._created_at) over (
            partition by a.id , a.effective_at::date
            order by a.id , a.effective_at
        )                    as max_sp_crdt
        , max(b._created_at) over (
            partition by b.id , b.effective_at::date
            order by b.id , b.effective_at
        )                    as max_sd_crdt
        , max(c._created_at) over (
            partition by c.id , c.effective_at::date
            order by c.id , c.effective_at
        )                    as max_ct_crdt
        , a.is_head          as is_head
        --, listagg( c.NAME || ' ('  || to_varchar(a.PERCENTAGE_C) || '%)' , '; ') within group(order by b.NAME) as FULL_ADVISOR_TEAM
    from {{ ref('salesforce_baystate__base_advisor_split_detail_c') }} as a
    inner join {{ ref('salesforce_baystate__base_advisor_split_code_c') }} as b
        on a.advisor_split_code_c = b.id
        and a.effective_at::date = b.effective_at::date
    inner join {{ ref('salesforce_baystate__base_contact') }} as c
        on a.advisor_name_c = c.id
        and a.effective_at::date = c.effective_at::date
    where 1 = 1
        and 1 = (select max(is_stale) from stale_check)
        and (
            a.effective_at::date in (select distinct cash_available_date from bills)
            or a.effective_at::date
            = (select max(effective_at::date) from {{ ref('salesforce_baystate__base_advisor_split_detail_c') }})
        )
)

, cte_split_detail_2 as (
    select
        effective_date
        , code_name
        , listagg(name || ' (' || to_varchar(percentage_c) || '%)' , '; ') within group (
            order by name
        ) as full_advisor_team
        , listagg(sol_id , '; ') within group (
            order by name
        ) as full_advisor_team_ids
        , is_head
    from cte_split_detail_1
    where 1 = 1
        and sp_crdt = max_sp_crdt
        and sd_crdt = max_sd_crdt
        and ct_crdt = max_ct_crdt
        and 1 = (select max(is_stale) from stale_check)
    group by all
)

, cte_less_than_five as (
    select
        account_number          as acct_num
        , _box_file_id          as box_id
        , sum(total_period_fee) as tot_prd_fee
        , case
            when tot_prd_fee < 5
                then
                    '1'
            else
                '0'
        end                     as exclude_less_than_5
        , case
            when tot_prd_fee < 5
                then
                    'Billed Less than $5'
        end                     as exclude_less_than_5_reason
    from bills
    where 1 = 1
        and 1 = (select max(is_stale) from stale_check)
    group by 1 , 2
    order by 1 , 2
)

select
-- [pms attributes]
    bb.system_name::text(500)                                                            as system_name
    , bb.system_instance::text(500)                                                      as system_instance
    , bb.system_key::text(500)                                                           as system_key
    , bb.firm_source::text(500)                                                          as firm_source

    -- [location]
    , 'L-10070'::text(500)                                                               as client_location_code

    -- [invoice]
    , (
        to_varchar(bb.account_number)
        || '_' || to_varchar(bb.as_of_date)
        || '_' || bb._id
    )::text(500
    )                                                                                    as invoice_number_source
    , bb.as_of_date::timestamp                                                           as invoice_created_at
    , dateadd('day' , -1 , date_trunc('quarter' , bb.cash_available_date))::date         as invoice_date-- dont have a better source for this unfortnuately
    , (
        to_varchar(bb.account_number) || '_'
        || to_varchar(bb.as_of_date) || '_'
        || bb._id
    )::text(500
    )                                                                                    as billing_statement_id_source
    , null::text(500)                                                                    as billing_statement_id_crm
    , null::text(500)                                                                    as invoice_status
    , 0::int                                                                             as is_intra_period_invoice
    , ltrim(replace(bb.account_number , '-' , '') , '0')::text(500)                      as account_number
    , bb.account_number::text(500)                                                       as account_number_formatted
    , bb.billing_account_number::text(500)                                               as billing_account_number
    , bb.external_id::text(500)                                                          as account_id_pms
    , bb.account_name::text(500)                                                         as registrant_name
    , bb.account_long_name::text(500)                                                    as account_name
    , coalesce(ba1.account_registration_type , ba2.account_registration_type)::text(500) as type_of_account
    , coalesce(cte1.pms_client_ids , cte2.pms_client_ids)::text(500)                     as client_id_pms
    , 'AUM - Assets Under Management'::text(500)                                         as aum_classification_status
    , bb.style::text(500)                                                                as model_investment_strategy
    , bb.custodian::text(500)                                                            as custodian
    , bb.billing_account_custodian::text(500)                                            as billing_custodian
    , null::text(500)                                                                    as partner_firm
    , null::text(500)                                                                    as partner_firm_original

    -- [advisor]
    , (bb.rep_code || ' (' || bb.advisor_commission_split_code || ')')::text(500)        as advisor_source
    , coalesce(cte3.full_advisor_team , cte4.full_advisor_team)::text(500)               as advisor_original
    , coalesce(cte3.full_advisor_team_ids , cte4.full_advisor_team_ids)::text(500)       as associate_id_original
    , coalesce(cte4.full_advisor_team , cte3.full_advisor_team)::text(500)               as advisor_primary
    , coalesce(cte4.full_advisor_team_ids , cte3.full_advisor_team_ids)::text(500)       as associate_id_primary
    , '1099'::text(500)                                                                  as advisor_type

    -- [assets and fees]
    , 'Quarterly Fee'::text(500)                                                         as fee_type
    , bb.fee_schedule_name::text(500)                                                    as fee_schedule_source
    , null::text(500)                                                                    as fee_schedule_type
    , null::text(500)                                                                    as fee_schedule
    , invoice_date::date                                                                 as assets_as_of_date
    , invoice_date::date                                                                 as fee_calculation_date
    , bb.rate_percentage::decimal(29 , 8)                                                as effective_fee_rate
    , coalesce(ba1.total_emv , bb.account_value)::decimal(20 , 5)                        as total_account_value
    , null::decimal(20 , 5)                                                              as billable_value
    , null::decimal(20 , 5)                                                              as fee_excluded_assets
    --, coalesce(bb.BILLABLE_VALUE, ba1.total_emv, bb.ACCOUNT_VALUE) as BILLABLE_VALUE
    --, coalesce(ba1.total_emv, bb.ACCOUNT_VALUE)-coalesce(bb.BILLABLE_VALUE, ba1.total_emv, bb.ACCOUNT_VALUE) as FEE_EXCLUDED_ASSETS
    , case
        when bb.fee_or_rebate_amount >= 0
            then bb.fee_or_rebate_amount
        else 0
    end::decimal(20 , 5)                                                                 as client_fee_gross
    , case
        when bb.fee_or_rebate_amount <= 0
            then bb.fee_or_rebate_amount
        else 0
    end::decimal(20 , 5)                                                                 as client_fee_rebates
    , null::decimal(20 , 5)                                                              as client_net_contribution_fee
    , null::decimal(20 , 5)                                                              as client_adjustments_fee
    , null::decimal(20 , 5)                                                              as client_write_off_fee
    , bb.total_period_fee::decimal(20 , 5)                                               as client_fee_net
    , null::decimal(20 , 2)                                                              as referral_fee
    , null::date                                                                         as collection_date
    , 0::boolean                                                                         as third_party_calculation

    -- [billing terms and payment]
    , 'Advance'::text(500)                                                               as billing_style
    , 'Quarterly'::text(500)                                                             as billing_frequency
    , 'Direct'::text(500)                                                                as billing_method
    , null::text(500)                                                                    as bill_on_balance_type
    , null::text(500)                                                                    as payment_terms
    , null::number(20 , 5)                                                               as payment_method_fee

    -- [accounting]
    , 'rev'::text(500)                                                                   as account_class
    , '260'::text(500)                                                                   as coa_segment_1_legal_entity_id
    , '1225'::text(500)                                                                  as coa_segment_3_accounting_id
    , '0000'::text(500)                                                                  as coa_segment_4_team_id
    , case
        when bb.advisor_commission_split_code in ('NEA8191' , 'S067110' , 'S045990')
            then
                '40001'
        else
            '40002'
    end::text(500)                                                                       as coa_segment_5_natural_account_id
    , 'Wealth Management'::text(500)                                                     as revenue_category
    , 'Wealth Mgmt Fees'::text(500)                                                      as revenue_type

    -- [crm]
    , 'salesforce'::text(500)                                                            as system_name_crm
    , 'baystate'::text(500)                                                              as system_instance_crm
    , 'salesforce__baystate'::text(500)                                                  as system_key_crm
    , null::text(500)                                                                    as account_id_crm
    , null::text(500)                                                                    as client_id_crm
    , null::text(500)                                                                    as client_id_original_crm
    , null::text(500)                                                                    as client_id_unique_compass
    , null::text(500)                                                                    as client_name
    , null::text(500)                                                                    as client_name_original_crm
    , null::text(500)                                                                    as client_lead_source
    , null::text(5000)                                                                   as client_key_tags_crm

    -- [transactions]
    , 'Invoice'::text(500)                                                               as transaction_type
    , 'Line'::text(500)                                                                  as transaction_line_type
    , 1::int                                                                             as transaction_line_quantity
    , 'USD'::text(500)                                                                   as currency_code
    , 'User'::text(500)                                                                  as currency_conversion_type
    , bb.total_period_fee::number(20 , 5)                                                as unit_selling_price

    -- [exclusion]
    , array_to_string(
    -- invoices less than $5 are not billed
        array_construct_compact(
            cte5.exclude_less_than_5_reason || ';'
        )
        , ' '
    )::text(5000)                                                                        as excluded_reasons
    , case
        when excluded_reasons = '' then 0
        else 1
    end::int                                                                             as is_excluded

    -- [finanical dates] dependencies on upstream identifiers
    , {{ financials_set_revenue_period() }}

    -- [referential]
    , null::text(500)                                                                    as _trans_key
    , current_timestamp()::timestamp_ntz                                                 as _created_at
    , null::timestamp_ntz(9)                                                             as _source_loaded_at
    , bb._box_file_name::text(500)                                                       as _source_file
    , bb._box_file_id::text(500)                                                         as _box_file_id

    -- [extra fields]
    , object_construct_keep_null(
        'join_pms_bay_base_accts_eff_date' , iff(ba1.id is not null , 1 , 0)
        , 'join_pms_bay_base_accts_is_head' , iff(ba2.id is not null , 1 , 0)
        , 'join_pms_bay_base_relat_eff_date' , iff(cte1.account_id is not null , 1 , 0)
        , 'join_pms_bay_base_relat_is_head' , iff(cte2.account_id is not null , 1 , 0)
        , 'join_pms_bay_base_split_eff_date' , iff(cte3.code_name is not null , 1 , 0)
        , 'join_pms_bay_base_split_is_head' , iff(cte4.code_name is not null , 1 , 0)
        , 'join_pms_bay_base_bills_is_head' , iff(cte5.acct_num is not null , 1 , 0)
    )::variant                                                                           as _extra_fields

from bills as bb
left join bd_accounts as ba1
    on bb.external_id = ba1.id
    and bb.cash_available_date = ba1.effective_date
left join bd_accounts as ba2
    on bb.external_id = ba2.id
    and ba2.is_head = 1
left join cte_pms_client_info_1 as cte1
    on bb.external_id = cte1.account_id
    and bb.cash_available_date = cte1.effective_date
left join cte_pms_client_info_1 as cte2
    on bb.external_id = cte2.account_id
    and cte2.is_head = 1
left join cte_split_detail_2 as cte3
    on bb.cash_available_date = cte3.effective_date
    and bb.advisor_commission_split_code = cte3.code_name
left join cte_split_detail_2 as cte4
    on ba2.advisor_commission_split_code = cte4.code_name
    and cte4.is_head = 1
left join cte_less_than_five as cte5
    on bb.account_number = cte5.acct_num
    and bb._box_file_id = cte5.box_id
where 1 = 1
order by--noqa: AM06
    system_key
    , revenue_period_end_date
    , coalesce(_trans_key , account_number)
