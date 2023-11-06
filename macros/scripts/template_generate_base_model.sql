{# Generate base models from sources #}

{{ codegen.generate_base_model(
    source_name='hubspot_network',
    table_name='email_event',
    leading_commas=True
) }}
