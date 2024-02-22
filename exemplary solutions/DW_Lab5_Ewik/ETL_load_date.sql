use AKCJE_DW

-- Fill DimDates Lookup Table
-- Step a: Declare variables use in processing
Declare @StartDate date; 
Declare @EndDate date;

-- Step b:  Fill the variable with values for the range of years needed
SELECT @StartDate = '2010-01-01', @EndDate = '2015-12-31';

-- Step c:  Use a while loop to add dates to the table
Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= '2015-12-31'
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [dbo].[Data_] 
		( [rok]
		, [miesiac]
		, [numer_miesiaca]
		, [dzien]
		, [dzien_tygodnia]
		, [numer_dnia_tygodnia]
		, [wakacje]
		, [swieto]
		, [dzien_roboczy]
		)
		Values ( 
		   Cast( Year(@DateInProcess) as varchar(4)) -- [rok]
		  , Cast( DATENAME(month, @DateInProcess) as varchar(15)) --[miesiac]
		  , Cast( Month(@DateInProcess) as int) --[numer miesiaca]
		  , CAST( Day(@DateInProcess) as int) --[dzien]
		  , Cast( DATENAME(dw,@DateInProcess) as varchar(15)) -- [dzien_tygodnia]
		  , Cast( DATEPART(dw, @DateInProcess) as int) -- [numer_dnia_tygodnia]
		  , 'brak' -- will be put in te next steps
		  , 'brak'  -- will be put in te next steps
		  , CASE
				WHEN DATEPART(dw, @DateInProcess) = 1 THEN 0
				ELSE 1
			END
		);  
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
GO


-- insert into holidays and vacations
-------------------------------------------------------------

-- auxiliary tables should be created first!


If (object_id('vETLDimDatesData') is not null) Drop View vETLDimDatesData;
GO

CREATE VIEW vETLDimDatesData
AS
SELECT 
	dd.rok
	, dd.miesiac
	, dd.numer_miesiaca
	, dd.dzien
	, dd.dzien_tygodnia
	, dd.numer_dnia_tygodnia
	, CASE
		WHEN w.rodzaj is not null THEN w.rodzaj
		ELSE 'brak'
		END AS [wakacje]
	, CASE	
		WHEN ah1.swieto is not null THEN ah1.swieto
		ELSE 'brak'
	  END AS [swieto]
	, CASE
		WHEN ah1.wolne = 1 THEN 0
		WHEN dd.dzien_roboczy = 0 then 0
		ELSE 1
		END AS [dzien_roboczy]

FROM auxiliary.dbo.swieta ah1
right JOIN Data_ as dd ON (dd.rok = ah1.rok and dd.numer_miesiaca = ah1.miesiac and dd.dzien = ah1.dzien)
left JOIN auxiliary.dbo.wakacje as w ON (DATEFROMPARTS(CAST(dd.rok AS INT), dd.numer_miesiaca, dd.dzien) BETWEEN w.start AND w.koniec);
GO

-- Merge view with updated information about holidays and befor e holiday days with already existing DimDate rows

MERGE INTO Data_ as TT
	USING vETLDimDatesData as ST
		ON TT.rok = ST.rok and TT.numer_miesiaca = ST.numer_miesiaca and TT.dzien = ST.dzien
			WHEN Matched -- when dates match...
			THEN -- update WorkingDay, Holiday and BeforeHolidayDay columns
				UPDATE
				SET TT.dzien_roboczy = ST.dzien_roboczy,
					TT.wakacje = ST.wakacje,
					TT.swieto = ST.swieto
			;

-- SELECT * from DimDate;

--Drop View vETLDimDatesData;