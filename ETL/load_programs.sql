----- SCD2

USE HDsoftware;
GO

IF (OBJECT_ID('vETLDimProgramy') IS NOT NULL) DROP VIEW vETLDimProgramy;
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

-- Aktualizacja rekordów, które mają takie same wartości Platforma, Rodzaj i Nazwa handlowa, ale różne wartości Aktualna_wersja
UPDATE HDsoftware.dbo.Programy
SET Czy_aktywny = 0
WHERE EXISTS (
    SELECT 1
    FROM vETLDimProgramy v
    WHERE v.Platforma = HDsoftware.dbo.Programy.Platforma
        AND v.Rodzaj = HDsoftware.dbo.Programy.Rodzaj
        AND v.Nazwa_handlowa = HDsoftware.dbo.Programy.Nazwa_handlowa
        AND v.Aktualna_wersja <> HDsoftware.dbo.Programy.Aktualna_wersja
);

-- Wstawienie nowych rekordów, które są w widoku vETLDimProgramy, ale nie ma ich w HDsoftware
INSERT INTO HDsoftware.dbo.Programy (Platforma, Rodzaj, Nazwa_handlowa, Aktualna_wersja, Czy_aktywny, Data_wydania, Data_zakonczenia_wsparcia)
SELECT v.Platforma, v.Rodzaj, v.Nazwa_handlowa, v.Aktualna_wersja, 1, (SELECT Id_daty FROM Data WHERE Data = v.Data_wydania), (SELECT Id_daty FROM Data WHERE Data = v.Data_zakonczenia_wsparcia)
FROM vETLDimProgramy v
WHERE NOT EXISTS (
    SELECT 1
    FROM HDsoftware.dbo.Programy p
    WHERE p.Platforma = v.Platforma
        AND p.Rodzaj = v.Rodzaj
        AND p.Nazwa_handlowa = v.Nazwa_handlowa
		AND p.Aktualna_wersja = v.Aktualna_wersja
);


DROP VIEW vETLDimProgramy;