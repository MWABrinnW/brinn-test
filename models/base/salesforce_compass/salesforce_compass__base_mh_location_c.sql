select
    a.json:ID:: VARCHAR(18)                      as id
  , a.json:OWNER_ID:: VARCHAR(18)                as owner_id
  , a.json:IS_DELETED:: BOOLEAN                  as is_deleted
  , a.json:NAME:: VARCHAR(240)                   as name
  , a.json:CREATED_DATE:: TIMESTAMPTZ            as created_date
  , a.json:CREATED_BY_ID:: VARCHAR(18)           as created_by_id
  , a.json:LAST_MODIFIED_DATE:: TIMESTAMPTZ      as last_modified_date
  , a.json:LAST_MODIFIED_BY_ID:: VARCHAR(18)     as last_modified_by_id
  , a.json:SYSTEM_MODSTAMP:: TIMESTAMPTZ         as system_modstamp
  , a.json:LAST_VIEWED_DATE:: TIMESTAMPTZ        as last_viewed_date
  , a.json:LAST_REFERENCED_DATE:: TIMESTAMPTZ    as last_referenced_date
  , a.json:ACTIVE_C:: BOOLEAN                    as active_c
  , a.json:CITY_C:: VARCHAR(300)                 as city_c
  , a.json:FINANCE_CODE_C:: VARCHAR(765)         as finance_code_c
  , a.json:MARKET_C:: VARCHAR(150)               as market_c
  , a.json:OFFICE_C:: VARCHAR(765)               as office_c
  , a.json:PARTNER_FIRM_C:: VARCHAR(18)          as partner_firm_c
  , a.json:REGION_C:: VARCHAR(150)               as region_c
  , a.json:STATE_C:: VARCHAR(12)                 as state_c
  , a.json:EXCLUDE_FROM_MFIT_C:: BOOLEAN         as exclude_from_mfit_c
  , a.json:ACQUISITION_DATE_C:: DATE             as acquisition_date_c
  , a.json:ACQUISITION_TYPE_C:: VARCHAR(765)     as acquisition_type_c
  , a.json:CURRENT_CRM_C:: VARCHAR(4099)         as current_crm_c
  , a.json:CURRENT_IAA_VERSION_C:: VARCHAR(4099) as current_iaa_version_c
  , a.json:CURRENT_OMS_C:: VARCHAR(4099)         as current_oms_c
  , a.json:CURRENT_PMS_C:: VARCHAR(4099)         as current_pms_c
  , a.json:LEGACY_CRM_C:: VARCHAR(4099)          as legacy_crm_c
  , a.json:LEGACY_FIRM_NAME_C:: VARCHAR(300)     as legacy_firm_name_c
  , a.json:LEGACY_OMS_C:: VARCHAR(4099)          as legacy_oms_c
  , a.json:LEGACY_PMS_C:: VARCHAR(4099)          as legacy_pms_c
  , a.json:NOTES_C:: VARCHAR(3000)               as notes_c
  , a.json:SETUP_C:: VARCHAR(1500)               as setup_c
  , a.json:X_1_MARINER_DATE_C:: DATE             as x_1_mariner_date_c
  , a.json:CRM_CONVERSION_DATE_C:: DATE          as crm_conversion_date_c
  , a.json:OMS_CONVERSION_DATE_C:: DATE          as oms_conversion_date_c
  , a.json:PMS_CONVERSION_DATE_C:: DATE          as pms_conversion_date_c
  , a.json:_FIVETRAN_SYNCED:: TIMESTAMPTZ        as _fivetran_synced
  , a.json:ACCOUNTING_ID_C:: VARCHAR(765)        as accounting_id_c
  , a.json:SUPER_MARKET_C:: VARCHAR(150)         as super_market_c
  , a.json:_FIVETRAN_DELETED:: BOOLEAN           as _fivetran_deleted

  , a.effective_at::timestamp                    as effective_at
  , a._created_at::timestamp                     as _created_at
  , {{ col_is_head(reference=source('salesforce_compass', 'mh_location_c'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , case when b.rn = 1 then 1 else 0 end         as is_latest
from {{ source('salesforce_compass', 'mh_location_c') }} a
left join (
  select effective_at::date as effective_at, _created_at, row_number() over(partition by effective_at::date order by _created_at desc) as rn
  from {{ source('salesforce_compass', 'mh_location_c') }}
  group by 1,2
) b
on a.effective_at::date = b.effective_at::date
    and a._created_at = b._created_at