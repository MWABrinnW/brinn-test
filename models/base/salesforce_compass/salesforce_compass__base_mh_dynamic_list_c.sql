select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , json:ID::varchar(18)                                    as id
    , json:OWNER_ID::varchar(18)                              as owner_id
    , json:IS_DELETED::boolean                                as is_deleted
    , json:NAME::varchar(240)                                 as name
    , json:RECORD_TYPE_ID::varchar(18)                        as record_type_id
    , json:CREATED_DATE::timestamptz                          as created_date
    , json:CREATED_BY_ID::varchar(18)                         as created_by_id
    , json:LAST_MODIFIED_DATE::timestamptz                    as last_modified_date
    , json:LAST_MODIFIED_BY_ID::varchar(18)                   as last_modified_by_id
    , json:SYSTEM_MODSTAMP::timestamptz                       as system_modstamp
    , json:LAST_VIEWED_DATE::timestamptz                      as last_viewed_date
    , json:LAST_REFERENCED_DATE::timestamptz                  as last_referenced_date
    , json:APPROVED_CUSTODIAN_C::boolean                      as approved_custodian_c
    , json:IS_QUALIFIED_C::boolean                            as is_qualified_c
    , json:SORT_ORDER_C::double                               as sort_order_c
    , json:TEXT_VALUE_1_C::varchar(150)                       as text_value_1_c
    , json:_FIVETRAN_SYNCED::timestamptz                      as _fivetran_synced
    , json:OCCUPATION_TYPE_C::varchar(765)                    as occupation_type_c
    , json:KEYWORDS_C::varchar(98304)                         as keywords_c
    , json:OCCUPATION_SUBTYPE_C::varchar(765)                 as occupation_subtype_c
    , json:INVOICE_ON_QPR_C::boolean                          as invoice_on_qpr_c
    , json:ERISA_C::varchar(765)                              as erisa_c
    , json:_FIVETRAN_DELETED::boolean                         as _fivetran_deleted

    , effective_at::timestamp                                 as effective_at
    , _created_at::timestamp                                  as _created_at
    , {{ col_is_head(
    reference=source('salesforce_compass', 'mh_dynamic_list_c')
    , source_date_col='effective_at'
    , reference_date_col='effective_at') }}
    , case when dense_rank() over (partition by effective_at::date order by _created_at desc) = 1
            then 1
        else 0
    end                                                       as is_latest
from {{ source('salesforce_compass', 'mh_dynamic_list_c') }}
