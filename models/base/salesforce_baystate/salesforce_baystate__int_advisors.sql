-- purpose built for pms masters as the crm template for baystate
select
    cod.effective_at::date as effective_date
    , cod.name             as advisor_commission_split_code
    , listagg(con.name || ' (' || to_varchar(det.percentage_c) || '%)' , '; ')
    within group (
        order by det.percentage_c desc , con.name asc
    )                      as advisor
    , listagg(con.id , '; ')
    within group (
        order by det.percentage_c desc , con.name asc
    )                      as advisor_id
from {{ ref('salesforce_baystate__base_advisor_split_detail_c') }} as det
inner join {{ ref('salesforce_baystate__base_advisor_split_code_c') }} as cod
    on det.advisor_split_code_c = cod.id
    and det.effective_at::date = cod.effective_at::date
    and cod.is_head_for_day = 1
inner join {{ ref('salesforce_baystate__base_contact') }} as con
    on det.advisor_name_c = con.id
    and det.effective_at::date = con.effective_at::date
    and con.is_head_for_day = 1
where det.is_head_for_day = 1
group by all
