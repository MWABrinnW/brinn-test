{% set src = source('cambak', 'cbclient') %}
select
    to_boolean(isclosed::text)::int         as is_closed
    , riaid::int                            as ri_aid
    , to_boolean(istaxexempt::text)::int    as is_tax_exempt
    , relationshipendtypeid::int            as relationship_end_typeid
    , legalname::text                       as legal_name
    , to_boolean(reconciled::text)::int     as reconciled
    , closeddate::timestamp_ntz             as closed_date
    , clientname::text                      as client_name
    , classificationid::int                 as classification_id
    , regionid::int                         as region_id
    , relationshipendsubtypeid::int         as relationship_end_subtype_id
    , to_boolean(ishighpriority::text)::int as is_high_priority
    , clientsubtypeid::int                  as client_subtype_id
    , to_boolean(isprospect::text)::int     as is_prospect
    , notes::text                           as notes
    , stateid::int                          as state_id
    , clientid::int                         as client_id
    , relationshipenddate::timestamp_ntz    as relationship_end_date
    , firmid::int                           as firm_id
    , inceptiondate::timestamp_ntz          as inception_date
    , clienttypeid::int                     as client_typeid
    , clientgroupid::int                    as client_groupid
    , closeduserid::int                     as closed_userid
    , fiscalye::int                         as fiscal_ye
    , relationshipendnote::text             as relationship_endnote

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                       as _extracted_at
    , file_type::text                       as file_type
    , _created_at::timestamp                as _created_at
    , _source_file::text                    as _source_file
from {{ src }}
