-- depends_on: {{ ref('create_udfs_pershing') }}
{{ isca_a(source('pershing_mwa', 'isca')) }}