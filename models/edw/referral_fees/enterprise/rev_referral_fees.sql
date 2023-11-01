select *
from {{ ref('bld_referral_fees') }} a
left join {{ ref('aux__stg_referral_fees_lock_dates') }} b
    on a.quarter_end_date = b.quarter_end_date
    and a.referral_party_name = b.referral_party_name
where 1=1
    and a.quarter_end_date >= '9/30/2023' --data before 2023Q3 not validated
    and (
        (
            a.referral_party_name ilike 'SAN Program' and a.effective_date =
            coalesce(
                b.lock_date
                , case when a.is_period_latest = 1 then a.effective_date else null end
            )
        )
        or
        (a.referral_party_name in ('SAN Program - Coral Gables', 'WAS Program') and a.is_period_latest = 1)
    )
