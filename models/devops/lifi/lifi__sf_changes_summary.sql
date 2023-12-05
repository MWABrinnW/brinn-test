select salesforce_needs_updated
     , change_summary
     , is_lifi  as should_be_LIFI
     , lifi_reason
     , is_salesforce_lifi
     , is_in_orion
     , is_in_schwab
     , is_in_fidelity
     , is_custodian_lifi
     , is_subadvisor_lifi
     , iff(sf_closed_date is not null, 1, 0) as is_sf_closed
     , iff(sf_status = 'Open', 1, 0) as is_sf__status_open
     , is_linked_at_all
     , iff(custodian_account_value is not null, 1, 0) as is_custodian_account_value_nonzero
     , count(*) as cnt
from {{ ref('lifi__sf_changes') }}
group by all
order by salesforce_needs_updated, change_summary, lifi_reason
