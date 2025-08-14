{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    on_schema_change = 'sync_all_columns',
    unique_key = 'system_key',
    cluster_by = ['revenue_period_end_date', 'system_key']
) }}

{%-
    set src_models = [
          'int_bills_insurance_mir'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
        select
            system_key
            , _box_file_id
            , max(_created_at) as _created_at
            , count(*)         as cnt
        from {{ this }}
        where 1 = 1
        group by all
        order by 1
    {% else -%}
    select null::text as system_key
        , null::text _box_file_id
        , null::int as cnt
        , null::timestamp as _created_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
        select
            system_key                  as system_key
            , _box_file_id              as _box_file_id
            , max(_created_at)          as _created_at
            , count(*)                  as cnt
            , {{ "'" ~ src_model ~ "'" }} as model_source
        from {{ ref(src_model) }}
        where 1 = 1
        group by all

        {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, file_spine as (
    select
        system_key
        , _box_file_id
    from source_summary
    group by all
    union distinct
    select
        system_key
        , _box_file_id
    from destination_summary
    group by all
)

, files_to_refresh as (
    select
        a._box_file_id  as _box_file_id
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
        , s.cnt         as source_cnt
        , d.cnt         as destination_cnt
    from file_spine as a
    left join source_summary as s
        on a._box_file_id = s._box_file_id
        and a.system_key = s.system_key
    left join destination_summary as d
        on a._box_file_id = d._box_file_id
        and a.system_key = d.system_key
    where 1 = 1
        -- Check if missing from destination OR the source records are newer for that date.
        and ((s._created_at > d._created_at) or (d._created_at is null))

    group by all
)
,
-- Retrieves advisor information based on the "salesforce_id", ultimately deriving the
-- "accounting_id" (segment 3) from the associate revenue coding file.
sf_clients_cte as (
    select
        a.id::text                    as client_id-- client_id
        , a.name::text                as client_name--client_name
        , a.owner_id::text            as advisor_id
        , a.unique_identifier_c::text as client_id_unique
        , a.lead_source_c::text       as lead_source
        , a.key_tags_c::text          as key_tags
        , a.effective_at::datetime    as effective_at
        , a.is_head::int              as is_head
        , a.type::text                as client_type
        , u.employee_number::text     as associate_id
        , u.name::text                as advisor
        , l.finance_code_c::text      as client_location_code
    from {{ ref('salesforce_compass__base_account') }} as a
    left join {{ ref('salesforce_compass__base_user') }} as u
        on a.owner_id = u.id
    left join {{ ref('salesforce_compass__base_mh_location_c') }} as l
        on a.mariner_location_c = l.id
        and a.effective_at::date = l.effective_at::date
        and l.is_head_for_day = 1
    where true
        and exists (select 1 from files_to_refresh)
        and a.is_deleted = 0
        and a._fivetran_deleted = 0
        and a.is_latest = 1
        and a.effective_at::date >= '2025-01-01'
        and lower(a.type) in ('client' , 'referral source' , 'consulting client' , 'product only client' , 'former client')
        and a.unique_identifier_c::text in (
            select distinct b.salesforce_id::text as salesforce_id from {{ ref('int_bills_insurance_mir') }} as b
            where true
        )
)

-- Resolves advisor details when the "client_manager_1" field maps to "insurance_only",
-- still allowing derivation of the "accounting_id" (segment 3) from the associate revenue coding file
, sf_advisors_cte as (
    select
        advisor
        , associate_id
    from sf_clients_cte
    where true
    qualify row_number() over (
            partition by associate_id
            order by effective_at
        ) = 1

)

, locations_cte as (
    select *
    from {{ ref('locations') }}
    where true
        and exists (select 1 from files_to_refresh)
    qualify row_number()
            over (
                partition by accounting_id
                order by location_code asc , end_date desc nulls first
            )
        = 1
)

-- The associate revenue coding file maintains the revenue chart of accounts that could vary from the Oracle COA.
, assoc_code_cte as (
    select
        associate_id_oracle
        , iff(left(associate_id_oracle , 1) = '0' , '1' || right(associate_id_oracle , 5) , associate_id_oracle) as orcl_id
        , seg_3                                                                                                  as accounting_id
        , associate_name_legal
        , effective_date
        , start_date
        , end_date
        , source_file_year
    from {{ ref('bld_associate_revenue_coding') }}
    where true
        and exists (select 1 from files_to_refresh)
    qualify row_number()
            over (
                partition by associate_id_oracle , effective_date
                order by effective_date , source_file_year
            )
        = 1
)

, mir_clients_cte as (
    select
        cli.policy::text            as policy
        , min(cli.date_added)::date as date_added
    from {{ ref('insurance_mir__stg_clients') }} as cli
    where true
        and exists (select 1 from files_to_refresh)
        and cli.is_head = 1
    group by all
)

select
    rev.system_name::text                                         as system_name
    , rev.system_instance::text                                   as system_instance
    , rev.system_key::text                                        as system_key
    , rev.firm_source::text                                       as firm_source
    , case
        when lower(rev.revenue_type) = 'mps revenue' and rev.firm_source = 'mps' then '609'
        when lower(rev.revenue_type) = 'mps revenue' and rev.firm_source = 'mir' then '603'
        when
            lower(rev.revenue_type) in ('mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic') and rev.firm_source = 'mir'
            then '603'
        else coalesce(l1.location_code , l2.location_code , l3.location_code)
    end::text                                                     as location_code
    , case
        when lower(rev.revenue_type) = 'mps revenue' and rev.firm_source = 'mps' then 'The Network'
        when lower(rev.revenue_type) = 'mps revenue' and rev.firm_source = 'mir' then 'National Insurance'
        when
            lower(rev.revenue_type) in ('mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic') and rev.firm_source = 'mir'
            then 'National Insurance'
        else coalesce(l1.office_name , l2.office_name , l3.office_name)
    end::text                                                     as office_name
    , l2.location_code                                            as client_location_code
    , l2.office_name                                              as client_office_name
    , rev.date::date                                              as invoice_date
    , to_date(to_char(last_day(rev.date) , 'yyyy-mm-dd'))         as revenue_period_end_date
    , case rev.rev_pmt_quarter
        when 1 then to_date(to_char(rev.date , 'yyyy') || '-03-31')
        when 2 then to_date(to_char(rev.date , 'yyyy') || '-06-30')
        when 3 then to_date(to_char(rev.date , 'yyyy') || '-09-30')
        when 4 then to_date(to_char(rev.date , 'yyyy') || '-12-31')
        else null
    end                                                           as revenue_quarter_end_date
    , null::text                                                  as invoice_number_source
    , 'Final'::text                                               as invoice_status
    , coalesce(sf1.client_name , rev.household_name)::text        as registrant_name
    -- [insurance domain specific fields]
    , rev.ic::text                                                as insurance_coordinator
    , rev.carrier::text                                           as insurance_carrier
    , rev.revenue_type::text                                      as insurance_revenue_source
    , rev.policy::text                                            as insurance_policy_number
    , cli.date_added::date                                        as insurance_policy_added_date
    , rev.lead_consultant::text                                   as lead_consultant
    -- business requirements do not entail "client manager 2"
    , rev.client_manager_1::text                                  as advisor_source
    -- defer to salesforce first 
    , coalesce(
        coalesce(c1.associate_name_legal , sf1.advisor , sf2.advisor , sf3.advisor)
        , rt.advisor_full_name , rev.client_manager_1
    )::text                                                       as advisor
    , coalesce(
        coalesce(c1.associate_id_oracle , sf1.associate_id , sf2.associate_id , sf3.associate_id)
        , rt.contact_id::text
    )::text                                                       as associate_id
    , rev.gross_comm::number(18 , 2)                              as client_fee_gross
    , rev.net_comm::number(18 , 2)                                as client_fee_net
    , 'Advance'::text                                             as billing_style
    , 'One-Time'::text                                            as billing_frequency
    , 'REV'::text                                                 as account_class
    , 0::boolean                                                  as recurring_revenue
    , 0::boolean                                                  as impacted_by_financial_markets
    ,
    case
        when rev.revenue_type = 'MPS Revenue' and rev.firm_source = 'mps' then '190-200-6609-0000-41001-000-000-000'
        when rev.revenue_type = 'MPS Revenue' and rev.firm_source = 'mir' then '150-150-6603-0000-41001-000-000-000'
        when
            lower(rev.revenue_type) in ('mwa revenue' , 'mwa revenue ap' , 'mwa revenue ic') and rev.firm_source = 'mir'
            then '150-150-6603-0000-41001-000-000-000'
        else rev.account
    end::text                                                     as coa_account_number
    , split_part(coa_account_number , '-' , 1)::text              as coa_segment_1_legal_entity_id
    , split_part(coa_account_number , '-' , 2)::text              as coa_segment_2_product_id
    , split_part(coa_account_number , '-' , 3)::text              as coa_segment_3_accounting_id
    , split_part(coa_account_number , '-' , 4)::text              as coa_segment_4_team_id
    , split_part(coa_account_number , '-' , 5)::text              as coa_segment_5_natural_account_id
    , split_part(coa_account_number , '-' , 6)::text              as coa_segment_6_initiative_id
    , split_part(coa_account_number , '-' , 7)::text              as coa_segment_7_intercompany_id
    , split_part(coa_account_number , '-' , 8)::text              as coa_segment_8_future_id
    , 'Insurance'::text                                           as revenue_category
    , rev.revenue_type::text                                      as revenue_type
    , case
        when rev.salesforce_id::text ilike 'A-%' then 'salesforce'::text
        else null::text
    end                                                           as system_name_crm
    , case
        when rev.salesforce_id::text ilike 'A-%' then 'compass'::text
        else null::text
    end                                                           as system_instance_crm
    , case
        when rev.salesforce_id::text ilike 'A-%' then 'salesforce__compass'::text
        else null::text
    end                                                           as system_key_crm
    , null::text                                                  as account_id_crm
    , coalesce(sf1.client_id , sf2.client_id)::text               as client_id_crm
    , coalesce(sf1.client_id , sf2.client_id)::text               as client_id_original_crm
    , coalesce(sf1.client_id_unique , sf2.client_id_unique)::text as client_id_unique_compass
    , coalesce(sf1.client_name , sf2.client_name)::text           as client_name
    , coalesce(sf1.client_name , sf2.client_name)::text           as client_name_original_crm
    , coalesce(sf1.lead_source , sf2.lead_source)::text           as client_lead_source
    , coalesce(sf1.key_tags , sf2.key_tags)::text                 as client_key_tags_crm
    , 'Invoice'::text                                             as transaction_type
    , 'Line'::text                                                as transaction_line_type
    , 1::int                                                      as transaction_line_quantity
    , 'USD'::text                                                 as currency_code
    , 'User'::text                                                as currency_conversion_type
    , rev.gross_comm::number(18 , 2)                              as unit_selling_price
    , 0::int                                                      as is_excluded
    , null::text                                                  as excluded_reasons
    , rev.policy || '_' || rev.date::text                         as _invoice_key
    , rev._created_at::timestamp_ntz(9)                           as _source_loaded_at
    , rev._box_file_name::text                                    as _source_file
    , rev._box_file_id::text                                      as _box_file_id
    , object_construct_keep_null(
        'join_to_crm_sf_eff_date' , (case when sf1.client_id_unique is null then 0 else 1 end)::text
        , 'join_to_crm_sf_is_head' , (case when sf2.client_id_unique is null then 0 else 1 end)::text
        , 'join_to_crm_sf_adv' , (case when sf3.advisor is null then 0 else 1 end)::text
        , 'join_to_ass_coding' , (case when c1.orcl_id is null then 0 else 1 end)::text
        , 'join_to_locations_on_associate' , (case when c1.accounting_id is null then 0 else 1 end)::text
        , 'join_to_locations_on_client' , (case when l2.location_code is null then 0 else 1 end)::text
        , 'join_to_locations_on_coa' , (case when l3.accounting_id is null then 0 else 1 end)::text
    )                                                             as _extra_fields

    , current_timestamp()::datetime                               as _created_at
    , 0::int                                                      as is_legacy

from {{ ref('int_bills_insurance_mir') }} as rev
left join mir_clients_cte as cli
    on rev.policy = cli.policy
-- resolves first to salesforce record on "invoice_date"
left join sf_clients_cte as sf1
    on rev.salesforce_id::text = sf1.client_id_unique::text
    and to_date(to_char(last_day(rev.date) , 'yyyy-mm-dd')) = sf1.effective_at::date
-- resolves second to salesforce record on "is_head"
left join sf_clients_cte as sf2
    on rev.salesforce_id::text = sf2.client_id_unique::text
    and sf2.is_head = 1
-- ensures an advisor found in salesforce proprogrates to records where the join on salesforce cannot be resolved
-- i.e., advisor "A" has a client with "salesforce_unique_compass" record but for other instances, the value is null;
-- therefore, the join to salesforce cannot be resolved, though we're able to obtain the "advisor" for other policies.
left join sf_advisors_cte as sf3
    on rev.client_manager_1 = sf3.advisor
-- obtains segement 3 from the revenue chart of accounts
left join assoc_code_cte as c1
    on coalesce(sf1.associate_id , sf2.associate_id , sf3.associate_id) = c1.orcl_id::text
    and last_day(rev.date) between c1.start_date and c1.end_date
left join locations_cte as l1
    on c1.accounting_id = l1.accounting_id
left join locations_cte as l2
    on coalesce(sf1.client_location_code , sf2.client_location_code) = l2.location_code
left join locations_cte as l3
-- catch all join for line items that don't get assigned a loaction in the two joins above
    on split_part(rev.account , '-' , 3)::text = l3.accounting_id
left join {{ ref('redtail_network__int_contact_preferred_pms') }} as rt
    on lower(
        coalesce(
            concat(rt.advisor_first_name , ' ' , rt.advisor_last_name)
            , concat(rt.advisor_nick_name , ' ' , rt.advisor_last_name)
        )
    ) = lower(rev.client_manager_1)
-- chart of accounts is reflects Oracle values
where true
    and exists (select 1 from files_to_refresh)
    and rev._box_file_id in (select a._box_file_id from files_to_refresh as a)
    and lower(rev.revenue_type) not in ('pending allocation' , 'due to msec' , 'other')
