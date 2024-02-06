{% set src = source('black_diamond_houston', 'portfolio_group') %}

select
    'black_diamond'                               as system_name
    , 'houston'                                   as system_instance
    , concat(system_name , '_' , system_instance) as system_key
    , 'mwa'                                       as firm_source
    , effective_date                              as effective_date
    , json:PortfolioGroupID::string               as portfolio_group_id
    , json:PortfolioGroupName::string             as asportfolio_group_name
    , portfolioid.value::string                   as portfolio_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                             as _source_loaded_at
from {{ src }}
, table(flatten(json , 'PortfolioIds')) as portfolioid
