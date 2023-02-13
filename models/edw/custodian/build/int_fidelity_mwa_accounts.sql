{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

with cte_effective_dates_out_of_date as
(
  select distinct effective_date
  from {{ ref('fidelity_mwa_history__vw_nabase_2x1_mailing_address') }}
  where _source_loaded_at > (select max(_created_at) from int_fidelity_mwa_accounts)

  union

  select distinct effective_date
  from {{ ref('fidelity_mwa_history__vw_nabase_2x2_legal_address') }}
  where _source_loaded_at > (select max(_created_at) from int_fidelity_mwa_accounts)

  union

  select distinct effective_date
  from {{ ref('fidelity_mwa_history__vw_nabase_3x0_notification') }}
  where _source_loaded_at > (select max(_created_at) from int_fidelity_mwa_accounts)

  union

  select distinct effective_date
  from {{ ref('fidelity_mwa_history__vw_nabase_2x0_customer') }}
  where _source_loaded_at > (select max(_created_at) from int_fidelity_mwa_accounts)
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
  from {{ ref('fidelity_mwa_history__vw_nabase_2x1_mailing_address') }}
  where true
    and record_number = '211'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
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
  from {{ ref('fidelity_mwa_history__vw_nabase_2x2_legal_address') }}
  where true
    and record_number = '212'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
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
  from {{ ref('fidelity_mwa_history__vw_nabase_3x0_notification') }}
  where true
    and record_number = '310'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
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
  from {{ ref('fidelity_mwa_history__vw_nabase_2x0_customer') }}
  where true
    and record_number = '210'
    {{ incremental_date_filter(
          source_col_name = 'effective_date',
          target_col_name = 'effective_date',
          do_lookback = false,
          do_new = false,
          custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}
)

select
    a.effective_date
  , 'fidelity'                                                 as custodian
  , 'mwa'                                                      as firm
  , a.account_custodial                                        as account_number
  , a.account_custodial_formatted                              as account_number_formatted

  , null                                                       as custodian_link -- branch/firm/gnumber? primary g number but how?
  , null                                                       as custodian_link_detail
  , a.registration_type                                        as account_type_source_code --account_classification or registration_type
  , a.establish_date                                           as opened_date

  , null                                                       as account_title
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
  , {{ col_is_head(reference=ref('fidelity_mwa_history__vw_nabase_101_account'), source_date_col='a.effective_date') }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at::timestamp                             as _source_loaded_at
  , current_timestamp()::timestamp                             as _created_at
from {{ ref('fidelity_mwa_history__vw_nabase_101_account') }} a
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
          custom_condition = 'a.effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
    ) }}