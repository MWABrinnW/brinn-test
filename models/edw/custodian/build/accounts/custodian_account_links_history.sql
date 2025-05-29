{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set source_models = [
          'fidelity__int_gnums'
         ,'int_pershing_mwa_accounts'
         ,'int_pershing_mps_accounts'
         ,'schwab__base_fa_master_relationships'
         ,'schwab__base_master_accounts_mapping'
    ]
-%}

{%-
    set nml_models = [
          'nml_custodian_account_links_fidelity'
         ,'nml_custodian_account_links_schwab_fa_master_relationships'
         ,'nml_custodian_account_links_schwab_master_accounts_mapping'
         ,'nml_custodian_account_links_pershing_mwa'
         ,'nml_custodian_account_links_pershing_mps'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {% for src_model in source_models -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, custodian, firm_source from source_summary group by all
    union
    select effective_date, custodian, firm_source from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date
        , a.custodian
        , a.firm_source
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
        and a.firm_source = s.firm_source
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
        and a.firm_source = d.firm_source
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

, data_to_build as (
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
        end::text                     as link_subtype
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
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)

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
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
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
        , null::text                              as clink_description
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
        , a._source_loaded_at                     as _source_loaded_at
        , a._source_file                          as _source_file
        , null::text                              as _checksum
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
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)

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
        , null::text                          as link_subtype
        , null::text                          as link_description
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
        , a._source_loaded_at                 as _source_loaded_at
        , a._source_file                      as _source_file
        , null::text                          as _checksum
        , max(cc._source_loaded_at)
            over (partition by 1 = 1)         as _map_loaded_at
    from {{ ref('int_pershing_mwa_accounts') }} as a
    left join {{ ref('aux__stg_custodian_links') }} as cc
        on a.custodian = cc.custodian
        and upper(a.investment_professional_ip_number) = upper(cc.link)
        and a.effective_date
        between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
    where 1 = 1
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)

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
        , null::text                          as link_subtype
        , null::text                          as link_description
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
        , a._source_loaded_at                 as _source_loaded_at
        , a._source_file                      as _source_file
        , null::text                          as _checksum
        , max(cc._source_loaded_at)
            over (partition by 1 = 1)         as _map_loaded_at
    from {{ ref('int_pershing_mps_accounts') }} as a
    left join {{ ref('aux__stg_custodian_links') }} as cc
        on a.custodian = cc.custodian
        and upper(a.investment_professional_ip_number) = upper(cc.link)
        and a.effective_date
        between coalesce(cc.effective_start_date , a.effective_date) and coalesce(cc.effective_end_date , a.effective_date)
    where 1 = 1
        and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
)

select
    effective_date                     as effective_date
  , custodian                          as custodian
  , firm_source                        as firm_source
  , effective_start_date               as effective_start_date
  , effective_end_date                 as effective_end_date
  , account_number_formatted           as account_number_formatted
  , account_number                     as account_number
  , link                               as link
  , link_type                          as link_type
  , link_subtype                       as link_subtype
  , link_description                   as link_description
  , link_subtype_detail                as link_subtype_detail
  , location_code                      as location_code
  , advisor_email                      as advisor_email
  , description                        as description
  , notes                              as notes
  , is_deceased                        as is_deceased
  , has_trading_authority              as has_trading_authority
  , exists_in_map                      as exists_in_map
  , current_timestamp()::timestamp_ntz as _created_at
  , _source_loaded_at                  as _source_loaded_at
  , _source_file                       as _source_file
  , _checksum                          as _checksum
  , _map_loaded_at                     as _map_loaded_at
from data_to_build
