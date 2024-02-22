----- SCD2

USE HDsoftware
GO

If (object_id('vETLDimProgramy') is not null) Drop View vETLDimProgramy;
GO
CREATE VIEW vETLDimProgramy
AS
SELECT DISTINCT
	[Aktualna_wersja] = [Aktualna_wersja],
	[Platforma] = [Platforma],
	[Rodzaj] = [Rodzaj],
	[Nazwa_handlowa] = [Nazwa_handlowa],
	[Data_zakonczenia_wsparcia] = [Data_zakonczenia_wsparcia],
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
    VALUES (ST.Aktualna_wersja, ST.Platforma, ST.Rodzaj, ST.Nazwa_handlowa, ST.Data_zakonczenia_wsparcia, ST.Data_wydania, 'TAK')
WHEN NOT MATCHED BY SOURCE THEN
	INSERT (Czy_aktywny)
	VALUES ('NIE');

Drop View vETLDimProgramy;