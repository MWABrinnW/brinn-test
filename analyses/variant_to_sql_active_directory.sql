with cte_paths as (

    select distinct
        f.path
      , typeof(f.value) as value_type
      , ',' || case
                   when f.path ilike any
                        ('created', 'LastBadPasswordAttempt', 'LastLogonDate', 'Modified', 'createTimeStamp',
                         'PasswordLastSet', 'modifyTimeStamp', 'whenCreated', 'LastBadPasswordAttempt',
                         'msTSExpireDate', 'whenchanged', 'msexchwhenmailboxcreated', 'accountexpirationdate',
                         'accountlockouttime')
                       then '_data:"' || f.path || '"' || '::timestamp_tz'
                   when f.path ilike any
                        ('pwdLastSet', 'lastLogon', 'badPasswordTime', 'lastLogonTimestamp', 'lastlogoff',
                         'badPasswordTime', 'pwdLastSet', 'lastLogon', 'lastLogonTimestamp', 'lastlogon',
                         'lockouttime', 'accountexpires')
                       then 'to_timestamp_ntz(( _data:"' || f.path || '"::integer - 116444736000000000 ) / 10000000.0)'
                   when ( typeof(f.value) ilike 'ARRAY' or f.path ilike any ( 'count' ) )
                       then '_data:"' || f.path || '"::variant'
                   when f.path ilike any ( 'country' )
                       then '_data:' || f.path || '"::text(500)'
                   when typeof(f.value) ilike 'BOOLEAN' then '_data:"' || f.path || '"::boolean::int'
                   when typeof(f.value) ilike 'INTEGER' then '_data:"' || f.path || '"::int'
                   when typeof(f.value) ilike 'VARCHAR' then '_data:"' || f.path || '"::text(500)'
                   when typeof(f.value) ilike 'NULL_VALUE' and f.path ilike 'is%' then '_data:"' || f.path || '"::int'
                   when typeof(f.value) ilike 'NULL_VALUE' and lower(f.path) in
                                                               ('homepage', 'displayname',
                                                                'lastknownparent', 'ipv6address',
                                                                'deleted', 'managedby',
                                                                'userprincipalname',
                                                                'operatingsystemservicepack',
                                                                'description')
                       then '_data:"' || f.path || '"::text(500)'
                   when typeof(f.value) ilike 'NULL_VALUE' and
                        ( f.path ilike any ('logoncount', 'badlogoncount', 'badpwdcount') or f.path ilike '%count%' )
                       then '_data:"' || f.path || '"::int'
                   when typeof(f.value) ilike 'NULL_VALUE' then '_data:"' || f.path || '"::text(500)'
                   else '_data:"' || f.path || '"::text(500)'
        end
            || ' as ' || lower(f.path)
                        as sql
      , min(f.value)    as min_value
      , max(f.value)    as max_value
    from raw_dev.active_directory.                 users
       , lateral flatten(_data, recursive => true) f
    where typeof(f.value) != 'OBJECT'
      -- exclude the paths to array elements
      and f.path not like '%[%]%'
      --exclude nested paths
      and f.path not like '%.%'
    group by all
)

select *
from cte_paths
