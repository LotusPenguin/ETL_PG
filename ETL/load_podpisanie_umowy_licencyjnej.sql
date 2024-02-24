USE HDsoftware
GO

If (object_id('vETLFPodpisanieUmowyLicencyjnej') is not null) Drop view vETLFPodpisanieUmowyLicencyjnej;
GO
CREATE VIEW vETLFPodpisanieUmowyLicencyjnej
AS
SELECT 
        ID_Sprzedawcy = umowy.ID_sprzedawcy,
        Nazwa_handlowa = umowy.Nazwa_programu,
        Data_zawarcia = umowy.Data_zawarcia,
        Data_wygaśnięcia = umowy.Data_wygaśnięcia,
        Nr_umowy = umowy.Numer_umowy,
        Plan_platnosci = umowy.Plan_płatności,
        ID_Klienta = umowy.ID_klienta,
        Kwota_platnosci = umowy.Kwota_płatności_okresowych
FROM SoftwareDB.dbo.Umowy_licencyjne as umowy


GO
	MERGE INTO Podpisanie_umowy_Licencyjnej as TT
	USING vETLFPodpisanieUmowyLicencyjnej as ST
		ON TT.ID_sprzedawcy = ST.ID_Sprzedawcy
		AND TT.Numer_umowy = ST.Nr_umowy
        AND TT.ID_klienta = ST.ID_Klienta
			WHEN Not Matched
				THEN
					INSERT
					Values (
                        (SELECT ID_daty FROM Data WHERE Data = ST.Data_zawarcia),
						(SELECT ID_daty FROM Data WHERE Data = ST.Data_wygaśnięcia),
                        ST.Kwota_platnosci,
						ST.ID_Sprzedawcy,
                        ST.ID_Klienta,
                        (SELECT ID_programu FROM Programy WHERE Nazwa_handlowa = ST.Nazwa_handlowa),
						(SELECT ID_junk FROM JUNK WHERE Plan_platnosci = ST.Plan_platnosci),
                        ST.Nr_umowy
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;