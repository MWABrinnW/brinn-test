{%- macro incremental_date_filter(
    source_col_name,
    target_col_name,
    source_relation = none,
    target_relation = "this",
    do_lookback = true,
    do_new = true,
    source_created_at_col = '_source_created_at',
    target_created_at_col = '_created_at',
    filter = none,
    custom_condition = none,
    custom_condition_only = false,
    max_lookback = none
) -%}

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
    mode                     : [lookback|new]

Returns:
    AND statement for a where clause that performs a filter on incremental models.
*/
#}

    {%- set lookback_var = cvar('lookback') -%}
    {%- set offset_var = cvar('offset') -%}
    {%- set filter_var = var('filter', none) -%}
    {%- set unique_key = config.require('unique_key') -%}
    {%- set target_relation_var = none -%}

{#  Set the max lookback (day cutoff)
    If target is dev we'll apply the max lookback.
    If target is not dev we'll only apply a max lookback if it was provided. #}
    {%- if target.name not in ['prod'] -%}
        {%- set max_lookback_var = cvar('dev_day_filter') -%}
    {%- else -%}
        {%- set max_lookback_var = 365 -%}
    {%- endif -%}

    {% if target_relation == "this" -%}
    {%- set target_relation_var = this -%}
    {%- else -%}
        {%- set target_relation_var = relation -%}
    {%- endif -%}

    {%- if max_lookback_var is not none -%}
        AND {{ source_col_name }}::timestamp >= (current_date() - {{ max_lookback_var }})::timestamp
    {%- endif -%}

    {%- if is_incremental() %}
        AND (
        {% if not custom_condition_only -%}
            -- select records that have a greater {effective_date} than the destination
            {{ source_col_name }}::timestamp > (
                SELECT MAX({{ target_col_name }}::timestamp)
                FROM {{ target_relation_var }}
                WHERE true
                {% if filter_var is not none %}
                    filter_var
                {% endif %}
            )
        {% endif -%}
        {% if do_new == true and not custom_condition_only -%}
            {% if source_relation is not none -%}
        -- all effective_dates where the source is more up to date than the target
        OR (
            {{ source_col_name }}::timestamp in (
                                    select distinct {{ target_col_name }}::timestamp
                                    from {{ source_relation }}
                                    where {{ source_created_at_col }} > (select max({{ target_created_at_col }})
                                                                        from {{ target_relation_var }}
                                                                        where true
                                                                        {% if filter_var is not none -%}
                                                                            filter_var
                                                                        {% endif -%}
                                                                        )
                                    group by 1
                                    )

        )
        {% endif -%}
        {% endif -%}

        {% if do_lookback == true and not custom_condition_only -%}
        OR (
            -- select records with the lookback window using supplied {effective_date} key
            {{ source_col_name }}::date
                >= DATEADD(
                    DAY,
                    -({{ offset_var + lookback_var }}),
                    CURRENT_DATE()
                )
            AND TO_DATE({{ source_col_name }})
                <= DATEADD(
                    DAY,
                    -({{ offset_var }}),
                    CURRENT_DATE()
            )
        )
    {% endif -%}

        {%- if custom_condition -%}
        -- custom condition
        {% if custom_condition_only == true -%}
        (
        {% else -%}
        OR (
        {% endif -%}
        {{ custom_condition }}
        )
    {% endif -%}
        )
    {%- endif -%}

{% endmacro %}
