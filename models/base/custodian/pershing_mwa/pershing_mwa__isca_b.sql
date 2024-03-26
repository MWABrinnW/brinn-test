-- depends_on: {{ ref('pershing_udfs') }}
{{ isca_b(source('pershing_mwa', 'isca')) }}