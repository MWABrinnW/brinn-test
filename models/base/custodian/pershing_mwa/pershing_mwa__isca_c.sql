-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_c(source('pershing_mwa', 'isca')) }}