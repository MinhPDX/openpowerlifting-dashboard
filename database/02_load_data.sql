/*
================================================================================
Load data from the CSV into the MeetResults table.
================================================================================
*/

-- Step 1: Ensure we are using the correct database.
USE OpenPowerlifting;
GO

-- Step 2: Clear out all old data from the table to prevent duplicates.
TRUNCATE TABLE dbo.MeetResults;
GO

-- Step 3: Load the new data using OPENROWSET and the new XML format file.
BEGIN TRY
    -- We will explicitly list the columns to ensure they match our table definition.
    INSERT INTO dbo.MeetResults (
        Name, Sex, Country, Age, AgeClass, Division, Event, Equipment,
        BodyweightKg, WeightClassKg,
        Squat1Kg, Squat2Kg, Squat3Kg, Squat4Kg,
        Bench1Kg, Bench2Kg, Bench3Kg, Bench4Kg,
        Deadlift1Kg, Deadlift2Kg, Deadlift3Kg, Deadlift4Kg,
        Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg,
        Place, Dots, Wilks, Glossbrenner, Goodlift,
        Federation, Date, MeetCountry, MeetState, MeetTown, MeetName,
        Tested, Sanctioned
    )
    SELECT
        Name, Sex, Country, Age, AgeClass, Division, Event, Equipment,
        BodyweightKg, WeightClassKg,
        Squat1Kg, Squat2Kg, Squat3Kg, Squat4Kg,
        Bench1Kg, Bench2Kg, Bench3Kg, Bench4Kg,
        Deadlift1Kg, Deadlift2Kg, Deadlift3Kg, Deadlift4Kg,
        Best3SquatKg, Best3BenchKg, Best3DeadliftKg, TotalKg,
        Place, Dots, Wilks, Glossbrenner, Goodlift,
        Federation, Date, MeetCountry, MeetState, MeetTown, MeetName,
        Tested, Sanctioned
    -- This OPENROWSET command reads the CSV and uses the XML file to understand the structure.
    FROM OPENROWSET(
        BULK 'C:\SQL_Data\openpowerlifting-2025-06-07-f8487982.csv',
        FORMATFILE = 'C:\SQL_Data\opl-format.xml',
        FIRSTROW = 2,
        CODEPAGE = '65001'
    ) AS Data;

    PRINT 'Data insert completed successfully using OPENROWSET with a format file.';
END TRY
BEGIN CATCH
    PRINT 'An error occurred during the data insert.';
    PRINT ERROR_MESSAGE(); 
END CATCH
GO

-- Optional: Check if the data was loaded by selecting the top 100 rows.
SELECT TOP 100 * FROM dbo.MeetResults;
GO