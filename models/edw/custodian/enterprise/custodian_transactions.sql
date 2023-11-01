{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the custoridan from custodians normalized. #}
{%-
    set source_models = [
          'nml_fidelity_mwa_transactions'
         ,'nml_schwab_transactions'
    ]
-%}

{% for nml_model in source_models -%}
select *
from {{ ref(nml_model) }}

{%- if not loop.last %}

union all

{% endif -%}
{%- endfor %}
