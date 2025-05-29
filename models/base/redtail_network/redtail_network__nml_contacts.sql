select c.*
{# ,udf.* exclude udf.udf_id #}
from {{ ref('redtail_network__base_contacts') }} as c
{# left join {{ ref('redtail_network__int_contact_udfs') }} udf
    on c.contact_id = udf.contact_id
    and c.effective_at::date = udf.effective_at::date #}
