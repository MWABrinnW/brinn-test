with cte_rnk as (
    select
        record_datetime::date as record_date
        , record_datetime
        , dense_rank() over (
            partition by record_datetime::date order by record_datetime desc
        )                     as rn_day
    from {{ source('active_directory_mwa', 'groups_history') }}
    group by 1 , 2
)

select
    'active_directory'::text(200)                  as system_name
    , 'mwa'::text(200)                             as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'::text(200)                             as firm_source
    , g.dn::text(200)                              as group_id
    , g.primarygrouptoken::text(200)               as group_token
    , g.name::text(200)                            as group_name
    , g.distinguishedname::text(200)               as group_dn
    , g.description::text(500)                     as group_description
    , g.whencreated::timestamp                     as group_created_at
    , g.whenchanged::timestamp                     as group_modified_at
    , g.objectcategory::text(200)                  as group_object_category
    , null::text(200)                              as group_object_category
    , null::text(200)                              as group_category
    , g.samaccountname::text(200)                  as group_sam_account_name
    , g.samaccounttype::int                        as group_sam_account_type
    , g.canonicalname::text(200)                   as group_canonical_name

    , g.member::text(500)                          as member_dn

    , g.record_date::date                          as record_date
    , g.record_datetime::timestamp                 as _created_at
    , {{ col_is_head(
      reference=source('active_directory_mwa', 'groups_history'),
      reference_date_col='record_datetime::timestamp',
      source_date_col='g.record_datetime::timestamp'
      ) }}
    , rnk.rn_day                                   as rn_day
from {{ source('active_directory_mwa', 'groups_history') }} as g
inner join cte_rnk as rnk
    on g.record_datetime = rnk.record_datetime
