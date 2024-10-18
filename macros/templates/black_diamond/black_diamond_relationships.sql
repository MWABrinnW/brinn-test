{%- macro black_diamond_relationships(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}

select
    'black_diamond'::text(200)                          as system_name
    , '{{ instance }}'::text(200)                       as system_instance
    , concat(system_name , '__' , system_instance)      as system_key
    , '{{ firm_source }}'::text(200)                    as firm_source
    , a.effective_date                                  as effective_date
    , a.json:Relationship.ID::string                    as relationship_id
    , a.json:Relationship.Name::string                  as relationship_name
    , a.json:Relationship.ClientTypeID::string          as relationship_client_type_id
    , account.value:HistoryStartDate::date              as history_start_date
    , account.value:ClosedDate::date                    as relationship_termination_date
    , account.value:Relationship::string                as relationship_display_name
    , portfolios.value:Id::string                       as portfolio_id
    , portfolios.value:Name::string                     as portfolio_name
    , portfolios.value:DisplayName::string              as portfolio_display_name
    , portfolios.value:IsMasterPortfolio::boolean::int  as is_master_portfolio
    , account.value:ExternalID::string                  as account_id
    , account.value:LongNumber::string                  as account_number
    , account.value:AccountDisplayNumber::string        as account_display_number
    , account.value:DisplayName::string                 as account_name
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                                 as _source_loaded_at
    {%- if extra_columns -%}
    {{ extra_columns }}
    {%- endif %}
from {{ src }}                                          as a
, table(flatten(a.json , 'ReferencedEntities.Accounts')) as account--noqa
, table(flatten(a.json , 'ReferencingPortfolios'))      as portfolios
{%- if extra_joins %}
{{ extra_joins }}
{% endif -%}

{%- endmacro -%}