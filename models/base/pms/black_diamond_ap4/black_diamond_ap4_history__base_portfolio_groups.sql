{% set src = source('black_diamond_ap4', 'portfolio_group') %}

select
    'black_diamond'                   as pms
    , 'ap4'                           as pms_location
    , 'mwa'                           as firm_source
    , effective_date                  as effective_date
    , json:PortfolioGroupID::string   as portfolio_group_id
    , json:PortfolioGroupName::string as asportfolio_group_name
    , portfolioid.value::string       as portfolio_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                 as _source_loaded_at
from {{ src }}
, TABLE(FLATTEN(json , 'PortfolioIds')) as portfolioid
