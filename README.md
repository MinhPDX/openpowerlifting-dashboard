# 🏋️‍♀️ Powerlifting Data Analysis and Visualization Project

## 📜 Project Overview

This project documents the end-to-end process of building a data analysis pipeline. It starts with a raw CSV data source, moves through a structured SQL database, and culminates in an interactive Power BI dashboard. This repository showcases key skills in data engineering, database management, and business intelligence.

---

## Phase 1: 🏗️ Database Setup and Data Ingestion

This initial phase focused on building a robust and well-designed database to serve as the foundation for all future analysis.

### 1. 💻 Technology Stack

- **Database:** Microsoft SQL Server
- **Management Tool:** SQL Server Management Studio (SSMS)
- **Data Source:** `openpowerlifting-latest.csv` from OpenPowerlifting.org

### 2. ✍️ Database and Table Design

A critical part of this project was designing a database schema that accurately models the source data.

- **Database Creation:** A new database named `OpenPowerlifting` was created to serve as a dedicated container for the project.
- **Iterative Table Design:** After careful consideration, **`dbo.MeetResults`** was chosen as the primary table name. This name accurately reflects the granularity of the data, where each row represents the results of a single lifter at a specific meet.
- **Data-Driven Column Selection:** Using the official data dictionary, columns were selected and assigned precise data types (e.g., `DECIMAL` for weights, `FLOAT` for scores, `DATE` for dates). The table design was expanded to include all individual lift attempts to support a detailed, lifter-centric analysis.

### 3. ⚙️ Data Loading and Troubleshooting

Loading a multi-gigabyte CSV file with over 40 columns presented a real-world data engineering challenge that required systematic troubleshooting.

- **Initial Approach (`BULK INSERT`):** This standard T-SQL command failed due to file system permission errors, a common issue when SQL Server cannot access user-specific folders.
- **Pivoting to `OPENROWSET`:** This more flexible function was used to overcome the initial permissions block, but led to further syntax and version-compatibility errors that were resolved sequentially.
- **✅ The Final Solution (XML Format File):** The ultimate, successful solution involved using `OPENROWSET` with a detailed **XML Format File**. This method provides a robust, column-by-column blueprint of the source file. It was key to solving the final error, which was caused by inconsistent line-ending characters (`\n` vs. `\r\n`) in the raw data.

After 32 seconds of execution, the entire dataset was successfully loaded into the `dbo.MeetResults` table.

---

## ➡️ Next Steps

With the data now cleaned, structured, and loaded into a SQL Server database, the project is ready for the next phase: **connecting Power BI and building a series of interactive dashboards for analysis and visualization.** ✨
