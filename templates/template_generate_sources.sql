{#- Generate sources -#}
{{ codegen.generate_source(
    database_name='fivetran',
    schema_name='hubspot_network',
    table_names=None,
    generate_columns=True,
    include_descriptions=True,
    ) 
}}