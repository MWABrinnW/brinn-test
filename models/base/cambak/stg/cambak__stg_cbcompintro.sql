select
    compintroid::int                                                      as comp_intro_id
    , billingdefinitionid::int                                            as billing_definition_id
    , recipientid::int                                                    as recipient_id
    , compfactor::float                                                   as comp_factor
    , to_timestamp_ntz(effectivedate::text , 'MM/DD/YYYY HH12:MI:SS AM')  as effective_date
    , to_timestamp_ntz(expirationdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as expiration_date

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                     as _extracted_at
    , file_type::text                                                     as file_type
    , _created_at::timestamp                                              as _created_at
    , _source_file::text                                                  as _source_file
from {{ source('cambak', 'cbcompintro') }}
