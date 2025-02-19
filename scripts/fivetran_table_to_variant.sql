-- Generate variant model on top of a fivetran table.
-- Example below was used for salesforce_igo snapshots (DE-165).
select
    t.table_catalog || '.' || t.table_schema || '.' || t.table_name as fq_name
  , case when c.ordinal_position = 1 then 'select ' else ', ' end
        || 'json:' || c.column_name || ' :: ' || c.data_type
        || case
               when c.data_type ilike 'number'
                   then '(' || c.numeric_precision || ',' || c.numeric_precision_radix || ')'
               else '' end
        || ' as ' || c.column_name
        || case
               when c.ordinal_position = max(c.ordinal_position) over (partition by c.table_schema, c.table_name)
                   then ', ''salesforce''::text as system_name, ''igo''::text as system_instance, system_name'
                   ||
                        ' || ''__'' || system_instance as system_key, effective_at as effective_at, _created_at as _created_at'
                   || ' , {{ col_is_head(
                reference=source(''' || lower(t.table_schema) || ''', ''' || lower(t.table_name) || '''),
                source_date_col=''effective_at'',
                reference_date_col=''effective_at''
                ) }}'
                   || ' from raw.' || t.table_schema || '.' || t.table_name || ';'
               else '' end
                                                                    as sql
from fivetran.information_schema.tables        t
inner join fivetran.information_schema.columns c
on t.table_name = c.table_name
    and t.table_schema = c.table_schema
where 1 = 1
  and t.table_schema ilike 'salesforce_igo'
  and t.table_name ilike any
      ('account', 'contact', 'deal_contact_relationship_c', 'practifi_deal_c', 'practifi_deal_history',
       'practifi_division_c', 'user')
order by t.table_name, c.ordinal_position
