select
    effective_at                                    as effective_at
    , _created_at                                   as _created_at
    , json:CONTENT_SEND_IF_VIEW_EMPTY::string       as content_send_if_view_empty
    , json:CONTENT_TYPE::string                     as content_type
    , json:ID::string                               as id
    , json:USER_ID::string                          as user_id
    , json:SITE_ID::string                          as site_id
    , json:_FIVETRAN_DELETED::string                as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::string                 as _fivetran_synced
    , json:CONTENT_ID::string                       as content_id
    , json:SCHEDULE_FREQUENCY_DETAILS_START::string as schedule_frequency_details_start
    , json:ATTACH_IMAGE::string                     as attach_image
    , json:SUSPENDED::string                        as suspended
    , json:SUBJECT::string                          as subject
    , json:ATTACH_PDF::string                       as attach_pdf
    , json:PAGE_ORIENTATION::string                 as page_orientation
    , json:PAGE_SIZE_OPTION::string                 as page_size_option
    , {{ col_is_head(
    reference=source('tableau_mwa', 'subscription'),
    source_date_col='effective_at',
    reference_date_col='effective_at'
    ) }}
from {{ source('tableau_mwa', 'subscription') }}
