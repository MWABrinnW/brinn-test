{% macro create_f_signed_to_numeric() %}
create or replace function {{target.schema}}.SIGNED_TO_NUMERIC(SIGNED_VALUE VARCHAR)
    returns NUMBER
as
$$
    select case
               when right(signed_value, 1) = '{' then concat(left(signed_value, len(signed_value) - 1), 0)::number
               when right(signed_value, 1) = 'A' then concat(left(signed_value, len(signed_value) - 1), 1)::number
               when right(signed_value, 1) = 'B' then concat(left(signed_value, len(signed_value) - 1), 2)::number
               when right(signed_value, 1) = 'C' then concat(left(signed_value, len(signed_value) - 1), 3)::number
               when right(signed_value, 1) = 'D' then concat(left(signed_value, len(signed_value) - 1), 4)::number
               when right(signed_value, 1) = 'E' then concat(left(signed_value, len(signed_value) - 1), 5)::number
               when right(signed_value, 1) = 'F' then concat(left(signed_value, len(signed_value) - 1), 6)::number
               when right(signed_value, 1) = 'G' then concat(left(signed_value, len(signed_value) - 1), 7)::number
               when right(signed_value, 1) = 'H' then concat(left(signed_value, len(signed_value) - 1), 8)::number
               when right(signed_value, 1) = 'I' then concat(left(signed_value, len(signed_value) - 1), 9)::number

               when right(signed_value, 1) = '}' then concat('-', left(signed_value, len(signed_value) - 1), 0)::number
               when right(signed_value, 1) = 'J' then concat('-', left(signed_value, len(signed_value) - 1), 1)::number
               when right(signed_value, 1) = 'K' then concat('-', left(signed_value, len(signed_value) - 1), 2)::number
               when right(signed_value, 1) = 'L' then concat('-', left(signed_value, len(signed_value) - 1), 3)::number
               when right(signed_value, 1) = 'M' then concat('-', left(signed_value, len(signed_value) - 1), 4)::number
               when right(signed_value, 1) = 'N' then concat('-', left(signed_value, len(signed_value) - 1), 5)::number
               when right(signed_value, 1) = 'O' then concat('-', left(signed_value, len(signed_value) - 1), 6)::number
               when right(signed_value, 1) = 'P' then concat('-', left(signed_value, len(signed_value) - 1), 7)::number
               when right(signed_value, 1) = 'Q' then concat('-', left(signed_value, len(signed_value) - 1), 8)::number
               when right(signed_value, 1) = 'R' then concat('-', left(signed_value, len(signed_value) - 1), 9)::number
               else
                   1/0  -- will throw an error, should not hit the else unless one of the signed_values is incorrect
               end
$$
{% endmacro %}