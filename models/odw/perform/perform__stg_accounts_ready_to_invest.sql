select
    json:account_custodial::text                                as account_number_formatted
    , replace(upper(trim(account_number_formatted)) , '-' , '') as account_number
    , json:account_id_orion::text                               as pms_account_id
    , json:formatted::text                                      as formatted
    , json:description::text                                    as description
    , json:type::text                                           as type
    , try_to_date(json:inception_date::text)::date              as inception_date
    , json:status::text                                         as status
    , json:model::text                                          as model
    , max(coalesce(try_to_boolean(json:is_ready_to_invest::text)::int , 0))
        over (partition by account_number , _created_at)        as is_ready_to_invest

    , _created_at::timestamp_ntz                                as _created_at
    , json:_box_file_id::text(100)                              as _box_file_id
    , _box_file_name::text(100)                                 as _box_sheet_name
    , row_number() over (
        partition by account_number , _created_at
        order by pms_account_id asc , _id desc
    )                                                           as rn
    , {{ col_is_head(reference=source('perform', 'accounts_ready_to_invest'),
        source_date_col='_created_at::timestamp_ntz',
        reference_date_col='_created_at::timestamp_ntz') }}
    , _id                                                       as _id
from {{ source('perform', 'accounts_ready_to_invest') }}
