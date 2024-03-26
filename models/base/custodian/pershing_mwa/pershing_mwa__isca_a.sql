-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_a(source('pershing_mwa', 'isca')) }}