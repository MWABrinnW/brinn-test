SELECT * FROM {{ source('freshservice', 'fivetran_audit') }}
