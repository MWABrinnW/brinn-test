with cte_accounting_id as (
    select *
    from {{ ref('edm__stg_accounting_id') }}
)

, cte_business_units as (
    select
        a.effective_date
        , a.name    as business_unit
        , a.attr_10 as org_effective_date
        , a.parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%BU%'
    group by all
)

, cte_sectors as (
    select
        a.effective_date
        , a.name    as sector
        , a.attr_10 as org_effective_date
        , case
            when a.attr_12 ilike '%BU%'
                then a.name
            else a.parent
        end         as parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Sector%'
    group by all
)

, cte_divisions as (
    select
        a.effective_date
        , a.name    as division
        , a.attr_10 as org_effective_date
        , case
            when a.attr_12 ilike '%Sector%'
                then a.name
            else a.parent
        end         as parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Division%'
    group by all
)

, cte_regions as (
    select
        a.effective_date
        , a.name    as region
        , a.attr_10 as org_effective_date
        , case
            when a.attr_12 ilike '%Division%'
                then a.name
            else a.parent
        end         as parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Region%'
    group by all
)

, cte_markets as (
    select
        a.effective_date
        , a.name    as market
        , a.attr_10 as org_effective_date
        , case
            when a.attr_12 ilike '%Region%'
                then a.name
            else a.parent
        end         as parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Market%'
    group by all
)

, cte_locations as (
    select
        a.effective_date
        , a.name    as location
        , a.attr_10 as org_effective_date
        , case
            when a.attr_12 ilike '%Market%'
                then a.name
            else a.parent
        end         as parent
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Location%'
    group by all
)

, cte_departments as (
    select
        a.effective_date
        , a.name         as department
        , a.attr_10      as org_effective_date
        , case
            when a.attr_12 ilike '%Location%'
                then a.name
            else a.parent
        end              as parent
        , a.attr_01      as location_code
        , a.description
        , a.is_enabled
        , a.end_date
        , a.attr_01      as attr_01
        , a.attr_02      as attr_02
        , a.attr_03      as attr_03
        , a.attr_04      as attr_04
        , a.attr_05      as attr_05
        , a.attr_08      as attr_08
        , a.attr_09      as attr_09
        , a.attr_14      as attr_14
        , a.attr_15      as attr_15
        , a.attr_13      as attr_13
        , a.attr_06      as attr_06
        , a.attr_07      as attr_07
        , a.attr_11      as attr_11
        , a.attr_16      as attr_16
        , a.is_head      as is_head
        , a._created_at  as _created_at
        , a._source_file as _source_file
    from cte_accounting_id as a
    where 1 = 1
        and a.attr_12 like '%Dept%'
        and a.attr_12 not like '%Rollup%'
    group by all
)

select
    dep.department                         as accounting_id
    , dep.is_enabled                       as is_enabled
    , dep.end_date                         as end_date
    , dep.location_code                    as location_code

    , dep.attr_02::text(200)               as city
    , dep.attr_03::text(200)               as state
    , dep.attr_04::text(200)               as acquisition_type
    , dep.attr_05::text(200)               as acquisition_name
    , dep.attr_08::text(200)               as leader_1
    , dep.attr_09::text(200)               as leader_1_email
    , dep.attr_14::text(200)               as leader_2
    , dep.attr_15::text(200)               as leader_2_email
    , dep.attr_13::text(200)               as hr_business_partner
    , dep.attr_06::int                     as is_greenfield
    , dep.attr_07::date                    as acquisition_start_month
    , dep.attr_11::date                    as inception_date
    , nullif(
        greatest(
            coalesce(dep.org_effective_date , '1900-01-01')::date
            , coalesce(loc.org_effective_date , '1900-01-01')::date
            , coalesce(mkt.org_effective_date , '1900-01-01')::date
            , coalesce(reg.org_effective_date , '1900-01-01')::date
            , coalesce(div.org_effective_date , '1900-01-01')::date
            , coalesce(sec.org_effective_date , '1900-01-01')::date
            , coalesce(bu.org_effective_date , '1900-01-01')::date
        )
        , '1900-01-01'::date
    )::date                                as org_effective_date
    , object_construct_keep_null(
        'deparment' , dep.org_effective_date
        , 'location' , loc.org_effective_date
        , 'market' , mkt.org_effective_date
        , 'region' , reg.org_effective_date
        , 'division' , div.org_effective_date
        , 'sector' , sec.org_effective_date
        , 'business_unit' , bu.org_effective_date
    )                                      as org_effective_dates
    , dep.attr_16::text(200)               as igo_segment

    , bu.business_unit                     as business_unit
    , sec.sector                           as sector
    , div.division                         as division
    , replace(reg.region , ' Region' , '') as region
    , replace(mkt.market , ' Market' , '') as market
    , loc.location                         as location
    , dep.description                      as department
    , dep.effective_date                   as effective_date

    , dep.is_head                          as is_head
    , dep._created_at                      as _created_at
    , dep._source_file                     as _source_file
from cte_departments as dep
left join cte_locations as loc
    on dep.effective_date = loc.effective_date
    and dep.parent = loc.location
left join cte_markets as mkt
    on loc.effective_date = mkt.effective_date
    and loc.parent = mkt.market
left join cte_regions as reg
    on mkt.effective_date = reg.effective_date
    and mkt.parent = reg.region
left join cte_divisions as div
    on reg.effective_date = div.effective_date
    and reg.parent = div.division
left join cte_sectors as sec
    on div.effective_date = sec.effective_date
    and div.parent = sec.sector
left join cte_business_units as bu
    on sec.effective_date = bu.effective_date
    and sec.parent = bu.business_unit
where 1 = 1
order by dep.effective_date , dep.department
