select
     'copilot'::text                                      as system_name
    , 'mwa-options'                                       as system_instance
    , system_name || '__' || system_instance              as system_key
    , a.json:name::text(200)                              as group_name
    , a.json:description::text(200)                       as group_description
    , a.json:groupId::text(200)                           as group_id
    , a.json:groupType::text(200)                         as group_type
    , a.json:groups::text(200)                            as groups
    , a.json:custId::text(200)                            as group_cust_id
    , a.json:parentGroupId::text(200)                     as parent_group_id
    , a.json:userId::int                                  as user_id
    , acc.value:accountDetail::text(200)                  as account_detail
    , acc.value:accountId::int                            as account_id
    , acc.value:accountNumber::text(200)                  as account_number
    , acc.value:accountName::text(200)                    as account_name
    , try_to_boolean(acc.value:cashAccount::text)::int    as is_cash_account
    , acc.value:cashReserve::double                       as cash_reserve
    , acc.value:cashReserveExpiry::date                   as cash_reserve_expiration_date
    , acc.value:cashReserveExpiryStr::text(200)           as cash_reserve_expiration
    , acc.value:complianceRules::text(200)                as compliance_rules
    , acc.value:custId::text(200)                         as account_cust_id
    , acc.value:custodian::text(200)                      as custodian
    , try_to_boolean(acc.value:disableSleeves::text)::int as is_disable_sleeves
    , acc.value:endDate::date                             as end_date
    , try_to_boolean(acc.value:explicitSleeve::text)::int as is_explicit_sleeve
    , acc.value:groupId::int                              as account_group_id
    , acc.value:householdId::int                          as household_id
    , acc.value:importDate::date                          as import_date
    , acc.value:longName::text(200)                       as long_name
    , acc.value:longTermTaxRate::float                    as long_term_tax_rate
    , acc.value:modelId::int                              as model_id
    , acc.value:modelName::text(200)                      as model_name
    , acc.value:name::text(200)                           as account_name
    , acc.value:notes::text(200)                          as notes
    , acc.value:percentOrjson::double                     as percent_or_value
    , acc.value:shortTermTaxRate::float                   as short_term_tax_rate
    , acc.value:startDate::date                           as start_date
    , acc.value:taxLotReliefMethod::text(200)             as tax_lot_relief_method
    , try_to_boolean(acc.value:taxable::text)::int        as is_taxable
    , case
        when a._created_at = (select max(_created_at) from {{ source('flyer', 'groups') }})
            then 1
        else 0
    end::int                                              as is_head
    , case
        when a._created_at = max(a._created_at) over(partition by a._created_at::date)
            then 1
        else 0
    end::int                                              as is_head_for_day
    , dt.prior_market_date                                as effective_date
    , a._created_at                                       as _created_at
    , a._source_file                                      as _source_file
    , a._uri                                              as _uri
    , {{ parse_copilot_env(col='a._uri') }}
from {{ source('flyer', 'groups') }} as a
left join {{ ref('dates' ) }} as dt
    on a._created_at::date = dt.date_key
, lateral flatten(input => a.json, path => 'accounts') as acc
where 1 = 1
    and _env = {{ "'" ~ copilot_env() ~ "'" }}
