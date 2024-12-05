with cte_fresh_dates as (
    select _effective_at::date as effective_date
    from {{ ref('active_directory__stg_groups') }}
    where _effective_at > (select max(t._effective_at) from {{ ref('active_directory__rpt_group_members_history') }} as t)
    group by all
)

, cte_groups as (
    select
        g.system_name           as system_name
        , g.system_instance     as system_instance
        , g.system_key          as system_key
        , g.firm_source         as firm_source
        , g.distinguishedname   as distinguishedname
        , g.name                as name
        , g.description         as description
        , g.whencreated         as whencreated
        , g.whenchanged         as whenchanged
        , g.groupcategory       as groupcategory
        , g.objectcategory      as objectcategory
        , g.samaccountname      as samaccountname
        , g.samaccounttype      as samaccounttype
        , g.canonicalname       as canonicalname
        , g.members             as members
        , gmem.value::text(200) as member_dn
        , g._effective_at       as _effective_at
        , g._created_at         as _created_at
        , g._source_file        as _source_file

    from {{ ref('active_directory__stg_groups') }} as g
    , table(flatten(g.members , outer => true)) as gmem
    where 1 = 1
        and g._effective_at::date in (select t.effective_date from cte_fresh_dates as t)
)

, cte_users as (
    select
        name
        , canonical_name
        , object_class
        , employee_number
        , employee_id
        , _effective_at
        , distinguished_name
    from {{ ref('active_directory__rpt_users') }}
    where 1 = 1
        and _effective_at::date in (select t.effective_date from cte_fresh_dates as t)
)

select
    g.system_name             as system_name
    , g.system_instance       as system_instance
    , g.system_key            as system_key
    , g.firm_source           as firm_source

    , g.name                  as group_name
    , g.distinguishedname     as group_dn
    , g.description           as group_description
    , g.whencreated           as group_created_at
    , g.whenchanged           as group_modified_at
    , g.groupcategory         as group_category
    , g.objectcategory        as group_object_category
    , g.samaccountname        as group_sam_account_name
    , g.samaccounttype        as group_sam_account_type
    , g.canonicalname         as group_canonical_name

    , g.member_dn             as member_dn
    , u.name::text            as member_name
    , u.canonical_name::text  as member_canonical_name
    , u.object_class::text    as member_object_class
    , u.employee_number::text as member_employee_number
    , u.employee_id::text     as member_employee_id

    , g._effective_at         as _effective_at
    , g._created_at           as _created_at
    , g._source_file          as _source_file
from cte_groups as g
left join cte_users as u
    on g._effective_at::date = u._effective_at::date
    and g.member_dn = u.distinguished_name
qualify dense_rank() over (
    partition by g._effective_at::date , g.distinguishedname order by g._created_at desc
) = 1
