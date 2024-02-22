USE DW_bookstore_test
GO

If (object_id('dbo.LocationsTemp') is not null) DROP TABLE dbo.LocationsTemp;
CREATE TABLE dbo.LocationsTemp(zipcode varchar(6), street varchar(100), city varchar(100), voivodeship varchar(100), number varchar(100));
go

BULK INSERT dbo.LocationsTemp
    FROM 'C:\Users\alenaboz\Documents\ETL Bookstore\T-SQL ETL Bookstore example\locations.csv'
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )

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

If (object_id('vETLDimBookstoresData') is not null) Drop View vETLDimBookstoresData;
go


CREATE VIEW vETLDimBookstoresData
AS
SELECT
	t1.bookstoreID,
	t1.bookstoreName,
	t3.voivodeship,
	t1.city,
	CASE
		WHEN count(t2.PESEL) <= 10 THEN 'mala'
		WHEN count(t2.PESEL) BETWEEN 11 AND 30 THEN 'srednia'
		ELSE 'duza'
	END AS [size]
FROM dbo.BookstoresTemp as t1
JOIN dbo.EmployeesTemp as t2 on t1.bookstoreID = t2.bookstoreID
JOIN dbo.LocationsTemp as t3 on t1.zipcode = t3.zipcode
GROUP BY
	t1.bookstoreID,
	t1.bookstoreName,
	t3.voivodeship,
	t1.city;
go

MERGE INTO DimBookstore as TT
	USING vETLDimBookstoresData as ST
		ON TT.BookstoreID = ST.bookstoreID
		and TT.bookstoreName = ST.bookstoreName
		and TT.voivodeship = ST.voivodeship
		and TT.city = ST.city
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.bookstoreID,
					ST.bookstoreName,
					ST.voivodeship,
					ST.city,
					ST.size
					)
			WHEN Matched -- when name, voivodeship and city match, but the size doesn't match
				AND (ST.size <> TT.size)
			THEN
				UPDATE
				SET TT.size = ST.size
			;

DROP TABLE dbo.LocationsTemp;
DROP TABLE dbo.BookstoresTemp;
DROP TABLE dbo.EmployeesTemp;
Drop View vETLDimBookstoresData