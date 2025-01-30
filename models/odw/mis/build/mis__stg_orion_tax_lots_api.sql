select
    effective_date                             as effective_date
    , _data:"id"::int                          as id
    , _data:"assetId"::int                     as asset_id
    , _data:"asOfDate"::date                   as as_of_date
    , _data:"accountId"::int                   as account_id
    , _data:"registrationName"::text           as registration_name
    , _data:"householdName"::text              as household_name
    , _data:"custodian"::text                  as custodian
    , _data:"custodianRecordID"::text          as custodian_record_id
    , _data:"shortTermUnits"::decimal(20 , 5)  as short_term_units
    , _data:"shortTermCost"::decimal(20 , 2)   as short_term_cost
    , _data:"longTermUnits"::decimal(20 , 5)   as long_term_units
    , _data:"longTermCost"::decimal(20 , 2)    as long_term_cost
    , _data:"amortizationAmt"::decimal(20 , 2) as amortization_amt
    , _data:"acquiredDate"::date               as acquired_date
    , _data:"productId"::int                   as product_id
    , _data:"productTicker"::text              as product_ticker
    , _data:"productName"::text                as product_name
    , _data:"isVarious"::boolean:int           as is_various
    , _data:"isQualified"::boolean::int        as is_qualified
    , _data:"isInherited"::int                 as is_inherited
    , _data:"isUnknown"::int                   as is_unknown
    , _data:"isLongTerm"::boolean::int         as is_long_term
    --   , _data:"accountNumber"::text             as account_number
    --   , _data:"accountCreatedDate"::text        as account_created_date
    --   , _data:"representative"::text            as representative
    --   , _data:"representativeNumber"::text      as representative_number
    --   , _data:"registrationId"::int             as registration_id
    --   , _data:"registrationType"::text          as registration_type
    --   , _data:"holdPeriodDate"::date            as hold_period_date
    , _data:"editedDate"::timestamp_tz         as edited_date
    , _data:"costBasisMethod"::int             as cost_basis_method
    , _data:"source"::int                      as source
    , case
        when _source_file ilike '%custodian%'
            then 'custodian'
        else 'orion'
    end::text                                  as lot_source
    , _data:"clientId"::int                    as client_id
    , _source_file                             as _source_file
    , _created_at                              as _created_at
    , _id                                      as _id
    , {{ col_is_head(
        reference=source('mis', 'orion_tax_lots_api'),
        source_date_col='effective_date',
        reference_date_col='effective_date'
        ) }}
    , case
        when _created_at = max(_created_at) over (
                partition by effective_date
            )
            then 1
        else 0
    end::int                                   as is_head_for_day
from {{ source('mis', 'orion_tax_lots_api') }}
where 1 = 1
    and _data:id::int is not null
