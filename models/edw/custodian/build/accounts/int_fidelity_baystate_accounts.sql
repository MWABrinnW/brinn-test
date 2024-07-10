-- depends_on: {{ source('fidelity_baystate', 'nabase') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_nabase_2x1_mailing_address') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_nabase_2x2_legal_address') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_nabase_3x0_notification') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_nabase_2x0_customer') }}
-- depends_on: {{ ref('fidelity_baystate_history__vw_nabase_101_account') }}
-- depends_on: {{ ref('dates') }}
{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{# Prepare the query we'll use to determine if new data from the source is available #}
{%- set src = source('fidelity_baystate', 'nabase') -%}

{# Check if table exists in the database. If it doesn't we can't run the query to check for new data without failing #}
{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.name) -%}

{%- set table_exists=source_relation is not none -%}

{%- set qry_check_for_new_data -%}
select
    case
        when (select count(*) from {{ this }}) = 0
            then 1 -- no records in table
        when (select top 1 1
              from {{ src }}
              where record_datetime > (select max(_created_at) from {{ this }})
              ) = 1
            then 1 -- new records in source compared to destination
        else 0 -- no need to insert anything new
        end
{%- endset -%}

{# Execute the query to determine if new data is ready. 1=yes 0=no #}
{%- if execute and table_exists -%}
    {%- set result = dbt_utils.get_single_value(qry_check_for_new_data) -%}
{%- else -%}
  {%- set result = 0 -%}
{%- endif -%}

{%- if result == 0 and flags.FULL_REFRESH == false and table_exists -%}
    {# Run a simple query with no results because nothing needs inserted #}
    select *
    from {{ this }}
    limit 0
{%- else -%}
{# Insert new data #}
with cte_effective_dates_out_of_date as
(
  select distinct effective_date
  from {{ src }}
  {% if table_exists -%}
  where record_datetime > (select nvl(max(_created_at), dateadd(d, -1, record_datetime)) from {{ this }})
  or effective_date not in (select distinct effective_date from {{ this }})
  {% else -%}
  where true
  {% endif -%}
)
,cte_mailing_address as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_format_address_line_1
    ,fixed_format_address_line_2
    ,fixed_format_address_line_3
    ,fixed_format_po_box
    ,fixed_format_city_name
    ,fixed_format_state
    ,fixed_format_postal_code
    ,country_name
  from {{ ref('fidelity_baystate_history__vw_nabase_2x1_mailing_address') }}
  where true
    and record_number = '211'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}

)
,cte_legal_address as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_format_address_line_1
    ,fixed_format_address_line_2
    ,fixed_format_address_line_3
    ,fixed_format_po_box
    ,fixed_format_city_name
    ,fixed_format_state
    ,fixed_format_postal_code
    ,country_name
  from {{ ref('fidelity_baystate_history__vw_nabase_2x2_legal_address') }}
  where true
    and record_number = '212'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}
)
,cte_notification as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,email_address
  from {{ ref('fidelity_baystate_history__vw_nabase_3x0_notification') }}
  where true
    and record_number = '310'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}
)
,cte_customer as
(
  select
    effective_date
    ,record_number
    ,account_custodial
    ,fixed_name_format_first
    ,fixed_name_format_middle
    ,fixed_name_format_last
    ,telephone_number_1
  from {{ ref('fidelity_baystate_history__vw_nabase_2x0_customer') }}
  where true
    and record_number = '210'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}
)
,cte_account as
(
  select
      a.effective_date
    , a.custodian
    , a.firm_source
    , a.account_custodial
    , a.account_custodial_formatted
    , a.registration_type
    , a.establish_date
    , a.irs_no
    , a.irs_code
    , a.birth_date
    , a.cost_basis_disposal_method_code
    , a.fee_authorization_code
    , a.prime_broker_indicator
    , a.portfolio_margin_indicator
    , a.multiple_margin_indicator
    , a.option_agreement
    , a.restriction_code_partial
    , a._source_loaded_at
    , a._source_file
    , case
        when b.account_custodial is not null
          then b.fixed_format_business_trust_name_1
        else
          nullif(
            replace(
              regexp_replace(
                case
                    -- when all match (use 1)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2)
                        and concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                            concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        then concat_ws(' '
                        , nvl(fixed_format_first_name_1, '')
                        , nvl(fixed_format_middle_name_1, '')
                        , nvl(fixed_format_last_name_1, '')
                        )
                    -- when 1 matches 2 (use 1 & 3)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2)
                        then concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , iff(p.fixed_format_last_name_3 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_3, '')
                        , nvl(p.fixed_format_middle_name_3, '')
                        , nvl(p.fixed_format_last_name_3, '')
                        )
                    -- when 1 matches 3 or when 2 matches 3  (use 1 & 2)
                    when concat(p.fixed_format_first_name_1, p.fixed_format_middle_name_1, p.fixed_format_last_name_1) =
                          concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        or concat(p.fixed_format_first_name_2, p.fixed_format_middle_name_2, p.fixed_format_last_name_2) =
                            concat(p.fixed_format_first_name_3, p.fixed_format_middle_name_3, p.fixed_format_last_name_3)
                        then concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , iff(p.fixed_format_last_name_2 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_2, '')
                        , nvl(p.fixed_format_middle_name_2, '')
                        , nvl(p.fixed_format_last_name_2, '')
                        )
                    else concat_ws(' '
                        , nvl(p.fixed_format_first_name_1, '')
                        , nvl(p.fixed_format_middle_name_1, '')
                        , nvl(p.fixed_format_last_name_1, '')
                        , case
                              when p.fixed_format_last_name_3 is not null then ','
                              when p.fixed_format_last_name_2 is not null then '&'
                              else '' end
                        , nvl(p.fixed_format_first_name_2, '')
                        , nvl(p.fixed_format_middle_name_2, '')
                        , nvl(p.fixed_format_last_name_2, '')
                        , iff(p.fixed_format_last_name_3 is not null, '&', '')
                        , nvl(p.fixed_format_first_name_3, '')
                        , nvl(p.fixed_format_middle_name_3, '')
                        , nvl(p.fixed_format_last_name_3, '')
                        )
                    end,
              '(\\s{2,})', ' '), ' ,', ','), '')::varchar(200)
          end                                                     as account_title
    from {{ ref('fidelity_baystate_history__vw_nabase_101_account') }} a
    left join {{ ref('fidelity_baystate_history__vw_nabase_102_business') }} b
      on a.effective_date = b.effective_date
      and a.account_custodial = b.account_custodial
    left join {{ ref('fidelity_baystate_history__vw_nabase_102_person') }} p
      on a.effective_date = p.effective_date
      and a.account_custodial = p.account_custodial
    where true
    {{ incremental_date_filter(
          source_col_name = 'a.effective_date',
          target_col_name = 'a.effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'a.effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}
)

select
    a.effective_date
  , custodian                                                  as custodian
  , firm_source                                                as firm_source
  , a.account_custodial                                        as account_number
  , a.account_custodial_formatted                              as account_number_formatted

  , null                                                       as custodian_link -- branch/firm/gnumber? primary g number but how?
  , null                                                       as custodian_link_detail
  , a.registration_type                                        as account_type_source_code --account_classification or registration_type
  , a.establish_date                                           as opened_date

  , a.account_title                                            as account_title
  , c.fixed_name_format_first                                  as first_name
  , c.fixed_name_format_middle                                 as middle_name
  , c.fixed_name_format_last                                   as last_name

  , replace(a.irs_no,'-','')::varchar(20)                      as irs_id
  , case
        when a.irs_code = 's'
            then 'ssn'
        when a.irs_code = 't'
            then 'tin'
        end                                                    as irs_id_type
  , a.birth_date                                               as birth_date

  , n.email_address                                            as email_address
  , replace(c.telephone_number_1,'-','')::varchar(20)          as phone
  , a.cost_basis_disposal_method_code                          as cost_basis_method_mutual_funds
  , a.cost_basis_disposal_method_code                          as cost_basis_method_non_mutual_funds
  , null::int                                                  as is_taxable
  , case when a.fee_authorization_code = 'f' then 1 else 0 end as is_fee_authorized
  , case
        when a.prime_broker_indicator in ('j', 'k', 'l', 'm', 'n')
            then 1
        else 0 end                                             as is_prime_broker
  , case 
       when a.portfolio_margin_indicator = 'P'
            then 1
        else 0 end                                             as is_margin_enabled
  , case 
        when a.multiple_margin_indicator = 'Y'
            then 1
        else 0 end                                             as is_multiple_margin_enabled
  , a.option_agreement                                         as options_approval_level
  , a.restriction_code_partial                                 as restrictions_source_code
  , ltrim(regexp_replace(concat_ws(' '
                             , nvl(ma.fixed_format_address_line_1, '')
                             , nvl(ma.fixed_format_address_line_2, '')
                             , nvl(ma.fixed_format_address_line_3, '')
                             , nvl(ma.fixed_format_po_box, '')), '(\s{2,})', ' '), ' ')
                                                               as mailing_address_street
  , ma.fixed_format_city_name                                  as mailing_address_city
  , ma.fixed_format_state                                      as mailing_address_state
  , ma.fixed_format_postal_code                                as mailing_address_zip
  , ma.country_name                                            as mailing_address_country
  , ltrim(regexp_replace(concat_ws(' '
                             , nvl(la.fixed_format_address_line_1, '')
                             , nvl(la.fixed_format_address_line_2, '')
                             , nvl(la.fixed_format_address_line_3, '')
                             , nvl(la.fixed_format_po_box, '')), '(\s{2,})', ' '), ' ')
                                                               as legal_address_street
  , la.fixed_format_city_name                                  as legal_address_city
  , la.fixed_format_state                                      as legal_address_state
  , la.fixed_format_postal_code                                as legal_address_zip
  , la.country_name                                            as legal_address_country
  , {{ col_is_head(reference=ref('fidelity_baystate_history__vw_nabase_101_account'), source_date_col='a.effective_date') }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , current_timestamp()::timestamp                             as _created_at
  , a._source_loaded_at::timestamp                             as _source_loaded_at
  , a._source_file                                             as _source_file
from cte_account a
left join cte_mailing_address ma
   on a.effective_date = ma.effective_date
   and a.account_custodial = ma.account_custodial
   and ma.record_number = '211'
left join cte_legal_address la
   on a.effective_date = la.effective_date
   and a.account_custodial = la.account_custodial
   and la.record_number = '212'
left join cte_notification n
  on a.effective_date = n.effective_date
  and a.account_custodial = n.account_custodial
  and n.record_number = '310'
left join cte_customer c
  on a.effective_date = c.effective_date
  and a.account_custodial = c.account_custodial
  and c.record_number = '210'
where true
    {{ incremental_date_filter(
          source_col_name = 'a.effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition_only = true,
          custom_condition = 'a.effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}

{%- endif -%}


