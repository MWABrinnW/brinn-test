{% set listagg_columns = [
    'relationship_id',
    'portfolio_display_name',
    'relationship_name'
] %}

{{ black_diamond_relationships_distinct('commonwealth', listagg_columns) }}
