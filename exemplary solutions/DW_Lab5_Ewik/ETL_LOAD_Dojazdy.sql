USE AKCJE_DW
GO

If (object_id('vETLFDojazdNaAkcje') is not null) Drop view vETLFDojazdNaAkcje;
GO
CREATE VIEW vETLFDojazdNaAkcje
AS
SELECT 
    ID_daty_rozpoczecia,
    ID_daty_zakonczenia,
    ID_czasu_rozpoczecia,
    ID_czasu_zakonczenia,
    ID_pojazdu,
    ID_zespolu,
    ID_kierowcy,
    ID_trasy,
    ID_remizy,
    Czas_zebrania_sie_zespolu,
    Czas_dojazdu,
    Dlugosc_pokonanej_trasy,
    Ilosc_kobiet,
    Ilosc_mezczyzn,
    Liczebnosc_zespolu,
    Srednia_dlugosc_stazu_zespolu,
    Srednia_predkosc,
    Czy_nowy_zespol
FROM
    (SELECT * FROM
	(SELECT
        ID_daty_rozpoczecia = datyWezwania.ID_daty,
        ID_daty_zakonczenia = datyZakonczenia.ID_daty,
        ID_czasu_rozpoczecia = czasWezwania.ID_czasu,
        ID_czasu_zakonczenia = czasZakonczenia.ID_czasu,
		ID_pojazdu = pojazd.ID_pojazdu,
		ID_zespolu = zespol.ID_zespolu,
		ID_kierowcy = ID_kierowcy,
		ID_trasy = trasy.ID,
		ID_remizy = remiza.ID_remizy,
		Czas_zebrania_sie_zespolu = -DATEDIFF(SECOND, trasy.Data_i_godzina_rozpoczecia, akcje.Data_i_godzina_wezwania),
		Czas_dojazdu = -DATEDIFF(SECOND, trasy.Data_i_godizna_zakonczania, trasy.Data_i_godzina_rozpoczecia),
		Dlugosc_pokonanej_trasy = trasy.Dlugosc,
		Ilosc_kobiet = (
			SELECT COUNT(*) FROM AKCJE_STRAZY_POZARNEJ.dbo.Strazacy JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu on
			AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.PESEL = AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.PESEL
			WHERE AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.P³eæ = 'K'
			GROUP BY AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu
			HAVING AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu = zespol.ID_zespolu
		),
		Ilosc_mezczyzn = (
			SELECT COUNT(*) FROM AKCJE_STRAZY_POZARNEJ.dbo.Strazacy JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu on
			AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.PESEL = AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.PESEL
			WHERE AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.P³eæ = 'M'
			GROUP BY AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu
			HAVING AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu = zespol.ID_zespolu
		),
		Liczebnosc_zespolu = (
			SELECT COUNT(*) FROM AKCJE_STRAZY_POZARNEJ.dbo.Strazacy JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu on
			AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.PESEL = AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.PESEL
			GROUP BY AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu
			HAVING AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu = zespol.ID_zespolu
		),
		 Srednia_dlugosc_stazu_zespolu = (
			SELECT AVG(newStrazacy.Dlugosc_stazu) FROM (
				Select *, CASE
							WHEN AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.Data_zakonczenia_pracy IS NULL THEN -DATEDIFF(year, CAST(GETDATE() as date), AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.Data_rozpoczecia_pracy)
							ELSE -DATEDIFF(year, AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.Data_zakonczenia_pracy, AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.Data_rozpoczecia_pracy)
							END as Dlugosc_stazu
				FROM AKCJE_STRAZY_POZARNEJ.dbo.Strazacy
			) as newStrazacy 
			
			JOIN AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu on
			newStrazacy.PESEL = AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.PESEL
			GROUP BY AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu
			HAVING AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu.ID_zespolu = zespol.ID_zespolu
		 ),
		 Srednia_predkosc = trasy.Dlugosc*3600/(-DATEDIFF(second, trasy.Data_i_godizna_zakonczania, trasy.Data_i_godzina_rozpoczecia)),
		 Czy_nowy_zespol = 1


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
    ) as p
	group by 
	p.ID_daty_rozpoczecia,
    p.ID_daty_zakonczenia,
    p.ID_czasu_rozpoczecia,
    p.ID_czasu_zakonczenia,
    p.ID_pojazdu,
    p.ID_zespolu,
    p.ID_kierowcy,
    p.ID_trasy,
    p.ID_remizy,
    p.Czas_zebrania_sie_zespolu,
    p.Czas_dojazdu,
    p.Dlugosc_pokonanej_trasy,
    p.Ilosc_kobiet,
    p.Ilosc_mezczyzn,
    p.Liczebnosc_zespolu,
    p.Srednia_dlugosc_stazu_zespolu,
    p.Srednia_predkosc,
    p.Czy_nowy_zespol
	)as x
	--JOIN Zespol as y on y.ID_zespolu = x.ID_zespolu;
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