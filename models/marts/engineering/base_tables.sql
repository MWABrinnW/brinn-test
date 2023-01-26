select * from {{ source('information_schema', 'tables') }}
