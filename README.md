# 🏋️‍♀️ Powerlifting Data Analysis and Visualization Project

📜 Project Overview

This project is a comprehensive analysis of the OpenPowerlifting dataset. The goal is to create a full data pipeline, starting from a raw CSV data source, moving through a structured SQL database, and ending with an interactive and insightful dashboard built in Power BI. This repository documents the entire process, focusing on the database setup and data ingestion phase, and will serve as a demonstration of my skills in data engineering, database management, and business intelligence.
Phase 1: 🏗️ Database Setup and Data Ingestion

This initial phase focused on building a robust and well-designed database to serve as the foundation for all future analysis.

1. 💻 Technology Stack

   Database: Microsoft SQL Server

   Management Tool: SQL Server Management Studio (SSMS)

   Data Source: CSV file from OpenPowerlifting.org

2. 📄 Data Source

The project utilizes the complete OpenPowerlifting dataset, which is publicly available as a single, large CSV file. This dataset contains millions of records of individual powerlifting performances from competitions around the world. The official data dictionary (a data-readme.md file) was also located and used to understand the structure, data types, and business rules for each column. 3. ✍️ Database and Table Design

A critical part of this project was designing a database schema that accurately models the source data and is optimized for analysis.

    Database Creation: A new database was created and named OpenPowerlifting to serve as a dedicated container for this project.

    Iterative Table Design: The design of the main table was an iterative process. After considering several naming options, I selected dbo.MeetResults. This name was chosen very deliberately because it accurately describes the granularity of the data: each row in the table represents the results of a single lifter at a single meet, not a unique lifter. This distinction is crucial for accurate analysis and demonstrates a professional approach to data modeling.

    Column Selection and Data Types: Using the official data dictionary, each column for the dbo.MeetResults table was carefully selected.

        Data types were chosen to match the source data precisely (e.g., DECIMAL for weights, FLOAT for calculated scores like Dots/Wilks, DATE for meet dates, and NVARCHAR with appropriate lengths for text).

        Constraints like NOT NULL were applied to mandatory fields as specified in the data dictionary.

        The scope of the table was expanded during the design process to include all individual lift attempts (Squat1Kg, Bench2Kg, etc.) to support a more detailed, lifter centric analysis in the final dashboard.

4. ⚙️ Data Loading and Troubleshooting

Loading a multi-gigabyte CSV file with over 40 columns presented a significant real world challenge. The process required systematic troubleshooting to find a successful and repeatable ingestion method.

    Initial Approach (BULK INSERT): My first attempt utilized the standard T-SQL BULK INSERT command. This approach failed due to file system permission errors, a common issue when the SQL Server service lacks access to user specific folders (like Documents or folders synced with OneDrive).

    Pivoting to OPENROWSET: To overcome the permission issues, I pivoted to the more flexible OPENROWSET(BULK...) function. This led to a series of syntax and version compatibility errors, which were resolved one by one.

    The Final Solution (Format File): The ultimate, successful solution was to use OPENROWSET in conjunction with a detailed XML Format File (opl-format.xml).

        Why a Format File? A format file is the most robust method for bulk data imports. It provides a precise, column by column blueprint of the source file, explicitly defining the data type, terminator, and length for every field.

        Overcoming the Final Error: This method allowed me to solve the final, subtle error caused by inconsistent line endings (\n vs. \r\n) in the source CSV, which had caused a "column is too long" error on the final column. By defining the exact row terminator in the format file, the import was able to parse every row correctly.

After 32 seconds of execution, this final method successfully loaded the entire dataset into the dbo.MeetResults table. ✅
➡️ Next Steps

With the data now cleaned, structured, and successfully loaded into a SQL Server database, the project is ready for the next phase: connecting Power BI to the OpenPowerlifting database and building a series of interactive dashboards for analysis and visualization. ✨
