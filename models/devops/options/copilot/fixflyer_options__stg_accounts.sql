select
    a.json:accountId::int                                                                    as account_id
  , a.json:accountNumber::text(200)                                                          as account_number
  , a.json:name::text(200)                                                                   as account_name
  , a.json:custodian::text(200)                                                              as custodian
  , a.json:householdId::text(200)                                                            as household_id
  , a.json:custId::text(200)                                                                 as cust_id
  , a.json:modelId::text(200)                                                                as model_id
  -- , a.json:groupId::text(200)                                                             as group_id --doesn't populate, use the groups payload
  , a.json:sleeveId::text(200)                                                               as sleeve_id
  , to_timestamp(a.json:startDate::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM')::date  as start_date
  , to_timestamp(a.json:importDate::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM')::date as import_date
  , try_to_boolean(a.json:cashAccount::text)::int                                            as is_cash_account
  , a.json:taxLotReliefMethod                                                                as tax_lot_relief_method
  , a.json:longTermTaxRate                                                                   as long_term_tax_rate
  , a.json:shortTermTaxRate                                                                  as short_term_tax_rate
  , try_to_boolean(a.json:taxable::text)::int                                                as is_taxable
  , try_to_boolean(a.json:disableSleeves::text)::int                                         as is_disable_sleeves
  , try_to_boolean(a.json:explicitSleeve::text)::int                                         as is_explicit_sleeve
  , a.json:cashReserve                                                                       as cash_reserve
  , a.json:percentOrValue                                                                    as percent_or_value
  , a.json:sleeves                                                                           as sleeves
  , {{ col_is_head(reference=source('copilot', 'accounts'), source_date_col='a._created_at', reference_date_col='_created_at') }}
  , case when a._created_at = b.max_created_at then 1 else 0 end                             as is_latest
  -- Derive effective date based on record created date
  , dt.prior_market_date                                                                     as effective_date
  , a._created_at                                                                            as _created_at
  , a._source_file                                                                           as _source_file
  , a._uri                                                                                   as _uri
from {{ source('copilot', 'accounts') }}                  a
     left join (
                   select
                       _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'accounts') }}
                   group by 1
               )                                          b
     on a._created_at::date = b._created_date::date
         and a._created_at = b.max_created_at
    left join {{ ref('dates' )}} dt
      on a._created_at::date = dt.date_key
where 1=1
