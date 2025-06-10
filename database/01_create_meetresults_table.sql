/*
==========================================================================
This script creates the main table for the OpenPowerlifting database.

DESIGNED USING THE OFFICIAL DATA DICTIONARY (data-readme.md)
==========================================================================
*/

-- Step 1: Ensure we are using the correct database.
USE OpenPowerlifting;
GO

-- Step 2: Drop the table if it already exists, to allow for a clean re-creation.
IF OBJECT_ID('dbo.MeetResults', 'U') IS NOT NULL
    DROP TABLE dbo.MeetResults;
GO

-- Step 3: Create the final table structure.
CREATE TABLE dbo.MeetResults (
    -- Lifter Details
    Name            NVARCHAR(255) NOT NULL,
    Sex             NVARCHAR(5)   NOT NULL,
    Country         NVARCHAR(50)  NULL,
    Age             DECIMAL(5, 2) NULL,
    AgeClass        NVARCHAR(20)  NULL,
    Division        NVARCHAR(100) NULL,

    -- Competition & Weight Details
    Event           NVARCHAR(5)   NOT NULL,
    Equipment       NVARCHAR(50)  NOT NULL,
    BodyweightKg    DECIMAL(6, 2) NULL,
    WeightClassKg   NVARCHAR(20)  NULL,
    
    -- Individual Lift Attempts (Kilograms)
    Squat1Kg        DECIMAL(7, 2) NULL,
    Squat2Kg        DECIMAL(7, 2) NULL,
    Squat3Kg        DECIMAL(7, 2) NULL,
    Squat4Kg        DECIMAL(7, 2) NULL,
    Bench1Kg        DECIMAL(7, 2) NULL,
    Bench2Kg        DECIMAL(7, 2) NULL,
    Bench3Kg        DECIMAL(7, 2) NULL,
    Bench4Kg        DECIMAL(7, 2) NULL,
    Deadlift1Kg     DECIMAL(7, 2) NULL,
    Deadlift2Kg     DECIMAL(7, 2) NULL,
    Deadlift3Kg     DECIMAL(7, 2) NULL,
    Deadlift4Kg     DECIMAL(7, 2) NULL,

    -- Best Lifts and Total (Kilograms)
    Best3SquatKg    DECIMAL(7, 2) NULL,
    Best3BenchKg    DECIMAL(7, 2) NULL,
    Best3DeadliftKg DECIMAL(7, 2) NULL,
    TotalKg         DECIMAL(8, 2) NULL,

    -- Scoring and Placement
    Place           NVARCHAR(10)  NOT NULL,
    Dots            FLOAT         NULL,
    Wilks           FLOAT         NULL,
    Glossbrenner    FLOAT         NULL,
    Goodlift        FLOAT         NULL,

    -- Meet Information
    Federation      NVARCHAR(50)  NOT NULL,
    Date            DATE          NOT NULL,
    MeetCountry     NVARCHAR(50)  NOT NULL,
    MeetState       NVARCHAR(50)  NULL,
    MeetTown        NVARCHAR(100) NULL,
    MeetName        NVARCHAR(255) NOT NULL,
    Tested          NVARCHAR(5)   NULL,
    Sanctioned      NVARCHAR(5)   NULL
);
GO

PRINT 'Table "MeetResults" created successfully in database "OpenPowerlifting".';
GO