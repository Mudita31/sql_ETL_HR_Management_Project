DECLARE @process_name NVARCHAR(100) = 'silver.load_employee_silver';
DECLARE @start_time DATETIME2 = SYSDATETIME();
DECLARE @row_count INT = 0;

BEGIN TRY
    -- Start Log
    INSERT INTO audit.etl_log (process_name, start_time, status)
    VALUES (@process_name, @start_time, 'START');

    -- Replace this block with your actual ETL logic
    DELETE FROM silver.employee_data;
    INSERT INTO silver.employee_data (...)
    SELECT ... FROM bronze.employee_data;

    -- Row count for logging
    SET @row_count = (SELECT COUNT(*) FROM silver.employee_data);

    -- End Log
    UPDATE audit.etl_log
    SET end_time = SYSDATETIME(), status = 'SUCCESS', row_count = @row_count
    WHERE process_name = @process_name AND start_time = @start_time;

END TRY
BEGIN CATCH
    UPDATE audit.etl_log
    SET end_time = SYSDATETIME(), status = 'FAILED', error_message = ERROR_MESSAGE()
    WHERE process_name = @process_name AND start_time = @start_time;

    THROW;
END CATCH;
