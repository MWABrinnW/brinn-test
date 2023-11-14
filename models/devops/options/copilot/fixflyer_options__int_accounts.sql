select
      g.group_name
    , g.group_type
    , g.group_description
    , g.group_id
    , g.parent_group_id
    , a.account_id
    , a.account_number
    , a.account_name
    , a.custodian
    , a.household_id
    , a.cust_id
    , a.model_id
    , a.sleeve_id
    , a.start_date
    , a.import_date
    , a.is_cash_account
    , a.tax_lot_relief_method
    , a.long_term_tax_rate
    , a.short_term_tax_rate
    , a.is_taxable
    , a.is_disable_sleeves
    , a.is_explicit_sleeve
    , a.cash_reserve
    , a.percent_or_value
    , a.sleeves

    , g.group_cust_id

    , a.is_head
    , a.is_head_for_day
    , a._created_at
    , a._uri
    , a._env
from {{ ref('fixflyer_options__stg_accounts') }} a
left join {{ ref('fixflyer_options__stg_groups') }} g
    on a._created_at::date = g._created_at::date
    and a.account_id = g.account_id
    and g.is_head_for_day = 1
    and a._env = g._env
where 1=1
    and a.is_head_for_day = 1

