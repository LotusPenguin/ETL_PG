use DW_bookstore_test;
go

If (object_id('vETLFAuthorship') is not null) Drop view vETLFAuthorship;
go
CREATE VIEW vETLFAuthorship
AS
SELECT
	AuthorKey = dbo.DimAuthor.AuthorKey,
	BookKey = dbo.DimBook.BookKey
FROM BillMaster.dbo.Autorstwo as ST1
JOIN dbo.DimBook on dbo.DimBook.ISBN = ST1.FK_Ksiazka
JOIN BillMaster.dbo.Autor ST2 on ST2.IdAutora = ST1.FK_Autor
JOIN dbo.DimAuthor on dbo.DimAuthor.NameAndSurname = Cast(ST2.[Imie1] + ' ' + IsNull(ST2.[Imie2] + ' ', '') + ST2.[Nazwisko] as nvarchar(128))
; 
go

MERGE INTO FAuthorship as TT
	USING vETLFAuthorship as ST
		ON TT.AuthorKey = ST.AuthorKey
		AND TT.BookKey = ST.BookKey
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.AuthorKey,
					ST.BookKey
					)
			;

Drop view vETLFAuthorship;