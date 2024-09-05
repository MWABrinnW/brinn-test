{{ config(
  grants = {'+select': ['ops_mwa']}
) }}

select ch.*
from {{ ref('salesforce_compass__base_case_history') }} as ch
inner join {{ ref('salesforce_compass__base_case_ops') }} as c
    on ch.case_id = c.id
