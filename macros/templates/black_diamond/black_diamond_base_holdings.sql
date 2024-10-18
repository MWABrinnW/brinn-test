{%- macro black_diamond_base_holdings(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}

select
    'black_diamond'::text(200)                     as system_name
    , '{{ instance }}'::text(200)                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , '{{ firm_source }}'::text(200)               as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , h.value:AccountId::string                    as account_id
    , h.value:Id::string                           as id
    , h.value:DisplayCusip::string                 as cusip
    , h.value:Ticker::string                       as ticker
    , h.value:AssetId::number                      as asset_id
    , h.value:AsOfDate::date                       as as_of_date
    , h.value:AssetName::string                    as asset_name
    , h.value:AssetNameShort::string               as asset_name_short
    , h.value:IssueType::string                    as issue_type
    , h.value:ProviderIssueType::string            as provider_issue_type
    , h.value:ClassName::string                    as class_name
    , h.value:Units::decimal(20 , 5)               as units
    , h.value:MarketValue::decimal(20 , 5)         as market_value
    , h.value:Cash::boolean                        as cash
    , h.value:Billable::boolean                    as billable
    , h.value:AssetTags::string                    as asset_tags
    , a.json:Custodian::string                     as custodian
    , h.value:Discretionary::string                as discretionary
    , h.value:Price::decimal(20 , 5)               as price
    , h.value:VotingAuthority::string              as proxy_voting_status
    , a.record_id                                  as record_id
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                            as _source_loaded_at
    {%- if extra_columns -%}
    {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
, lateral flatten(input => a.json:Holdings) as h
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}
