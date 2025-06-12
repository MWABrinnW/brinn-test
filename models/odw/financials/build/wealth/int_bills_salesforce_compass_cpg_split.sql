{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['system_key']
) }}

with stale_check as (
    {%- if is_incremental() %}
        select
            case
                -- Compare source table max timestamp after TZ conversion to destination max timestamp.
                when (
                    select
                        max(convert_timezone(
                            'America/Chicago' , _fivetran_synced
                        )::timestamp_ntz)
                    from {{ source('salesforce_compass_fivetran', 'invoice_review_c') }}
                ) > (select max(_created_at) from {{ this }})
                    then 1
                else 0
            end::int as is_stale
    {%- else %}
        select 1::int as is_stale
    {%- endif %}
)

, salesforce_estate_item as (
    select
        id
        , identifier_c
    from {{ ref('salesforce_compass__base_estate_item_c') }}
    where 1 = 1
        and effective_at = (select max(effective_at) from {{ ref('salesforce_compass__base_estate_item_c') }})
        and is_deleted = 0
        and _fivetran_deleted = 0
        and 1 = (select max(is_stale) from stale_check)
    group by all
)

, tamarac_accounts as (
    select
        effective_date                       as effective_date
        , replace(account_number , '-' , '') as account_number
    from {{ ref('tamarac_state_college_history__base_accounts') }}
    where 1 = 1
        and entity_type = 'Single Account'
        and 1 = (select max(is_stale) from stale_check)
    qualify row_number() over (
            partition by effective_date , replace(account_number , '-' , '')
            order by _created_at desc
        ) = 1
)

-- revaluate if invoices originating from orion via salesforce are cpg or not.
select
    'salesforce'::text                              as system_name
    , 'compass'::text                               as system_instance
    , concat('salesforce' , '__' , 'compass')::text as system_key
    , 'mwa'::text                                   as firm_source
    , ir.invoice_date_c                             as invoice_date_c
    , ir.created_date                               as created_date
    , ir.last_modified_date                         as last_modified_date
    , ir.calculation_as_of_date_c                   as calculation_as_of_date_c
    , ir.name                                       as name
    , ir.registration_name_c                        as registration_name_c
    , ir.client_name_c                              as client_name_c
    , ir.account_type_c                             as account_type_c
    , ir.orion_bill_id_c                            as orion_bill_id_c
    , ir.id                                         as id
    , ir.billing_style_c                            as billing_style_c
    , ir.fee_frequency_c                            as fee_frequency_c
    , ir.billing_method_c                           as billing_method_c
    , ir.status_c                                   as status_c
    , ir.account_number_c                           as account_number_c
    , ir.orion_account_id_c                         as orion_account_id_c
    , ir.custodian_c                                as custodian_c
    , ir.fee_type_c                                 as fee_type_c
    , ir.billing_account_number_c                   as billing_account_number_c
    , ir.billing_custodian_c                        as billing_custodian_c
    , ir.billable_value_c                           as billable_value_c
    , ir.total_account_value_c                      as total_account_value_c
    , ir.referral_fee_c                             as referral_fee_c
    , ir.net_fee_c                                  as net_fee_c
    , ir.fee_excluded_assets_c                      as fee_excluded_assets_c
    , ir.gross_fee_c                                as gross_fee_c
    , ir.fee_rebates_c                              as fee_rebates_c
    , ir.net_contributions_fee_c                    as net_contributions_fee_c
    , ir.third_party_calculation_c                  as third_party_calculation_c
    , ir.adjustments_fee_c                          as adjustments_fee_c
    , ir.write_off_fee_c                            as write_off_fee_c
    , ir.revenue_as_of_date_c                       as revenue_as_of_date_c
    , ir.collection_date_c                          as collection_date_c
    , ir.payment_method_fee_c                       as payment_method_fee_c
    , ir.branch_c                                   as branch_c
    , ir.branch_2_c                                 as branch_2_c
    , ir.quarterback_2_c                            as quarterback_2_c
    , ir.company_family_c                           as company_family_c
    , ir.service_rendered_c                         as service_rendered_c
    , ir.aum_classification_c                       as aum_classification_c
    , ir.model_on_account_c                         as model_on_account_c
    , ir.estate_item_c                              as estate_item_c
    , ir.orion_house_id_c                           as orion_house_id_c
    , case
        when
            coalesce(cpg_ba_prior_market_date.account_number , cpg_ba_invoice_date.account_number) is not null
            and ir.orion_bill_id_c is null
            then 1
        else 0
    end::int                                        as is_cpg

    , ir._fivetran_synced                           as _fivetran_synced
    , ir._fivetran_deleted                          as _fivetran_deleted
    , current_timestamp()::timestamp_ntz            as _created_at
from {{ source('salesforce_compass_fivetran', 'invoice_review_c') }} as ir
inner join {{ ref('dates') }} as dt
    on ir.invoice_date_c = dt.date_key
left join salesforce_estate_item as ei
    on ir.estate_item_c = ei.id
-- We attempt to join on prior_market_date and invoice_date_c to ensure we capture the
-- account record if it exists for either date.
left join tamarac_accounts as cpg_ba_prior_market_date
    on replace(ei.identifier_c , '-' , '') = cpg_ba_prior_market_date.account_number
    and dt.prior_market_date = cpg_ba_prior_market_date.effective_date
left join tamarac_accounts as cpg_ba_invoice_date
    on replace(ei.identifier_c , '-' , '') = cpg_ba_invoice_date.account_number
    and ir.invoice_date_c = cpg_ba_invoice_date.effective_date
where 1 = 1
    and ir.is_deleted = 0
    and ir._fivetran_deleted = 0
    and ir.invoice_date_c >= '12/31/2021'
    and 1 = (select max(is_stale) from stale_check)
qualify row_number() over (
        partition by ir.name
        order by ir.name asc , coalesce(cpg_ba_prior_market_date.effective_date , cpg_ba_invoice_date.effective_date) desc
    ) = 1
order by ir.name
