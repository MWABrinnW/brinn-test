select distinct
    regexp_substr(advisor_code, '^[^ ]+') as rep_code
    ,case
        when office_location ilike '%mwa%'
            then 'mwa'
        when office_location ilike '%mps%'
            then 'mps'
        when office_location ilike '%msec%'
            then 'msec'
        when office_location ilike '%swag%'
            then 'swag'
        else null
        end as firm
    ,status
    ,description
from {{ref('aux__base_custodian_codes_master_list')}}
where true
    and custodian ilike '%td%'