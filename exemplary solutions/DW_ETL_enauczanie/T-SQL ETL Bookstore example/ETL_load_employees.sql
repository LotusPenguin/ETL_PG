USE DW_bookstore_test
GO

If (object_id('dbo.BookstoresTemp') is not null) DROP TABLE dbo.BookstoresTemp;
CREATE TABLE dbo.BookstoresTemp(bookstoreID varchar(100), bookstoreName varchar(100), BookstoreAddress varchar(100), zipcode varchar(6), city varchar(100));
go

BULK INSERT dbo.BookstoresTemp
    FROM 'C:\Users\alenaboz\Documents\ETL Bookstore\T-SQL ETL Bookstore example\CEO_sheet1.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )

--SELECT * FROM dbo.BookstoresTemp;


If (object_id('dbo.EmployeesTemp') is not null) DROP TABLE dbo.EmployeesTemp;
CREATE TABLE dbo.EmployeesTemp(bookstoreID varchar(255), PESEL varchar(255), empName varchar(255), 
								empSurname varchar(255), birthDate date, education varchar(255), position varchar(255),
								startWorkDate date, endWorkDate date);
go

BULK INSERT dbo.EmployeesTemp
    FROM 'C:\Users\alenaboz\Documents\ETL Bookstore\T-SQL ETL Bookstore example\CEO_sheet2.csv'
    WITH
    (
    FIRSTROW = 2,
	DATAFILETYPE = 'char',
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )

If (object_id('vETLDimSellersData') is not null) Drop View vETLDimSellersData;
go
CREATE VIEW vETLDimSellersData
AS
SELECT 
	t3.[bookstoreKey],
	t1.[PESEL] as [PID],
	[NameAndSurname] = Cast([empName] + ' ' + [empSurname] as nvarchar(128)),
	CASE
		WHEN DATEDIFF(year, [birthDate], CURRENT_TIMESTAMP) BETWEEN 15 AND 17 THEN '15-17'
		WHEN DATEDIFF(year, [birthDate], CURRENT_TIMESTAMP) BETWEEN 18 AND 21 THEN '18-21'
		WHEN DATEDIFF(year, [birthDate], CURRENT_TIMESTAMP) BETWEEN 22 AND 29 THEN '22-29'
		WHEN DATEDIFF(year, [birthDate], CURRENT_TIMESTAMP) BETWEEN 30 AND 49 THEN '30-49'
		WHEN DATEDIFF(year, [birthDate], CURRENT_TIMESTAMP) BETWEEN 50 AND 64 THEN '50-64'
	END AS [AgeRange],
	CASE
		WHEN DATEDIFF(year, [startWorkDate], isNull([endWorkDate], CURRENT_TIMESTAMP)) <=1 THEN 'up to 1 year'
		WHEN DATEDIFF(year, [startWorkDate], isNull([endWorkDate], CURRENT_TIMESTAMP)) BETWEEN 1 AND 5 THEN '1-5 years'
		ELSE 'more than 5 years'
	END AS [WorkExperience],
	t1.[Education],
	CASE
		WHEN t1.[position] = 'dyrektor' THEN NULL
		ELSE -1
	END AS [BossKey],
	t1.[Position],
	CASE
		WHEN t1.[position] = 'dyrektor' THEN 1
		ELSE 0
	END AS [isBoss]
FROM dbo.EmployeesTemp as t1
JOIN dbo.BookstoresTemp as t2 ON t1.bookstoreID = t2.bookstoreID
JOIN dbo.DimBookstore as t3 ON t2.bookstoreID = t3.bookstoreID
;
go

-----------------------------------------
-- for testing purposes only!!
Declare @EntryDate datetime; 
SELECT @EntryDate = '1980-01-01 00:00:01';
--SELECT @EntryDate = '2016-06-30 00:00:00';
-----------------------------------------

