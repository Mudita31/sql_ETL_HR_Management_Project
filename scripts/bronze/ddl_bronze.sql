/*
=====================================================================================
DDL Script: Create Bronze Tables
=====================================================================================
Script Purpose: 
    This script creates tables in the 'bronze' schema , dropiing existing tables
    if they already exist .
    Run this script to re-define the DDL structure of 'bronze' Tables
Author : Mudita Rastogi
Date : 2025-07-09
=====================================================================================
*/

USE HumanResource;
GO

-- ============================
-- 🟫 Bronze Table: employee_data
-- ============================
IF OBJECT_ID('bronze.employee_data', 'U') IS NOT NULL
    DROP TABLE bronze.employee_data;
GO

CREATE TABLE bronze.employee_data (
    emp_id INT,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    start_date DATE,
    exit_date DATE,
    title NVARCHAR(50),
    supervisor NVARCHAR(50),
    ad_email NVARCHAR(50),
    business_unit NVARCHAR(50),
    employee_status NVARCHAR(50),
    employee_type NVARCHAR(50),
    pay_zone NVARCHAR(50),
    employee_classification_type NVARCHAR(50),
    termination_type NVARCHAR(50),
    termination_description NVARCHAR(50),
    department_type NVARCHAR(50),
    division NVARCHAR(50),
    dob DATE,
    state NVARCHAR(50),
    job_function_description NVARCHAR(50),
    gender_code NVARCHAR(50),
    location_code INT,
    race_desc NVARCHAR(50),
    marital_desc NVARCHAR(50),
    performance_score NVARCHAR(50),
    current_employee_rating INT
);
GO

-- ==============================================
-- 🟫 Bronze Table: employee_engagement_survey_data
-- ==============================================
IF OBJECT_ID('bronze.employee_engagement_survey_data', 'U') IS NOT NULL
    DROP TABLE bronze.employee_engagement_survey_data;
GO

CREATE TABLE bronze.employee_engagement_survey_data (
    employee_id INT,
    survey_date DATE,
    engagement_score INT,
    satisfaction_score INT,
    work_life_balance_score INT
);
GO

-- ============================
-- 🟫 Bronze Table: recruitment_data
-- ============================
IF OBJECT_ID('bronze.recruitment_data', 'U') IS NOT NULL
    DROP TABLE bronze.recruitment_data;
GO

CREATE TABLE bronze.recruitment_data (
    applicant_id INT,
    application_date DATE,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    gender NVARCHAR(50),
    date_of_birth DATE,
    phone_number NVARCHAR(50),
    email NVARCHAR(50),
    address NVARCHAR(50),
    city NVARCHAR(50),
    state NVARCHAR(50),
    zip_code INT,
    country NVARCHAR(50),
    education_level NVARCHAR(50),
    years_of_experience INT,
    desired_salary FLOAT,
    job_title NVARCHAR(50),
    status NVARCHAR(50)
);
GO

-- ==========================================
-- 🟫 Bronze Table: training_and_development_data
-- ==========================================
IF OBJECT_ID('bronze.training_and_development_data', 'U') IS NOT NULL
    DROP TABLE bronze.training_and_development_data;
GO

CREATE TABLE bronze.training_and_development_data (
    employee_id INT,
    training_date DATE,
    training_program_name NVARCHAR(50),
    training_type NVARCHAR(50),
    training_outcome NVARCHAR(50),
    location NVARCHAR(50),
    trainer NVARCHAR(50),
    training_duration_days INT,
    training_cost FLOAT
);
GO

-- =====================================================
-- ✅ Bronze tables successfully created in 'bronze' schema.
-- Next Step: Import CSV data into each staging table.
-- =====================================================
