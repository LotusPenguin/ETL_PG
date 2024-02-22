USE HDsoftware
GO

If (object_id('vETLFPodpisanieUmowyDystrybucyjnej') is not null) Drop view vETLFPodpisanieUmowyDystrybucyjnej;
GO
CREATE VIEW vETLFPodpisanieUmowyDystrybucyjnej
AS
SELECT 
    ID_Sprzedawcy,
    ID_Programu,
    Data_zawarcia,
    Data_wygaśnięcia,
    Nr_umowy
FROM
    (SELECT * FROM
	(SELECT
        ID_Sprzedawcy = sprzedawca.ID_sprzedawcy,
        ID_Programu = programy.ID_programu,
        Data_zawarcia = datyZawarcia.ID_daty,
        Data_wygaśnięcia = datyWygasniecia.ID_daty,
        Nr_umowy = umowy.Nr_umowy

        FROM SoftwareDB.dbo.Umowy_dystrybucyjne as umowy
        JOIN 


    ) as p
    group by


		FROM AKCJE_STRAZY_POZARNEJ.dbo.Trasy as trasy
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Akcje as akcje on trasy.Numer_wezwania = akcje.Numer_wezwania
		JOIN dbo.Data_ as datyWezwania on CAST(akcje.Data_i_godzina_wezwania as date) = (DATEFROMPARTS(CAST(datyWezwania.rok AS INT), datyWezwania.numer_miesiaca, datyWezwania.dzien))
		JOIN dbo.Data_ as datyZakonczenia on CAST(trasy.Data_i_godizna_zakonczania as date) = (DATEFROMPARTS(CAST(datyZakonczenia.rok AS INT), datyZakonczenia.numer_miesiaca, datyZakonczenia.dzien))
		JOIN dbo.Czas as czasWezwania on DATEPART(HOUR,CAST(akcje.Data_i_godzina_wezwania as time)) = czasWezwania.Godzina
		JOIN dbo.Czas as czasZakonczenia on DATEPART(HOUR,CAST(trasy.Data_i_godizna_zakonczania as time)) = czasZakonczenia.Godzina
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_trasy as przynaleznosci on przynaleznosci.ID = trasy.ID
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Drogi as drogi on drogi.Miejscowosc = przynaleznosci.Miejscowosc and drogi.Nazwa = przynaleznosci.Nazwa
		JOIN Droga as droga on droga.Miejscowosc =drogi.Miejscowosc and droga.Nazwa = drogi.Nazwa
		JOIN Uzyte_drogi as uzycieDrogi on uzycieDrogi.ID_drogi = droga.ID_drogi
		Join Trasa as trasa on trasa.ID_trasy = uzycieDrogi.ID_trasy
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Zespoly as zespoly on zespoly.ID_zespolu = trasy.ID_zespolu
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu as przynaleznosciDoZesp on przynaleznosciDoZesp.ID_zespolu = zespoly.ID_zespolu
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Strazacy as strazacy on strazacy.PESEL = przynaleznosciDoZesp.PESEL
		JOIN Strazak as strazak On strazak.Imie_i_nazwisko = CAST(strazacy.Imie + ' ' + strazacy.Nazwisko as varchar(100))
		JOIN Czlonkostwo_w_zespole as czlonkostwo on czlonkostwo.ID_strazaka = strazak.ID_strazaka
		JOIN Kierowca as kierowca on kierowca.Imie_i_nazwisko = strazak.Imie_i_nazwisko
		JOIN AKCJE_STRAZY_POZARNEJ.dbo.Remizy as remizy on remizy.Numer = zespoly.Numer
		JOIN PojazdyTemp as pojazdy on pojazdy.Numer_rejestracyjny = trasy.nr_rejestracyjny_samochodu
		JOIN Pojazd as pojazd on pojazd.Ilosc_drzwi = pojazdy.Ilosc_drzwi and pojazd.Marka = pojazdy.Marka and pojazd.Masa_wlasna = pojazdy.Masa_wlasna
		JOIN Remiza as remiza on remiza.Miejscowosc = remizy.Miejscowosc and remiza.Numer = remizy.Numer
		JOIN Zespol as zespol on zespol.ID_zespolu = czlonkostwo.ID_zespolu
		--group by datyWezwania.ID_daty, datyZakonczenia.ID_daty, trasy.ID

	GO


	MERGE INTO Dojazd_na_akcje as TT
	USING vETLFDojazdNaAkcje as ST
		ON TT.ID_daty_rozpoczecia = ST.ID_daty_rozpoczecia
		AND TT.ID_daty_zakonczenia = ST.ID_daty_zakonczenia
		AND TT.ID_czasu_rozpoczecia = ST.ID_czasu_rozpoczecia
		AND TT.ID_czasu_zakonczenia = ST.ID_czasu_zakonczenia
		AND TT.ID_pojazdu = ST.ID_pojazdu
		AND TT.ID_zespolu = ST.ID_zespolu
		AND TT.ID_kierowcy = ST.ID_kierowcy
		AND TT.ID_trasy = ST.ID_trasy
		AND TT.ID_remizy = ST.ID_remizy
		AND TT.Czas_zebrania_sie_zespolu = ST.Czas_zebrania_sie_zespolu
		AND TT.Czas_dojazdu = ST.Czas_dojazdu
		AND TT.Dlugosc_pokonanej_trasy = ST.Dlugosc_pokonanej_trasy
		AND TT.Ilosc_kobiet = ST.Ilosc_kobiet
		AND TT.Ilosc_mezczyzn = ST.Ilosc_mezczyzn
		AND TT.Liczebnosc_zespolu = ST.Liczebnosc_zespolu
		AND TT.Srednia_dlugosc_stazu_zespolu = ST.Srednia_dlugosc_stazu_zespolu
		AND TT.Srednia_predkosc = ST.Srednia_predkosc
		AND TT.Czy_nowy_zespol = ST.Czy_nowy_zespol
			WHEN Not Matched
				THEN
					INSERT
					Values (
						ST.ID_daty_rozpoczecia,
						ST.ID_daty_zakonczenia,
						ST.ID_czasu_rozpoczecia,
						ST.ID_czasu_zakonczenia,
						ST.ID_pojazdu,
						ST.ID_zespolu,
						ST.ID_kierowcy,
						ST.ID_trasy,
						ST.ID_remizy,
						ST.Czas_zebrania_sie_zespolu,
						ST.Czas_dojazdu,
						ST.Dlugosc_pokonanej_trasy,
						ST.Ilosc_kobiet,
						ST.Ilosc_mezczyzn,
						ST.Liczebnosc_zespolu,
						ST.Srednia_dlugosc_stazu_zespolu,
						ST.Srednia_predkosc,
						ST.Czy_nowy_zespol
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;