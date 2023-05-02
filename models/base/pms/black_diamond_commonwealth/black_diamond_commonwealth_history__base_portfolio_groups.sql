{% set src = source('black_diamond_commonwealth', 'portfolio_group') %}

SELECT 
    'black_diamond' as pms
    , 'commonwealth' as pms_location
    , 'mwa' as firm_source
    , EFFECTIVE_DATE as effective_date
    , JSON:PortfolioGroupID::string as portfolio_group_id
    , JSON:PortfolioGroupName::string asportfolio_group_name
    , PortfolioId.value::string as portfolio_id
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
FROM {{ src }},
     TABLE (flatten(JSON, 'PortfolioIds')) AS PortfolioId