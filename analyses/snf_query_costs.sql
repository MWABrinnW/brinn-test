with
filtered_queries as (
    select
        query_id
        , query_text
            as original_query_text

            -- First, we remove comments enclosed by /* <comment text> */
            , REGEXP_REPLACE(query_text , '(/\*.*\*/)')
                as _cleaned_query_text
                -- Next, removes single line comments starting with --
                -- and either ending with a new line or end of string
                , REGEXP_REPLACE(_cleaned_query_text , '(--.*$)|(--.*\n)') as cleaned_query_text
                , warehouse_id
                , warehouse_name
                , warehouse_size
                , role_name
                , user_name
                , database_name
                , schema_name
                , rows_produced
                , total_elapsed_time
                , TIMEADD(
                    'millisecond'
                    , queued_overload_time + compilation_time
                    + queued_provisioning_time + queued_repair_time
                    + list_external_files_time
                    , start_time
                )                                                          as execution_start_time
                , end_time
            from snowflake.account_usage.query_history
            where TRUE
                and warehouse_size is not NULL
                and start_time >= DATEADD('day' , -1 , DATEADD('day' , -30 , CURRENT_DATE))
        )

        -- 1 row per hour from 30 days ago until the end of today
        , hours_list as (
            select
                DATEADD(
                    'hour'
                    , '-' || ROW_NUMBER() over (order by NULL)
                    , DATEADD('day' , '+1' , CURRENT_DATE)
                )                                     as hour_start
                , DATEADD('hour' , '+1' , hour_start) as hour_end
            from TABLE(GENERATOR(rowcount => (24 * 31)))
        )

        -- 1 row per hour a query ran
        , query_hours as (
            select
                hl.hour_start
                , hl.hour_end
                , queries.*
            from hours_list as hl
            inner join filtered_queries as queries
                on hl.hour_start >= DATE_TRUNC('hour' , queries.execution_start_time)
                and hl.hour_start < queries.end_time
        )

        , query_seconds_per_hour as (
            select
                *
                , DATEDIFF('millisecond' , GREATEST(execution_start_time , hour_start) , LEAST(end_time , hour_end)) as num_milliseconds_query_ran
                , SUM(num_milliseconds_query_ran) over (partition by warehouse_id , hour_start)                      as total_query_milliseconds_in_hour
                , num_milliseconds_query_ran / total_query_milliseconds_in_hour                                      as fraction_of_total_query_time_in_hour
                , hour_start                                                                                         as hour
            from query_hours
        )

        , credits_billed_per_hour as (
            select
                start_time as hour
                , warehouse_id
                , credits_used_compute
            from snowflake.account_usage.warehouse_metering_history
        )

        , query_cost as (
            select
                query.*
                , credits.credits_used_compute * 2.28                                        as actual_warehouse_cost
                , credits.credits_used_compute * fraction_of_total_query_time_in_hour * 2.28 as query_allocated_cost_in_hour
            from query_seconds_per_hour as query
            inner join credits_billed_per_hour as credits
                on query.warehouse_id = credits.warehouse_id
                and query.hour = credits.hour
        )

        , cost_per_query as (
            select
                query_id
                , ANY_VALUE(MD5(cleaned_query_text))     as query_signature
                , SUM(query_allocated_cost_in_hour)      as query_cost
                , ANY_VALUE(original_query_text)         as original_query_text
                , ANY_VALUE(warehouse_id)                as warehouse_id
                , SUM(num_milliseconds_query_ran) / 1000 as execution_time_s
            from query_cost
            group by 1
        )

        select
            query_signature
            , COUNT(*)                       as num_executions
            , AVG(query_cost)                as avg_cost_per_execution
            , SUM(query_cost)                as total_cost_last_30d
            , ANY_VALUE(original_query_text) as sample_query_text
        from cost_per_query
        group by 1
