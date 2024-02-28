USE HDsoftware
GO

If (object_id('vETLFPodpisanieUmowyLicencyjnej') is not null) Drop view vETLFPodpisanieUmowyLicencyjnej;
GO
CREATE VIEW vETLFPodpisanieUmowyLicencyjnej
AS
SELECT DISTINCT
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
		ON TT.Numer_umowy = ST.Nr_umowy
			WHEN Not Matched BY TARGET
				THEN
					INSERT
					Values (
                        (SELECT ID_daty FROM Data WHERE Data = ST.Data_zawarcia),
						(SELECT ID_daty FROM Data WHERE Data = ST.Data_wygaśnięcia),
                        ST.Kwota_platnosci,
						(SELECT ID_sprzedawcy FROM Sprzedawcy WHERE Nazwa = (SELECT Nazwa FROM SoftwareDB.dbo.Sprzedawcy WHERE ID = ST.ID_Sprzedawcy)),
                        (SELECT ID_klienta FROM Klienci WHERE Nazwa = (SELECT Nazwa FROM SoftwareDB.dbo.Klienci WHERE ID = ST.ID_Klienta)),
                        (SELECT ID_programu FROM Programy WHERE Nazwa_handlowa = ST.Nazwa_handlowa AND Czy_aktywny = 1),
						(SELECT ID_junk FROM JUNK WHERE Plan_platnosci = ST.Plan_platnosci),
                        ST.Nr_umowy
					);