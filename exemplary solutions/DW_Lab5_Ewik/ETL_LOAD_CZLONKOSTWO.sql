use AKCJE_DW;
GO

If (object_id('vETLFPrzyDoZesp') is not null) Drop view vETLFPrzyDoZesp;
GO
CREATE VIEW vETLFPrzyDoZesp
AS
SELECT
	ID_zespolu = ST2.ID_zespolu,
	ID_strazaka = ST4.ID_strazaka
FROM AKCJE_STRAZY_POZARNEJ.dbo.Przynaleznosc_do_zespolu as ST1
JOIN AKCJE_STRAZY_POZARNEJ.dbo.Strazacy as ST3 on ST1.PESEL = ST3.PESEL
JOIN Strazak as ST4 on Cast(ST3.Imie + ' '+ ST3.Nazwisko as varchar(100)) = ST4.Imie_i_nazwisko
JOIN AKCJE_STRAZY_POZARNEJ.dbo.Zespoly ST2 on ST2.ID_zespolu = ST1.ID_zespolu
; 
GO

MERGE INTO Czlonkostwo_w_zespole as TT
	USING vETLFPrzyDoZesp as ST
		ON TT.ID_zespolu = ST.ID_zespolu
		AND TT.ID_strazaka = ST.ID_strazaka
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.ID_zespolu,
					ST.ID_strazaka
					)
			;


--Drop view vETLFPrzyDoZesp;