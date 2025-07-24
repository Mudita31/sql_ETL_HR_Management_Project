CREATE SCHEMA IF NOT EXISTS audit;

CREATE TABLE audit.etl_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    process_name NVARCHAR(100),
    start_time DATETIME2,
    end_time DATETIME2,
    status NVARCHAR(10),
    row_count INT,
    error_message NVARCHAR(MAX)
);
