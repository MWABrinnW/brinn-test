{% set src = source('cambak', 'cbplan') %}
select
    planid::int                                  as plan_id
    , planname::text                             as plan_name
    , plantypeid::int                            as plan_type_id
    , clientid::int                              as client_id
    , to_boolean(isclosed::text)::int            as is_closed
    , to_boolean(isexplicitclose::text)::int     as is_explicit_close
    , plansubtypeid::int                         as plan_subtype_id
    , inceptiondate::timestamp_ntz               as inception_date
    , notes::text                                as notes
    , discretionlevelid::int                     as discretion_level_id
    , relationshipstartdate::timestamp_ntz       as relationship_start_date
    , bidtypeid::int                             as bid_type_id
    , sourcetypeid::int                          as source_type_id
    , sourcesubtypeid::int                       as source_subtype_id
    , to_boolean(isprospect::text)::int          as is_prospect
    , relationshipenddate::timestamp_ntz         as relationship_end_date
    , relationshipendtypeid::int                 as relationship_end_type_id
    , relationshipendsubtypeid::int              as relationship_end_subtype_id
    , relationshipendnote::text                  as relationship_end_note
    , sourcenotes::text                          as source_notes
    , closeduserid::int                          as closed_user_id
    , closeddate::timestamp_ntz                  as closed_date
    , cridforfee::int                            as cr_id_for_fee
    , to_boolean(requiresproxyvoting::text)::int as requires_proxy_voting

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                            as _extracted_at
    , file_type::text                            as file_type
    , _created_at::timestamp                     as _created_at
    , _source_file::text                         as _source_file
from {{ source('cambak', 'cbplan') }}
