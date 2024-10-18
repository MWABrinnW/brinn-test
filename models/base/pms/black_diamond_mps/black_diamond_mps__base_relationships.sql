{{ black_diamond_relationships(
    src=source('black_diamond_mps', 'accounts'),
    instance='mps',
    firm_source='mps',
    extra_columns=none,
    extra_joins=none
) }}
