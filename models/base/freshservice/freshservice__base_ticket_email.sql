SELECT * FROM {{ source('freshservice', 'ticket_email') }}
