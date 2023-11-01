select
      json:Period::int                                  as period_datenum
    , json:Date::date                                   as date
    , json:"Adjustment Amount"::decimal(15,2)           as amount
    , json:"Adjustment Type"::varchar(200)              as adjustment_type
    , replace(json:"HH ID"::varchar(200),'HH','')       as household_id
    , json:"Client Household"::varchar(200)             as client_name
    , json:Description::varchar(200)                    as description
    , json:"MWA Advisor"::varchar(200)                  as mwa_advisor
from {{ source('aux', 'referral_fees_san_adjustments') }}
