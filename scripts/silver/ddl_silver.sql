/*
**********************************************************************************
DDL Script: Create Silver Tables
**********************************************************************************
Script Purpose:
    This script creates cleaned and structured Silver Layer tables in the 'silver' schema.
    It drops existing tables (if any), and re-creates them with appropriate datatypes,
    default metadata columns, and naming conventions based on data profiling done
    in the Bronze Layer.
**********************************************************************************
*/

-- ========================================
-- TABLE: silver.employee_data
-- ========================================
IF OBJECT_ID('silver.employee_data', 'U') IS NOT NULL
    DROP TABLE silver.employee_data;
GO

CREATE TABLE silver.employee_data (
    EmployeeID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(10),
    Department NVARCHAR(100),
    Position NVARCHAR(100),
    DateOfJoining DATE,
    Salary DECIMAL(18,2),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- ========================================
-- TABLE: silver.employee_engagement_survey
-- ========================================
IF OBJECT_ID('silver.employee_engagement_survey', 'U') IS NOT NULL
    DROP TABLE silver.employee_engagement_survey;
GO

CREATE TABLE silver.employee_engagement_survey (
    EmployeeID INT,
    SurveyYear INT,
    EngagementScore DECIMAL(5,2),
    Comments NVARCHAR(MAX),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- ========================================
-- TABLE: silver.employee_exit_data
-- ========================================
IF OBJECT_ID('silver.employee_exit_data', 'U') IS NOT NULL
    DROP TABLE silver.employee_exit_data;
GO

CREATE TABLE silver.employee_exit_data (
    EmployeeID INT,
    ExitDate DATE,
    ReasonForLeaving NVARCHAR(255),
    ExitInterviewCompleted BIT,
    Feedback NVARCHAR(MAX),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- ========================================
-- TABLE: silver.employee_performance_reviews
-- ========================================
IF OBJECT_ID('silver.employee_performance_reviews', 'U') IS NOT NULL
    DROP TABLE silver.employee_performance_reviews;
GO

CREATE TABLE silver.employee_performance_reviews (
    EmployeeID INT,
    ReviewPeriodStart DATE,
    ReviewPeriodEnd DATE,
    OverallRating DECIMAL(3,2),
    ManagerComments NVARCHAR(MAX),
    PromotionRecommended BIT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
