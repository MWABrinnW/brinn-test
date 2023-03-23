-- depends_on: {{ ref('create_udfs_pershing') }}
{{ isca_b(source('pershing_mwa', 'isca')) }}