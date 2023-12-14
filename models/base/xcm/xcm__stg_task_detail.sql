select
    _pk::int                                                                  as _pk
    , NULLIF(json:"description"::text(200) , '')                              as description
    , json:"taskId"::int                                                      as task_id
    , NULLIF(json:"clientName"::text(200) , '')                               as client_name
    , json:"clientId"::int                                                    as client_id
    , NULLIF(json:"taskTypeCode"::text(200) , '')                             as task_type_code
    , TO_DATE((json:"periodEndDate"::text(200)) , 'DD/MM/YYYY')               as period_end_date
    , NULLIF(json:"priority"::text(200) , '')                                 as priority
    , NULLIF(json:"taskDescription"::text(200) , '')                          as task_description
    , NULLIF(json:"originatingLocationName"::text(200) , '')                  as originating_location_name
    , NULLIF(json:"assignedTo"::text(200) , '')                               as assigned_to
    , NULLIF(json:"assignedToEmailID"::text(200) , '')                        as assigned_to_email_id
    , NULLIF(json:"auditPartner"::text(200) , '')                             as audit_partner
    , NULLIF(json:"auditPartnerEmailID"::text(200) , '')                      as audit_partner_email_id
    , NULLIF(json:"auditManager"::text(200) , '')                             as audit_manager
    , NULLIF(json:"auditManagerEmailID"::text(200) , '')                      as audit_manager_email_id
    , NULLIF(json:"taxPartner"::text(200) , '')                               as tax_partner
    , NULLIF(json:"taxPartnerEmailID"::text(200) , '')                        as tax_partner_email_id
    , NULLIF(json:"manager"::text(200) , '')                                  as manager
    , NULLIF(json:"managerEmailID"::text(200) , '')                           as manager_email_id
    , NULLIF(json:"responsiblePerson"::text(200) , '')                        as responsible_person
    , NULLIF(json:"responsiblePersonEmailId"::text(200) , '')                 as responsible_person_email_id
    , NULLIF(json:"taxSenior"::text(200) , '')                                as tax_senior
    , NULLIF(json:"taxSeniorEmailID"::text(200) , '')                         as tax_senior_email_id
    , NULLIF(json:"auditSenior"::text(200) , '')                              as audit_senior
    , NULLIF(json:"auditSeniorEmailID"::text(200) , '')                       as audit_senior_email_id
    , NULLIF(json:"auditStaff"::text(200) , '')                               as audit_staff
    , NULLIF(json:"auditStaffEmailID"::text(200) , '')                        as audit_staff_email_id
    , NULLIF(json:"taxStaff"::text(200) , '')                                 as tax_staff
    , NULLIF(json:"taxStaffEmailID"::text(200) , '')                          as tax_staff_email_id
    , NULLIF(json:"accountNumber"::text(200) , '')                            as account_number
    , NULLIF(json:"primaryTaskType"::text(200) , '')                          as primary_task_type
    , NULLIF(json:"software"::text(200) , '')                                 as software
    , NULLIF(json:"group_Name"::text(200) , '')                               as group_name
    , NULLIF(json:"group_Number"::text(200) , '')                             as group_number
    , NULLIF(json:"branch_Name"::text(200) , '')                              as branch_name
    , NULLIF(json:"lastExtensionFiled_By"::text(200) , '')                    as last_extension_filed_by
    , NULLIF(json:"status_Type"::text(200) , '')                              as status_type
    , NULLIF(json:"pcaoB_or_NonPublic"::text(200) , '')                       as pcaob_or_non_public
    , NULLIF(json:"levelOf_Service"::text(200) , '')                          as level_of_service
    , NULLIF(json:"descriptionOfOther_Service"::text(200) , '')               as description_of_other_service
    , NULLIF(json:"entity_Structure"::text(200) , '')                         as entity_structure
    , TRY_TO_DATE((json:"financialStatement_Date"::text(200)) , 'DD/MM/YYYY') as financial_statement_date
    , NULLIF(json:"basisof_Accounting"::text(200) , '')                       as basis_of_accounting
    , NULLIF(json:"task_Industry"::text(200) , '')                            as task_industry
    , NULLIF(json:"descriptionOfOther_Industry"::text(200) , '')              as description_of_other_industry
    , NULLIF(json:"engagement_Status"::text(200) , '')                        as engagement_status
    , TRY_TO_DATE((json:"due_Date"::text(200)) , 'DD/MM/YYYY')                as due_date
    , NULLIF(json:"externalId"::text(200) , '')                               as external_id
    , NULLIF(json:"taskCategoryCode"::text(200) , '')                         as task_category_code
    , NULLIF(json:"taskCategoryName"::text(200) , '')                         as task_category_name
    , NULLIF(json:"taskType"::text(200) , '')                                 as task_type
    , NULLIF(json:"returnId"::text(200) , '')                                 as return_id
    , NULLIF(json:"customFields"::text(200) , '')                             as custom_fields
    , NULLIF(PARSE_JSON(custom_fields):"Advisor Name"::text(200) , '')        as advisor_name
    , NULLIF(PARSE_JSON(custom_fields):"Office Location"::text(200) , '')     as location_name
    , NULLIF(PARSE_JSON(custom_fields):"Region"::text(200) , '')              as region
    , TRY_CAST((
        REPLACE((
            PARSE_JSON(custom_fields):"Billed Fee"
        ) , '$' , '')
    ) as decimal(18 , 2))                                                     as billed_fee
    , TRY_CAST((
        REPLACE((
            PARSE_JSON(custom_fields):"Allocated Fee"
        ) , '$' , '')
    ) as decimal(18 , 2))                                                     as allocated_fee
    , TRY_TO_DATE(
        (PARSE_JSON(custom_fields):"Invoice Sent"::text(200)) , 'MM/DD/YYYY'
    )                                                                         as invoice_sent
    , _created_at                                                             as _create_at
from
    {{ source('xcm', 'task_detail') }}
