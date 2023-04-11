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
,tmp_all_codes as
(
    select distinct rep_code from tmp_rep_codes
    union
    select distinct rep_code from tmp_rep_codes_map
)
select
    a.rep_code
    ,case when b.rep_code is not null then 1 else 0 end as exists_in_datalake
    ,case when c.rep_code is not null then 1 else 0 end as exists_in_map
    ,case when exists_in_datalake = 1 and exists_in_map = 1 then 1 else 0 end as exists_in_both
    ,b.file_count
    ,b.min_effective_date as datalake_min_effective_date
    ,b.max_effective_date as datalake_max_effective_date
    {# ,c.office_location      as map_office_location
    ,c.description          as map_description #}
from tmp_all_codes a
left join tmp_rep_codes b
    on a.rep_code = b.rep_code
left join tmp_rep_codes_map c
    on a.rep_code = c.rep_code
where true
order by a.rep_code