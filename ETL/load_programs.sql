----- SCD2

USE HDsoftware
GO

IF (object_id('vETLDimProgramy') is not null) DROP VIEW vETLDimProgramy;

GO
CREATE VIEW vETLDimProgramy
AS
SELECT DISTINCT
	[Aktualna_wersja] = [Aktualna_wersja],
	[Platforma] = [Platforma],
	[Rodzaj] = [Rodzaj],
	[Nazwa_handlowa] = [Nazwa_handlowa],
	[Data_zakonczenia_wsparcia] = [Data_zakończenia_wsparcia],
	[Data_wydania] = [Data_wydania]
FROM SoftwareDB.dbo.Programy;
GO

MERGE INTO Programy AS TT
USING vETLDimProgramy AS ST
ON TT.Platforma = ST.Platforma
AND TT.Rodzaj = ST.Rodzaj
AND TT.Nazwa_handlowa = ST.Nazwa_handlowa
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Aktualna_wersja, Platforma, Rodzaj, Nazwa_handlowa, Data_zakonczenia_wsparcia, Data_wydania, Czy_aktywny)
    VALUES (ST.Aktualna_wersja, ST.Platforma, ST.Rodzaj, ST.Nazwa_handlowa, (SELECT ID_Daty FROM Data WHERE Data = ST.Data_zakonczenia_wsparcia), (SELECT ID_Daty FROM Data WHERE Data = ST.Data_wydania), 1)
WHEN NOT MATCHED BY SOURCE THEN
	UPDATE SET Czy_aktywny = 0;

DROP VIEW vETLDimProgramy;