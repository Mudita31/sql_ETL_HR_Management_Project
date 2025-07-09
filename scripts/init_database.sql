-- =====================================================
-- Script Purpose: 
    --This script creates a new database named 'HumanResource' after checking if it already exists.
    --If the database exists , It is dropped and recreated . Additionally , the script sets up three schemas
    -- within the database: 'bronze' , 'silver' and 'gold'.

-- WARNING:
--    Running this script will drop the entire 'HumanResource' database if exists.
--    All data in the database will be permanently deleted. Proceed with caution 
--    and ensure you have proper backups before running this script.
-- Author: [Mudita Rastogi]
-- Date: [2025-07-09]
-- =====================================================

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'HumanResource')
BEGIN
  ALTER DATABASE  HumanResource SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE HumanResource;
END;
GO

-- 1. Create the main database
CREATE DATABASE HumanResource;
GO

-- 2. Switch to the new database context
USE HumanResource;
GO

-- 3. Create schemas for each ETL layer

-- Bronze Layer: Raw Staging Data
CREATE SCHEMA bronze;
GO

-- Silver Layer: Cleaned and Validated Data
CREATE SCHEMA silver;
GO

-- Gold Layer: Final Aggregated Reporting Data
CREATE SCHEMA gold;
GO

-- =====================================================
-- ✅ Schemas successfully created.
-- =====================================================
