select
    system_name         as system_name
    , system_instance   as system_instance
    , system_key        as system_key
    , firm_source       as firm_source

    , name              as name
    , distinguishedname as distinguished_name
    , cn                as cn
    , canonicalname     as canonical_name
    , description       as description
    , whencreated       as created_at
    , whenchanged       as modified_at
    , groupcategory     as group_category
    , objectclass       as object_class
    , objectcategory    as object_category
    , samaccountname    as sam_account_name
    , samaccounttype    as sam_account_type
    , memberof          as member_of

    , is_head           as is_head
    , _effective_at     as _effective_at
    , _created_at       as _created_at
    , _source_file      as _source_file
from {{ ref('active_directory__stg_groups') }}
where rn_day = 1

union all

select
    system_name         as system_name
    , system_instance   as system_instance
    , system_key        as system_key
    , firm_source       as firm_source

    , group_name        as name
    , distinguishedname as distinguished_name
    , cn                as cn
    , canonicalname     as canonical_name
    , description       as description
    , whencreated       as created_at
    , whenchanged       as modified_at
    , null::text(200)   as group_category
    , objectclass       as object_class
    , objectcategory    as object_category
    , samaccountname    as sam_account_name
    , samaccounttype    as sam_account_type
    , null::variant     as member_of

    , 0::int            as is_head
    , _created_at       as _effective_at
    , _created_at       as _created_at
    , null::text(200)   as _source_file
from {{ ref('active_directory_mwa__stg_groups') }}
where rn_day = 1
    -- Exclude historical records from old ETL
    and _created_at::date < (select min(_effective_at::date) from {{ ref('active_directory__stg_groups') }})
