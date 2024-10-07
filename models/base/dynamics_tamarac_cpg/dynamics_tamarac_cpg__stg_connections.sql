select
    json:CONNECTIONID::varchar(200)                   as connection_id
    , json:CREATEDON::timestamp_ntz                   as created_at
    , effective_at::timestamp_ntz                     as effective_at
    , json:EFFECTIVEEND::timestamp_ntz                as effective_end_at
    , json:EXCHANGERATE::decimal(20 , 2)              as exchange_rate
    , json:IMPORTSEQUENCENUMBER::integer              as import_sequence_number
    , json:ISMASTER::boolean                          as is_master
    , json:MODIFIEDON::timestamp_ntz                  as modified_at
    , json:NAME::varchar(200)                         as name
    , json:RECORD_1_OBJECTTYPECODE::integer           as record_1_object_type_code
    , json:RECORD_2_OBJECTTYPECODE::integer           as record_2_object_type_code
    , json:STATECODE::integer                         as state_code
    , json:STATUSCODE::integer                        as status_code
    , json:VERSIONNUMBER::integer                     as version_number
    , json:_CREATEDBY_VALUE::varchar(200)             as _created_by_value
    , json:_FIVETRAN_DELETED::integer                 as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz            as _fivetran_synced
    , json:_MODIFIEDBY_VALUE::varchar(200)            as _modified_by_value
    , json:_OWNERID_VALUE::varchar(200)               as _owner_id_value
    , json:_OWNINGBUSINESSUNIT_VALUE::varchar(200)    as _owning_business_unit_value
    , json:_OWNINGUSER_VALUE::varchar(200)            as _owning_user_value
    , json:_RECORD_1_ID_VALUE::varchar(200)           as _record_1_id_value
    , json:_RECORD_1_ROLEID_VALUE::varchar(200)       as _record_1_role_id_value
    , json:_RECORD_2_ID_VALUE::varchar(200)           as _record_2_id_value
    , json:_RECORD_2_ROLEID_VALUE::varchar(200)       as _record_2_role_id_value
    , json:_RELATEDCONNECTIONID_VALUE::varchar(200)   as _related_connection_id_value
    , json:_CREATEDONBEHALFBY_VALUE::varchar(200)     as _created_on_behalf_by_value
    , json:_MODIFIEDONBEHALFBY_VALUE::varchar(200)    as _modified_on_behalf_by_value
    , json:_TRANSACTIONCURRENCYID_VALUE::varchar(200) as _transaction_currency_id_value
    , _created_at::timestamp_ntz                      as _created_at
    , {{ col_is_head(reference = source('dynamics_tamarac_cpg', 'connection'), 
            reference_date_col = 'effective_at::date', 
            source_date_col = 'effective_at::date') }}
    , case when
            dense_rank() over (partition by effective_at::date order by date_trunc('second' , _created_at) desc) = 1
            then 1
        else 0
    end::int                                          as is_head_for_day
from
    {{ source('dynamics_tamarac_cpg', 'connection') }}
