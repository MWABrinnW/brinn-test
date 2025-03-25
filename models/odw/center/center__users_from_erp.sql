with cte as (
    select
        -- Center won't accept periods in user names.
        trim(
            replace(
                case
                    when count(*) over (partition by a.associate_legal_name_first , a.associate_legal_name_last) > 1
                        then concat(a.associate_legal_name_first , ' ' , coalesce(a.associate_legal_name_middle , ''))
                    else a.associate_legal_name_first
                end , '.' , ''
            )
        )                                                 as first_name
        , replace(a.associate_legal_name_last , '.' , '') as last_name
        , case
            when count(*) over (partition by a.associate_legal_name_first , a.associate_legal_name_last) > 1
                then 1
            else 0
        end::int                                          as has_user_name_dupes
        , lower(a.associate_work_email)                   as email_address
        , a.employee_num                                  as employee_num
        , null::text                                      as phone
        , 'no'::text                                      as fm
        , null::text                                      as delegate_to
        , 'no'::text                                      as order_card
        , null::text                                      as card_lock
        , null::text                                      as card_limit
        , case
            when a.employee_num = 100940
                -- Marty Bicknell reports to Marty Bicknell!
                then a.associate_work_email
            else a.position_manager_email
        end                                               as default_approver_email
        , a.associate_legal_address_line1                 as address_1
        , a.associate_legal_address_line2                 as address_2
        , a.associate_legal_address_city                  as city

        , case lower(a.associate_legal_address_state)
            when 'alabama' then 'AL'
            when 'alaska' then 'AK'
            when 'arizona' then 'AZ'
            when 'arkansas' then 'AR'
            when 'california' then 'CA'
            when 'colorado' then 'CO'
            when 'connecticut' then 'CT'
            when 'delaware' then 'DE'
            when 'district of Columbia' then 'DC'
            when 'florida' then 'FL'
            when 'georgia' then 'GA'
            when 'hawaii' then 'HI'
            when 'idaho' then 'ID'
            when 'illinois' then 'IL'
            when 'indiana' then 'IN'
            when 'iowa' then 'IA'
            when 'kansas' then 'KS'
            when 'kentucky' then 'KY'
            when 'louisiana' then 'LA'
            when 'maine' then 'ME'
            when 'maryland' then 'MD'
            when 'massachusetts' then 'MA'
            when 'michigan' then 'MI'
            when 'minnesota' then 'MN'
            when 'mississippi' then 'MS'
            when 'missouri' then 'MO'
            when 'montana' then 'MT'
            when 'nebraska' then 'NE'
            when 'nevada' then 'NV'
            when 'new hampshire' then 'NH'
            when 'new jersey' then 'NJ'
            when 'new mexico' then 'NM'
            when 'new york' then 'NY'
            when 'north carolina' then 'NC'
            when 'north dakota' then 'ND'
            when 'ohio' then 'OH'
            when 'oklahoma' then 'OK'
            when 'oregon' then 'OR'
            when 'pennsylvania' then 'PA'
            when 'rhode island' then 'RI'
            when 'south carolina' then 'SC'
            when 'south dakota' then 'SD'
            when 'tennessee' then 'TN'
            when 'texas' then 'TX'
            when 'utah' then 'UT'
            when 'vermont' then 'VT'
            when 'virginia' then 'VA'
            when 'washington' then 'WA'
            when 'west virginia' then 'WV'
            when 'wisconsin' then 'WI'
            when 'wyoming' then 'WY'
            when 'puerto rico' then 'PR'
            when 'alberta' then 'AB'
            when 'british columbia' then 'BC'
            when 'manitoba' then 'MB'
            when 'new brunswick' then 'NB'
            when 'newfoundland and Labrador' then 'NL'
            when 'northwest territories' then 'NT'
            when 'nova scotia' then 'NS'
            when 'nunavut' then 'NU'
            when 'ontario' then 'ON'
            when 'prince edward island' then 'PE'
            when 'quebec' then 'QC'
            when 'saskatchewan' then 'SK'
            when 'yukon territory' then 'YT'
            else a.associate_legal_address_state
        end                                               as state
        , a.associate_legal_address_zip_code              as zip_code
        , case
            when a.associate_legal_address_country ilike 'US' then 'USA'
            else a.associate_legal_address_country
        end                                               as country
        , null::text                                      as insights_cost_center
        , a.department::text                              as default_cost_center

        , a.department::text                              as cost_centers

        , 'No'::text                                      as welcome_email
        , 'Yes'::text                                     as traveler
        , 'No'::text                                      as travel_manager
        , b.id                                            as id
        , a.cost_seg_1                                    as legal_entity
        , a.cost_seg_2::text                              as product_code
        , a.cost_seg_3                                    as accounting_id
        , a.cost_seg_4                                    as team
        , a.cost_seg_6                                    as initiative
        -- Abacus user list from Becky Margason for Center users that are deactivated, they use different expense tool
        , case
            when
                a.employee_num in (
                    '103534'
                    , '103548'
                    , '103526'
                    , '103525'
                    , '103530'
                    , '103550'
                    , '103476'
                    , '103508'
                    , '100701'
                    , '103456'
                    , '102022'
                    , '103553'
                    , '103488'
                    , '103535'
                    , '103485'
                    , '103452'
                    , '103547'
                    , '103462'
                    , '103499'
                    , '103492'
                    , '103505'
                    , '103512'
                    , '103516'
                    , '103484'
                    , '103495'
                    , '103496'
                    , '103552'
                    , '100697'
                    , '103538'
                    , '103474'
                    , '103503'
                    , '103450'
                    , '103469'
                    , '103540'
                    , '103527'
                    , '103510'
                    , '103531'
                    , '103493'
                    , '103478'
                    , '103513'
                    , '102755'
                    , '103472'
                    , '103520'
                    , '101609'
                    , '103546'
                    , '103498'
                    , '103517'
                    , '103465'
                    , '103482'
                    , '101574'
                    , '103507'
                    , '103522'
                    , '103533'
                    , '103459'
                    , '103460'
                    , '103481'
                    , '103468'
                    , '103554'
                    , '103471'
                    , '103453'
                    , '103477'
                    , '103502'
                    , '101095'
                    , '103549'
                    , '103521'
                    , '103500'
                    , '103490'
                    , '102313'
                    , '100699'
                    , '103511'
                    , '108378'
                    , '103458'
                    , '103480'
                    , '103489'
                    , '103497'
                    , '103537'
                    , '103209'
                    , '103487'
                    , '103556'
                    , '103532'
                    , '103515'
                    , '101439'
                    , '103509'
                    , '103463'
                    , '103523'
                    , '102623'
                    , '103555'
                    , '103454'
                    , '103466'
                    , '103486'
                    , '103475'
                    , '103455'
                    , '103539'
                    , '100347'
                    , '101346'
                    , '103551'
                    , '100698'
                    , '103536'
                    , '103464'
                    , '101398'
                    , '103504'
                    , '103470'
                )
                then 1
            else 0
        end                                               as is_abacus_user

    from {{ ref('nml_oracle_hcm_associates') }} as a
    left join {{ ref('center__stg_users') }} as b
        on a.employee_num = b.employee_id
        and b.is_head = 1
    where 1 = 1
        and a.is_head = 1
        and a.employment_status not ilike 'TERMINATED'
        and a.position_start_date <= current_date()

)

