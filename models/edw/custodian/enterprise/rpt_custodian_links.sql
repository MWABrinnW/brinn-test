with cte_custodian_account_links as (
    select *
    from {{ ref('custodian_account_links') }}
    where is_head = 1
        and link is not null
)

, cte_dates as (
    select
        custodian
        , link
        , min(effective_date) as earliest_date
        , max(effective_date) as latest_date
    from {{ ref('custodian_account_links') }}
    group by all
)

, cte_accounts as (
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
        end::text(100)                   as __custodian_key
        , financial_account_number_clean as account_number
        , location_code
        , case
            when client_manager ilike any ('%test%rep%' , '%demo%')
                then null
            else client_manager
        end                              as advisor
    from {{ ref('legacy__vw_financial_accounts_daily') }}
    where is_head = 1
)

, cte_account_links_to_master as (
    select
        a.*
        , b.location_code                                           as location_code_mapped
        , b.advisor                                                 as advisor_mapped
        , case when b.__custodian_key is not null then 1 else 0 end as is_mapped
    from cte_custodian_account_links as a
    left join cte_accounts as b
        on a.custodian = b.__custodian_key
        and a.account_number = b.account_number
)

, cte_summary as (
    select
        custodian                                                        as custodian
        , link                                                           as link
        , null::date                                                     as effective_start_date
        , null::date                                                     as effective_end_date
        , firm_source                                                    as firm_source
        , max(link_type)                                                 as link_type
        , max(link_subtype)                                              as link_subtype
        , max(link_description)                                          as link_description
        , max(link_subtype_detail)                                       as link_subtype_detail
        , max(description)                                               as description
        , max(notes)                                                     as notes
        , 1::int                                                         as exists_in_feed
        , exists_in_map                                                  as exists_in_map
        , is_deceased                                                    as is_deceased
        , has_trading_authority                                          as has_trading_authority
        , location_code                                                  as location_code
        , advisor_email                                                  as advisor_email
        , count(distinct account_number)                                 as cnt_accounts
        , sum(is_mapped)                                                 as cnt_mapped
        , count(distinct location_code_mapped)                           as cnt_locations
        , count(distinct advisor_mapped)                                 as cnt_advisor
        --, case when cnt_locations = 1 then 1 else 0 end                  as is_location_one_to_one
        --, case when cnt_advisor = 1 then 1 else 0 end                    as is_advisor_one_to_one
        --, case when cnt_locations = 1 then max(location_code_mapped) end as location_code_derived
        , case when cnt_advisor = 1 then max(advisor_mapped) end         as advisor_derived
        , max(_source_loaded_at::timestamp)                              as _feed_loaded_at
        , max(_map_loaded_at)                                            as _map_loaded_at
    from cte_account_links_to_master
    group by all

    union all

    select
        custodian               as custodian
        , link                  as link
        , effective_start_date  as effective_start_date
        , effective_end_date    as effective_end_date
        , firm_source           as firm_source
        , link_type             as link_type
        , link_subtype          as link_subtype
        , null::text(200)       as link_description
        , null::text(200)       as link_subtype_detail
        , description           as description
        , notes                 as notes
        , 0::int                as exists_in_feed
        , 1::int                as exists_in_map
        , is_deceased           as is_deceased
        , has_trading_authority as has_trading_authority
        , location_code         as location_code
        , advisor_email         as advisor_email
        , null::int             as cnt_accounts
        , null::int             as cnt_mapped
        , null::int             as cnt_locations
        , null::int             as cnt_advisor
        --, null::int             as is_location_one_to_one
        --, null::int             as is_advisor_one_to_one
        --, null::text(200)       as location_code_derived
        , null::text(200)       as advisor_derived
        , null::timestamp       as _feed_loaded_at
        , _source_loaded_at     as _map_loaded_at
    from {{ ref('aux__stg_custodian_links') }}
    where link not in (select distinct link from cte_custodian_account_links)
    order by custodian , link
)


select
    a.custodian
    , a.link
    , a.effective_start_date
    , a.effective_end_date
    , a.firm_source
    , a.link_type
    , a.link_subtype
    , a.link_description
    , a.link_subtype_detail
    , a.description
    , a.notes
    , a.location_code
    , l.office_name
    , a.advisor_email
    --, a.location_code_derived
    , a.advisor_derived
    , a.exists_in_feed
    , a.exists_in_map
    , a.cnt_accounts
    , a.cnt_mapped
    , a.cnt_locations
    , a.cnt_advisor
    , a.is_deceased
    , a.has_trading_authority
    , ''::text(2000)
    || coalesce(case
        when a.exists_in_feed = 1 and a.exists_in_map = 0
            then '; Not in mapping file'
    end , '')
    || coalesce(case
        when coalesce(a.firm_source , '') = ''
            then '; Mapping file is missing FIRM_SOURCE'
    end , '')
        as exception_notes
    , d.earliest_date
    , d.latest_date
    , a._feed_loaded_at
    , a._map_loaded_at
from cte_summary as a
left join edw.enterprise.locations_active as l
    on a.location_code = l.location_code
left join cte_dates as d
    on a.custodian = d.custodian
    and a.link = d.link
order by a.custodian , a.firm_source , a.link
