{% set src = source('black_diamond_baystate', 'relationship') %}

select
    'black_diamond'                              as pms
    , 'baystate'                                 as pms_location
    , 'baystate'                                 as firm_source
    , effective_date                             as effective_date
    , json:Relationship.ID::string               as relationship_id
    , json:Relationship.Name::string             as relationship_name
    , json:Relationship.ClientTypeID::string     as relationship_client_type_id
    , account.value:HistoryStartDate::date       as history_start_date
    , account.value:ClosedDate::date             as relationship_termination_date
    , account.value:Relationship::string         as relationship_display_name
    , portfolios.value:Id::string                as portfolio_id
    , portfolios.value:Name::string              as portfolio_name
    , portfolios.value:DisplayName::string       as portfolio_display_name
    , account.value:ExternalID::string           as account_id
    , account.value:LongNumber::string           as account_number
    , account.value:AccountDisplayNumber::string as account_display_number
    , account.value:DisplayName::string          as account_name
    , {{ col_is_head(reference=src) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                            as _source_loaded_at
from {{ src }}
, table(flatten(json , 'ReferencedEntities.Accounts')) as account
, table(flatten(json , 'ReferencingPortfolios')) as portfolios
