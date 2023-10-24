--depends_on: {{ ref('nml_fidelity_mps_tax_lots') }}
--depends_on: {{ ref('nml_fidelity_mwa_tax_lots') }}
--depends_on: {{ ref('nml_fidelity_swag_tax_lots') }}
--depends_on: {{ ref('nml_schwab_tax_lots') }}

{# Set the upstream holdings models here and dbt will use them dynamically below
    These models show the holdings/positions from custodians normalized. #}
{%-
    set source_models = [
          'nml_fidelity_mps_tax_lots'
         ,'nml_fidelity_mwa_tax_lots'
         ,'nml_fidelity_swag_tax_lots'
         ,'nml_schwab_tax_lots'
    ]
-%}

{% for nml_model in source_models -%}
select *
from {{ ref(nml_model) }}

{%- if not loop.last %}

union all

{% endif -%}
{%- endfor %}
