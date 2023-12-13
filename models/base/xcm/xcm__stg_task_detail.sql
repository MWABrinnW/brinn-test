select
    _pk
    , json:"description"::string                                as description
    , json:"taskId"::string                                     as task_id
    , json:"clientName"::string                                 as client_name
    , json:"clientId"::string                                   as client_id
    , json:"taskTypeCode"::string                               as task_type_code
    , json:"periodEndDate"::string                              as period_end_date
    , json:"priority"::string                                   as priority
    , json:"taskDescription"::string                            as task_description
    , json:"originatingLocationName"::string                    as originating_location_name
    , json:"assignedTo"::string                                 as assigned_to
    , json:"assignedToEmailID"::string                          as assigned_to_email_id
    , json:"auditPartner"::string                               as audit_partner
    , json:"auditPartnerEmailID"::string                        as audit_partner_email_id
    , json:"auditManager"::string                               as audit_manager
    , json:"auditManagerEmailID"::string                        as audit_manager_email_id
    , json:"taxPartner"::string                                 as tax_partner
    , json:"taxPartnerEmailID"::string                          as tax_partner_email_id
    , json:"manager"::string                                    as manager
    , json:"managerEmailID"::string                             as manager_email_id
    , json:"responsiblePerson"::string                          as responsible_person
    , json:"responsiblePersonEmailId"::string                   as responsible_person_email_id
    , json:"taxSenior"::string                                  as tax_senior
    , json:"taxSeniorEmailID"::string                           as tax_senior_email_id
    , json:"auditSenior"::string                                as audit_senior
    , json:"auditSeniorEmailID"::string                         as audit_senior_email_id
    , json:"auditStaff"::string                                 as audit_staff
    , json:"auditStaffEmailID"::string                          as audit_staff_email_id
    , json:"taxStaff"::string                                   as tax_staff
    , json:"taxStaffEmailID"::string                            as tax_staff_email_id
    , json:"accountNumber"::string                              as account_number
    , json:"primaryTaskType"::string                            as primary_task_type
    , json:"software"::string                                   as software
    , json:"group_Name"::string                                 as group_name
    , json:"group_Number"::string                               as group_number
    , json:"branch_Name"::string                                as branch_name
    , json:"lastExtensionFiled_By"::string                      as last_extension_filed_by
    , json:"status_Type"::string                                as status_type
    , json:"pcaoB_or_NonPublic"::string                         as pcaob_or_non_public
    , json:"levelOf_Service"::string                            as level_of_service
    , json:"descriptionOfOther_Service"::string                 as description_of_other_service
    , json:"entity_Structure"::string                           as entity_structure
    , json:"financialStatement_Date"::string                    as financial_statement_date
    , json:"basisof_Accounting"::string                         as basis_of_accounting
    , json:"task_Industry"::string                              as task_industry
    , json:"descriptionOfOther_Industry"::string                as description_of_other_industry
    , json:"engagement_Status"::string                          as engagement_status
    , json:"due_Date"::string                                   as due_date
    , json:"externalId"::string                                 as external_id
    , json:"taskCategoryCode"::string                           as task_category_code
    , json:"taskCategoryName"::string                           as task_category_name
    , json:"taskType"::string                                   as task_type
    , json:"returnId"::string                                   as return_id
    , json:"customFields"::string                               as custom_fields_parse
    , parse_json(custom_fields_parse):"Advisor Name"::string    as advisor_name
    , parse_json(custom_fields_parse):"Office Location"::string as location_name
    , parse_json(custom_fields_parse):"Region"::string          as region
    , parse_json(custom_fields_parse):"Billed Fee"::string      as billed_fee
    , parse_json(custom_fields_parse):"Allocated Fee"::string   as allocated_fee
    , parse_json(custom_fields_parse):"Invoice Sent"::string    as invoice_sent
    , _created_at
from
    {{ source('xcm', 'task_detail') }}
