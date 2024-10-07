select
    json:CREATEDON::timestamp_ntz                  as created_at
    , effective_at::timestamp_ntz                  as effective_at
    , json:MODIFIEDON::timestamp_ntz               as modified_at
    , json:TAM_ACCOUNTTYPEID::varchar(200)         as tam_account_type_id
    , json:TAM_NAME::varchar(200)                  as tam_name
    , json:STATECODE::integer                      as state_code
    , json:STATUSCODE::integer                     as status_code
    , json:VERSIONNUMBER::integer                  as version_number
    , json:_CREATEDBY_VALUE::varchar(200)          as _created_by_value
    , json:_FIVETRAN_DELETED::integer              as _fivetran_deleted
    , json:_FIVETRAN_SYNCED::timestamp_ntz         as _fivetran_synced
    , json:_MODIFIEDBY_VALUE::varchar(200)         as _modified_by_value
    , json:_OWNERID_VALUE::varchar(200)            as _owner_id_value
    , json:_OWNINGBUSINESSUNIT_VALUE::varchar(200) as _owning_business_unit_value
    , json:_OWNINGUSER_VALUE::varchar(200)         as _owning_user_value
    , _created_at::timestamp_ntz                   as _created_at
    , {{ col_is_head(reference = source('dynamics_tamarac_cpg', 'tam_accounttype'), 
            reference_date_col = 'effective_at::date', 
            source_date_col = 'effective_at::date') }}
    , case when
            dense_rank() over (partition by effective_at::date order by date_trunc('second' , _created_at) desc) = 1
            then 1
        else 0
    end::int                                       as is_head_for_day
from {{ source('dynamics_tamarac_cpg', 'tam_accounttype') }}
