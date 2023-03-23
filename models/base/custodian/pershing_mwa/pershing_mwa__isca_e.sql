-- depends_on: {{ ref('create_udfs_pershing') }}
{{ isca_e(source('pershing_mwa', 'isca')) }}