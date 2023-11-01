select
    g.json:name::text(200)                            as group_name
  , g.json:description::text(200)                     as group_description
  , g.json:groupId::text(200)                         as group_id
  , g.json:groupType::text(200)                       as group_type
  , g.json:groups::text(200)                          as groups
  , g.json:custId::text(200)                          as group_cust_id
  , g.json:parentGroupId::text(200)                   as parent_group_id
  , g.json:userId::int                                as user_id
  , a.value:accountDetail::text(200)                  as account_detail
  , a.value:accountId::int                            as account_id
  , a.value:accountNumber::text(200)                  as account_number
  , a.value:accountName::text(200)                    as account_name
  , try_to_boolean(a.value:cashAccount::text)::int    as is_cash_account
  , a.value:cashReserve::double                       as cash_reserve
  , a.value:cashReserveExpiry::date                   as cash_reserve_expiration_date
  , a.value:cashReserveExpiryStr::text(200)           as cash_reserve_expiration
  , a.value:complianceRules::text(200)                as compliance_rules
  , a.value:custId::text(200)                         as account_cust_id
  , a.value:custodian::text(200)                      as custodian
  , try_to_boolean(a.value:disableSleeves::text)::int as is_disable_sleeves
  , a.value:endDate::date                             as end_date
  , try_to_boolean(a.value:explicitSleeve::text)::int as is_explicit_sleeve
  , a.value:groupId::int                              as account_group_id
  , a.value:householdId::int                          as household_id
  , a.value:importDate::date                          as import_date
  , a.value:longName::text(200)                       as long_name
  , a.value:longTermTaxRate::float                    as long_term_tax_rate
  , a.value:modelId::int                              as model_id
  , a.value:modelName::text(200)                      as model_name
  , a.value:name::text(200)                           as account_name
  , a.value:notes::text(200)                          as notes
  , a.value:percentOrjson::double                     as percent_or_value
  , a.value:shortTermTaxRate::float                   as short_term_tax_rate
  , a.value:startDate::date                           as start_date
  , a.value:taxLotReliefMethod::text(200)             as tax_lot_relief_method
  , try_to_boolean(a.value:taxable::text)::int        as is_taxable
  , {{ col_is_head(reference=source('copilot', 'groups'), source_date_col='g._created_at', reference_date_col='_created_at') }}
  , case when g._created_at = b.max_created_at then 1 else 0 end as is_latest
  , dt.prior_market_date                              as effective_date
  , g._created_at                                     as _created_at
  , g._source_file                                    as _source_file
  , g._uri                                            as _uri
from {{ source('copilot', 'groups') }}                   g
     left join (
                   select
                       _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'groups') }}
                   group by 1
               )                                          b
     on g._created_at::date = b._created_date::date
         and g._created_at = b.max_created_at
    left join {{ ref('dates' )}} dt
      on g._created_at::date = dt.date_key
   , lateral flatten(input => g.json, path => 'accounts') a
where 1=1
