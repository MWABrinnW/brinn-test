-- depends_on: {{ ref('create_udfs_pershing') }}
{{ capt_5(source('pershing_mwa', 'capt')) }}