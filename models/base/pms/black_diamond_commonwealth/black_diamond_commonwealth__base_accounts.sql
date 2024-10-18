{%- set extra_columns -%}
{%- endset -%}

{{ black_diamond_base_accounts(
    src=source('black_diamond_commonwealth', 'accounts'),
    instance='commonwealth',
    firm_source='mwa',
    extra_columns=extra_columns,
    extra_joins=none
) }}
