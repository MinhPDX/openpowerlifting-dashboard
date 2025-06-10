/*
==========================================================================
SCRIPT 02: LOAD STAGING DATA
PURPOSE: Loads the raw data from the CSV file into the staging table.
- Clears the staging table to prepare for a new load.
- Uses BULK INSERT to efficiently load the text data.
RUN: Every time you download a new openpowerlifting-latest.csv file.
==========================================================================
*/

USE OpenPowerlifting;
GO

-- Truncate the staging table to ensure it's empty before loading.
TRUNCATE TABLE dbo.MeetResults_Staging;
GO

-- Load the raw data as text into the staging table.
-- UPDATE THE FILE PATH to your local machine.
BULK INSERT dbo.MeetResults_Staging
FROM 'C:\SQL_Data\openpowerlifting-latest.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- This specifies a line feed character as the row terminator
    CODEPAGE = '65001' -- This specifies UTF-8 encoding
);
GO

PRINT 'SUCCESS: Raw data has been loaded into the staging table.';
GO
