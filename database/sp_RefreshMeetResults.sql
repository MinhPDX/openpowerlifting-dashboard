USE OpenPowerlifting;
GO

-- Create a master stored procedure to refresh all data
CREATE OR ALTER PROCEDURE dbo.sp_RefreshMeetResults
AS
BEGIN
    -- This procedure automates the entire ETL process within SQL Server.

    -- Step 1: Clear out the tables
    TRUNCATE TABLE dbo.MeetResults_Staging;
    TRUNCATE TABLE dbo.MeetResults;
    PRINT 'SUCCESS: Staging and Final tables have been cleared.';

    -- Step 2: Load the raw data into the staging table
    BULK INSERT dbo.MeetResults_Staging
    FROM 'C:\SQL_Data\openpowerlifting-latest.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        CODEPAGE = '65001'
    );
    PRINT 'SUCCESS: Raw data loaded into staging table.';

    -- Step 3: Transform and load data into the final table
    INSERT INTO dbo.MeetResults
    SELECT
        Name, Sex, Country, TRY_CAST(Age AS DECIMAL(5, 2)), AgeClass, Division, Event, Equipment,
        TRY_CAST(BodyweightKg AS DECIMAL(6, 2)), WeightClassKg, TRY_CAST(Squat1Kg AS DECIMAL(7, 2)),
        TRY_CAST(Squat2Kg AS DECIMAL(7, 2)), TRY_CAST(Squat3Kg AS DECIMAL(7, 2)), TRY_CAST(Squat4Kg AS DECIMAL(7, 2)),
        TRY_CAST(Bench1Kg AS DECIMAL(7, 2)), TRY_CAST(Bench2Kg AS DECIMAL(7, 2)), TRY_CAST(Bench3Kg AS DECIMAL(7, 2)),
        TRY_CAST(Bench4Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift1Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift2Kg AS DECIMAL(7, 2)),
        TRY_CAST(Deadlift3Kg AS DECIMAL(7, 2)), TRY_CAST(Deadlift4Kg AS DECIMAL(7, 2)), TRY_CAST(Best3SquatKg AS DECIMAL(7, 2)),
        TRY_CAST(Best3BenchKg AS DECIMAL(7, 2)), TRY_CAST(Best3DeadliftKg AS DECIMAL(7, 2)), TRY_CAST(TotalKg AS DECIMAL(8, 2)),
        Place, TRY_CAST(Dots AS FLOAT), TRY_CAST(Wilks AS FLOAT), TRY_CAST(Glossbrenner AS FLOAT),
        TRY_CAST(Goodlift AS FLOAT), Federation, TRY_CAST(Date AS DATE), MeetCountry, MeetState,
        MeetTown, MeetName, Tested, Sanctioned
    FROM dbo.MeetResults_Staging;
    PRINT 'SUCCESS: Data transformed and loaded into final MeetResults table.';

END
GO