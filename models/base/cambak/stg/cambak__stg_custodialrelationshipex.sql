select
    accountid::integer                                   as account_id
    , to_boolean(accountisclosed::text)::int             as account_is_closed
    , accountname::text                                  as account_name
    , accountnumber::text                                as account_number
    , accountnumberpattern::text                         as account_number_pattern
    , clientid::integer                                  as client_id
    , to_boolean(clientisclosed::text)::int              as client_is_closed
    , clientname::text                                   as clientname
    , custodialrelationshipid::integer                   as custodial_relationship_id
    , custodianid::text                                  as custodian_id
    , custodianname::text                                as custodian_name
    , firmid::integer                                    as firm_id
    , to_boolean(hascustodiandocuments::text)::int       as has_custodian_documents
    , to_boolean(hasrecentcustodiandocuments::text)::int as has_recent_custodian_documents
    , inceptiondate::text                                as inception_date
    , to_boolean(isclosed::text)::int                    as is_closed
    , to_boolean(isexplicitclose::text)::int             as is_explicit_close
    , notes::text                                        as notes
    , planid::integer                                    as plan_id
    , to_boolean(planisclosed::text)::int                as plan_is_closed
    , planname::text                                     as plan_name
    , primaryaccessmethodid::text                        as primary_access_method_id
    , proxyvotingtypeid::text                            as proxy_voting_type_id
    , proxyvotingtypestring::text                        as proxy_voting_type_string
    , relationshiptypeid::integer                        as relationship_type_id
    , relationshiptypestring::text                       as relationship_type_string
    , statementfrequency::integer                        as statement_frequency
    , trackingstartdate::text                            as tracking_start_date
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                    as _extracted_at
    , file_type::text                                    as file_type
    , _created_at::timestamp                             as _created_at
    , _source_file::text                                 as _source_file
from {{ source('cambak', 'custodialrelationshipex') }}
