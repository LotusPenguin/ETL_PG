USE HDsoftware
GO

If (object_id('vETLFPodpisanieUmowyDystrybucyjnej') is not null) Drop view vETLFPodpisanieUmowyDystrybucyjnej;
GO
CREATE VIEW vETLFPodpisanieUmowyDystrybucyjnej
AS
SELECT 
        ID_Sprzedawcy = umowy.ID_sprzedawcy,
        Nazwa_handlowa = dystrybucja.Nazwa_handlowa,
        Data_zawarcia = umowy.Data_zawarcia,
        Data_wygaśnięcia = umowy.Data_wygaśnięcia,
        Nr_umowy = umowy.Nr_umowy
FROM SoftwareDB.dbo.Umowy_dystrybucyjne as umowy, SoftwareDB.dbo.Dystrybucja as dystrybucja


GO
	MERGE INTO Podpisanie_umowy_dystrybucyjnej as TT
	USING vETLFPodpisanieUmowyDystrybucyjnej as ST
		ON TT.ID_sprzedawcy = ST.ID_Sprzedawcy
		AND TT.Numer_umowy = ST.Nr_umowy
			WHEN Not Matched
				THEN
					INSERT
					Values (
						ST.ID_Sprzedawcy,
						(SELECT ID_daty FROM Data WHERE Data = ST.Data_zawarcia),
						(SELECT ID_daty FROM Data WHERE Data = ST.Data_wygaśnięcia),
						(SELECT ID_programu FROM Programy WHERE Nazwa_handlowa = ST.Nazwa_handlowa),
						ST.Nr_umowy
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;