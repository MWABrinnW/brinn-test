with cte_max_for_day as (
    select
        _created_at::date as _created_date
        , max(_created_at) as max_created_at
    from {{ source('activebatch','jobs') }}
    group by all
)

select
    id::int                                                                               as id
    , classid::int                                                                        as class_id
    , path::text(200)                                                                     as path
    , name::text(200)                                                                     as name
    , ref_label::text(200)                                                                as ref_label
    , ref_name::text(200)                                                                 as ref_name
    , nullif(ref_pid , '')::int                                                           as ref_pid
    , last_jobid::int                                                                     as last_jobid
    , enabled::boolean                                                                    as enabled
    , nullif(targetid , '')::int                                                          as target_id
    , pid::int                                                                            as pid
    , rid::int                                                                            as rid
    , status::int                                                                         as status
    , instancetype::int                                                                   as instancetype
    , to_timestamp_ntz(last_successful_execution_started_at , 'MM/DD/YYYY HH12:MI:SS AM') as last_successful_execution_started_at
    , script::text                                                                        as script
    , is_script_from_ref::int                                                             as is_script_from_ref
    , is_script_from_job::int                                                             as is_script_from_job
    , is_alteryx_related::int                                                             as is_alteryx_related
    , ayx_min_prop_value::text                                                            as ayx_min_prop_value
    , ayx_max_prop_value::text                                                            as ayx_max_prop_value
    , is_ref_obj::int                                                                     as is_ref_obj
    , _created_at::timestamp_ntz                                                          as _created_at

    , {{ col_is_head(
      reference=source('activebatch', 'jobs'),
      reference_date_col='_created_at',
      source_date_col='_created_at'
      ) }}
    , case when a._created_at = b.max_created_at then 1 else 0 end::int                   as is_head_for_day
from {{ source('activebatch','jobs') }} a
left join cte_max_for_day b
    on a._created_at::date = b._created_date
