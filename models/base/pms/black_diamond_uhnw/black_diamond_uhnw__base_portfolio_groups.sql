{% set src = source('black_diamond_uhnw', 'portfolio_group') %}

select
    'black_diamond'                                as system_name
    , 'uhnw'                                       as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , a.effective_date                             as effective_date
    , a.json:PortfolioGroupID::string              as portfolio_group_id
    , a.json:PortfolioGroupName::string            as asportfolio_group_name
    , portfolioid.value::string                    as portfolio_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , a.record_datetime                            as _source_loaded_at
from {{ src }} as a
, table(flatten(a.json , 'PortfolioIds')) as portfolioid
