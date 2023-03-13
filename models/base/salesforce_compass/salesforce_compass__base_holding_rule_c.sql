select
    a.json:ID:: VARCHAR(18)                           as id
  , a.json:IS_DELETED:: BOOLEAN                       as is_deleted
  , a.json:NAME:: VARCHAR(240)                        as name
  , a.json:CREATED_DATE:: TIMESTAMPTZ                 as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ           as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)          as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ              as system_modstamp
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ             as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ         as last_referenced_date
  , a.json:FINANCIAL_ACCOUNT_C:: VARCHAR(18)          as financial_account_c
  , a.json:AUM_CLASSIFICATION_C:: VARCHAR(765)        as aum_classification_c
  , a.json:DESCRIPTION_C:: VARCHAR(765)               as description_c
  , a.json:RULE_END_DATE_C:: DATE                     as rule_end_date_c
  , a.json:RULE_START_DATE_C:: DATE                   as rule_start_date_c
  , a.json:SECURITY_IDENTIFIER_C:: VARCHAR(54)        as security_identifier_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ             as _fivetran_synced
  , a.json:IDENTIFIER_TYPE_C:: VARCHAR(3900)          as identifier_type_c
  , a.json:ACTIVE_C:: BOOLEAN                         as active_c
  , a.json:FINANCIAL_ACCOUNT_NUMBER_C:: VARCHAR(3900) as financial_account_number_c
  , a.json:ORION_ACCOUNT_ID_C:: VARCHAR(3900)         as orion_account_id_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                as _fivetran_deleted

  , a.effective_at::timestamp                         as effective_at
  , a._created_at::timestamp                          as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'holding_rule_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end              as is_latest
from {{ source('salesforce_compass', 'holding_rule_c') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'holding_rule_c') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at