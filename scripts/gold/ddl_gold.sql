/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =======================================================================
-- Create Dimension: gold.dim_employee
-- =======================================================================

IF OBJECT_ID('gold.dim_employee', 'V') IS NOT NULL
    DROP VIEW gold.dim_employee
GO
CREATE VIEW gold.dim_employee AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY emp.EmployeeID) AS employee_key,
    emp.EmployeeID,
    emp.Name,
    emp.Department,
    emp.Designation,
    emp.Gender,
    emp.Education,
    emp.JoinDate,
    rec.RecruitmentChannel
FROM silver.employee_data emp
LEFT JOIN silver.recruitment_data rec
    ON emp.EmployeeID = rec.EmployeeID

-- =======================================================================
-- Create Dimension: gold.dim_training
-- =======================================================================

IF OBJECT_ID('gold.dim_training', 'V') IS NOT NULL
    DROP VIEW gold.dim_training
GO
CREATE VIEW gold.dim_training AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY td.EmployeeID) AS training_key,
    td.EmployeeID,
    emp.Name,
    emp.Department,
    td.TrainingProgram,
    td.TrainingHours,
    td.TrainingType
FROM silver.training_and_development_data td
LEFT JOIN silver.employee_data emp
    ON td.EmployeeID = emp.EmployeeID

-- =======================================================================
-- Create Fact Table: gold.fact_engagement
-- =======================================================================

IF OBJECT_ID('gold.fact_engagement', 'V') IS NOT NULL
    DROP VIEW gold.fact_engagement
GO
CREATE VIEW gold.fact_engagement AS
SELECT 
    ee.EmployeeID,
    emp.Name,
    emp.Department,
    emp.Designation,
    ee.JobSatisfaction,
    ee.EnvironmentSatisfaction,
    ee.WorkLifeBalance,
    ee.EngagementScore
FROM silver.employee_engagement_survey_data ee
LEFT JOIN silver.employee_data emp
    ON ee.EmployeeID = emp.EmployeeID
