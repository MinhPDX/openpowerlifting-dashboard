# 🏋️‍♀️ Powerlifting Data Analysis and Visualization Project

![image](https://github.com/user-attachments/assets/9c365345-adaa-464e-a4eb-5227df108a94)
[OpenPowerlifting Dashboard - Power BI](https://app.powerbi.com/links/oHeCmjs9sV?ctid=983bb12d-4704-4fe3-a862-f064ed80292d&pbi_source=linkShare&bookmarkGuid=41bf3263-bd98-4bc1-b869-93fe84f7e8bb)
## 📜 Project Overview

This project documents the end-to-end process of building a comprehensive data analysis solution for the OpenPowerlifting dataset. It begins with raw CSV data, establishes a robust data pipeline into a SQL Server database, and culminates in a sophisticated, multi-page, interactive Power BI dashboard designed for both high-level analysis and detailed individual exploration.

This repository showcases key skills in data engineering, database design, database management, advanced DAX, user-centric dashboard development, and business intelligence.

---

## Phase 1: 🏗️ Database Setup and Data Ingestion

This initial phase focused on building a robust, reliable, and well-designed database to serve as the foundation for all future analysis.

### 1. Technology Stack

- **Database:** Microsoft SQL Server
- **Database Tools:** SQL Server Management Studio (SSMS)
- **Automation Scripting:** Python
- **Version Control:** Git & GitHub

### 2. The Data Loading Challenge: A Staging Table Approach

Loading a CSV file with over 40 columns presented a significant real-world data engineering challenge. Initial attempts to load the data directly into a pre-formatted table using `BULK INSERT` and `OPENROWSET` failed due to a subtle but critical issue: the import process was rounding decimal values, leading to a loss of precision for all lift data.

To solve this, a professional, industry-standard **staging table pattern** was implemented.

- **Step 1: Create a Staging Table:** A staging table (`dbo.MeetResults_Staging`) was created where every single column was defined as `NVARCHAR`. This ensures that the raw data is imported as plain text, guaranteeing **zero data loss or unintended conversion** during the initial load.
- **Step 2: Load Raw Data:** `BULK INSERT` was used to efficiently load the CSV data into this text-only staging table.
- **Step 3: Transform and Load into Final Table:** A final, permanent table (`dbo.MeetResults`) was created with precise, correct data types (e.g., `DECIMAL(7, 2)` for lifts, `DATE` for dates). An `INSERT...SELECT` script was then executed to move data from the staging table to the final table, using `TRY_CAST` to safely convert each text column into its proper data type.

This two-step process completely solved the data integrity issue and created a repeatable, robust data pipeline.

---

## Phase 2: 🤖 Automation of the Data Pipeline

To ensure the dashboard can be updated with the latest data efficiently, the entire data ingestion process was automated.

- **Python for Data Retrieval:** A Python script was developed to handle the data download. It automatically fetches the latest `openpowerlifting-latest.zip` file from the source, intelligently finds the dynamically named `.csv` file within the archive, and saves it to a consistent local path for the SQL Server to access.
- **SQL Stored Procedure:** The entire multi-step SQL process (clearing tables, loading to staging, transforming and loading to the final table) was encapsulated into a single, reusable **Stored Procedure** named `dbo.sp_RefreshMeetResults`. This is a professional best practice that makes the database refresh process a single, callable command.
- **Scheduling:** This pipeline is designed to be fully automated using a tool like Windows Task Scheduler, which can be configured to run the Python download script and then execute the SQL stored procedure on a recurring basis (e.g., weekly or monthly).

---

## Phase 3: 📊 Power BI Data Modeling & Transformation

Once the data was reliably in SQL Server, the focus shifted to preparing it for analysis in Power BI and creating a powerful and user-friendly report.

### 1. Data Transformation in Power Query

Inside the Power Query Editor, several key transformations were performed:

- **Handling Nulls:** Replaced `null` values in all numeric lift and score columns with `0` to ensure accurate calculations.
- **Creating a Dynamic Date Table:** A best-practice, dynamic Date Table was created using M code. This table automatically determines the start and end dates from the main `MeetResults` table and generates a complete calendar, which is essential for powerful time-intelligence analysis.

* **Data Modeling for Comparison:** To enable the side-by-side lifter comparison feature, the `MeetResults` query was duplicated to create a second, **disconnected table** called `MeetResults_Comparison`. This advanced technique allows two slicers on the same page to filter two independent datasets.

### 2. Data Modeling

In the Model view, a clean star schema was established by creating a **one-to-many relationship** between the `Date Table` (the "one" side) and the `MeetResults` table (the "many" side) on their respective `Date` columns.

---

## Phase 4: 📈 Dashboard Development

The final phase focused on creating an intuitive, multi-page report to explore the data.

### 1. The "Overview" Dashboard

This page provides a high-level summary of the entire dataset.

- **KPIs:** Key metrics were created using DAX measures (`DISTINCTCOUNT`, `AVERAGE`) to display Total Performances, Unique Lifters, and the Average Total.
- **Visuals:** A combination of visuals tells a comprehensive story:
  - A **Line Chart** shows the growth of powerlifting participation over time.
  - A **Donut Chart** breaks down the demographic distribution of lifters by gender.
  - A **Stacked Column Chart** combines these two concepts to show how the gender distribution has evolved year over year.
  - A **Treemap** provides a powerful alternative to a map visual, showing the distribution of lifters by country.
- **Interactivity:** **Slicers** for `Equipment` and `Federation` (formatted as a dropdown) were added to allow users to dynamically filter the entire report.

### Page 2: The "Lifter Details & Comparison" Page

This page was designed as a powerful tool for lifters to analyze their own performance and compare themselves to others.

- **Data Modeling for Comparison:** To enable the side-by-side lifter comparison feature, the `MeetResults` query was duplicated to create a second, **disconnected table** called `MeetResults_Comparison`. This advanced technique allows two slicers on the same page to filter two independent datasets.
- **Dual Slicer Functionality:** Two independent, searchable slicers allow the user to select "Lifter 1" and "Lifter 2".
- **Side-by-Side History:** Two separate tables display the complete competition history for each selected lifter.
- **KPI Comparison:** A series of **Card** visuals at the top of the page provides an "at-a-glance" comparison of the two lifters' personal bests (Squat, Bench, Deadlift, Total, and DOTS) and calculates the absolute **Difference** between them.
- **Advanced DAX for Formatting:** To overcome a persistent Power BI formatting bug with trailing zeros, custom DAX measures using the `FORMAT` function were written to ensure all numbers are displayed cleanly and correctly.

### 3. Advanced DAX for Custom Formatting

A persistent formatting bug in Power BI prevented the display of correct decimal places (e.g., showing `102.50` or `102` instead of `102.5`). After multiple standard methods failed, an advanced DAX solution was implemented.

- **The Solution:** A new text column was created for each numeric field using a conditional DAX formula. This formula checks if a number is a whole number or a decimal and formats it as text accordingly, completely bypassing Power BI's problematic automatic formatting. This demonstrates advanced problem-solving within DAX.

```dax
TotalKg_Formatted =
IF(
    MeetResults[TotalKg] = 0, "0",
    IF(
        ROUND(MeetResults[TotalKg], 2) = INT(MeetResults[TotalKg]),
        FORMAT(MeetResults[TotalKg], "0"),
        FORMAT(MeetResults[TotalKg], "General Number")
    )
)
```

---

### The Final Dashboard

The report consists of two main pages:

1.  **The "Overview" Dashboard:** Provides a high-level summary of the entire dataset, featuring KPIs, trend charts, demographic breakdowns, and interactive slicers.
2.  **The "Lifter Details & Comparison" Page:** A powerful tool for users to search for two individual lifters and compare their complete competition histories and personal bests side-by-side.
