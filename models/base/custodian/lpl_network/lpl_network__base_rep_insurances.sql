
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , repid                                                   as rep_id
  , state                                                   as state
  , insurancelinecode                                       as insurance_line_code
  , to_date(pendingdate, 'MM/DD/YYYY')                      as insurance_pending_date
  , to_date(effectivedate, 'MM/DD/YYYY')                    as insurance_effective_date
  , to_date(expirationdate, 'MM/DD/YYYY')                   as expiration_date
  , licenseno                                               as license_no
  , insurancestatuscode                                     as insurance_status_code
  , insurancestatusdate                                     as insurance_status_date
  , appointmentno                                           as appointment_no
  , sponsorname                                             as sponsor_name
  , {{ col_is_head(reference=source('lpl_network', 'repinsurance')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file
from {{ source('lpl_network', 'repinsurance') }}
