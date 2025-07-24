/*
************************************************************************************
Stored Procedure: silver.load_employee_silver
************************************************************************************
Script Purpose:
    This stored procedure performs the ETL process to load cleaned and deduplicated 
    employee-related data from the Bronze layer into the Silver layer.

Key Operations:
    - Deduplicates data using ROW_NUMBER()
    - Trims and standardizes string fields
    - Converts and validates data types using TRY_CAST
    - Translates yes/no flags to 1/0
    - Tracks runtime duration per load step for monitoring

Loaded Tables:
    - silver.employee_data
    - silver.employee_engagement_survey
    - silver.employee_exit_data
    - silver.employee_performance_reviews

Error Handling:
    - Captures and reports any runtime exceptions using TRY/CATCH and RAISERROR

Usage Example:
    EXEC silver.load_employee_silver;

Author:
    Mudita Rastogi
************************************************************************************
*/

CREATE OR ALTER PROCEDURE silver.load_employee_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME2 = SYSDATETIME();
    DECLARE @step_start DATETIME2;
    DECLARE @step_end DATETIME2;
    DECLARE @duration_ms INT;

    BEGIN TRY

        -------------------------------
        -- 1. Load silver.employee_data
        -------------------------------
        SET @step_start = SYSDATETIME();

        TRUNCATE TABLE silver.employee_data;

        WITH Deduped AS (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY DateOfJoining DESC) AS rn
            FROM bronze.employee_data
        )
        INSERT INTO silver.employee_data (
            EmployeeID,
            FirstName,
            LastName,
            Gender,
            Department,
            Position,
            DateOfJoining,
            Salary,
            dwh_create_date
        )
        SELECT
            TRY_CAST(EmployeeID AS INT),
            TRIM(FirstName),
            TRIM(LastName),
            CASE 
                WHEN Gender IN ('Male', 'Female', 'Other') THEN Gender
                ELSE 'Unknown'
            END,
            TRIM(Department),
            TRIM(Position),
            TRY_CAST(DateOfJoining AS DATE),
            TRY_CAST(Salary AS DECIMAL(18,2)),
            SYSDATETIME()
        FROM Deduped
        WHERE rn = 1;

        SET @step_end = SYSDATETIME();
        SET @duration_ms = DATEDIFF(MILLISECOND, @step_start, @step_end);
        PRINT 'employee_data loaded in ' + CAST(@duration_ms AS VARCHAR) + ' ms';

        -----------------------------------------------
        -- 2. Load silver.employee_engagement_survey
        -----------------------------------------------
        SET @step_start = SYSDATETIME();

        TRUNCATE TABLE silver.employee_engagement_survey;

        WITH Deduped AS (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY EmployeeID, SurveyYear ORDER BY EngagementScore DESC) AS rn
            FROM bronze.employee_engagement_survey_data
        )
        INSERT INTO silver.employee_engagement_survey (
            EmployeeID,
            SurveyYear,
            EngagementScore,
            Comments,
            dwh_create_date
        )
        SELECT
            TRY_CAST(EmployeeID AS INT),
            TRY_CAST(SurveyYear AS INT),
            TRY_CAST(EngagementScore AS DECIMAL(5,2)),
            TRIM(Comments),
            SYSDATETIME()
        FROM Deduped
        WHERE rn = 1;

        SET @step_end = SYSDATETIME();
        SET @duration_ms = DATEDIFF(MILLISECOND, @step_start, @step_end);
        PRINT 'employee_engagement_survey loaded in ' + CAST(@duration_ms AS VARCHAR) + ' ms';

        ------------------------------------------
        -- 3. Load silver.employee_exit_data
        ------------------------------------------
        SET @step_start = SYSDATETIME();

        TRUNCATE TABLE silver.employee_exit_data;

        WITH Deduped AS (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY ExitDate DESC) AS rn
            FROM bronze.recruitment_data
            WHERE ExitDate IS NOT NULL  -- only exited employees
        )
        INSERT INTO silver.employee_exit_data (
            EmployeeID,
            ExitDate,
            ReasonForLeaving,
            ExitInterviewCompleted,
            Feedback,
            dwh_create_date
        )
        SELECT
            TRY_CAST(EmployeeID AS INT),
            TRY_CAST(ExitDate AS DATE),
            TRIM(ReasonForLeaving),
            CASE 
                WHEN LOWER(ExitInterviewCompleted) IN ('yes', 'y', 'true', '1') THEN 1
                ELSE 0
            END,
            TRIM(Feedback),
            SYSDATETIME()
        FROM Deduped
        WHERE rn = 1;

        SET @step_end = SYSDATETIME();
        SET @duration_ms = DATEDIFF(MILLISECOND, @step_start, @step_end);
        PRINT 'employee_exit_data loaded in ' + CAST(@duration_ms AS VARCHAR) + ' ms';

        ---------------------------------------------------
        -- 4. Load silver.employee_performance_reviews
        ---------------------------------------------------
        SET @step_start = SYSDATETIME();

        TRUNCATE TABLE silver.employee_performance_reviews;

        WITH Deduped AS (
            SELECT *,
                   ROW_NUMBER() OVER (PARTITION BY EmployeeID, ReviewPeriodStart, ReviewPeriodEnd ORDER BY OverallRating DESC) AS rn
            FROM bronze.training_and_development_data
        )
        INSERT INTO silver.employee_performance_reviews (
            EmployeeID,
            ReviewPeriodStart,
            ReviewPeriodEnd,
            OverallRating,
            ManagerComments,
            PromotionRecommended,
            dwh_create_date
        )
        SELECT
            TRY_CAST(EmployeeID AS INT),
            TRY_CAST(ReviewPeriodStart AS DATE),
            TRY_CAST(ReviewPeriodEnd AS DATE),
            TRY_CAST(OverallRating AS DECIMAL(3,2)),
            TRIM(ManagerComments),
            CASE 
                WHEN LOWER(PromotionRecommended) IN ('yes', 'y', 'true', '1') THEN 1
                ELSE 0
            END,
            SYSDATETIME()
        FROM Deduped
        WHERE rn = 1;

        SET @step_end = SYSDATETIME();
        SET @duration_ms = DATEDIFF(MILLISECOND, @step_start, @step_end);
        PRINT 'employee_performance_reviews loaded in ' + CAST(@duration_ms AS VARCHAR) + ' ms';

    END TRY
    BEGIN CATCH
        DECLARE @err_msg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR('Error in load_employee_silver: %s', 16, 1, @err_msg);
    END CATCH
END;
