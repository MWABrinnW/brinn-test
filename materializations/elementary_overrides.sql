{% materialization table, adapter='snowflake' %}
  {{ return(elementary.materialization_table_snowflake()) }}
{% endmaterialization %}

{% materialization incremental, adapter='incremental' %}
  {{ return(elementary.materialization_table_snowflake()) }}
{% endmaterialization %}