with max_date_from_history as (
    select max(effective_date) as effective_date from {{ ref('custodian_account_links_history') }}
)

select
    a.effective_date              as effective_date
    , a.custodian                 as custodian
    , cc.firm_source              as firm_source
    , cc.effective_start_date     as effective_start_date
    , cc.effective_end_date       as effective_end_date
    , a.account_number_formatted  as account_number_formatted
    , a.account_number            as account_number
    , a.gnum                      as link
    , 'gnumber'                   as link_type
    , case
        when a.is_primary = 1
            then 'primary'
        else 'secondary'
    end::text(500)                as link_subtype
    , a.gnum_name                 as link_description
    , cc.link_subtype_detail      as link_subtype_detail
    , cc.location_code            as location_code
    , cc.advisor_email            as advisor_email
    , cc.description              as description
    , cc.notes                    as notes
    , cc.is_deceased              as is_deceased
    , cc.has_trading_authority    as has_trading_authority
    , case
        when cc.link is not null
            then 1
        else 0
    end                           as exists_in_map
    , a._created_at               as _created_at
    , a._source_loaded_at         as _source_loaded_at
    , a._source_file              as _source_file
    , a._checksum                 as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1) as _map_loaded_at
from {{ ref('fidelity__int_gnums') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.gnum) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
where 1 = 1
    and a.effective_date > (select max(t.effective_date) from max_date_from_history as t)

union all

select
    a.effective_date                  as effective_date
    , a.custodian                     as custodian
    , a.firm_source                   as firm_source
    , cc.effective_start_date         as effective_start_date
    , cc.effective_end_date           as effective_end_date
    , a.account_number                as account_number_formatted
    , a.account_number                as account_number
    , a.fa_master_account_number      as link
    , 'master_number'                 as link_type
    , 'fa_master'                     as link_subtype
    , a.fa_master_account_description as link_description
    , cc.link_subtype_detail          as link_subtype_detail
    , cc.location_code                as location_code
    , cc.advisor_email                as advisor_email
    , cc.description                  as description
    , cc.notes                        as notes
    , cc.is_deceased                  as is_deceased
    , cc.has_trading_authority        as has_trading_authority
    , case
        when cc.link is not null
            then 1
        else 0
    end                               as exists_in_map
    , a._source_loaded_at             as _created_at
    , a._source_loaded_at             as _source_loaded_at
    , a._source_file                  as _source_file
    , a._md5                          as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)     as _map_loaded_at
from {{ ref('schwab__base_fa_master_relationships') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.fa_master_account_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
where 1 = 1
    and a.effective_date > (select max(t.effective_date) from max_date_from_history as t)
qualify
    row_number() over (partition by
        a.effective_date
        , a.firm_source
        , a.account_number
        , a.fa_master_account_number
    order by a.fa_master_account_number asc , a._source_loaded_at desc) = 1

union all

select
    a.effective_date                          as effective_date
    , a.custodian                             as custodian
    , a.firm_source                           as firm_source
    , cc.effective_start_date                 as effective_start_date
    , cc.effective_end_date                   as effective_end_date
    , a.account_number                        as account_number_formatted
    , a.account_number                        as account_number
    , a.master_account_number                 as clink
    , 'master_number'                         as clink_type
    , coalesce(cc.link_subtype , 'sl_master') as clink_subtype
    , null::text(500)                         as clink_description
    , cc.link_subtype_detail                  as clink_subtype_detail
    , cc.location_code                        as location_code
    , cc.advisor_email                        as advisor_email
    , cc.description                          as description
    , cc.notes                                as notes
    , cc.is_deceased                          as is_deceased
    , cc.has_trading_authority                as has_trading_authority
    , case
        when cc.link is not null
            then 1
        else 0
    end                                       as exists_in_map
    , a._source_loaded_at                     as _created_at
    , a._source_loaded_at                     as _source_loaded_at
    , a._source_file                          as _source_file
    , null::text(500)                         as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)             as _map_loaded_at
from {{ ref('schwab__base_master_accounts_mapping') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.master_account_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
left join {{ ref('schwab__base_fa_master_relationships') }} as fam
    on a.effective_date = fam.effective_date
    and a.account_number = fam.account_number
    and a.master_account_number = fam.fa_master_account_number
where 1 = 1
    --exclude record if it's already represented by FAM file
    and fam.account_number is null
    and a.effective_date > (select max(t.effective_date) from max_date_from_history as t)

union all

select
    a.effective_date                      as effective_date
    , a.custodian                         as custodian
    , cc.firm_source                      as firm_source
    , cc.effective_start_date             as effective_start_date
    , cc.effective_end_date               as effective_end_date
    , a.account_number                    as account_number_formatted
    , a.account_number                    as account_number
    , a.investment_professional_ip_number as link
    , 'investment_professional_number'    as link_type
    , null::text(500)                     as link_subtype
    , null::text(500)                     as link_description
    , cc.link_subtype_detail              as link_subtype_detail
    , cc.location_code                    as location_code
    , cc.advisor_email                    as advisor_email
    , cc.description                      as description
    , cc.notes                            as notes
    , cc.is_deceased                      as is_deceased
    , cc.has_trading_authority            as has_trading_authority
    , case
        when cc.link is not null
            then 1
        else 0
    end                                   as exists_in_map
    , a._source_loaded_at                 as _created_at
    , a._source_loaded_at                 as _source_loaded_at
    , a._source_file                      as _source_file
    , null::text(500)                     as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)         as _map_loaded_at
from {{ ref('int_pershing_mwa_accounts') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.investment_professional_ip_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
where 1 = 1
    and effective_date > (select max(t.effective_date) from max_date_from_history as t)

union all

select
    a.effective_date                      as effective_date
    , a.custodian                         as custodian
    , cc.firm_source                      as firm_source
    , cc.effective_start_date             as effective_start_date
    , cc.effective_end_date               as effective_end_date
    , a.account_number                    as account_number_formatted
    , a.account_number                    as account_number
    , a.investment_professional_ip_number as link
    , 'investment_professional_number'    as link_type
    , null::text(500)                     as link_subtype
    , null::text(500)                     as link_description
    , cc.link_subtype_detail              as link_subtype_detail
    , cc.location_code                    as location_code
    , cc.advisor_email                    as advisor_email
    , cc.description                      as description
    , cc.notes                            as notes
    , cc.is_deceased                      as is_deceased
    , cc.has_trading_authority            as has_trading_authority
    , case
        when cc.link is not null
            then 1
        else 0
    end                                   as exists_in_map
    , a._source_loaded_at                 as _created_at
    , a._source_loaded_at                 as _source_loaded_at
    , a._source_file                      as _source_file
    , null::text(500)                     as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)         as _map_loaded_at
from {{ ref('int_pershing_mps_accounts') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.investment_professional_ip_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
where 1 = 1
    and effective_date > (select max(t.effective_date) from max_date_from_history as t)
