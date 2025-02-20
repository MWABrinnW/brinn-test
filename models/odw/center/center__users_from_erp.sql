with cte as (
    select
        -- Center won't accept periods in user names.
        replace(
            case
                when count(*) over (partition by a.associate_legal_name_first , a.associate_legal_name_last) > 1
                    then concat(a.associate_legal_name_first , ' ' , coalesce(a.associate_legal_name_middle , ''))
                else a.associate_legal_name_first
            end , '.' , ''
        )                                                 as first_name
        , replace(a.associate_legal_name_last , '.' , '') as last_name
        , case
            when count(*) over (partition by a.associate_legal_name_first , a.associate_legal_name_last) > 1
                then 1
            else 0
        end::int                                          as has_user_name_dupes
        , a.associate_work_email                          as email_address
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
        end                                               as default_approver
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
    *
    , nullif(
        concat(
            -- Of course a user needs an email address!
            case when email_address is null then 'email_address is null, ' else '' end
            -- Center requires a default cost center.
            , case when default_cost_center is null then 'default_cost_center is null, ' else '' end
            -- Center requires a default approver.
            , case when default_approver is null then 'default_approver is null, ' else '' end
            -- Center does not accept first names greater than 15 characters.
            , case when len(first_name) > 15 then 'first_name length > 15 ' else '' end
        ) , ''
    ) as exceptions
from cte
