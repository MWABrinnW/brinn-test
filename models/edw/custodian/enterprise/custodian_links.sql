{{ config(enabled=true) }}

with cte_custodian_links as
(
    select *
    from {{ ref('custodian_account_links') }}
    where is_head = 1
        and link is not null
)
,cte_accounts as
(
    select
        case
            when custodian ilike '%schwab%'
                then 'schwab'
            when custodian ilike '%fidel%'
                then 'fidelity'
            when custodian ilike '%lpl%'
                then 'lpl'
            when custodian ilike '%pershing%'
                then 'pershing'
            when custodian ilike '%tda%'
                or custodian ilike '%ameritrade%'
                then 'tda'
            else ''
            end::text(100)                                              as __custodian_key
        , financial_account_number_clean as account_number
        , location_code
        , case
            when client_manager ilike any ('%test%rep%', '%demo%')
                then null
            else client_manager
            end as advisor
    from {{ ref('legacy__vw_financial_accounts_daily')}}
    where is_head = 1
)
,cte_mapped as
(
    select
        a.*
        ,b.location_code as location_code_mapped, b.advisor as advisor_mapped
        ,case when b.__custodian_key is not null then 1 else 0 end as is_mapped
    from cte_custodian_links a
    left join cte_accounts b
        on a.custodian = b.__custodian_key
        and a.account_number = b.account_number
)
,cte_summary as
(
    select
         custodian                                          as custodian
        ,firm_source                                        as firm_source
        ,link                                               as link
        ,link_type                                          as link_type
        ,link_subtype                                       as link_subtype
        ,link_description                                   as link_description
        ,link_subtype_detail                                as link_subtype_detail
        ,description                                        as description
        ,notes                                              as notes
        ,1::int                                             as exists_in_feed
        ,exists_in_map                                      as exists_in_map
        ,has_trading_authority                              as has_trading_authority
        ,location_code                                      as location_code
        ,advisor_email                                      as advisor_email
        ,count(distinct account_number)                     as cnt_accounts
        ,sum(is_mapped)                                     as cnt_mapped
        ,count(distinct location_code_mapped)               as cnt_locations
        ,count(distinct advisor_mapped)                     as cnt_advisor
        ,case when cnt_locations = 1 then 1 else 0 end      as is_location_one_to_one
        ,case when cnt_advisor = 1 then 1 else 0 end        as is_advisor_one_to_one
        ,case when cnt_locations = 1 then max(location_code_mapped) else null end as location_code_derived
        ,case when cnt_advisor = 1 then max(advisor_mapped) else null end as advisor_derived
        ,max(_source_loaded_at::timestamp)                  as _feed_loaded_at
        ,max(_map_loaded_at)                                as _map_loaded_at
    from cte_mapped
    group by custodian, firm_source, link_type, link_subtype, link_subtype_detail, link, link_description
        , description, notes, exists_in_map, has_trading_authority
        , location_code, advisor_email

    union all

    select
        custodian                                    as custodian
        , firm_source                                as firm_source
        , link                                       as link
        , link_type                                  as link_type
        , link_subtype                               as link_subtype
        , null::text(200)                            as link_description
        , null::text(200)                            as link_subtype_detail
        , description                                as description
        , notes                                      as notes
        , 0::int                                     as exists_in_feed
        , 1::int                                     as exists_in_map
        , has_trading_authority                      as has_trading_authority
        , location_code                              as location_code
        , advisor_email                              as advisor_email
        , null::int                                  as cnt_accounts
        , null::int                                  as cnt_mapped
        , null::int                                  as cnt_locations
        , null::int                                  as cnt_advisor
        , null::int                                  as is_location_one_to_one
        , null::int                                  as is_advisor_one_to_one
        , null::text(200)                            as location_code_derived
        , null::text(200)                            as advisor_derived
        , null::timestamp                            as _feed_loaded_at
        , _source_loaded_at                          as _map_loaded_at
    from {{ ref('aux__stg_custodian_links') }}
    where link not in (select distinct link from cte_custodian_links)

    order by custodian, link
)


select
      a.custodian
    , a.firm_source
    , a.link
    , a.link_type
    , a.link_subtype
    , a.link_description
    , a.link_subtype_detail
    , a.description
    , a.notes
    , a.location_code
    , l.office_name
    , a.advisor_email
    , a.location_code_derived
    , a.advisor_derived
    , a.exists_in_feed
    , a.exists_in_map
    , a.cnt_accounts
    , a.cnt_mapped
    , a.cnt_locations
    , a.cnt_advisor
    , a.has_trading_authority
    , a._feed_loaded_at
    , a._map_loaded_at
from cte_summary a
left join edw.enterprise.locations_active l
    on a.location_code = l.location_code
order by a.custodian, a.firm_source, a.link
