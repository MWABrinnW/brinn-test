with cte_dates as (
    select distinct effective_date
    from {{ source('reporting_ext', 'vw_network_advisor_master_monthly') }}
    order by effective_date
)

, cte_lpl_emails as (
    select distinct
        effective_date
        , rep_id
        , email_address
    from {{ ref('lpl_network__base_reps') }}
    where 1 = 1
        and is_head = 1
        and email_address is not null
        and effective_date in (select effective_date from cte_dates)
    qualify dense_rank() over (partition by effective_date , rep_id order by _source_loaded_at desc) = 1
)

, cte_lpl_emails_all_time as (
    select distinct
        rep_id
        , email_address
    from {{ ref('lpl_network__base_reps') }}
    where 1 = 1
        and email_address is not null
    qualify dense_rank() over (partition by rep_id order by _source_loaded_at desc) = 1
)

, cte_redtail_emails as (
    select distinct
        contact_id
        , email_address
        /*
        debugging fields: support deduplication
        --, email_type_description
        --, email_type
        --, is_primary
        --, custom_type_title
        */
        , dense_rank() over (partition by contact_id order by _source_loaded_at desc , is_primary desc , email_type desc) as rn
    from {{ ref('redtail_network__base_contact_email_addresses') }}
    where 1 = 1
        and is_head = 1
)

select
    a.*
    , coalesce(lpl.email_address , redtail.email_address , lpl_all.email_address) as advisor_email
    , {{ col_is_head(
        reference=source('reporting_ext', 'vw_network_advisor_master_monthly')
        , source_date_col='a.effective_date'
        ) }}
    , current_timestamp()                                                         as _created_at
from {{ source('reporting_ext', 'vw_network_advisor_master_monthly') }} as a
left join cte_lpl_emails as lpl
    on a.effective_date = lpl.effective_date
    and a.lpl_master_rep_id = lpl.rep_id
left join cte_redtail_emails as redtail
    on a.redtail_id = redtail.contact_id
    and redtail.rn = 1
left join cte_lpl_emails_all_time as lpl_all
    on a.lpl_master_rep_id = lpl_all.rep_id
qualify row_number() over (partition by a.record_id order by advisor_email desc) = 1
