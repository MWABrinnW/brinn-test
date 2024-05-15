--depends_on: {{ ref('flyer__sod_positions') }}

with cte as (
    select
        _created_at::date  as _created_date
        , max(_created_at) as max_created_at
    from {{ source('flyer', 'sod_positions_history') }}
    group by 1
)

select
    a.effective_date::date                               as effective_date
    , a.custodiancode::text(200)                         as custodiancode
    , a.account::text(200)                               as account-- noqa: RF04
    , a.product::text(200)                               as product
    , a.symbol::text(200)                                as symbol
    , a.quantity::decimal(19 , 6)                        as quantity
    , a.unitcost::decimal(19 , 6)                        as unitcost
    , a.totalcost::decimal(19 , 6)                       as totalcost
    , a.price::decimal(19 , 6)                           as price
    , a.lotdate::int                                     as lotdate
    , a.lotnum::text(200)                                as lotnum
    , a.unsupervised::text(200)                          as unsupervised
    , a.cusiplookup::text(200)                           as cusiplookup
    , a.cusip::text(200)                                 as cusip
    , a.preferred::text(200)                             as preferred
    , a.securityid::text(200)                            as securityid
    , a.security_type_description::text(200)             as security_type_description
    , a.fund_type::text(200)                             as fund_type
    , a.product_type::text(200)                          as product_type
    , a.product_type_source_code::text(200)              as product_type_source_code
    , a.product_type_source_definition::text(200)        as product_type_source_definition
    , a.legacy_product_type::text(200)                   as legacy_product_type
    , a.legacy_product_type_source_code::text(200)       as legacy_product_type_source_code
    , a.legacy_product_type_source_definition::text(200) as legacy_product_type_source_definition
    , case
        when a.effective_date::date = (
                select max(effective_date::date)
                from {{ source('flyer', 'sod_positions_history') }}
            )
            and a._created_at::timestamp = b.max_created_at
            then 1
        else 0
    end::int                                             as is_head
    , case
        when a._created_at = b.max_created_at
            then 1
        else 0
    end::int                                             as is_head_for_day
    , a._created_at::timestamp_ntz                       as created_at
from {{ source('flyer', 'sod_positions_history') }} as a
left join cte as b
    on a._created_at::date = b._created_date::date
    and a._created_at = b.max_created_at
