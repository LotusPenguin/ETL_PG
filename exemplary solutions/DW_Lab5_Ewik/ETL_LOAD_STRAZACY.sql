USE AKCJE_DW
GO

If (object_id('vETLDimStrazakDane') is not null) Drop View vETLDimStrazakDane;
GO
CREATE VIEW vETLDimStrazakDane
AS
SELECT DISTINCT
	[ImieINazwisko] = CAST( ([Imie] + ' ' + [Nazwisko]) as varchar(100) ) ,
	CASE
		WHEN t1.Data_zakonczenia_pracy IS NULL THEN 
            		CASE
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, GETDATE()) < 2 THEN 'od 0 do 2 lat'
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, GETDATE()) < 5 THEN 'od 2 do 5 lat'
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, GETDATE()) < 10 THEN 'od 5 do 10 lat'

                		ELSE 'Powy¿ej 10 lat'
            		END
        	ELSE 
            		CASE
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, t1.Data_zakonczenia_pracy) < 2 THEN 'od 0 do 2 lat'
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, t1.Data_zakonczenia_pracy) < 5 THEN 'od 2 do 5 lat'
                		WHEN DATEDIFF(YEAR, t1.Data_rozpoczecia_pracy, t1.Data_zakonczenia_pracy) < 10 THEN 'od 5 do 10 lat'

                		ELSE 'Powy¿ej 10 lat'
            		END
    		END AS Okres_pracy,
	Case 
		WHEN t1.P³eæ = 'K' THEN 'Kobieta'
		ELSE 'Mezczyzna'
	END AS Plec,
	[Czy_dane_aktualne] = 1


FROM AKCJE_STRAZY_POZARNEJ.dbo.Strazacy as t1;
GO

MERGE INTO Strazak as TT
	USING vETLDimStrazakDane as ST
		ON TT.Imie_i_nazwisko = ST.ImieINazwisko
		AND TT.Dlugosc_stazu = ST.Okres_pracy
		AND TT.Plec = ST.Plec
		AND TT.Czy_dane_aktualne = ST.Czy_dane_aktualne
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.ImieINazwisko,
					ST.Okres_pracy,
					ST.Plec,
					ST.Czy_dane_aktualne
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View vETLDimStrazakDane;