/*
==========================================================================
SCRIPT 03: TRANSFORM AND LOAD
PURPOSE: Transforms the raw text data from staging and loads it into the
         final, production-ready MeetResults table.
- Clears the final table.
- Uses TRY_CAST to safely convert text to numbers and dates.
- Populates the final table with clean, correctly typed data.
RUN: Immediately after running script 02.
==========================================================================
*/

USE OpenPowerlifting;
GO

-- Truncate the final table to prepare for the new, clean data.
TRUNCATE TABLE dbo.MeetResults;
GO

-- Insert data from the staging table into the final table, converting data types on the fly.
-- Using TRY_CAST is a best practice as it prevents the entire script from
-- failing if it encounters a single value that cannot be converted. It will
-- insert NULL instead.
INSERT INTO dbo.MeetResults
SELECT
    Name, Sex, Country,
    TRY_CAST(Age AS DECIMAL(5, 2)),
    AgeClass, Division, Event, Equipment,
    TRY_CAST(BodyweightKg AS DECIMAL(6, 2)),
    WeightClassKg,
    TRY_CAST(Squat1Kg AS DECIMAL(7, 2)), TRY_CAST(Squat2Kg AS DECIMAL(7, 2)), TRY_CAST(Squat3Kg AS DECIMAL(7, 2)), TRY_CAST(Squat4Kg AS DECIMAL(7, 2)),
    TRY_CAST(Bench1Kg AS DECIMAL(7, 2)), TRY_CAST(Bench2Kg AS DECIMAL(7, 2)), TRY_CAST(Bench3Kg AS DECIMAL(7, 2)), TRY_CAST(Bench4Kg AS DECIMAL(7, 2)),
    TRY_CAST(Deadlift1Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift2Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift3Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift4Kg AS DECIMAL(7, 2)),
    TRY_CAST(Best3SquatKg AS DECIMAL(7, 2)), TRY_CAST(Best3BenchKg AS DECIMAL(7, 2)), TRY_CAST(Best3DeadliftKg AS DECIMAL(7, 2)),
    TRY_CAST(TotalKg AS DECIMAL(8, 2)),
    Place,
    TRY_CAST(Dots AS FLOAT), TRY_CAST(Wilks AS FLOAT), TRY_CAST(Glossbrenner AS FLOAT), TRY_CAST(Goodlift AS FLOAT),
    Federation,
    TRY_CAST(Date AS DATE),
    MeetCountry, MeetState, MeetTown, MeetName, Tested, Sanctioned
FROM
    dbo.MeetResults_Staging;
GO

PRINT 'SUCCESS: Data has been transformed and loaded into the final MeetResults table!';
GO

-- Optional: Verify the final data to ensure it loaded correctly.
SELECT TOP 100 * FROM dbo.MeetResults;
GO
