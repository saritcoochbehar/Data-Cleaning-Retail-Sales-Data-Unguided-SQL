# Data-Cleaning-Retail-Sales-Data-Unguided-SQL
Structured data, simplified with SQL

# SQL Data Cleaning Project

This project demonstrates a **complete SQL-based data cleaning workflow** applied to a `Sales` table.  
It covers handling null values, fixing inconsistent data, checking duplicates, detecting outliers, and enforcing proper data types — all using SQL queries.

---

## Project Overview
- Identify and count **null values** across all columns.
- Replace nulls with meaningful defaults:
  - `Item` → `'Unknown'`
  - `Discount_Applied` → `0`
  - `Price_Per_Unit` → calculated as `Total_Spent / Quantity`
  - `Quantity` → replaced with **Median value (6)**
  - `Total_Spent` → recalculated as `Price_Per_Unit * Quantity`
- Validate that **no null values remain**.
- Check for **duplicate Transaction_IDs** (none found).
- Ensure no **extra spaces** in text fields.
- Detect **outliers** in `Quantity` and `Total_Spent` using Z-score (none found).
- Standardize **data types** for consistency and accuracy.

---

## Table Schema (Final)
| Column Name       | Data Type  | Nullable |
|-------------------|------------|----------|
| Transaction_ID    | varchar(50)| NO       |
| Customer_ID       | varchar(50)| NO       |
| Category          | varchar(50)| NO       |
| Item              | varchar(50)| NO       |
| Price_Per_Unit    | float      | NO       |
| Quantity          | int        | NO       |
| Total_Spent       | float      | NO       |
| Payment_Method    | varchar(50)| NO       |
| Location          | varchar(50)| NO       |
| Transaction_Date  | date       | NO       |
| Discount_Applied  | int        | YES      |

---
