with part1 as (
    select
        level8.name   as level8_name
        , level7.name as level7_name
        , level6.name as level6_name
        , level5.name as level5_name
        , level4.name as level4_name
        , level3.name as level3_name
        , level2.name as level2_name
        , level1.name as level1_name
        , coalesce(
            level8.level
            , level7.level
            , level6.level
            , level5.level
            , level4.level
            , level3.level
            , level2.level
            , level1.level
        )             as source_level
        , coalesce(
            level8.name
            , level7.name
            , level6.name
            , level5.name
            , level4.name
            , level3.name
            , level2.name
            , level1.name
        )             as natural_account_id
        , coalesce(
            level8.description
            , level7.description
            , level6.description
            , level5.description
            , level4.description
            , level3.description
            , level2.description
            , level1.description
        )             as description
        , coalesce(
            level8.is_enabled
            , level7.is_enabled
            , level6.is_enabled
            , level5.is_enabled
            , level4.is_enabled
            , level3.is_enabled
            , level2.is_enabled
            , level1.is_enabled
        )             as is_enabled
        , coalesce(
            level8.end_date
            , level7.end_date
            , level6.end_date
            , level5.end_date
            , level4.end_date
            , level3.end_date
            , level2.end_date
            , level1.end_date
        )             as end_date
        , coalesce(
            level8.account_type
            , level7.account_type
            , level6.account_type
            , level5.account_type
            , level4.account_type
            , level3.account_type
            , level2.account_type
            , level1.account_type
        )             as account_type
    from {{ ref('edm__stg_natural_account_level1') }} as level1
    left outer join {{ ref('edm__stg_natural_account_level2') }} as level2
        on level1.name = level2.parent
        and level1.effective_date = level2.effective_date
    left outer join {{ ref('edm__stg_natural_account_level3') }} as level3
        on level2.name = level3.parent
        and level1.effective_date = level3.effective_date
    left outer join {{ ref('edm__stg_natural_account_level4') }} as level4
        on level3.name = level4.parent
        and level1.effective_date = level4.effective_date
    left outer join {{ ref('edm__stg_natural_account_level5') }} as level5
        on level4.name = level5.parent
        and level1.effective_date = level5.effective_date
    left outer join {{ ref('edm__stg_natural_account_level6') }} as level6
        on level5.name = level6.parent
        and level1.effective_date = level6.effective_date
    left outer join {{ ref('edm__stg_natural_account_level7') }} as level7
        on level6.name = level7.parent
        and level1.effective_date = level7.effective_date
    left outer join {{ ref('edm__stg_natural_account_level8') }} as level8
        on level7.name = level8.parent
        and level1.effective_date = level8.effective_date
    where level1.is_head = 1
)

, natural_account_parent as (
    select
        parent
        , effective_date
    from {{ ref('edm__stg_natural_account') }}
    where is_head = 1
        and parent is not null
    group by all
)

, part2 as (
    select
        na_all.level  as source_level
        , na_all.name as natural_account_id
        , na_all.description
        , na_all.is_enabled
        , na_all.end_date
        , na_all.account_type
        , level8.name as level8_name
        , case
            when na_all.level = 7 then na_all.name
            else coalesce(level7.name , level7b.name)
        end           as level7_name
        , case
            when na_all.level = 6 then na_all.name
            else coalesce(level6.name , level6b.name)
        end           as level6_name
        , case
            when na_all.level = 5 then na_all.name
            else coalesce(level5.name , level5b.name)
        end           as level5_name
        , case
            when na_all.level = 4 then na_all.name
            else coalesce(level4.name , level4b.name)
        end           as level4_name
        , case
            when na_all.level = 3 then na_all.name
            else coalesce(level3.name , level3b.name)
        end           as level3_name
        , case
            when na_all.level = 2 then na_all.name
            else coalesce(level2.name , level2b.name)
        end           as level2_name
        , case
            when na_all.level = 1 then na_all.name
            else coalesce(level1.name , level1b.name)
        end           as level1_name
    from {{ ref('edm__stg_natural_account') }} as na_all

    inner join natural_account_parent as na_prnt
        on na_all.name = na_prnt.parent
        and na_all.effective_date = na_prnt.effective_date

    left outer join {{ ref('edm__stg_natural_account_level8') }} as level8
        on na_all.parent = level8.name
        and (na_all.level - 1) = level8.level
        and na_all.effective_date = level8.effective_date

    left outer join {{ ref('edm__stg_natural_account_level7') }} as level7
        on na_all.parent = level7.name
        and (na_all.level - 1) = level7.level
        and na_all.effective_date = level7.effective_date

    left outer join {{ ref('edm__stg_natural_account_level6') }} as level6
        on na_all.parent = level6.name
        and (na_all.level - 1) = level6.level
        and na_all.effective_date = level6.effective_date

    left outer join {{ ref('edm__stg_natural_account_level5') }} as level5
        on na_all.parent = level5.name
        and (na_all.level - 1) = level5.level
        and na_all.effective_date = level5.effective_date

    left outer join {{ ref('edm__stg_natural_account_level4') }} as level4
        on na_all.parent = level4.name
        and (na_all.level - 1) = level4.level
        and na_all.effective_date = level4.effective_date

    left outer join {{ ref('edm__stg_natural_account_level3') }} as level3
        on na_all.parent = level3.name
        and (na_all.level - 1) = level3.level
        and na_all.effective_date = level3.effective_date

    left outer join {{ ref('edm__stg_natural_account_level2') }} as level2
        on na_all.parent = level2.name
        and (na_all.level - 1) = level2.level
        and na_all.effective_date = level2.effective_date

    left outer join {{ ref('edm__stg_natural_account_level1') }} as level1
        on na_all.parent = level1.name
        and na_all.level - 1 = level1.level
        and na_all.effective_date = level1.effective_date

    left outer join {{ ref('edm__stg_natural_account_level7') }} as level7b
        on level8.parent = level7b.name
        and na_all.effective_date = level7b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level6') }} as level6b
        on coalesce(level7.parent , level7b.parent) = level6b.name
        and na_all.effective_date = level6b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level5') }} as level5b
        on coalesce(level6.parent , level6b.parent) = level5b.name
        and na_all.effective_date = level5b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level4') }} as level4b
        on coalesce(level5.parent , level5b.parent) = level4b.name
        and na_all.effective_date = level4b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level3') }} as level3b
        on coalesce(level4.parent , level4b.parent) = level3b.name
        and na_all.effective_date = level3b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level2') }} as level2b
        on coalesce(level3.parent , level3b.parent) = level2b.name
        and na_all.effective_date = level2b.effective_date

    left outer join {{ ref('edm__stg_natural_account_level1') }} as level1b
        on coalesce(level2.parent , level2b.parent) = level1b.name
        and na_all.effective_date = level1b.effective_date
    where na_all.is_head = 1
)

select
    source_level
    , natural_account_id
    , description
    , is_enabled
    , end_date
    , account_type
    , level8_name
    , level7_name
    , level6_name
    , level5_name
    , level4_name
    , level3_name
    , level2_name
    , level1_name
from part1
union all
select
    source_level
    , natural_account_id
    , description
    , is_enabled
    , end_date
    , account_type
    , level8_name
    , level7_name
    , level6_name
    , level5_name
    , level4_name
    , level3_name
    , level2_name
    , level1_name
from part2
order by source_level , natural_account_id
