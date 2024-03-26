-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_e(source('pershing_mwa', 'isca')) }}