MERGE INTO DimSeller as TT
	USING vETLDimSellersData as ST
		ON TT.PID = ST.PID
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.PID,
					ST.NameAndSurname,
					ST.AgeRange,
					ST.Education,
					@EntryDate,
					NULL,
					1,
					ST.Position,
					ST.WorkExperience,
					CASE
						WHEN ST.[position] = 'dyrektor' THEN null
						ELSE -1
					END,               -- BossKey is UKNOWN for now; for actual Bosses it is NULL
					ST.BookstoreKey,
					ST.isBoss
					)
			WHEN Matched -- when PID number match, 
			-- but AgeRange doesn't...
				AND (ST.AgeRange <> TT.AgeRange
			-- or the Education level...
				OR ST.Education <> TT.Education
			-- or the Position
				OR ST.position <> TT.Position
			-- or the WorkExperience 
				OR ST.WorkExperience <> TT.WorkExperience
			-- or the BookstoreKey
				OR ST.BookstoreKey <> TT.BookstoreKey)
			THEN
				UPDATE
				SET TT.IsCurrent = 0,
				TT.ExpiryDate = @EntryDate
			WHEN Not Matched BY Source
			AND TT.PID != 'UNKNOWN' -- do not update the UNKNOWN tuple
			THEN
				UPDATE
				SET TT.IsCurrent = 0,
					TT.ExpiryDate = @EntryDate
			;

-- SELect * from DimSeller;

-- INSERTING CHANGED ROWS TO THE DIMSELLER TABLE
INSERT INTO DimSeller(
	PID, 
	NameAndSurname, 
	AgeRange, 
	Education, 
	EntryDate, 
	ExpiryDate, 
	IsCurrent, 
	Position,
	WorkExperience, 
	BossKey,
	BookstoreKey,
	isBoss
	)
	SELECT 
		PID, 
		NameAndSurname, 
		AgeRange, 
		Education, 
		@EntryDate, 
		NULL, 
		1, 
		Position, 
		WorkExperience, 
		-1,
		BookstoreKey, 
		isBoss 
	FROM vETLDimSellersData
	EXCEPT
	SELECT 
		PID, 
		NameAndSurname, 
		AgeRange, 
		Education, 
		@EntryDate, 
		NULL, 
		1, 
		Position, 
		WorkExperience, 
		-1,
		BookstoreKey, 
		isBoss 
	FROM DimSeller;

--------------------------------------------------------
-- Filling Bosses

If (object_id('vBookstoreBoss') is not null) Drop View vBookstoreBoss;
go
CREATE VIEW vBookstoreBoss
AS
SELECT 
	t3.bookstoreKey, 
	t2.SellerKey as 'BossKey'
from dbo.EmployeesTemp as t1
JOIN DimSeller as t2 ON t1.PESEL = t2.PID
JOIN DimBookstore as t3 ON t1.bookstoreID = t3.bookstoreID
WHERE t1.position = 'dyrektor' AND t1.endWorkDate is null AND t2.IsCurrent = 1;
go

-- SELECT * FROM vBookstoreBoss;

-- fill the BossKey column with the proper DW Key

IF (object_id('vDimSellerWithBosses') is not null) Drop View vDimSellerWithBosses;
go
CREATE VIEW vDimSellerWithBosses
AS
SELECT
	t1.SellerKey,
	t1.PID, 
	t1.NameAndSurname, 
	t1.AgeRange, 
	t1.Education, 
	t1.EntryDate, 
	t1.ExpiryDate, 
	t1.IsCurrent, 
	t1.Position, 
	t1.WorkExperience, 
	CASE
		WHEN t1.BossKey is not null THEN t2.BossKey
		ELSE NULL
	END AS [BossKey],
	t1.BookstoreKey,
	t1.isBoss
FROM DimSeller as t1
JOIN vBookstoreBoss as t2 ON t1.bookstoreKey = t2.bookstoreKey
;
go

-- select * from vDimSellerWithBosses;

-- Merge Command once again to see if the boss has changed

MERGE INTO DimSeller as TT
	USING vDimSellerWithBosses as ST
		ON TT.SellerKey = ST.SellerKey
			WHEN Matched -- when SellerKey number match, 
			THEN
				UPDATE
				SET TT.BossKey = ST.BossKey
			;

-- select * from DimSeller;

DROP TABLE dbo.BookstoresTemp;
DROP TABLE dbo.EmployeesTemp;
Drop View vETLDimSellersData; 
Drop View vBookstoreBoss;
Drop View vDimSellerWithBosses;

-- select * from DimSeller WHERE PID = '68122894473'; -- zmieni wykszta³cenie
-- select * from DimSeller WHERE PID = '82062050539'; -- przestanie byæ dyrektorem
-- select * from DimSeller WHERE PID = '82072905373'; -- zostanie dyrektorem