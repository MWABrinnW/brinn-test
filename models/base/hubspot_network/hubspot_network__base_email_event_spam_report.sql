select *
from {{ source('hubspot_network', 'email_event_spam_report') }}