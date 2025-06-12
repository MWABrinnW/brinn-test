select
    json:ID::text                                                   as id
    , json:NAME::text                                               as name
    , json:CREATED_BY_ID::int                                       as created_by_id
    , json:FILTERS_UPDATED_AT::text                                 as filters_updated_at
    , json:LIST_VERSION::int                                        as list_version
    , json:UPDATED_AT::text                                         as updated_at
    , json:CREATED_AT::text                                         as created_at
    , json:OBJECT_TYPE_ID::text                                     as object_type_id
    , json:PROCESSING_STATUS::text                                  as processing_status
    , json:PROCESSING_TYPE::text                                    as processing_type
    , json:PROPERTY_HS_CLASSIC_LIST_ID::int                         as property_hs_classic_list_id
    , json:PROPERTY_HS_CLICK_THROUGH_RATE::int                      as property_hs_click_through_rate
    , json:PROPERTY_HS_CREATEDATE::int                              as property_hs_create_date
    , json:PROPERTY_HS_CREATED_AT::int                              as property_hs_created_at
    , json:PROPERTY_HS_CREATED_BY_USER_ID::int                      as property_hs_created_by_userid
    , json:PROPERTY_HS_DEFINITION_UPDATED_AT::int                   as property_hs_definition_updated_at
    , json:PROPERTY_HS_DESCRIPTION::text                            as property_hs_description
    , json:PROPERTY_HS_EMAIL_OPEN_RATE::float                       as property_hs_email_open_rate
    , try_to_boolean(json:PROPERTY_HS_GENERATED_BY_AI::text)::int   as property_hs_generated_by_a_i
    , try_to_boolean(json:PROPERTY_HS_IS_LIMIT_EXEMPT::text)::int   as property_hs_is_limit_exempt
    , try_to_boolean(json:PROPERTY_HS_IS_LOOKALIKE_LIST::text)::int as property_hs_is_lookalike_list
    , try_to_boolean(json:PROPERTY_HS_IS_PUBLIC::text)::int         as property_hs_is_public
    , try_to_boolean(json:PROPERTY_HS_IS_READ_ONLY::text)::int      as property_hs_isreadonly
    , json:PROPERTY_HS_LASTMODIFIEDDATE::int                        as property_hs_last_modified_date
    , json:PROPERTY_HS_LAST_RECORD_ADDED_AT::int                    as property_hs_last_record_added_at
    , json:PROPERTY_HS_LAST_RECORD_REMOVED_AT::int                  as property_hs_last_record_removed_at
    , json:PROPERTY_HS_LIST_ACCESS_LEVEL::text                      as property_hs_list_access_level
    , json:PROPERTY_HS_LIST_ID::int                                 as property_hs_list_id
    , json:PROPERTY_HS_LIST_NAME::text                              as property_hs_listname
    , json:PROPERTY_HS_LIST_REFERENCE_COUNT::int                    as property_hs_list_reference_count
    , json:PROPERTY_HS_LIST_SIZE::int                               as property_hs_list_size
    , json:PROPERTY_HS_LIST_SIZE_WEEK_DELTA::int                    as property_hs_list_size_week_delta
    , json:PROPERTY_HS_LIST_VERSION::int                            as property_hs_list_version
    , json:PROPERTY_HS_NUM_REFERENCES_BLOCKING_DELETE::int          as property_hs_num_references_blocking_delete
    , json:PROPERTY_HS_OBJECT_ID::int                               as property_hs_objectid
    , json:PROPERTY_HS_OBJECT_SOURCE::text                          as property_hs_object_source
    , json:PROPERTY_HS_OBJECT_SOURCE_ID::text                       as property_hs_object_sourceid
    , json:PROPERTY_HS_OBJECT_SOURCE_LABEL::text                    as property_hs_object_source_label
    , json:PROPERTY_HS_OBJECT_SOURCE_USER_ID::int                   as property_hs_object_source_userid
    , json:PROPERTY_HS_OBJECT_TYPE_ID::text                         as property_hs_object_type_id
    , json:PROPERTY_HS_PROCESSING_STATUS::text                      as property_hs_processing_status
    , json:PROPERTY_HS_PROCESSING_TYPE::text                        as property_hs_processing_type
    , json:PROPERTY_HS_TOTAL_SIZE_CALCULATED_AT::int                as property_hs_total_size_calculated_at
    , json:PROPERTY_HS_UNIQUE_LIST_REFERENCE_TYPES::text            as property_hs_unique_list_reference_types
    , json:PROPERTY_HS_UPDATED_AT::int                              as property_hs_updated_at
    , json:PROPERTY_HS_UPDATED_BY_USER_ID::int                      as property_hs_updated_by_userid
    , json:_FIVETRAN_DELETED::text                                  as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::text                                   as _fivetran_synced

    , effective_at::timestamp                                       as effective_at
    , _created_at::timestamp                                        as _created_at
    , {{ col_is_head(reference=source('hubspot_advisor_recruiting', 'contact_list')
                , source_date_col='effective_at'
                , reference_date_col='effective_at') }}
    , case when _created_at = max(_created_at)
                over (
                    partition by effective_at::date
                )
            then 1
        else 0
    end                                                             as is_latest
from {{ source('hubspot_advisor_recruiting', 'contact_list') }}
where effective_at is not null
