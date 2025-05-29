with max_effective_dates as (
    select max(effective_date) as effective_date
    from {{ ref('custodian_account_links_history') }}
    group by all

    union distinct

    select max(effective_date) as effective_date
    from {{ ref('custodian_account_links_fresh') }}
    group by all
)

, head_date as (
    select max(effective_date) as effective_date from max_effective_dates
)

select
    a.effective_date             as effective_date
    , a.custodian                as custodian
    , a.firm_source              as firm_source
    , a.effective_start_date     as effective_start_date
    , a.effective_end_date       as effective_end_date
    , a.account_number_formatted as account_number_formatted
    , a.account_number           as account_number
    , a.link                     as link
    , a.link_type                as link_type
    , a.link_subtype             as link_subtype
    , a.link_description         as link_description
    , a.link_subtype_detail      as link_subtype_detail
    , a.location_code            as location_code
    , a.advisor_email            as advisor_email
    , a.description              as description
    , a.notes                    as notes
    , a.is_deceased              as is_deceased
    , a.has_trading_authority    as has_trading_authority
    , a.exists_in_map            as exists_in_map
    , a._created_at              as _created_at
    , a._source_loaded_at        as _source_loaded_at
    , a._source_file             as _source_file
    , a._checksum                as _checksum
    , a._map_loaded_at           as _map_loaded_at
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int                     as is_head
from {{ ref('custodian_account_links_fresh') }} as a
left join head_date as b
    on a.effective_date = b.effective_date

union all

select
    a.effective_date             as effective_date
    , a.custodian                as custodian
    , a.firm_source              as firm_source
    , a.effective_start_date     as effective_start_date
    , a.effective_end_date       as effective_end_date
    , a.account_number_formatted as account_number_formatted
    , a.account_number           as account_number
    , a.link                     as link
    , a.link_type                as link_type
    , a.link_subtype             as link_subtype
    , a.link_description         as link_description
    , a.link_subtype_detail      as link_subtype_detail
    , a.location_code            as location_code
    , a.advisor_email            as advisor_email
    , a.description              as description
    , a.notes                    as notes
    , a.is_deceased              as is_deceased
    , a.has_trading_authority    as has_trading_authority
    , a.exists_in_map            as exists_in_map
    , a._created_at              as _created_at
    , a._source_loaded_at        as _source_loaded_at
    , a._source_file             as _source_file
    , a._checksum                as _checksum
    , a._map_loaded_at           as _map_loaded_at
    , case
        when a.effective_date = b.effective_date
            then 1
        else 0
    end::int                     as is_head
from {{ ref('custodian_account_links_history') }} as a
left join head_date as b
    on a.effective_date = b.effective_date
