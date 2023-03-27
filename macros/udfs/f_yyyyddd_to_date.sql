{% macro create_f_yyyyddd_to_date() %}
create or replace function {{target.schema}}.YYYYDDD_TO_DATE(DATE_VAL VARCHAR)
    returns DATE
as
$$
    select IFF(date_val is null, date_val,
               DateAdd(DAY, right(date_val, 3), DateFromParts(left(date_val, 4) - 1, 12, 31)))
$$
{% endmacro %}