select
    a.json:ID:: VARCHAR(18)                                 as id
  , a.json:OWNER_ID:: VARCHAR(18)                           as owner_id
  , a.json:IS_DELETED:: BOOLEAN                             as is_deleted
  , a.json:NAME:: VARCHAR(240)                              as name
  , a.json:CREATED_DATE:: TIMESTAMPTZ                       as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)                      as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ                 as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)                as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ                    as system_modstamp
  , a.json:LAST_ACTIVITY_DATE:: DATE                        as last_activity_date
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ                   as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ               as last_referenced_date
  , a.json:CONTACT_NAME_C:: VARCHAR(240)                    as contact_name_c
  , a.json:EMAIL_ADDRESS_C:: VARCHAR(450)                   as email_address_c
  , a.json:MAILING_ADDRESS_C:: VARCHAR(450)                 as mailing_address_c
  , a.json:PHONE_C:: VARCHAR(120)                           as phone_c
  , a.json:STATEMENT_DELIVERY_C:: VARCHAR(765)              as statement_delivery_c
  , a.json:STATEMENT_DELIVERY_NOTIFICATION_C:: VARCHAR(765) as statement_delivery_notification_c
  , a.json:AVERAGE_DATE_DATA_AVAILABLE_C:: VARCHAR(765)     as average_date_data_available_c
  , a.json:DATA_SOURCE_C:: VARCHAR(765)                     as data_source_c
  , a.json:BO_RECONCILIATION_FREQUENCY_C:: VARCHAR(765)     as bo_reconciliation_frequency_c
  , a.json:LEGAL_NAME_C:: VARCHAR(300)                      as legal_name_c
  , a.json:LEGAL_ADDRESS_C:: VARCHAR(300)                   as legal_address_c
  , a.json:LEGAL_CITY_C:: VARCHAR(150)                      as legal_city_c
  , a.json:LEGAL_STATE_C:: VARCHAR(765)                     as legal_state_c
  , a.json:LEGAL_ZIP_CODE_C:: VARCHAR(45)                   as legal_zip_code_c
  , a.json:QUALIFIED_CUSTODIAN_C:: VARCHAR(765)             as qualified_custodian_c
  , a.json:QUALIFIED_LEGAL_NAME_C:: VARCHAR(300)            as qualified_legal_name_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ                   as _fivetran_synced
  , a.json:CURRENT_RECON_DATE_C:: DATE                      as current_recon_date_c
  , a.json:NOTES_C:: VARCHAR(765)                           as notes_c
  , a.json:DEFAULT_CASH_SYMBOL_C:: VARCHAR(225)             as default_cash_symbol_c
  , a.json:RECON_ASSIGNMENT_C:: VARCHAR(18)                 as recon_assignment_c
  , a.json:FUND_FAMILY_C:: VARCHAR(765)                     as fund_family_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN                      as _fivetran_deleted

  , a.effective_at::timestamp                               as effective_at
  , a._created_at::timestamp                                as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'custodian_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end                    as is_latest
from {{ source('salesforce_compass', 'custodian_c') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'custodian_c') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at