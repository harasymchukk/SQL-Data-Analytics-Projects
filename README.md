## SQL Data Analytics Portfolio

Welcome to my SQL portfolio! This repository showcases a collection of advanced SQL projects focused on extracting actionable business insights, tracking revenue performance, and evaluating marketing campaign efficiency. 

The scripts are optimized for handling complex relational data models (Google Analytics session data, user accounting, and marketing funnel logs) using advanced query structures.

## 🚀 Key Technical Skills Showcased
* **Advanced Analytical Functions:** `DENSE_RANK()`, `SUM() OVER(PARTITION BY...)`, `LAG/LEAD`
* **Complex Data Structuring:** Multi-layered Common Table Expressions (CTEs), nested subqueries, and conditional aggregation (`SUM(CASE WHEN...)`)
* **Data Consolidation:** `UNION ALL` pipelines for multi-source metric integration
* **Business Metrics:** Share of Voice (SoV), Cumulative Revenue Run Rates, Conversion Rates (Open/Visit), and Regional Cohort Ranking

---

## 📌 Repository Structure & Projects

### 1. [Email Share & Distribution Analysis](./Project_01_Email_Distribution_Analysis/)
* **Business Problem:** The marketing team needed to evaluate user engagement with email campaigns on a granular, monthly account level to understand messaging distribution.
* **SQL Techniques Used:** Multi-stage CTEs, BigQuery Date/Time manipulation (`DATE_ADD`, `EXTRACT`), and dynamic percentage calculations.
* **What the Code Does:** * Aligns email dispatch dates with web session baselines.
    * Calculates the total volume of messages sent per month.
    * Determines what percentage of the month's total volume was contributed by each individual account, alongside tracking their first and last activity milestones.

### 2. [Cumulative Revenue Run-Rate vs. Forecast](./Project_02_Cumulative_Revenue_vs_Forecast/)
* **Business Problem:** Financial analysts required a day-by-day progress tracking mechanism to check if actual operational revenue is pacing well against the predictive model targets.
* **SQL Techniques Used:** Nested subqueries, `UNION ALL` dataset blending, and window-based running totals (`SUM() OVER (ORDER BY date)`).
* **What the Code Does:** * Aggregates actual product order values and predictive revenue metrics by date.
    * Builds a day-over-day cumulative running total for both actual and forecasted metrics.
    * Generates a dynamic pacing percentage (`predict_to_revenue_percent`) to monitor plan execution.

### 3. [Global Revenue and User Demographics Matrix](./Project_03_Global_Revenue_and_User_Demographics/)
* **Business Problem:** Executive leadership needed a high-level geographical performance dashboard comparing continental traffic, account verification rates, and platform device revenue splits (Mobile vs. Desktop).
* **SQL Techniques Used:** Conditional aggregation (`CASE WHEN`), global window aggregates (`OVER()`), and multi-table `LEFT JOIN` operations.
* **What the Code Does:** * Extracts total global revenue and segments it instantly into desktop vs. mobile device shares.
    * Computes each continent's financial contribution weight against the global total.
    * Aggregates total user accounts, counts verified customers, and benchmarks this against raw traffic (session counts) across all continents.

### 4. [Top-10 Countries Marketing Performance & Funnel Evaluation (Module Capstone)](./Project_04_Top_Countries_Marketing_Performance/)
* **Business Problem:** The Growth team wanted to isolate the top 10 highest-performing countries based on user acquisition and marketing communication volume, while analyzing email funnel conversion metrics.
* **SQL Techniques Used:** Unified metric logging (`UNION ALL`), multi-layered CTEs, Window Aggregations, and advanced sorting with `DENSE_RANK()`.
* **What the Code Does:** * Constructs a unified data grid combining email funnel interaction steps (Sent $\rightarrow$ Opened $\rightarrow$ Visited) with base user account registrations.
    * Pre-calculates running total benchmarks for account counts and sent volume per country.
    * Applies individual country rankings using dense partitioning and filters the final output to only show regions in the top 10 for either user base size or communication footprint.

---

## 📊 Database Schema Context
The queries operate over a structured schema prefixed with `DA.`, utilizing relationships across:
* `DA.session` & `DA.session_params` (Traffic and geolocation data)
* `DA.account` & `DA.account_session` (User subscription profiles and verification statuses)
* `DA.order` & `DA.product` (E-commerce conversion details)
* `DA.email_sent`, `DA.email_open`, & `DA.email_visit` (Marketing distribution layers)

