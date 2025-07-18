-- ================================================
-- Author      : Your Name
-- Created On  : YYYY-MM-DD
-- Procedure   : bronze.load_bronze
-- Description : Loads raw CSV files from local storage into the Bronze Layer
--               using BULK INSERT. Logs each load duration and handles errors.
-- ================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '===============================================';
        PRINT '          Starting Bronze Layer Load';
        PRINT '===============================================';
        PRINT '-----------------------------------------------';
        PRINT '                Loading Tables';
        PRINT '-----------------------------------------------';

        --------------------------------------------------
        -- 1. Load Employee Data
        --------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.employee_data';
        TRUNCATE TABLE bronze.employee_data;

        PRINT '>> Inserting Data Into: bronze.employee_data';
        BULK INSERT bronze.employee_data
        FROM 'C:\Users\rasto\OneDrive\Desktop\ETLFiles\employee_data.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------';

        --------------------------------------------------
        -- 2. Load Employee Engagement Survey Data
        --------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.employee_engagement_survey_data';
        TRUNCATE TABLE bronze.employee_engagement_survey_data;

        PRINT '>> Inserting Data Into: bronze.employee_engagement_survey_data';
        BULK INSERT bronze.employee_engagement_survey_data
        FROM 'C:\Users\rasto\OneDrive\Desktop\ETLFiles\employee_engagement_survey_data.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------';

        --------------------------------------------------
        -- 3. Load Recruitment Data
        --------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.recruitment_data';
        TRUNCATE TABLE bronze.recruitment_data;

        PRINT '>> Inserting Data Into: bronze.recruitment_data';
        BULK INSERT bronze.recruitment_data
        FROM 'C:\Users\rasto\OneDrive\Desktop\ETLFiles\recruitment_data.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------';

        --------------------------------------------------
        -- 4. Load Training and Development Data
        --------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.training_and_development_data';
        TRUNCATE TABLE bronze.training_and_development_data;

        PRINT '>> Inserting Data Into: bronze.training_and_development_data';
        BULK INSERT bronze.training_and_development_data
        FROM 'C:\Users\rasto\OneDrive\Desktop\ETLFiles\training_and_development_data.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------';

        --------------------------------------------------
        -- Summary
        --------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '=========================================';
        PRINT 'Bronze Layer Load Completed Successfully!';
        PRINT 'Total Batch Load Time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=========================================';

    END TRY
    BEGIN CATCH
        PRINT '=========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================';
    END CATCH
END;

--Execution:
EXEC bronze.load_bronze;
