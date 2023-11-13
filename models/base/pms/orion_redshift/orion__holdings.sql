--depends_on: {{ ref('orion__base_vw_account') }}
--depends_on: {{ ref('orion__base_vw_asset') }}
--depends_on: {{ ref('orion__base_vw_assetvalue') }}
--depends_on: {{ ref('orion__base_vw_product') }}
--depends_on: {{ ref('orion__base_vw_custodian') }}
--depends_on: {{ ref('orion__base_vw_registration') }}
--depends_on: {{ ref('orion__base_vw_personal_household') }}
--depends_on: {{ ref('orion__cost_basis_by_account') }}

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
            from {{ ref('orion__base_vw_assetvalue') }}
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
    {{ dbt_utils.log_info(this ~ " | Dates to refresh") }}
    {# The results told us there is fresh data to load or refresh. #}
    {%- if results is not none -%}
    {%- do results.print_table() -%}
    {%- endif -%}
    select
    v.effective_date                                                      as effective_date
  , 'orion'                                                               as pms
  , case
        when a._client = 568 --mwa
            then 'mwa'
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
        end                                                               as pms_instance_location
  , concat(pms, '__', pms_instance_location)                              as pms_key
  , 'mwa'                                                                 as firm_source
    -- PMS ---------------------------------------------------------------------
  , a.pkaccount                                                           as account_id
  , upper(ass.acctcode)                                                   as account_number_format
  , replace(replace(ltrim(upper(ass.acctcode), '0'), '-', ''), '  ', ' ') as account_number
  , ph.hh_pkclient                                                        as household_id
  , ph.hh_pers_entityname                                                 as household_name
  , cust.name                                                             as custodian
  , v.fkasset                                                             as security_id
  , coalesce(prod.ticker, prod.cusip)::text(100)                          as symbol
  , prod.cusip                                                            as cusip
  , prod.ticker                                                           as ticker
  , case
        when prod.cusip = prod.ticker
            then 1
        else 0
        end::int                                                          as is_ticker_cusip
  , prod.productname                                                      as security_name
  , prod.producttypename                                                  as security_type
  , prod.productclass                                                     as asset_class
  , v.calculatedvalue                                                     as market_value
  , v.unitbalance                                                         as units_shares
  , v.navprice                                                            as price
  , null::decimal(19, 9)                                                  as price_unfactored
  , null::decimal(19, 9)                                                  as factor
  , cb.cost_basis                                                         as cost_basis

    -- META ---------------------------------------------------------------------
  , v.is_head                                                             as is_head
  , v.is_current                                                          as is_current
  , current_timestamp::timestamp_ntz                                      as _created_at
  , v._extracted_at::timestamp_ntz                                        as _source_loaded_at
  , v._source_file::varchar(200)                                          as _source_file

    from {{ ref('orion__base_vw_account') }}                 a
    join      {{ ref('orion__base_vw_asset') }}              ass
              on a._client = ass._client
                  and a.pkaccount = ass.accountid
    join      {{ ref('orion__base_vw_assetvalue') }}         v
              on a._client = v._client
                  and ass.fkasset = v.fkasset
                  and a.effective_date = v.effective_date
    join      {{ ref('orion__base_vw_product') }}            prod
              on a._client = prod._client
                  and ass.productid = prod.pkproduct
    left join {{ ref('orion__base_vw_custodian') }}          cust
              on a._client = cust._client
                  and a.fkcustodian = cust.pkcustodian
    join      {{ ref('orion__base_vw_registration') }}       reg
              on a._client = reg._client
                  and a.fkregistration = reg.pkregistration
                  and a.effective_date = reg.effective_date
    left join {{ ref('orion__base_vw_personal_household') }} ph
              on reg._client = ph._client
                  and reg.fkclient = ph.hh_pkclient
    left join {{ ref('orion__cost_basis_by_account') }} cb
            on a._client = cb._client
                and ass.fkasset = cb.fkasset
                and a.effective_date = cb.effective_date
    where 1=1
    {%- if target.name not in ["prod"] %}
        and v.effective_date >= current_date() - 7
    {%- endif %}
    {%- if is_incremental() and table_exists %}
        and v.effective_date in ({{ "'" ~ results_list | join("','") | string ~ "'" }})
    {%- endif %}
{% endif %}


