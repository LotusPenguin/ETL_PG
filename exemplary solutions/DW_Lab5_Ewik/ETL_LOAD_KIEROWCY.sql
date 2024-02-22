USE AKCJE_DW
GO

If (object_id('vETLDimKierowcyDane') is not null) Drop View vETLDimKierowcyDane;
GO
CREATE VIEW vETLDimKierowcyDane
AS
SELECT DISTINCT
    [ImieINazwisko] = CAST( ([Imie] + ' ' + [Nazwisko]) as varchar(100) ) 
FROM 
AKCJE_STRAZY_POZARNEJ.dbo.Kierowcy LEFT JOIN AKCJE_STRAZY_POZARNEJ.dbo.Strazacy 
on AKCJE_STRAZY_POZARNEJ.dbo.Kierowcy.PESEL = AKCJE_STRAZY_POZARNEJ.dbo.Strazacy.PESEL
GO

MERGE INTO Kierowca as TT
    USING vETLDimKierowcyDane as ST
        ON TT.Imie_i_nazwisko  = ST.ImieINazwisko
            WHEN Not Matched
                THEN
                    INSERT
                    Values (
                    ST.ImieINazwisko
                    )
            WHEN Not Matched By Source
                Then
                    DELETE
            ;

Drop View vETLDimKierowcyDane; 
