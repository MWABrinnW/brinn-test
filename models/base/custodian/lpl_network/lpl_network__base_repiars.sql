
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , repid::varchar(200)                                     as rep_id
  , state::varchar(200)                                     as state
  , isstateregistered::int                                  as is_state_registered
  , isiarregistered::int                                    as is_iar_registered
  , to_date(approveddate, 'MM/DD/YYYY')                     as approved_date
  , to_date(updateddate, 'MM/DD/YYYY')                      as updated_date
  , {{ col_is_head(reference=source('lpl_network', 'repiar')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'repiar') }}
