select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , cc.firm_source                        as firm_source
  , a.account_number_formatted            as account_number_formatted
  , a.account_number                      as account_number
  , a.gnum                                as link
  , 'gnumber'                             as link_type
  , case
        when max(a.is_primary) over(partition by a.effective_date, a.gnum) = 1
          then 'primary'
        else 'secondary'
        end::text(100)                    as link_subtype
  , a.gnum_name                           as link_description
  , cc.link_subtype_detail                as link_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , a.is_head                             as is_head
  , a.is_current                          as is_current
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , a._checksum                           as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('fidelity__int_gnums') }}  a
left join {{ ref('aux__stg_custodian_links') }} cc
          on a.custodian = cc.custodian
              and upper(a.gnum) = upper(cc.link)

union all

select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , a.firm_source                         as firm_source
  , a.account_number                      as account_number_formatted
  , a.account_number                      as account_number
  , a.fa_master_account_number            as link
  , 'master_number'                       as link_type
  , 'fa_master'                           as link_subtype
  , a.fa_master_account_description       as link_description
  , cc.link_subtype_detail                as link_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , a.is_head                             as is_head
  , a.is_current                          as is_current
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , a._md5                                as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('schwab__base_fa_master_relationships') }} a
left join {{ ref('aux__stg_custodian_links') }}                                  cc
          on a.custodian = cc.custodian
              and upper(a.fa_master_account_number) = upper(cc.link)
qualify row_number() over (partition by a.effective_date
    , a.firm_source
    , a.account_number
    , a.fa_master_account_number
    order by a.fa_master_account_number, a._source_loaded_at desc) = 1

union all

select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , a.firm_source                         as firm_source
  , a.account_number                      as account_number_formatted
  , a.account_number                      as account_number
  , a.master_account_number               as clink
  , 'master_number'                       as clink_type
  , 'sl_master'                           as clink_subtype
  , null::text(200)                       as clink_description
  , cc.link_subtype_detail                as clink_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , a.is_head                             as is_head
  , a.is_current                          as is_current
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , null::text(200)                       as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('schwab__base_master_accounts_mapping') }} a
left join {{ ref('aux__stg_custodian_links') }}        cc
          on a.custodian = cc.custodian
              and upper(a.master_account_number) = upper(cc.link)
left join {{ ref('schwab__base_fa_master_relationships') }} fam
          on a.effective_date = fam.effective_date
              and a.account_number = fam.account_number
              and a.master_account_number = fam.fa_master_account_number
where 1=1
  --exclude record if it's already represented by FAM file
  and fam.account_number is null

union all

select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , a.rep_code_firm                       as firm_source
  , a.account_number                      as account_number_formatted
  , a.account_number                      as account_number
  , a._rep_code                           as link
  , 'rep_code'                            as link_type
  , null::text(200)                       as link_subtype
  , null::text(200)                       as link_description
  , cc.link_subtype_detail                as link_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , {{ col_is_head(reference=ref('tda__int_accounts')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , null::text(200)                       as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('tda__int_accounts') }}    a
left join {{ ref('aux__stg_custodian_links') }} cc
          on a.custodian = cc.custodian
              and a.rep_code_firm = cc.firm_source
              and upper(a._rep_code) = upper(cc.link)

union all

select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , cc.firm_source                        as firm_source
  , a.account_number                      as account_number_formatted
  , a.account_number                      as account_number
  , a.investment_professional_ip_number   as link
  , 'investment_professional_number'      as link_type
  , null::text(200)                       as link_subtype
  , null::text(200)                       as link_description
  , cc.link_subtype_detail                as link_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , a.is_head                             as is_head
  , a.is_current                          as is_current
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , null::text(200)                       as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('int_pershing_mwa_accounts') }} a
left join {{ ref('aux__stg_custodian_links') }}      cc
          on a.custodian = cc.custodian
              and upper(a.investment_professional_ip_number) = upper(cc.link)

union all

select
    a.effective_date                      as effective_date
  , a.custodian                           as custodian
  , cc.firm_source                        as firm_source
  , a.account_number                      as account_number_formatted
  , a.account_number                      as account_number
  , a.investment_professional_ip_number   as link
  , 'investment_professional_number'      as link_type
  , null::text(200)                       as link_subtype
  , null::text(200)                       as link_description
  , cc.link_subtype_detail                as link_subtype_detail
  , cc.location_code                      as location_code
  , cc.advisor_email                      as advisor_email
  , cc.description                        as description
  , cc.notes                              as notes
  , cc.is_deceased                        as is_deceased
  , cc.has_trading_authority              as has_trading_authority
  , case
      when cc.link is not null
        then 1
      else 0
      end                                 as exists_in_map
  , a.is_head                             as is_head
  , a.is_current                          as is_current
  , a._source_loaded_at                   as _source_loaded_at
  , a._source_file                        as _source_file
  , null::text(200)                       as _checksum
  , max(cc._source_loaded_at)
    over(partition by 1=1)                as _map_loaded_at
from {{ ref('int_pershing_mps_accounts') }} a
left join {{ ref('aux__stg_custodian_links') }}      cc
          on a.custodian = cc.custodian
              and upper(a.investment_professional_ip_number) = upper(cc.link)
