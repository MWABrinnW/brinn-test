{%- set extra_columns -%}
, max(case when atag.tag_name = 'Name' then atag.tag_value end)        as name
{%- endset -%}

{{ black_diamond_base_accounts(
    src=source('black_diamond_mcgervey', 'accounts'),
    instance='mcgervey',
    firm_source='mwa',
    extra_columns=extra_columns,
    extra_joins=none
) }}
