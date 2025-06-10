# 🏋️‍♀️ Powerlifting Data Analysis and Visualization Project

## 📜 Project Overview

This project is a comprehensive, end-to-end analysis of the OpenPowerlifting dataset. The goal was to build a full data pipeline, starting from a raw CSV data source, moving through a robust SQL database, and culminating in a multi-page, interactive Power BI dashboard. This repository documents the entire process, showcasing key skills in data engineering, database management, and business intelligence.

---

## Phase 1: 🏗️ Database Setup and Data Ingestion

This initial phase focused on building a robust, reliable, and well-designed database to serve as the foundation for all future analysis.

### 1. Technology Stack

- **Database:** Microsoft SQL Server
- **Database Tools:** SQL Server Management Studio (SSMS)
- **Version Control:** Git & GitHub

### 2. The Data Loading Challenge: A Staging Table Approach

Loading a multi-gigabyte CSV file with over 40 columns presented a significant real-world data engineering challenge. Initial attempts to load the data directly into a pre-formatted table using `BULK INSERT` and `OPENROWSET` failed due to a subtle but critical issue: the import process was rounding decimal values, leading to a loss of precision for all lift data.

To solve this, a professional, industry-standard **staging table pattern** was implemented.

- **Step 1: Create a Staging Table:** A staging table (`dbo.MeetResults_Staging`) was created where every single column was defined as `NVARCHAR`. This ensures that the raw data is imported as plain text, guaranteeing **zero data loss or unintended conversion** during the initial load.
- **Step 2: Load Raw Data:** `BULK INSERT` was used to efficiently load the CSV data into this text-only staging table.
- **Step 3: Transform and Load into Final Table:** A final, permanent table (`dbo.MeetResults`) was created with precise, correct data types (e.g., `DECIMAL(7, 2)` for lifts, `DATE` for dates). An `INSERT...SELECT` script was then executed to move data from the staging table to the final table, using `TRY_CAST` to safely convert each text column into its proper data type.

This two-step process completely solved the data integrity issue and created a repeatable, robust data pipeline.

---

## Phase 2: 📊 Power BI Data Modeling & Transformation

Once the data was reliably in SQL Server, the focus shifted to preparing it for analysis in Power BI.

### 1. Data Transformation in Power Query

Inside the Power Query Editor, several key transformations were performed:

- **Handling Nulls:** Replaced `null` values in all numeric lift and score columns with `0` to ensure accurate calculations.
- **Creating a Dynamic Date Table:** A best-practice, dynamic Date Table was created using M code. This table automatically determines the start and end dates from the main `MeetResults` table and generates a complete calendar, which is essential for powerful time-intelligence analysis.

### 2. Data Modeling

In the Model view, a clean star schema was established by creating a **one-to-many relationship** between the `Date Table` (the "one" side) and the `MeetResults` table (the "many" side) on their respective `Date` columns.

---

## Phase 3: 📈 Dashboard Development

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

### 2. The "Lifter Details" Page

This page was designed as a user-centric tool for lifters to analyze their own performance.

- **Search Functionality:** A searchable **Slicer** on the `Name` column allows a user to easily find and select any lifter from the dataset.
- **Competition History Table:** The core of this page is a detailed `Table` visual that replicates the functionality of the OpenPowerlifting website, showing a lifter's complete competition history.

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
