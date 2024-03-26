-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_d(source('pershing_mwa', 'isca')) }}