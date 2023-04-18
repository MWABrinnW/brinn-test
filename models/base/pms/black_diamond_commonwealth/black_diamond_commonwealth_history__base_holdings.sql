{% set src = source('black_diamond_commonwealth', 'accounts') %}

select
  'black_diamond'                            as pms
  , 'commonwealth'                                    as pms_location
  , 'mwa'                                    as firm_source
  , EFFECTIVE_DATE as effective_date
  , JSON:AccountNumber::string as account_number
  , H.value:AccountId::string as account_id
  , H.value:Id::string as id
  , H.value:DisplayCusip::string as cusip
  , H.value:Ticker::string as ticker
  , H.value:AssetId::number as asset_id
  , H.value:AsOfDate::date as as_of_date
  , H.value:AssetName::string as asset_name
  , H.value:AssetNameShort::string as asset_name_short
  , H.value:IssueType::string as issue_type
  , H.value:ProviderIssueType::string as PROVIDER_ISSUE_TYPE
  , H.value:ClassName::string as class_name
  , H.value:Units::decimal(20,5) as units
  , H.value:MarketValue::decimal(20,5) as market_value
  , H.value:Cash::boolean as cash
  , H.value:Billable::boolean as billable
  , H.value:AssetTags::string as asset_tags
  , JSON:Custodian::string as custodian
  , H.value:Discretionary::string as discretionary
  , H.value:Price::decimal(20,5) as price
  , H.value:VotingAuthority::string as proxy_voting_status
  , RECORD_ID as record_id
  , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime as _source_loaded_at
from {{ src }}, lateral flatten(input => JSON:Holdings) H 

