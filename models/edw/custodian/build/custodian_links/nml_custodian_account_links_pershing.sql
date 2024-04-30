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
    , null::text(200)                     as link_subtype
    , null::text(200)                     as link_description
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
    , a.is_head                           as is_head
    , a.is_current                        as is_current
    , a._source_loaded_at                 as _source_loaded_at
    , a._source_file                      as _source_file
    , null::text(200)                     as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)         as _map_loaded_at
from {{ ref('int_pershing_mwa_accounts') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.investment_professional_ip_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)

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
    , null::text(200)                     as link_subtype
    , null::text(200)                     as link_description
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
    , a.is_head                           as is_head
    , a.is_current                        as is_current
    , a._source_loaded_at                 as _source_loaded_at
    , a._source_file                      as _source_file
    , null::text(200)                     as _checksum
    , max(cc._source_loaded_at)
        over (partition by 1 = 1)         as _map_loaded_at
from {{ ref('int_pershing_mps_accounts') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cc
    on a.custodian = cc.custodian
    and upper(a.investment_professional_ip_number) = upper(cc.link)
    and a.effective_date
    between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
