-- noqa: disable=all
{{ dbt_utils.union_relations(
    relations=[ref('mis__tax_lots_schwab'), ref('mis__tax_lots_fidelity')]
) }}
