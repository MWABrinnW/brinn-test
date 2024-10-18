{%- macro black_diamond_contacts(src, instance, firm_source, extra_columns=none, extra_joins=none) -%}
-- depends_on: {{ ref('dates') }}

select
    'black_diamond'::text(200)                           as system_name
    , '{{ instance }}'::text(200)                        as system_instance
    , concat(system_name , '__' , system_instance)       as system_key
    , '{{ firm_source }}'::text(200)                     as firm_source
    , a.effective_date                                   as effective_date
    , a.json:Relationship.ID::string                     as relationship_id
    , a.json:Relationship.Name::string                   as relationship_name
    , contacts.value:ContactId::int                      as contact_id
    , contacts.value:FirstName::varchar(100)             as contact_first_name
    , contacts.value:LastName::varchar(100)              as contact_last_name
    , contacts.value:EmailAddress[0]:email::varchar(100) as email_address_1
    , contacts.value:EmailAddress[0]:label::varchar(100) as email_address_1_label
    , contacts.value:EmailAddress[0]:type::varchar(100)  as email_address_1_type
    , contacts.value:EmailAddress[1]:email::varchar(100) as email_address_2
    , contacts.value:EmailAddress[1]:label::varchar(100) as email_address_2_label
    , contacts.value:EmailAddress[1]:type::varchar(100)  as email_address_2_type
    , a.record_datetime                                  as _source_loaded_at
    , {{ col_is_head(
        reference=src,
        reference_date_col='effective_date',
        source_date_col='a.effective_date') }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a.record_datetime                                  as _source_loaded_at
    {%- if extra_columns -%}
    {{ extra_columns }}
    {%- endif %}
from {{ src }} as a
, table(flatten(a.json , 'ReferencedEntities.Contacts')) as contacts
{%- if extra_joins %}
{{ extra_joins }}
{% endif %}
where true

{%- endmacro -%}
