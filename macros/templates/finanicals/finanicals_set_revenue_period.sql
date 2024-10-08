{%- macro financials_set_revenue_period() -%}
            case
            -- quarterly bills and on-cycle
            when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 0
                then
                    case
                        -- if advance, get next quarter end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Quarter' , 1 , fee_calculation_date) , 'Quarter')
                        -- if arrears, get current quarter end date
                        when billing_style ilike 'Arrears' then
                            last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                    end
            -- quarterly bills and NOT on-cycle
            when billing_frequency ilike 'Quarterly' and is_intra_period_invoice = 1
                then
                    case
                        -- if advance, get current quarter end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                        -- if arrears, get current quarter end date
                        when billing_style ilike 'Arrears' then
                            last_day(dateadd('Quarter' , 0 , fee_calculation_date) , 'Quarter')
                    end
            -- monthly bills, intra period is NOT evaluated
            when billing_frequency ilike 'Monthly'
                then
                    case
                    -- if advance, get next month end date
                        when billing_style ilike 'Advance'
                            then
                                last_day(dateadd('Month' , 1 , fee_calculation_date) , 'Month')
                        -- if arrears, get current month end date
                        when billing_style ilike 'Arrears'
                            then
                                last_day(dateadd('Month' , 0 , fee_calculation_date) , 'Month')
                    end
            -- NOT quarterly or monthly bills, get current month end date (i.e., one-time, semi-annual, annual)
            else last_day(dateadd('Month' , 0 , fee_calculation_date) , 'Month')
        end::date as revenue_period_end_date
    {%- endmacro -%}
