{%- macro black_diamond_nml_accounts(instance) -%}

    {% if instance | lower == 'baystate' %}
--cte to pull advisor split percents from salesforce, baystate only
with sf_baystate_advisor_split as
(
    select
      cod.name as advisor_commission_split_code
    , cod.effective_at::date as effective_date
    , listagg( con.name || ' ('  || to_varchar(det.percentage_c) || '%)' , '; ') within group(order by det.percentage_c desc, con.name) as full_advisor_team
    from {{ ref('salesforce_baystate__base_advisor_split_detail_c') }} as det
    inner join {{ ref('salesforce_baystate__base_advisor_split_code_c') }} as cod
        on det.advisor_split_code_c = cod.id
        and det.effective_at::date = cod.effective_at::date
        and cod.is_head_for_day = 1
    inner join {{ ref('salesforce_baystate__base_contact') }} as con
        on det.advisor_name_c = con.id
        and det.effective_at::date = con.effective_at::date
        and con.is_head_for_day = 1
    where det.is_head_for_day = 1
    group by all
)
{% endif %}

select
    a.effective_date                                                      as effective_date
    , a.system_name                                                       as system_name
    , a.system_instance                                                   as system_instance
    , a.system_key                                                        as system_key
    , a.firm_source                                                       as firm_source
    , a.account_number_formatted                                          as account_number_formatted
    , a.account_number                                                    as account_number
    , a.account_number                                                    as pms_account_number
    , a.custodian                                                         as pms_custodian
    , a.id::text(200)                                                     as pms_account_id
    , a.account_registration_type::text(200)                              as pms_account_type
    , case
        when a.system_key in (
            'black_diamond__baystate'
            , 'black_diamond__commonwealth'
            , 'black_diamond__houston'
            , 'black_diamond__uhnw'
            ) then a.account_name
        when a.system_key = 'black_diamond__mcgervey' then r.portfolio_display_name
        else a.custodial_account_name
    end::text(500)                                                        as pms_account_name
    , case
        when a.system_key = 'black_diamond__mcgervey' then r.portfolio_display_name
        else a.custodial_account_name
    end::text(500)                                                        as pms_registrant_name
    , r.relationship_id                                                   as pms_household_id
    , r.portfolio_display_name                                            as pms_household_name
    , iff(a.closed_date is null , 1 , 0)                                  as pms_is_active
    , null::date                                                          as pms_created_date
    , a.start_date                                                        as pms_opened_date
    , a.closed_date                                                       as pms_closed_date
    , a.total_emv::decimal(16 , 2)                                        as pms_account_value
    , case
        when a.system_key = 'black_diamond__houston'
            then a.manager
        {% if instance | lower == 'baystate' %}
        when a.system_key = 'black_diamond__baystate'
            then sf_as.full_advisor_team
        {% endif %}
        when a.system_key = 'black_diamond__mcgervey'
            then case
                    when a.manager = 'YA8' then 'Matt McGervey'
                    when a.manager = '55T' then 'Michael E. McGervey'
                    when a.manager = '37F' then 'E. Mike McGervey'
                    else a.manager
                end
        {# when a.system_key = 'black_diamond__commonwealth'
            then pg.portfolio_group_name #}
        -- accounts for 'uhnw' and 'mps'
        else a.team
        end::text(200)                                                    as pms_advisor
    , null::text(200)                                                     as pms_advisor_email
    , case
        when a.system_key = 'black_diamond__houston' then '116'
        when a.system_key = 'black_diamond__mcgervey' then 'L-10016'
        when a.system_key = 'black_diamond__commonwealth' then '173'
        when a.system_key = 'black_diamond__uhnw' then '640'
        when a.system_key = 'black_diamond__baystate' then 'L-10070'
        when a.system_key = 'black_diamond__mps' then '609'
    end::text(200)                                                        as pms_location_code
    , a.fee_name                                                          as pms_fee_schedule
    , null::text(200)                                                     as pms_investment_strategy
    ,  {% if instance | lower == 'uhnw' or instance | lower == 'mps' %}    
      a.aum_aua_ro as pms_aum_classification
      {% else %}    
      'AUM - Assets Under Management'as pms_aum_classification
      {% endif %}
    , null::int                                                           as pms_is_erisa
    , a.discretionary::int                                                as pms_is_discretionary
    , null::int                                                           as pms_is_voting_proxied
    , null::int                                                           as pms_is_prime_broker
    , null::int                                                           as pms_is_broker_dealer_account
    , null::int                                                           as pms_cost_basis_method

    -- CRM --------------------------------------------------------------------
    {% if instance == 'houston' %}
        {{ select_crm_salesforce_compass() }}
    {% else %}
        {{ select_crm_null() }}
    {% endif %}

    -- COALESCE ---------------------------------------------------------------
    {{ select_nml_account_coalesce() }}

    -- KEYS -------------------------------------------------------------------
    , concat(a.system_key , '__' , pms_account_name)                      as system_key__account_name
    , concat(a.system_key , '__' , pms_account_number)                    as system_key__account_number
    , concat(a.system_key , '__' , coalesce(pms_advisor , crm_advisor))   as system_key__advisor
    , concat(pms_advisor , '__' , pms_account_number)                     as advisor__account_number

    {% if instance == 'uhnw' %}
       ,  case 
            when make_distinct = 1 
        then concat(pms_account_number , '_' , pms_account_id) 
        else pms_account_number end::varchar(200)                         as __account_key
    {% else %}
       , pms_account_number::varchar(200)                                 as __account_key
    {% endif %}
    
    -- HELPERS ----------------------------------------------------------------
    , {{ assign_custodian_key() }}                                              
    , sot_aan._system_key                                                 as sot_advisor__account_number
    {% if instance == 'mps' %}
    , coalesce(sot_adv._system_key , (
        case when pp.preferred_pms = 'Orion' then 'orion__mps'
            else 'black_diamond__mps'
        end
    ))
        as sot_advisor
    {% else %}
    ,  sot_adv._system_key  as sot_advisor
    {% endif %}
    , sot_loc._system_key                                                 as sot_location
    , coalesce(
        sot_advisor__account_number
        , sot_advisor
        , sot_location
        , a.system_key
    )                                                                     as sot
    , row_number()
        over (
            partition by
                a.effective_date
                , __account_key
                , __custodian_key
            order by
                a._source_loaded_at desc
                , pms_closed_date desc
                , case when aum_classification = 'AUM - Assets Under Management' then 1
                  when aum_classification = 'AUA - Assets Under Advisory' then 2
                  else 3 end asc
                , crm_account_id asc
                , pms_account_value desc
                , pms_created_date asc
        )                                                                 as dedupe_system_rn
    , count(*)
        over (
               partition by
                a.effective_date
                , __account_key
                , __custodian_key
        )                                                                 as dedupe_system_count
    , case when dedupe_system_count > 1 then 1 else 0 end                    as has_dupes
    , ''::text(2000)
    || coalesce(case
        when coalesce(
                ovrd_acc._excluded_reasons
                , ovrd_pms_acc._excluded_reasons
                , ovrd_pms_adv._excluded_reasons
            ) is not null
            then coalesce(
                    ovrd_acc._excluded_reasons
                    , ovrd_pms_acc._excluded_reasons
                    , ovrd_pms_adv._excluded_reasons
                ) || ';'
    end , '')
    {# || coalesce(case
        when a.system_key = 'black_diamond__commonwealth' and r.is_master_portfolio = 0
        then 'black diamond is_master_portfolio=0;'
        else ''
    end , '') #}
    || coalesce(case
        when a.system_key = 'black_diamond__uhnw' and pms_advisor is null
            then 'Advisor is null;'
        when a.system_key = 'black_diamond__uhnw' and pms_advisor not in ('Bonde', 'Dominic Cozzetto', 'Marc Russell', 'The Lab', 'APX')
            then 'Non UHNW advisor;'
    end , '')
        as excluded_reasons
    , coalesce(
        ovrd_acc._is_excluded
        , ovrd_pms_acc._is_excluded
        , ovrd_pms_adv._is_excluded
        , case
            when excluded_reasons = '' then 0
            else 1
        end
    )                                                                     as is_excluded
    , object_construct_keep_null(
        {# 'portfolio_id' , pg.portfolio_id
        , 'portfolio_group_name' , pg.portfolio_group_name #}
    {# 'is_master_portfolio' , r.is_master_portfolio::int #}
    )                                                                     as extra_fields
    -- META -------------------------------------------------------------------
    , a.is_head                                                           as is_head
    , a.is_current                                                        as is_current
    , a._source_loaded_at::timestamp_ntz                                  as _source_loaded_at
    , null::text(200)                                                     as _source_file
{% if instance == 'uhnw' %}
from {{ ref('int_black_diamond_uhnw_accounts') }} as a
{% else %}
from {{ ref('black_diamond_' ~ instance ~ '__base_accounts') }} as a
{% endif %}
left join {{ ref('black_diamond_' ~ instance ~ '__int_relationships_distinct') }} as r
    on a.effective_date = r.effective_date
    and a.id = r.account_id
left join {{ ref('black_diamond_' ~ instance ~ '__base_account_fees') }} as f
    on a.effective_date = f.effective_date
    and a.id = f.account_id
{# left join {{ ref('black_diamond_' ~ instance ~ '__base_portfolio_groups') }} as pg
    on a.effective_date = pg.effective_date
    and r.portfolio_id = pg.portfolio_id
    and not (a.system_key = 'black_diamond__commonwealth' and
            pg.portfolio_group_name  in (
                'Bryan Test'
                , 'No Mailings'
                , 'Mailing List'
                , 'All Portfolios'
                , 'Terminated Portfolios'
            )
            ) -- values are exclusive to commonwealth #}

-- crm
left join {{ ref('salesforce_compass_accounts') }} as sf
    on pms_account_number = sf.account_number
    and __custodian_key = sf.custodian_key
    and a.effective_date = sf.effective_at::date

{% if instance | lower == 'baystate' %}
    left join sf_baystate_advisor_split as sf_as
        on a.advisor_commission_split_code = sf_as.advisor_commission_split_code
        and a.effective_date = sf_as.effective_date
{% endif %}
-- mappings
left join {{ ref('aux__stg_rules_mappings') }} as map_cus_glo
    on map_cus_glo.field = 'custodian'
    and pms_custodian = map_cus_glo.source_value
    and
    a.effective_date between coalesce(map_cus_glo.start_date , a.effective_date) and coalesce(
        map_cus_glo.end_date , a.effective_date
    )
left join {{ ref('aux__stg_rules_mappings') }} as map_cusv_glo
    on map_cusv_glo.field = 'custodian_verified'
    and pms_custodian = map_cusv_glo.source_value
    and
    a.effective_date between coalesce(map_cusv_glo.start_date , a.effective_date) and coalesce(
        map_cusv_glo.end_date , a.effective_date
    )
-- overrides
left join {{ ref('aux__stg_rules_overrides') }} as ovrd_acc
    on ovrd_acc.scope = 'account_number'
    and pms_account_number = ovrd_acc.scope_key
    and
    a.effective_date between coalesce(ovrd_acc.start_date , a.effective_date) and coalesce(ovrd_acc.end_date , a.effective_date)
left join {{ ref('aux__stg_rules_overrides') }} as ovrd_pms_acc
    on ovrd_pms_acc.scope = 'system_key__account_number'
    and system_key__account_number = ovrd_pms_acc.scope_key
    and
    a.effective_date between coalesce(ovrd_pms_acc.start_date , a.effective_date) and coalesce(
        ovrd_pms_acc.end_date , a.effective_date
    )
left join {{ ref('aux__stg_rules_overrides') }} as ovrd_pms_adv
    on ovrd_pms_adv.scope = 'system_key__advisor'
    and system_key__advisor = ovrd_pms_adv.scope_key
    and
    a.effective_date between coalesce(ovrd_pms_adv.start_date , a.effective_date) and coalesce(
        ovrd_pms_adv.end_date , a.effective_date
    )
{% if instance == 'mps' %}
left join {{ ref('redtail_network__int_contact_preferred_pms') }} as pp
    on upper(pp.advisor) = upper(pms_advisor)
{% endif %}

-- source of truth
left join {{ ref('aux__stg_rules_source_of_truth') }} as sot_aan
    on advisor__account_number = sot_aan.scope_key
    and
    a.effective_date between coalesce(sot_aan.start_date , a.effective_date) and coalesce(sot_aan.end_date , a.effective_date)
left join {{ ref('aux__stg_rules_source_of_truth') }} as sot_adv
    on coalesce(pms_advisor , crm_advisor) = sot_adv.scope_key
    and
    a.effective_date between coalesce(sot_adv.start_date , a.effective_date) and coalesce(sot_adv.end_date , a.effective_date)
left join {{ ref('aux__stg_rules_source_of_truth') }} as sot_loc
    on location_code = sot_loc.scope_key
    and
    a.effective_date between coalesce(sot_loc.start_date , a.effective_date) and coalesce(sot_loc.end_date , a.effective_date)

{%- endmacro -%}
