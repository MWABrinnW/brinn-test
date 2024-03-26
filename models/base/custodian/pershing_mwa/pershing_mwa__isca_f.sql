-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_f(source('pershing_mwa', 'isca')) }}