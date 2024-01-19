{% set src = source('black_diamond_ap4', 'accounts') %}

select
    'black_diamond'                        as pms
    , 'ap4'                                as pms_location
    , 'mwa'                                as firm_source
    , effective_date                       as effective_date
    , json:AccountNumber::string           as account_number
    , h.value:AccountId::string            as account_id
    , h.value:Id::string                   as id
    , h.value:DisplayCusip::string         as cusip
    , h.value:Ticker::string               as ticker
    , h.value:AssetId::number              as asset_id
    , h.value:AsOfDate::date               as as_of_date
    , h.value:AssetName::string            as asset_name
    , h.value:AssetNameShort::string       as asset_name_short
    , h.value:IssueType::string            as issue_type
    , h.value:ProviderIssueType::string    as provider_issue_type
    , h.value:ClassName::string            as class_name
    , h.value:Units::decimal(20 , 5)       as units
    , h.value:MarketValue::decimal(20 , 5) as market_value
    , h.value:Cash::boolean                as cash
    , h.value:Billable::boolean            as billable
    , h.value:AssetTags::string            as asset_tags
    , json:Custodian::string               as custodian
    , h.value:Discretionary::string        as discretionary
    , h.value:Price::decimal(20 , 5)       as price
    , h.value:VotingAuthority::string      as proxy_voting_status
    , record_id                            as record_id
    , {{ col_is_head(reference=src, reference_date_col='effective_date', source_date_col='effective_date') }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                      as _source_loaded_at
from {{ src }} , lateral flatten(input => json:Holdings) as h
