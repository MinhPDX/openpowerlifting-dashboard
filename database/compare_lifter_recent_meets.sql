/*
================================================================================
 Compare Most Recent Lifter Performance by DOTS Score (SBD Prioritized)
================================================================================
 This query identifies the most recent valid meet for a specific list of lifters
 and displays their performance details, ordered by the highest DOTS score.
 It specifically prioritizes the 'SBD' (Squat-Bench-Deadlift) event, filters for
 lifters in the '60' kg weight class, and will ignore any meets where the lifter
 bombed out or had an incomplete total.

-- How it works:
1. A Common Table Expression (CTE) named 'RankedLifts' is created.
2. The ROW_NUMBER() function ranks the remaining valid meets for each lifter,
   prioritizing by date and then by the 'SBD' event.
3. The final SELECT statement retrieves the records from the CTE where the rank is 1.
4. Formatting functions (CAST, ISNULL) are applied for a clean display.
5. The results are ordered by the 'Dots' column in descending order by the 'Dots'
   column in descending order to show the top performer first.
*/

      WITH RankedLifts AS
      (
    SELECT
           opl.Name
          ,opl.Sex
          ,opl.Age
          ,opl.Division
          ,opl.Event
          ,opl.Equipment
          ,opl.WeightClassKg
          ,opl.BodyweightKg
          ,opl.Best3SquatKg
          ,opl.Best3BenchKg
          ,opl.Best3DeadliftKg
          ,opl.TotalKg
          ,opl.Dots
          ,opl.Date
          ,opl.Federation [Fed]
          ,opl.MeetCountry [Country]
          ,opl.MeetState [State]
          ,opl.MeetTown [City]
          ,opl.MeetName
          ,opl.Tested
          ,ROW_NUMBER() OVER(PARTITION BY Name ORDER BY Date DESC, CASE WHEN Event = 'SBD' THEN 0 ELSE 1 END) [rn]
      FROM OpenPowerlifting.dbo.MeetResults opl
     WHERE Name IN (

                    'Davien Anthony'
                   ,'Michael Carmona'
                   ,'Joseph DeMeo'
                   ,'Noe Lora'
                   ,'Eric Lowe'
                   ,'Daniel Sandoval'
                   ,'Tony Huynh'
                   ,'Tuan Dinh'
                   )
       AND TotalKg IS NOT NULL
       AND Best3SquatKg IS NOT NULL
       AND Best3BenchKg IS NOT NULL
       AND Best3DeadliftKg IS NOT NULL
       AND WeightClassKg = '60'
      )
    SELECT 
           Name
          ,Sex
          ,CAST(Age AS FLOAT) [Age]
          ,Division
          ,Event
          ,Equipment
          ,WeightClassKg [WeightClass]
          ,CAST(BodyweightKg AS FLOAT) [BodyWeight]
          ,CAST(Best3SquatKg AS FLOAT) [BestSquat]
          ,CAST(Best3BenchKg AS FLOAT) [BestBench]
          ,CAST(Best3DeadliftKg AS FLOAT) [BestDeadlift]
          ,CAST(TotalKg AS FLOAT) [Total]
          ,CAST(Dots AS FLOAT) [DOTS]
          ,Date [MostRecentMeetDate]
          ,Fed
          ,Country
          ,State
          ,ISNULL(City, 'N/A') [City]
          ,MeetName
          ,ISNULL(Tested, 'No') [Tested]
      FROM RankedLifts
     WHERE rn = 1
  ORDER BY Dots DESC
