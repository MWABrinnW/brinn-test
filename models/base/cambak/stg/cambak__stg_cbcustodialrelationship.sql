select
    custodialrelationshipid::int                                             as custodial_relationship_id
    , relationshiptypeid::int                                                as relationship_typeid
    , custodianid::int                                                       as custodian_id
    , accountid::int                                                         as account_id
    , statementfrequency::int                                                as statement_frequency
    , to_timestamp_ntz(trackingstartdate::text , 'MM/DD/YYYY HH12:MI:SS AM') as tracking_start_date
    , to_timestamp_ntz(inceptiondate::text , 'MM/DD/YYYY HH12:MI:SS AM')     as inception_date
    , to_boolean(isclosed::text)::int                                        as is_closed
    , to_boolean(isexplicitclose::text)::int                                 as is_explicit_close
    , accountnumber::text                                                    as account_number
    , firmid::int                                                            as firm_id
    , notes::text                                                            as notes
    , primaryaccessmethodid::int                                             as primary_access_method_id
    , accountnumberpattern::text                                             as account_number_pattern
    , proxyvotingtypeid::int                                                 as proxy_voting_typeid

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                        as _extracted_at
    , file_type::text                                                        as file_type
    , _created_at::timestamp                                                 as _created_at
    , _source_file::text                                                     as _source_file
from {{ source('cambak', 'cbcustodialrelationship') }}
