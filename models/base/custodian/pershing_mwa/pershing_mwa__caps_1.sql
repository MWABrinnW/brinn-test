-- depends_on: {{ ref('create_udfs_pershing') }}
{{ caps_1(source('pershing_mwa', 'caps')) }}