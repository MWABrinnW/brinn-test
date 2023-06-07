select
    r.value:accountId::string                                                           as accountid
  , r.value:name::string                                                                as name
  , r.value:custId::string                                                              as custid
  , r.value:modelId::string                                                             as modelid
  , r.value:groupId::string                                                             as groupid
  , r.value:sleeveId::string                                                            as sleeveid
  , to_timestamp(r.value:startDate::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM')  as startdate
  , to_timestamp(r.value:importDate::varchar(100), 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM') as importdate
  , r.value:cashAccount::boolean                                                        as cashaccount
  , r.value:taxLotReliefMethod                                                          as taxlotreliefmethod
  , r.value:longTermTaxRate                                                             as longtermtaxrate
  , r.value:shortTermTaxRate                                                            as shorttermtaxrate
  , r.value:taxable::boolean                                                            as taxable
  , r.value:disableSleeves::boolean                                                     as disablesleeves
  , r.value:explicitSleeve::boolean                                                     as explicitsleeve
  , r.value:cashReserve                                                                 as cashreserve
  , r.value:percentOrValue                                                              as percentorvalue
  , r.value:sleeves                                                                     as sleeves
  , r.value:accountNumber::string                                                       as accountnumber
  , r.value:custodian::string                                                           as custodian
  , r.value:householdId::string                                                         as householdid
  , {{ col_is_head(reference=source('copilot', 'copilot_accounts'), source_date_col='a.record_datetime', reference_date_col='record_datetime') }}
  , a.record_date
  , a.record_datetime
from {{ source('copilot', 'copilot_accounts') }}                  a
   , lateral flatten(input => a.variant_data, path => 'accounts') r