select
    a.*

    , nullif(
        -- any updates are noted with a before and after comparison
        object_construct(
            'first_name' , iff(a.first_name <> b.first_name , b.first_name || ' --> ' || a.first_name , null)
            , 'last_name' , iff(a.last_name <> b.last_name , b.last_name || ' --> ' || a.last_name , null)
            , 'email_address'
            , iff(lower(a.email_address) <> lower(b.email_address) , b.email_address || ' --> ' || a.email_address , null)
            , 'phone' , iff(a.phone <> b.phone_number , b.phone_number || ' --> ' || a.phone , null)
            , 'default_approver'
            , iff(c.id <> b.default_approver:id::text , b.default_approver:id::text || ' --> ' || c.id , null)
            , 'address_1' , iff(a.address_1 <> b.billing_address , b.billing_address || ' --> ' || a.address_1 , null)
            , 'city' , iff(a.city <> b.billing_city , b.billing_city || ' --> ' || a.city , null)
            , 'state' , iff(a.state <> b.billing_state , b.billing_state || ' --> ' || a.state , null)
            , 'zip' , iff(a.zip_code <> b.billing_postal_code , b.billing_postal_code || ' --> ' || a.zip_code , null)
            , 'country' , iff(a.country <> b.billing_country , b.billing_country || ' --> ' || a.country , null)
            , 'default_cost_center'
            , iff(
                a.default_cost_center <> b.default_cost_center_name
                , b.default_cost_center_name || ' --> ' || a.default_cost_center
                , null
            )
        ) , { }
    )   as variances

    , case when a.id is null-- only calculate exceptions if the user doesn't exist in Center already
            then
                nullif(
                    object_construct(
                        -- Of course a user needs an email address!
                        'email_address' , iff(a.email_address is null , 'missing' , null)
                        -- Center requires a default cost center.
                        , 'default_cost_center' , iff(a.default_cost_center is null , 'missing' , null)
                        -- Center requires a default approver.
                        , 'default_approver_email' , iff(a.default_approver_email is null , 'missing' , null)
                        -- Center does not accept first names greater than 15 characters.
                        , 'first_name' , iff(len(a.first_name) > 15 , '> 15 characters' , null)
                    ) , { }
                )
    end
        as exceptions

from cte as a
left join {{ ref('center__stg_users') }} as b
    on a.employee_num = b.employee_id
    and b.is_head = 1
-- join to get approver_id from approver_email
left join {{ ref('center__stg_users') }} as c
    on a.default_approver_email = c.email_address
    and c.is_head = 1
-- drop users that are in specific Abacus users list (received from Becky Margason)
where a.is_abacus_user = 0
