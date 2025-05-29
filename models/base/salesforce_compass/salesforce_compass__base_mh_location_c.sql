select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OWNER_ID::varchar(18)                            as owner_id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:ACTIVE_C::boolean                                as active_c
    , a.json:CITY_C::varchar(300)                             as city_c
    , a.json:FINANCE_CODE_C::varchar(765)                     as finance_code_c
    , a.json:MARKET_C::varchar(150)                           as market_c
    , a.json:OFFICE_C::varchar(765)                           as office_c
    , a.json:PARTNER_FIRM_C::varchar(18)                      as partner_firm_c
    , a.json:REGION_C::varchar(150)                           as region_c
    , a.json:STATE_C::varchar(12)                             as state_c
    , a.json:EXCLUDE_FROM_MFIT_C::boolean                     as exclude_from_mfit_c
    , a.json:ACQUISITION_DATE_C::date                         as acquisition_date_c
    , a.json:ACQUISITION_TYPE_C::varchar(765)                 as acquisition_type_c
    , a.json:CURRENT_CRM_C::varchar(4099)                     as current_crm_c
    , a.json:CURRENT_IAA_VERSION_C::varchar(4099)             as current_iaa_version_c
    , a.json:CURRENT_OMS_C::varchar(4099)                     as current_oms_c
    , a.json:CURRENT_PMS_C::varchar(4099)                     as current_pms_c
    , a.json:LEGACY_CRM_C::varchar(4099)                      as legacy_crm_c
    , a.json:LEGACY_FIRM_NAME_C::varchar(300)                 as legacy_firm_name_c
    , a.json:LEGACY_OMS_C::varchar(4099)                      as legacy_oms_c
    , a.json:LEGACY_PMS_C::varchar(4099)                      as legacy_pms_c
    , a.json:NOTES_C::varchar(3000)                           as notes_c
    , a.json:SETUP_C::varchar(1500)                           as setup_c
    , a.json:X_1_MARINER_DATE_C::date                         as x_1_mariner_date_c
    , a.json:CRM_CONVERSION_DATE_C::date                      as crm_conversion_date_c
    , a.json:OMS_CONVERSION_DATE_C::date                      as oms_conversion_date_c
    , a.json:PMS_CONVERSION_DATE_C::date                      as pms_conversion_date_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:ACCOUNTING_ID_C::varchar(765)                    as accounting_id_c
    , a.json:SUPER_MARKET_C::varchar(150)                     as super_market_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'mh_location_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_head_for_day
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_latest
    , case
        when a._created_at = min(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_earliest
from {{ source('salesforce_compass', 'mh_location_c') }} as a
