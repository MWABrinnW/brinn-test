-- List of dependencies using --depends_on syntax
--depends_on: {{ ref('orion__base_vw_account') }}
--depends_on: {{ ref('orion__account_values') }}
--depends_on: {{ ref('orion__base_vw_custodian') }}
--depends_on: {{ ref('orion__base_vw_registration') }}
--depends_on: {{ ref('orion__base_vw_registrationtype') }}
--depends_on: {{ ref('orion__base_vw_personal') }}
--depends_on: {{ ref('orion__base_vw_personal_household') }}
--depends_on: {{ ref('orion__base_vw_household') }}
--depends_on: {{ ref('orion__base_vw_representative') }}
--depends_on: {{ ref('orion__base_vw_brokerdealer') }}
--depends_on: {{ ref('orion__base_vw_personal_brokerdealer') }}
--depends_on: {{ ref('orion__base_vw_model') }}

{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Check if table exists in the database. If it doesn't we can't run the query to check for new data without failing #}
{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.name) -%}

{%- set table_exists=source_relation is not none and source_relation.type == 'table' -%}

{%- if execute and is_incremental() and table_exists -%}

    {# Results of this query tell us if data needs loaded. #}
    {%- set query -%}
        select a.effective_date
        from (
            select effective_date, max(_created_at) as _created_at
            from {{ ref('orion__base_vw_account') }}
            group by 1
        ) a
        where a._created_at > nvl((select max(_created_at) from {{ this }}), a._created_at - interval '1 day')
    {%- endset -%}

    {# Execute the query and store the results #}
    {%- set results = run_query(query) -%}
    {%- set results_list = results.columns[0].values() -%}

 {%- else -%}
    {# Set and empty list because dbt is in compile mode or full-refresh #}
    {%- set results = none -%}
    {%- set results_list = [] -%}

{%- endif %}

{# The results told us data does not need loaded, so compile a dummy query. #}
{%- if is_incremental() and results_list|length == 0 and table_exists -%}
    {{ dbt_utils.log_info(this ~ " | No refresh") }}
    select *
    from {{ this }}
    limit 0
{%- else -%}
    {# The results told us there is fresh data to load or refresh. #}
    {%- if results is not none -%}
    {{ dbt_utils.log_info(this ~ " | Dates to refresh") }}
    {%- do results.print_table() -%}
    {%- endif -%}
    select
    a.effective_date                                    as effective_date
  , 'orion'::text(100)                                  as pms
  , case
        when a._client = 568 --mwa
            then 'core'
        when a._client = 1945 --hayes
            then 'hayes'
        when a._client = 2102 --cascadia
            then 'cascadia'
        when a._client = 2623 --arbor_wealth
            then 'arbor_wealth'
        when a._client = 3394 --mps
            then 'mps'
        when a._client = 2878 --network
            then 'network'
        end::text(100)                                  as pms_instance_location
  , concat(pms, '__', pms_instance_location)::text(100) as pms_key
  , case
        when a._client = 568 --mwa
            then 'mwa'
        when a._client = 1945 --hayes
            then 'mwa'
        when a._client = 2102 --cascadia
            then 'mwa'
        when a._client = 2623 --arbor_wealth
            then 'mwa'
        when a._client = 3394 --mps
            then 'mps'
        when a._client = 2878 --network
            then 'network'
        end::text(100)                                  as firm_source
    -- CRM --------------------------------------------------------------------
  , upper(a.acctcode)::text(200)                        as account_number_formatted
  , regexp_replace(
            ltrim(upper(replace(a.acctcode, '-', '')), '0')::text(200)
        , '\\s{2,}', ' ')                               as account_number
  , cust.name::text(500)                                as custodian
  , a.pkaccount::text(200)                              as account_id
  , regtype.sregdesc::text(200)                         as account_type
  , p.entityname::text(500)                             as account_name
  , null::text(200)                                     as registrant_name
  , ph.hh_pkclient::text(200)                           as household_id
  , ph.hh_pers_entityname::text(500)                    as household_name
  , case
        when a.isactive = 0 or a.canceldate is not null
            then 0
        else a.isactive
        end::int                                        as is_active
  , a.acctcreateddate::date                             as created_date
  , a.acctstartdate::date                               as opened_date
  , a.canceldate::date                                  as closed_date
  , av.aum::decimal(16, 2)                              as account_value
  , repp.entityname::text(200)                          as advisor
  , lower(repp.email)::text(200)                        as advisor_email
  , case
        when a._client = 568 --mwa/core
            then null
        when a._client = 1945 --hayes
            then 'L-10019'
        when a._client = 2102 --cascadia
            then '199'
        when a._client = 2623 --arbor_wealth
            then '194'
        when a._client = 3394 --mps
            then null
        when a._client = 2878 --network
            then null
        end::text(50)                                   as location_code
  , null::text(200)                                     as fee_schedule --not available in RS yet
  , mod.modelname::text(200)                            as investment_strategy
  --, null::text(200)                                     as aum_classification --sourced from crm

  , a._client                                           as _client
  , bdp.bd_pers_entityname::text(200)                   as bd_name
    -- META -------------------------------------------------------------------
  , a.is_head                                           as is_head
  , a.is_current                                        as is_current
  , current_timestamp::timestamp_ntz                    as _created_at
  , a._extracted_at::timestamp_ntz                      as _source_loaded_at
  , a._source_file::varchar(200)                        as _source_file
    from {{ ref('orion__base_vw_account') }}                    a
    left join {{ ref('orion__account_values') }}                av
            on a._client = av._client
              and a.pkaccount = av.pkaccount
              and a.effective_date = av.effective_date
    left join {{ ref('orion__base_vw_custodian') }}             cust
            on a._client = cust._client
              and a.fkcustodian = cust.pkcustodian
    join      {{ ref('orion__base_vw_registration') }}          reg
            on a._client = reg._client
              and a.fkregistration = reg.pkregistration
              and a.effective_date = reg.effective_date
    left join {{ ref('orion__base_vw_registrationtype') }}      regtype
            on reg._client = regtype._client
              and reg.fkregistrationtype = regtype.pkregistrationtype
    left join {{ ref('orion__base_vw_personal') }}              p
            on reg._client = p._client
              and reg.fkpersonal = p.pkpersonal
    left join {{ ref('orion__base_vw_personal_household') }}    ph
          on reg._client = ph._client
              and reg.fkclient = ph.hh_pkclient
    join      {{ ref('orion__base_vw_household') }}             h
          on reg._client = h._client
              and reg.fkclient = h.pkclient
              and a.effective_date = h.effective_date
    join      {{ ref('orion__base_vw_representative') }}        rep
          on h._client = rep._client
              and h.fkrep = rep.pkrep
              and a.effective_date = rep.effective_date
    left join {{ ref('orion__base_vw_personal') }}              repp
              on rep._client = repp._client
                  and rep.fkpersonal = repp.pkpersonal
    left join {{ ref('orion__base_vw_brokerdealer') }}          bd
              on rep._client = bd._client
                  and rep.fkbrokerdealer = bd.pkbrokerdealer
    left join {{ ref('orion__base_vw_personal_brokerdealer') }} bdp
              on bd._client = bdp.fkalclient
                  and bd.pkbrokerdealer = bdp.bd_pkbrokerdealer
                  and a.effective_date = bdp.effective_date
    left join {{ ref('orion__base_vw_model') }}                 mod
              on a._client = mod._client
                  and a.pkmdlaccount = mod.fkmodel
                  and a.effective_date = mod.effective_date
    where 1=1
        and nullif(replace(a.acctcode, '-', ''), '') is not null
    {%- if target.name not in ["prod"] %}
        and a.effective_date >= current_date() - 7
    {%- endif %}
    {%- if is_incremental() %}
        and a.effective_date in ({{ "'" ~ results_list | join("','") | string ~ "'" }})
    {%- endif %}
{% endif %}