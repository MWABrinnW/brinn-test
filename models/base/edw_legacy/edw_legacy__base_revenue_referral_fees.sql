select
    a.system_name
    , a.source_file_name
    , a.statement_number
    , a.statement_date
    , a.revenue_quarter
    , a.client_name
    , a.client_manager
    , a.financial_account_number
    , a.location_code
    , a.location_name
    , a.referral_party_name
    , a.referral_party_id
    , a.client_net_fee
    , a.referral_rate
    , a.referral_fee
    , a.key
    , a.record_datetime
    , a.record_date
    , a.id
    , lh.location_code as effective_location_code
    , l.location_name  as effective_location_name
    , l.accounting_id
from {{ source('edw_legacy', 'revenue_referral_fees') }} as a
left join {{ ref('locations_history') }} as lh
    on a.location_code = lh.location_code
    and a.statement_date = lh.effective_date
    and a.statement_date between lh.start_date and lh.end_date
left join {{ ref('locations') }} as l
    on lh.location_code = l.location_code
    and a.statement_date between l.start_date and l.end_date
