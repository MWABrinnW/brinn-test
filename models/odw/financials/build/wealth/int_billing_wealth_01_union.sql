{%- set source_models = [
    'nml_bills_addepar_corbenic_practifi',
    'nml_bills_addepar_corbenic_compass',
    'nml_bills_black_diamond_baystate',
    'nml_bills_black_diamond_houston',
    'nml_bills_black_diamond_uhnw',
    'nml_bills_envestnet_manasquan',
    'nml_bills_salesforce_compass',
    'nml_bills_salesforce_compass_cpg',
    'nml_bills_sei_manasquan'
] -%}

with cte_loc_cli as (
    select
        accounting_id
        , location_code
        , office_name
        , start_date
        , row_number() over (partition by accounting_id order by start_date desc) as rn
    from {{ ref('locations') }}
    qualify rn = 1
)


, cte_associates_rev_coding_latest as (
    select
        associate_id_adp
        , associate_id_oracle
        , start_date
        , end_date
        , seg_1
        , seg_2
        , seg_3
        , seg_4
        , seg_5
        , seg_6
        , seg_7
        , seg_8
        , is_latest
        -- accounts for rare instances that an client manager has two records for the same period, differerent state values for tax requirements
        , row_number() over (partition by associate_id_adp , associate_id_oracle , start_date , end_date order by _id) as rn
    from {{ ref('bld_associate_revenue_coding') }}
    where is_latest = 1
    qualify rn = 1
)

, cte_normalized as (

    {% for model in source_models -%}
        select *
        from {{ ref(model) }}
        {%- if not loop.last %} union all {% endif -%}
    {% endfor %}
)

select
    nml.*
    , loc_cli.office_name                                as client_office_name
    , loc_cli.accounting_id                              as client_location_accounting_id
    , ass.advisor_nonadvisor
    , coalesce(ass_coa_adp.seg_1 , ass_coa_oracle.seg_1) as associate_coa_segment_1
    , coalesce(ass_coa_adp.seg_2 , ass_coa_oracle.seg_2) as associate_coa_segment_2
    , coalesce(ass_coa_adp.seg_3 , ass_coa_oracle.seg_3) as associate_coa_segment_3
    , coalesce(ass_coa_adp.seg_4 , ass_coa_oracle.seg_4) as associate_coa_segment_4
    , coalesce(ass_coa_adp.seg_5 , ass_coa_oracle.seg_5) as associate_coa_segment_5
    , coalesce(ass_coa_adp.seg_6 , ass_coa_oracle.seg_6) as associate_coa_segment_6
    , coalesce(ass_coa_adp.seg_7 , ass_coa_oracle.seg_7) as associate_coa_segment_7
    , coalesce(ass_coa_adp.seg_8 , ass_coa_oracle.seg_8) as associate_coa_segment_8
from cte_normalized as nml
left join cte_loc_cli as loc_cli
    on nml.client_location_code = loc_cli.location_code
    and loc_cli.rn = 1
left join {{ ref('bld_associates') }} as ass
    on coalesce(nml.associate_id_original , nml.associate_id_primary) = ass.employee_num
    and (ass.effective_at::date) = nml.fee_calculation_date
    -- revenue coding join for associate_id_adp
left join cte_associates_rev_coding_latest as ass_coa_adp
    on coalesce(nml.associate_id_original , nml.associate_id_primary) = ass_coa_adp.associate_id_adp
    and nml.fee_calculation_date between coalesce(ass_coa_adp.start_date , '1999-01-01')
    and coalesce(ass_coa_adp.end_date , '2099-12-31')
    and ass_coa_adp.is_latest = 1
    -- revenue coding join for associate_id_oracle
left join cte_associates_rev_coding_latest as ass_coa_oracle
    on coalesce(nml.associate_id_original , nml.associate_id_primary) = ass_coa_oracle.associate_id_oracle
    and nml.fee_calculation_date between coalesce(ass_coa_oracle.start_date , '1999-01-01')
    and coalesce(ass_coa_oracle.end_date , '2099-12-31')
    and ass_coa_oracle.is_latest = 1
