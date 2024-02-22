USE AKCJE_DW
GO

If (object_id('dbo.PojazdyTemp') is not null) DROP TABLE dbo.PojazdyTemp;
CREATE TABLE dbo.PojazdyTemp(
Numer_rejestracyjny varchar(7),
 Marka varchar(20),
 n2 float,
 n3 int,
 Rok_produkcji int,
 Masa_wlasna varchar(20),
 n5 int,
n6 int,
 n7 int,
 n8 varchar(20),
 Ilosc_drzwi int
);
GO

BULK INSERT dbo.PojazdyTemp
    FROM 'D:\Studia\5\Hurtownie danych\data_generator\bulks\Pojazdy.csv' ------------????????????????-------------
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )
	GO

If (object_id('vETLDimPojazdyDane') is not null) DROP View vETLDimPojazdyDane;
go
CREATE VIEW vETLDimPojazdyDane
AS
SELECT
	t1.Masa_wlasna,
	t1.Ilosc_drzwi,
	CASE
		WHEN t1.Rok_produkcji >= 1990 AND t1.Rok_produkcji < 2000 THEN 'od 1990 do 2000'
		WHEN t1.Rok_produkcji >= 2000 AND t1.Rok_produkcji < 2010 THEN 'od 2000 do 2010'
		WHEN t1.Rok_produkcji >= 2010 AND t1.Rok_produkcji < 2020 THEN 'od 2010 do 2020'
		WHEN t1.Rok_produkcji >= 2020 AND t1.Rok_produkcji < 2030 THEN 'od 2020 do 2030'
	END AS [Rok_produkcji],
	t1.Marka
FROM dbo.PojazdyTemp as t1
GO

MERGE INTO Pojazd as TT
	USING vETLDimPojazdyDane as ST
		ON TT.Masa_wlasna = ST.Masa_wlasna
		and TT.Ilosc_drzwi = ST.Ilosc_drzwi
		and TT.Marka = ST.Marka
			WHEN Not Matched
				THEN
					INSERT Values (
					ST.Masa_wlasna,
					ST.Ilosc_drzwi,
					ST.Rok_produkcji,
					ST.Marka

					)
			WHEN Not Matched By Source
                Then
                    DELETE
            ;

--DROP TABLE dbo.PojazdyTemp;
Drop View vETLDimPojazdyDane