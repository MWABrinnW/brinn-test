select
    json:ATTRIBUTENAME::varchar(200)       as attribute_name
    , json:ATTRIBUTEVALUE::varchar(200)    as attribute_value
    , json:DISPLAYORDER::integer           as display_order
    , effective_at::timestamp_ntz          as effective_at
    , json:LANGID::varchar(200)            as lang_id
    , json:OBJECTTYPECODE::varchar(200)    as object_type_code
    , json:ORGANIZATIONID::varchar(200)    as organization_id
    , json:STRINGMAPID::varchar(200)       as string_map_id
    , json:VALUE::varchar(200)             as value
    , json:VERSIONNUMBER::integer          as version_number
    , json:_FIVETRAN_DELETED::integer      as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz as _fivetran_synced
    , _created_at::timestamp_ntz           as _created_at
    , {{ col_is_head(reference = source('dynamics_tamarac_cpg', 'stringmap'), 
            reference_date_col = 'effective_at::date', 
            source_date_col = 'effective_at::date') }}
    , case when
            dense_rank() over (partition by effective_at::date order by date_trunc('second' , _created_at) desc) = 1
            then 1
        else 0
    end::int                               as is_head_for_day
from {{ source('dynamics_tamarac_cpg', 'stringmap') }}
