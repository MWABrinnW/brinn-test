with cte_grouped as (
    select
        location_code
        , is_enabled
        , end_date
        , business_unit
        , sector
        , division
        , region
        , market
        , location
        , department
        , city
        , state
        , accounting_id
        , acquisition_name
        , acquisition_type
        , leader_1
        , leader_1_email
        , leader_2
        , leader_2_email
        , hr_business_partner
        , is_greenfield
        , acquisition_start_month
        , inception_date
        , igo_segment
        , min(inception_date)     as min_inception_date
        , org_effective_date      as org_effective_date
        , min(org_effective_date) as min_org_effective_date
        , max(org_effective_date) as max_org_effective_date

        , min(effective_date)     as min_effective_date
        , max(effective_date)     as max_effective_date
        , min(_created_at)        as min_created_at
        , max(_created_at)        as max_created_at
        , min(_source_file)       as min_source_file
        , max(_source_file)       as max_source_file
    from {{ ref('edm__base_accounting_id') }}
    group by all
)

, cte_ranked_by_org_effective_date as (
    select
        location_code
        , is_enabled
        , min_org_effective_date                                                                        as start_date
        , end_date
        , business_unit
        , sector
        , division
        , region
        , market
        , location
        , department
        , city
        , state
        , accounting_id
        , department
            as accounting_id_description
        , acquisition_name
        , acquisition_type
        , leader_1
        , leader_1_email
        , leader_2
        , leader_2_email
        , hr_business_partner
        , is_greenfield
        , acquisition_start_month
        , inception_date
        , igo_segment
        , min_inception_date
        , org_effective_date
        , min_org_effective_date
        , max_org_effective_date
        , min_effective_date
        , max_effective_date
        , min_created_at
        , max_created_at
        , min_source_file
        , max_source_file
        -- We'll take the latest version of an accounting id by the min_org_effective_date it has.
        -- Not sure why we got away from capturing changes via the daily files and using org effective
        -- date in the way that we are. This might be better but it's a bit nebuluous and I worry
        -- it will introduce further issues down the line. We shouldn't be in a state where
        -- we are unsure how changes in EDM will impact the location master, instead being
        -- able to trust that we are capturing as SCD2 without the uncertainties of what we've
        -- built here.
        , row_number()
            over (partition by accounting_id , min_org_effective_date order by max_effective_date desc)
            as rn_accounting_id_org_date
        , dense_rank()
            over (partition by accounting_id order by min_org_effective_date desc)
            as rn_accounting_id
    from cte_grouped
)

, cte_ranked_by_org_effective_date_filtered as (
    select *
    from cte_ranked_by_org_effective_date
    where rn_accounting_id_org_date = 1
)

select
    location_code
    , min_org_effective_date as start_date
    , case
        when rn_accounting_id <> 1
            -- If not the latest version of the accounting id, then we need to use the
            -- the start_date - 1 from the next version.
            then dateadd(day , -1 , lead(start_date , 1) over (partition by accounting_id order by start_date))
        else end_date
    end                      as end_date
    , case
        when rn_accounting_id <> 1 then 0 else 1
    end::int                 as active
    , business_unit
    , sector
    , division
    , region
    , market
    , location
    , department
    , city
    , state
    , accounting_id
    , accounting_id_description
    , acquisition_name
    , acquisition_type
    , leader_1
    , leader_1_email
    , leader_2
    , leader_2_email
    , hr_business_partner
    , is_greenfield
    , acquisition_start_month
    , inception_date
    , igo_segment
    , min_inception_date
    , org_effective_date
    , min_org_effective_date
    , max_org_effective_date
    , min_effective_date
    , max_effective_date
    , min_created_at
    , max_created_at
    , min_source_file
    , max_source_file
from cte_ranked_by_org_effective_date_filtered
