{%- macro incremental_date_filter(
    source_col_name,
    target_col_name,
    relation = "this",
    filter = none,
    dev_filter=var("dev_day_filter")
)-%}

{#
/*
Macro provides a shortened version of below sql/jinja code, filtering out already processed data in an incremental file.
In addition it supports processing data in the past, by providing a offset and the days back to update relative to this offset.
The main usage of this is data recovery, by providing these values via CLI.
This macro requires a primary key to be set on the table, as it would create duplication otherwise.

Args:
    source_col_name (datetime/date)     : Date column from data being run
    target_col_name (datetime/date)     : Date column from data already run
    relation(snowflake relation)        : Relation to which this filter must be applied to. Default actual table.
    lookback (int)           : Number of days back to update, relative to the offset. Default is 3.
    offset (int)             : Number of days to offset the start date by, relative to the current date. Default is 0.

Returns:
    AND statement for a where clause that performs a filter on incremental models.
*/
#}

{%- set lookback_var = var('lookback', 4) -%}
{%- set offset_var = var('offset', 0) -%}
{%- set filter_var = var('filter', none) -%}
    {%- set unique_key = config.require('unique_key') -%}
    {%- if target.name not in ['prod', 'test'] -%}
        and {{source_col_name}} >= (current_date() - {{dev_filter}})
    {% endif -%}
    {% if is_incremental() -%}
        AND (
            TO_DATE({{source_col_name}}) > (
                SELECT MAX({{target_col_name}})
                FROM {% if relation == "this" -%}
                        {{ this }}
                     {%- else -%}
                        {{ relation }}
                     {%- endif %}
                WHERE true
                {% if filter_var is not none %}
                    filter_var
                {% endif %}
            )
        OR (
            TO_DATE({{source_col_name}})
                >= DATEADD(
                    DAY,
                    -({{ offset_var + lookback_var }}),
                    CURRENT_DATE()
                )
            AND TO_DATE({{source_col_name}})
                <= DATEADD(
                    DAY,
                    -({{ offset_var }}),
                    CURRENT_DATE()
            )
        )
    )
    {% endif %}
{% endmacro %}
