# 🏢 Human Resource ETL Project (SQL Server)

This project simulates a complete **ETL (Extract, Transform, Load)** pipeline using **SQL Server** for a Human Resource (HR) management system.  
The goal is to load raw HR datasets, clean and transform them, and prepare them for analytics-ready reporting using a layered approach:

- 🟫 **Bronze Layer**: Raw staging tables
- 🪞 **Silver Layer**: Cleaned and validated data
- 🥇 **Gold Layer**: Final reporting data (summary metrics & insights)

---

## ✅ Status

| Phase                 | Status | Description                                      |
|----------------------|--------|--------------------------------------------------|
| Database Setup        | ✅ Done | `HumanResource` DB created                       |
| Schema Setup          | ✅ Done | `bronze`, `silver`, `gold` schemas created       |
| Bronze Layer Tables   | ✅ Done | Raw data tables created in `bronze` schema       |
| Data Import           | ✅ Done | CSVs imported into staging tables (bronze)       |
| Silver Layer          | ✅ Done | Cleaned, deduplicated & transformed data created |
| Gold Layer            | ✅ Done | Summary tables and final reports built           |
| ETL Logging           | ✅ Done | Audit trail and job tracking tables         |

---

## 🗂️ Project Structure (GitHub)

