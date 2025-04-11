{{ black_diamond_transactions(
    src=source('black_diamond_ap4', 'accounts'),
    instance='ap4',
    firm_source='mps',
    extra_columns=none,
    extra_joins=none
) }}
