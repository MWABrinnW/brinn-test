{%-
    set source_models = [
          'nml_custodian_account_links_fidelity'
         ,'nml_custodian_account_links_schwab'
         ,'nml_custodian_account_links_pershing'
         ,'nml_custodian_account_links_tda'
    ]
-%}

{% for nml_model in source_models -%}
select *
from {{ ref(nml_model) }}

{%- if not loop.last %}

union all

{% endif -%}
{%- endfor %}
