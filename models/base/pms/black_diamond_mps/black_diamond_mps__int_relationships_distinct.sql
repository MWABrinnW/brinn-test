{% set listagg_columns = [
    'relationship_id',
    'portfolio_display_name'
] %}

{{ black_diamond_relationships_distinct('mps', listagg_columns) }}
