with tmp_rep_codes as 
(
    select
         advisor_rep_code as rep_code
        ,count(distinct _source_file) as file_count
        ,min(effective_date) as min_effective_date
        ,max(effective_date) as max_effective_date
    from {{ref('tda__base_trn')}}
    group by 1
    order by 2 desc
)
,tmp_rep_codes_map as
(
    {# select distinct
         regexp_substr(advisor_code, '^[^ ]+') as rep_code
        ,office_location
        ,status
        ,description
    from {{ref('aux__base_custodian_codes_master_list')}}
    where true
        and custodian ilike '%td%'
        and office_location not ilike 'tbd' #}

    select
        rep_code
        ,firm
    from {{ ref('tda_rep_codes') }}
)
,tmp_rep_codes_veo as
(
    select
        rep_id as rep_code
        ,sum(market_value) as market_value
        ,count(distinct account_number) as accounts
    from {{ ref('tda__base_accounts_balances') }}
    where is_head = 1
    group by 1
)
,tmp_all_codes as
(
    select distinct rep_code from tmp_rep_codes
    union
    select distinct rep_code from tmp_rep_codes_map
    union
    select distinct rep_code from tmp_rep_codes_veo
)
select
    a.rep_code
    ,case when b.rep_code is not null then 1 else 0 end as exists_in_datalake
    ,case when c.rep_code is not null then 1 else 0 end as exists_in_map
    ,case when v.rep_code is not null then 1 else 0 end as exists_in_veo
    ,b.file_count
    ,b.min_effective_date as datalake_min_effective_date
    ,b.max_effective_date as datalake_max_effective_date
    ,v.market_value         as veo_market_value
    ,v.accounts             as accounts
    {# ,c.office_location      as map_office_location
    ,c.description          as map_description #}
from tmp_all_codes a
left join tmp_rep_codes b
    on a.rep_code = b.rep_code
left join tmp_rep_codes_map c
    on a.rep_code = c.rep_code
left join tmp_rep_codes_veo v
    on a.rep_code = v.rep_code
where true
order by a.rep_code