select
    to_date(v.value:restrictionStartDate::string, 'YYYYMMDD')                as restrictionstartdate
  , case
        when v.value:restrictionEndDate != ''
            then to_date(v.value:restrictionEndDate::string, 'YYYYMMDD') end as restrictionenddate
  , v.value:enabled::boolean                                                 as enabled
  , v.value:restrictionId::string                                            as restrictionid
  , v.value:accountId::string                                                as accountid
  , v.value:custId::string                                                   as custid
  , v.value:userId::string                                                   as userid
  , v.value:restrictionType::string                                          as restrictiontype
  , v.value:securityId::string                                               as securityid
  , v.value:cusip::string                                                    as cusip
  , v.value:product::string                                                  as product
  , v.value:notes::string                                                    as notes
  , to_timestamp_tz(v.value:lastModified::string,
                    'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')                       as lastmodified
  , {{ col_is_head(reference=source('copilot', 'restrictions_raw'), source_date_col='r.record_datetime', reference_date_col='record_datetime') }}
  , r.record_date                                                            as record_date
  , r.record_datetime                                                        as record_datetime
from {{ source('copilot', 'restrictions_raw') }}              r
   , lateral flatten(input => r.json, path => 'restrictions') v