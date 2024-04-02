with cte_accounting_id as (
    select *
    from {{ ref('edm__stg_accounting_id') }}
)

, cte_sector as (
    select
        business_unit.name as business_unit
        , business_unit.effective_date
        , coalesce(
            new_data.name , business_unit.name
        )                  as sector
    from cte_accounting_id as business_unit
    left join cte_accounting_id as new_data
        on business_unit.name = new_data.parent
        and business_unit.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Sector%'
    where business_unit.attr_12 like '%BU%'
)

, cte_division as (
    select
        business_unit
        , sector
        , cte_sector.effective_date
        , coalesce(new_data.name , cte_sector.sector) as division
    from cte_sector
    left join cte_accounting_id as new_data
        on cte_sector.sector = new_data.parent
        and cte_sector.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Division%'
)

, cte_region as (
    select
        business_unit
        , sector
        , division
        , cte_division.effective_date
        , coalesce(new_data.name , cte_division.division) as region
    from cte_division
    left join cte_accounting_id as new_data
        on cte_division.division = new_data.parent
        and cte_division.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Region%'
)

, cte_market as (
    select
        business_unit
        , sector
        , division
        , region
        , cte_region.effective_date
        , coalesce(new_data.name , cte_region.region) as market
    from cte_region
    left join cte_accounting_id as new_data
        on cte_region.region = new_data.parent
        and cte_region.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Market%'
)

, cte_location as (
    select
        business_unit
        , sector
        , division
        , region
        , market
        , cte_market.effective_date
        , coalesce(new_data.name , cte_market.market) as location
    from cte_market
    left join cte_accounting_id as new_data
        on cte_market.market = new_data.parent
        and cte_market.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Location%'
)

, cte_department as (
    select
         new_data.name                                        as accounting_id
        , new_data.is_enabled
        , new_data.end_date
        , new_data.attr_01::text(200)                        as location_code
        , new_data.attr_02::text(200)                        as city
        , new_data.attr_03::text(200)                        as state
        , new_data.attr_04::text(200)                        as acquisition_type
        , new_data.attr_05::text(200)                        as acquisition_name
        , new_data.attr_08::text(200)                        as leader_1
        , new_data.attr_09::text(200)                        as leader_1_email
        , new_data.attr_14::text(200)                        as leader_2
        , new_data.attr_15::text(200)                        as leader_2_email
        , new_data.attr_13::text(200)                        as hr_business_partner
        , new_data.attr_06::int                              as is_greenfield
        , new_data.attr_07::date                             as acquisition_start_month
        , new_data.attr_11::date                             as inception_date
        , cte_location.business_unit
        , cte_location.sector
        , cte_location.division
        , cte_location.region
        , cte_location.market
        , cte_location.location
        , new_data.description as department
        , cte_location.effective_date
        , new_data.is_head
        , new_data._created_at
        , new_data._source_file
    from cte_location
    left join cte_accounting_id as new_data
        on cte_location.location = new_data.parent
        and cte_location.effective_date = new_data.effective_date
        and new_data.attr_12 like '%Dept'
)

select *
from cte_department
