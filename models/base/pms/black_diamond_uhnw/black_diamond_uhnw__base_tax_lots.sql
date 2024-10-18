{{ black_diamond_tax_lots(
    src=source('black_diamond_uhnw', 'accounts'),
    instance='uhnw',
    firm_source='mwa',
    extra_columns=none,
    extra_joins=none
) }}
