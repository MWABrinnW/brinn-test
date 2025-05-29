select
    json:CATEGORY::varchar(200)                      as category
    , json:COMPONENTSTATE::varchar(200)              as component_state
    , json:CONNECTIONROLEID::varchar(200)            as connection_role_id
    , json:CONNECTIONROLEIDUNIQUE::varchar(200)      as connection_role_id_unique
    , json:CREATEDON::timestamp_ntz                  as created_at
    , effective_at::timestamp_ntz                    as effective_at
    , json:DESCRIPTION::varchar(200)                 as description
    , json:INTRODUCEDVERSION::varchar(200)           as introduced_version
    , nullif(json:ISCUSTOMIZABLE , '')::varchar(200) as is_customizable
    , json:ISMANAGED::boolean                        as is_managed
    , json:MODIFIEDON::timestamp_ntz                 as modified_at
    , json:NAME::varchar(200)                        as name
    , json:OVERWRITETIME::timestamp_ntz              as overwrite_at
    , json:SOLUTIONID::varchar(200)                  as solution_id
    , json:STATECODE::integer                        as state_code
    , json:STATUSCODE::integer                       as status_code
    , json:VERSIONNUMBER::integer                    as version_number
    , json:_CREATEDBY_VALUE::varchar(200)            as _created_by_value
    , json:_CREATEDONBEHALFBY_VALUE::varchar(200)    as _created_on_behalf_by_value
    , json:_FIVETRAN_DELETED::integer                as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz           as _fivetran_synced
    , json:_MODIFIEDBY_VALUE::varchar(200)           as _modified_by_value
    , json:_MODIFIEDONBEHALFBY_VALUE::varchar(200)   as _modified_on_behalf_by_value
    , json:_ORGANIZATIONID_VALUE::varchar(200)       as _organization_id_value
    , _created_at::timestamp_ntz                     as _created_at
    , {{ col_is_head(
        reference = source('dynamics_tamarac_cpg', 'connectionrole'),
        reference_date_col = 'effective_at::date',
        source_date_col = 'effective_at::date') }}
    , case
        when _created_at = max(_created_at) over (
                partition by effective_at::date
            )
            then 1
        else 0
    end::int                                         as is_head_for_day

from
    {{ source('dynamics_tamarac_cpg', 'connectionrole') }}
