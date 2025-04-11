{%- macro black_diamond_transactions(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}
select
    'black_diamond'::text(200)                     as system_name
    , '{{ instance }}'::text(200)                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , '{{ firm_source }}'::text(200)               as firm_source
    , a.effective_date                             as effective_date
    , a.json:AccountNumber::string                 as account_number
    , t.value:AccountFee::decimal(20 , 5)          as account_fee
    , t.value:AccountId::string                    as account_id
    , t.value:Action::string                       as action
    , t.value:AlternateId::string                  as alternate_id
    , t.value:AssetID::string                      as asset_id
    , t.value:Cusip::string                        as cusip
    , t.value:Description::string                  as description
    , t.value:DisplayCusip::string                 as display_cusip
    , t.value:ExternalContraAccountId::string      as external_contra_account_id
    , t.value:ExternalFlowAffect::string           as external_flow_affect
    , t.value:FileCodeDescription::string          as file_code_description
    , t.value:HoldingID::string                    as holding_id
    , t.value:IssueType::string                    as issue_type
    , t.value:MarketValue::decimal(20 , 5)         as market_value
    , t.value:Notes::string                        as notes
    , t.value:Price::decimal(20 , 5)               as price
    , t.value:ReturnDate::date                     as return_date
    , t.value:SettleDate::date                     as settle_date
    , t.value:SubCode::string                      as sub_code
    , t.value:Ticker::string                       as ticker
    , t.value:TradeDate::date                      as trade_date
    , t.value:TransCode::string                    as trans_code
    , t.value:TransactionFee::decimal(20 , 5)      as transaction_fee
    , t.value:TransactionID::string                as transaction_id
    , t.value:TransactionSubType::string           as transaction_sub_type
    , t.value:TransactionType::string              as transaction_type
    , t.value:Units::decimal(20 , 5)               as units
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
, lateral flatten(input => a.json:Transactions) as t
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}
