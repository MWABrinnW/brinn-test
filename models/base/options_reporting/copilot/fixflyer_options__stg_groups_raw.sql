select
    g.value:name::string                 as name
  , g.value:description::string          as description
  , g.value:groupId::string              as groupid
  , g.value:groupType::string            as grouptype
  , g.value:groups::string               as groups
  , g.value:custId::string               as custid
  , g.value:parentGroupId::string        as parentgroupid
  , g.value:userId::string               as userid
  , a.value:accountDetail::string        as accountdetail
  , a.value:accountId::string            as accountid
  , a.value:accountName::string          as accountname
  , a.value:accountNumber::string        as accountnumber
  , a.value:cashAccount::boolean         as cashaccount
  , a.value:cashReserve::double          as cashreserve
  , a.value:cashReserveExpiry::date      as cashreserveexpiry
  , a.value:cashReserveExpiryStr::string as cashreserveexpirystr
  , a.value:complianceRules::string      as compliancerules
  , a.value:custId::string               as account_custid
  , a.value:custodian::string            as custodian
  , a.value:disableSleeves::boolean      as disablesleeves
  , a.value:endDate::date                as enddate
  , a.value:explicitSleeve::boolean      as explicitsleeve
  , a.value:groupId::string              as account_groupid
  , a.value:householdId::string          as householdid
  , a.value:importDate::date             as importdate
  , a.value:longName::string             as longname
  , a.value:longTermTaxRate::float       as longtermtaxrate
  , a.value:modelId::string              as modelid
  , a.value:modelName::string            as modelname
  , a.value:name::string                 as account_name
  , a.value:notes::string                as notes
  , a.value:percentOrValue::double       as percentorvalue
  , a.value:shortTermTaxRate::float      as shorttermtaxrate
  , a.value:startDate::date              as startdate
  , a.value:taxLotReliefMethod::string   as taxlotreliefmethod
  , a.value:taxable::boolean             as taxable
  , {{ col_is_head(reference=source('copilot', 'groups_raw'), source_date_col='gr.record_datetime', reference_date_col='record_datetime') }}
  , gr.record_date                       as record_date
  , gr.record_datetime                   as record_datetime
from {{ source('copilot', 'groups_raw') }}                 gr
   , lateral flatten(input => gr.json, path => 'groups')   g
   , lateral flatten(input => g.value, path => 'accounts') a