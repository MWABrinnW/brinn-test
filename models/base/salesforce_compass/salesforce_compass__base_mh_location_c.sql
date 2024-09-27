select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:ACTIVE_C::boolean                                  as active_c
    , json:CITY_C::varchar(300)                               as city_c
    , json:FINANCE_CODE_C::varchar(765)                       as finance_code_c
    , json:MARKET_C::varchar(150)                             as market_c
    , json:OFFICE_C::varchar(765)                             as office_c
    , json:PARTNER_FIRM_C::varchar(18)                        as partner_firm_c
    , json:REGION_C::varchar(150)                             as region_c
    , json:STATE_C::varchar(12)                               as state_c
    , json:EXCLUDE_FROM_MFIT_C::boolean                       as exclude_from_mfit_c
    , json:ACQUISITION_DATE_C::date                           as acquisition_date_c
    , json:ACQUISITION_TYPE_C::varchar(765)                   as acquisition_type_c
    , json:CURRENT_CRM_C::varchar(4099)                       as current_crm_c
    , json:CURRENT_IAA_VERSION_C::varchar(4099)               as current_iaa_version_c
    , json:CURRENT_OMS_C::varchar(4099)                       as current_oms_c
    , json:CURRENT_PMS_C::varchar(4099)                       as current_pms_c
    , json:LEGACY_CRM_C::varchar(4099)                        as legacy_crm_c
    , json:LEGACY_FIRM_NAME_C::varchar(300)                   as legacy_firm_name_c
    , json:LEGACY_OMS_C::varchar(4099)                        as legacy_oms_c
    , json:LEGACY_PMS_C::varchar(4099)                        as legacy_pms_c
    , json:NOTES_C::varchar(3000)                             as notes_c
    , json:SETUP_C::varchar(1500)                             as setup_c
    , json:X_1_MARINER_DATE_C::date                           as x_1_mariner_date_c
    , json:CRM_CONVERSION_DATE_C::date                        as crm_conversion_date_c
    , json:OMS_CONVERSION_DATE_C::date                        as oms_conversion_date_c
    , json:PMS_CONVERSION_DATE_C::date                        as pms_conversion_date_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:ACCOUNTING_ID_C::varchar(765)                      as accounting_id_c
    , json:SUPER_MARKET_C::varchar(150)                       as super_market_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'mh_location_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'mh_location_c') }}
