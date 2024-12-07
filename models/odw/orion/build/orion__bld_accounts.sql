{{ config(
    materialized='incremental',
    cluster_by=['effective_date', 'fkalclient', 'left(account_number, 2)'],
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{% set lookback = cvar('lookback') %}
{% set dev_filter = cvar('dev_day_filter') %}
{%- set max_lookback = 183 -%}

-- need distinct because of tiered bill schedules
with cte_dates_to_refresh as (
    {%- if is_incremental() %}
        select distinct aa.effective_date
        from (
            select
                effective_date
                , max(createddate) as _created_at
            from {{ ref('orion__base_vw_account') }}
            where 1 = 1
                -- Restrict lookback for incremental run.
                and effective_date >= current_date() - {{ lookback }}
            group by 1
        ) as aa
        where aa._created_at > coalesce((select max(createddate) from {{ this }}) , aa._created_at - interval '1 day')
        group by all
    {%- else %}
        select distinct effective_date
        from {{ ref('orion__base_vw_account') }}
        where 1 = 1
            -- Max lookback for a full refresh.
            and effective_date >= current_date() - 183

            {%- if target.name not in ['prod'] %}
            --Restrict lookback window in dev.
            and effective_date >= current_date() - {{ dev_filter }}
            {%- endif %}
    {%- endif %}
)


, cte_billschedules as (
    select distinct
        fkalclient
        , pkbillschedule
        , sschedule
    from {{ ref('orion__base_vw_billschedule') }}
)

, cte_eclipse_udf as (
    select
        fkalclient
        , entityenum
        , fkparent
        , lower(fieldvalue) as fieldvalue
        , effective_date
    from {{ ref('orion__base_vw_userdefinedfields') }}
    where 1=1
        -- eclipse_enabled UDF
        and pkuserdefinedef = 529
        {%- if is_incremental() %}
        and effective_date in (select effective_date from cte_dates_to_refresh)
        {%- endif %}
)

, cte_account_values as (
    select effective_date, fkalclient, account_id, aum
    from {{ ref('orion__account_values') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_registration as (
    select effective_date, fkalclient, pkregistration, fkclient, fkpersonal, fkregistrationtype
    from {{ ref('orion__base_vw_registration') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_personal_registration as (
    select effective_date, reg_fkalclient, reg_pkregistration, reg_fkpersonal, reg_pers_entityname
    from {{ ref('orion__base_vw_personal_registration') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_household as (
    select effective_date, fkalclient, pkclient, fkrep, startdate
    from {{ ref('orion__base_vw_household') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_rep as (
    select effective_date, fkalclient, pkrep, fkpersonal, fkbrokerdealer
    from {{ ref('orion__base_vw_representative') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_personal_brokerdealer as (
    select effective_date, fkalclient, pkbrokerdealer
    from {{ ref('orion__base_vw_brokerdealer') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
)

, cte_udf_account as (
    select effective_date, fkalclient, code, fkaccount, fieldvalue
    from {{ ref('orion__base_vw_userdefinedfields_account') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_dates_to_refresh)
        and code in ('7COMMITTED', '7CUSTODIAN', '7ACCOUNTCL')
)

select
    a.effective_date                                as effective_date
    , a.system_name                                 as system_name
    , a.system_instance                             as system_instance
    , a.system_key                                  as system_key
    , a.firm_source                                 as firm_source
    -- CRM --------------------------------------------------------------------
    , upper(a.acctcode)::text(200)                  as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(a.acctcode , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )                                               as account_number
    , cust.name::text(500)                          as custodian
    , a.pkaccount::text(200)                        as account_id
    , regtype.sregdesc::text(200)                   as account_type
    , p.entityname::text(500)                       as account_name
    , reg.pkregistration::integer                   as registration_id
    , regp.reg_pers_entityname::text(512)           as registrant_name
    , ph.hh_pkclient::text(200)                     as household_id
    , ph.hh_pers_entityname::text(500)              as household_name
    , h.startdate::date                             as client_open_date
    , case
        when a.isactive = 0 or a.canceldate is not null
            then 0
        else a.isactive
    end::int                                        as is_active
    , a.acctcreateddate::date                       as created_date
    , a.acctstartdate::date                         as opened_date
    , a.canceldate::date                            as closed_date
    , try_to_date(udfacd.fieldvalue)                as closed_date_udf
    , av.aum::decimal(16 , 2)                       as account_value
    , rep.pkrep::integer                            as representative_id
    , repp.entityname::text(200)                    as advisor
    , lower(repp.email)::text(200)                  as advisor_email
    , case
        when a.fkalclient = 568--mwa/core
            then null
        when a.fkalclient = 1945--hayes
            then 'L-10019'
        when a.fkalclient = 2102--cascadia
            then '199'
        when a.fkalclient = 2623--arbor_wealth
            then '194'
        when a.fkalclient = 3394--mps
            then null
        when a.fkalclient = 2878--network
            then null
    end::text(50)                                   as location_code
    --, mod.modelname::text(200)                              as investment_strategy
    , mod.aggregationname::text(200)                as investment_strategy
    --, null::text(200)                                       as aum_classification --sourced from crm
    , a.fkalclient                                  as fkalclient
    , bdp.bd_pers_entityname::text(200)             as bd_name
    , abs.lastreconciledeffectivedate               as last_reconciled_date
    , abs.inbalance::int                            as is_in_balance
    , abs.hasnondownloadingasset::int               as has_non_downloading_asset
    , a.tradinginstr::text(512)                     as trading_instructions
    , a.ismanaged::boolean::int                     as is_managed
    , udfcar.fieldvalue::text(512)                  as custodian_account_restriction
    , a.fksubadvisor::int                           as subadvisor_id
    , subp.entityname::text(200)                    as subadvisor
    , fund.entityname::text(200)                    as fund_family
    , a.issma::boolean::int                         as is_sma
    , a.fksmaasset::int                             as sma_asset_id
    , coalesce(smap.ticker , smap.cusip)::text(200) as sma_asset
    , ds.downloaddesc::text(200)                    as download_source
    , a.istradingblocked::boolean::int              as is_trading_blocked
    , bs.sschedule::text(200)                       as fee_schedule
    , a.eclipsesma::int                             as eclipse_sma
    , coalesce(
        udf_eclacc.fieldvalue
        , udf_eclreg.fieldvalue
        , udf_eclhh.fieldvalue
        , udf_eclrep.fieldvalue
        , udf_ecldb.fieldvalue
    )::boolean::int                                 as eclipse_enabled
    , udfcom.fieldvalue::decimal(16 , 2)            as committed_amount_udf

    -- META ----------------------------------------  ---------------------------
    , current_timestamp()::timestamp_ntz            as _created_at
    , a._extracted_at::timestamp_ntz                as _source_loaded_at
    , a.createddate                                 as createddate
    , a._source_file::varchar(200)                  as _source_file
from {{ ref('orion__base_vw_account') }} as a
left join cte_account_values as av
    on a.fkalclient = av.fkalclient
    and a.pkaccount = av.account_id
    and a.effective_date = av.effective_date
left join {{ ref('orion__base_vw_custodian') }} as cust
    on a.fkalclient = cust.fkalclient
    and a.fkcustodian = cust.pkcustodian
inner join cte_registration as reg
    on a.fkalclient = reg.fkalclient
    and a.fkregistration = reg.pkregistration
    and a.effective_date = reg.effective_date
left join cte_personal_registration as regp
    on reg.fkalclient = regp.reg_fkalclient
    and reg.pkregistration = regp.reg_pkregistration
    and reg.fkpersonal = regp.reg_fkpersonal
    and reg.effective_date = regp.effective_date
left join {{ ref('orion__base_vw_registrationtype') }} as regtype
    on reg.fkalclient = regtype.fkalclient
    and reg.fkregistrationtype = regtype.pkregistrationtype
left join {{ ref('orion__base_vw_personal') }} as p
    on reg.fkalclient = p.fkalclient
    and reg.fkpersonal = p.pkpersonal
left join {{ ref('orion__base_vw_personal_household') }} as ph
    on reg.fkalclient = ph.hh_fkalclient
    and reg.fkclient = ph.hh_pkclient
inner join cte_household as h
    on reg.fkalclient = h.fkalclient
    and reg.fkclient = h.pkclient
    and a.effective_date = h.effective_date
inner join cte_rep as rep
    on h.fkalclient = rep.fkalclient
    and h.fkrep = rep.pkrep
    and a.effective_date = rep.effective_date
left join {{ ref('orion__base_vw_personal') }} as repp
    on rep.fkalclient = repp.fkalclient
    and rep.fkpersonal = repp.pkpersonal
left join cte_personal_brokerdealer as bd
    on rep.fkalclient = bd.fkalclient
    and rep.fkbrokerdealer = bd.pkbrokerdealer
left join {{ ref('orion__base_vw_personal_brokerdealer') }} as bdp
    on bd.fkalclient = bdp.bd_fkalclient
    and bd.pkbrokerdealer = bdp.bd_pkbrokerdealer
    and a.effective_date = bdp.effective_date
left join {{ ref('orion__base_vw_modelagg') }} as mod
    on a.fkalclient = mod.fkalclient
    and a.fkmodelagg = mod.fkmodelagg
    and a.effective_date = mod.effective_date
left join {{ ref('orion__base_vw_accountbalancestatus') }} as abs
    on a.fkalclient = abs.fkalclient
    and a.pkaccount = abs.fkaccount
left join cte_udf_account as udfcar
    on a.fkalclient = udfcar.fkalclient
    and a.pkaccount = udfcar.fkaccount
    and udfcar.code = '7CUSTODIAN'
    and a.effective_date = udfcar.effective_date
left join cte_udf_account as udfcom
    on a.fkalclient = udfcom.fkalclient
    and a.pkaccount = udfcom.fkaccount
    and udfcom.code = '7COMMITTED'
    and a.effective_date = udfcom.effective_date
left join {{ ref('orion__base_vw_subadvisor') }} as sub
    on a.fkalclient = sub.fkalclient
    and a.fksubadvisor = sub.pksubadvisor
left join {{ ref('orion__base_vw_personal') }} as subp
    on sub.fkalclient = subp.fkalclient
    and sub.fkpersonal = subp.pkpersonal
left join {{ ref('orion__base_vw_fundfamily') }} as fund
    on a.fkalclient = fund.fkalclient
    and a.fkfundfamily = fund.pkfundfamily
left join {{ ref('orion__base_vw_asset') }} as smaa
    on a.fksmaasset = smaa.fkasset
    and a.fkalclient = smaa.fkalclient
left join {{ ref('orion__base_vw_product') }} as smap
    on smaa.productid = smap.pkproduct
    and smaa.fkalclient = smap.fkalclient
left join {{ ref('orion__base_vw_downloadsource') }} as ds
    on a.fkdownloadsource = ds.pkdownloadsource
    and a.fkalclient = ds.fkalclient
left join {{ ref('orion__base_vw_billaccount') }} as ba
    on a.pkaccount = ba.fkaccount
    and a.fkalclient = ba.fkalclient
left join cte_billschedules as bs
    on ba.fkbillfeeschedule = bs.pkbillschedule
    and ba.fkalclient = bs.fkalclient
left join cte_udf_account as udfacd
    on a.fkalclient = udfacd.fkalclient
    and a.pkaccount = udfacd.fkaccount
    and udfacd.code = '7ACCOUNTCL'
    and a.effective_date = udfacd.effective_date
left join cte_eclipse_udf as udf_eclrep
    on udf_eclrep.entityenum = 4--rep
    and representative_id = udf_eclrep.fkparent
    and a.fkalclient = udf_eclrep.fkalclient
    and a.effective_date = udf_eclrep.effective_date
left join cte_eclipse_udf as udf_eclhh
    on udf_eclhh.entityenum = 5--client
    and household_id = udf_eclhh.fkparent
    and a.fkalclient = udf_eclhh.fkalclient
    and a.effective_date = udf_eclhh.effective_date
left join cte_eclipse_udf as udf_eclreg
    on udf_eclreg.entityenum = 6--registration
    and registration_id = udf_eclreg.fkparent
    and a.fkalclient = udf_eclreg.fkalclient
    and a.effective_date = udf_eclreg.effective_date
left join cte_eclipse_udf as udf_eclacc
    on udf_eclacc.entityenum = 7--account
    and account_id = udf_eclacc.fkparent
    and a.fkalclient = udf_eclacc.fkalclient
    and a.effective_date = udf_eclacc.effective_date
left join cte_eclipse_udf as udf_ecldb
    on udf_ecldb.entityenum = 39--database
    and a.fkalclient = udf_ecldb.fkalclient
    and a.effective_date = udf_ecldb.effective_date

where 1 = 1
    and a.effective_date >= current_date() - {{ max_lookback }}
    -- If an account record doesn't have an account number we'll exclude it.
    -- Not sure if this has happened before but it would probably indicate a corrupt,
    -- fake, or otherwise useless record. We _need_ an account number.
    and nullif(replace(a.acctcode , '-' , '') , '') is not null

    and a.effective_date in (select effective_date from cte_dates_to_refresh)
order by a.effective_date , a.fkalclient , left(account_number , 2)
