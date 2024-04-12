select
    g.system_name           as system_name
    , g.system_instance     as system_instance
    , g.system_key          as system_key
    , g.firm_source         as firm_source
    , gmem.value::text(200) as member_dn
    , g.distinguishedname   as group_dn
    , g.name                as group_name
    , g.distinguishedname   as group_dn
    , g.description         as group_description
    , g.whencreated         as group_created_at
    , g.whenchanged         as group_modified_at
    , g.groupcategory       as group_category
    , g.objectcategory      as group_object_category
    , g.samaccountname      as group_sam_account_name
    , g.samaccounttype      as group_sam_account_type
    , g.canonicalname       as group_canonical_name

    , g.is_head             as is_head
    , g._effective_at       as _effective_at
    , g._created_at         as _created_at
    , g._source_file        as _source_file
from {{ ref('active_directory__stg_groups') }} as g
, table(flatten(g.members , outer => true)) as gmem
where g.rn_day = 1
