USE HDsoftware
GO

-- Fill DimDates Lookup Table
-- Step a: Declare variables use in processing
DECLARE @StartDate DATE; 
DECLARE @EndDate DATE;

-- Step b:  Fill the variable with values for the range of years needed
SELECT @StartDate = '1980-01-01', @EndDate = '2040-12-31';

-- Step c:  Use a while loop to add dates to the table
DECLARE @DateInProcess DATETIME = @StartDate;

WHILE @DateInProcess <= @EndDate
	BEGIN
	--Add a row into the date dimension table for this date
		INSERT INTO [dbo].[Data] ( 
			[Rok], 
			[Miesiac], 
			[Dzien],
			[Data]
		) VALUES ( 
			Cast( Year(@DateInProcess) as varchar(4)), -- [Year]
			Cast( Month(@DateInProcess) as int), -- [MonthNo]
			Cast( Day(@DateInProcess) as int), -- [Day]
			@DateInProcess
		);  
		-- Add a day and loop again
		SET @DateInProcess = DateAdd(d, 1, @DateInProcess);
	END
GO


-------------------------------------------------------------
