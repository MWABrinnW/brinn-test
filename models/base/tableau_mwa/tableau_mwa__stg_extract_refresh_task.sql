select
    effective_at                                               as effective_at
    , _created_at                                              as _created_at
    , json:WORKBOOK_ID::string                                 as workbook_id
    , json:ID::string                                          as id
    , json:SITE_ID::string                                     as site_id
    , json:PRIORITY::string                                    as priority
    , json:_FIVETRAN_DELETED::string                           as _fivetran_deleted
    , json:SCHEDULE_NEXT_RUN_AT::string                        as schedule_next_run_at
    , json:TYPE::string                                        as type
    , json:SCHEDULE_FREQUENCY::string                          as schedule_frequency
    , json:CONSECUTIVE_FAILED_COUNT::string                    as consecutive_failed_count
    , json:_FIVETRAN_SYNCED::string                            as _fivetran_synced
    , json:SCHEDULE_FREQUENCY_DETAILS_START::string            as schedule_frequency_details_start
    , json:SCHEDULE_FREQUENCY_DETAILS_INTERVAL_WEEKDAY::string as schedule_frequency_details_interval_weekday
    , {{ col_is_head(
    reference=source('tableau_mwa', 'extract_refresh_task'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'extract_refresh_task') }}
