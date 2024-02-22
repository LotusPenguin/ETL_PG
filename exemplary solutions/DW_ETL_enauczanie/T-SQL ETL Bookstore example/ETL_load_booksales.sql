use DW_bookstore_test;
go

If (object_id('vETLFBookSales') is not null) Drop view vETLFBookSales;
go
CREATE VIEW vETLFBookSales
AS
SELECT 
	Amount
	, PurchasePrice
	, Profit
	, BookKey
	, SellDateKey
	, PayDateKey
	, SellerKey
	, JunkKey
	, TimeKey
	, TransactionNo
FROM
	(SELECT 
		  Amount = ST1.LiczbaEgzemplarzy
		, PurchasePrice = ST1.Cena * ST1.LiczbaEgzemplarzy
		, Profit = ST1.Cena * ST1.LiczbaEgzemplarzy * 1.07
		, SellDateKey = SD.DateKey
		, PayDateKey = PD.DateKey
		, JunkKey = junk.JunkKey
		, SellerKey = IsNull(seller.SellerKey, -1)
		, TimeKey = dbo.DimTime.TimeKey
		, TransactionNo = ST2.NrRachunku
		, CASE
			WHEN [Cena] < 20 THEN 'tania'
			WHEN [Cena] BETWEEN 21 AND 100 THEN 'umiarkowana'
			ELSE 'droga'
		  END AS [SourcePriceRange]
		, FK_Ksiazka
		, pid = seller.PID
		, data_wystawienia = ST2.DataWystawienia
					
	FROM BillMaster.dbo.SprzedazKsiazki AS ST1
	JOIN BillMaster.dbo.Rachunek as ST2 ON ST1.FK_Rachunek = ST2.NrRachunku
	JOIN dbo.DimDate as SD ON CONVERT(VARCHAR(10), SD.Date, 111) = CONVERT(VARCHAR(10), ST2.DataWystawienia, 111)
	JOIN dbo.DimDate as PD ON CONVERT(VARCHAR(10), PD.Date, 111) = CONVERT(VARCHAR(10), ST2.DataOplacenia, 111)
	JOIN dbo.DimJunk as junk ON junk.Position = ST2.Stanowisko and junk.TypeOfPayment = ST2.Platnosc
	left JOIN dbo.DimSeller as seller ON 
			seller.PID = ST2.FK_Sprzedawca
		and ST2.DataWystawienia BETWEEN seller.EntryDate AND isnull(seller.ExpiryDate, CURRENT_TIMESTAMP)
	JOIN dbo.DimTime ON dbo.DimTime.Hour = DATEPART(HOUR, ST2.DataWystawienia)
	) AS x
JOIN dbo.DimBook ON dbo.DimBook.ISBN = x.FK_Ksiazka
WHERE SourcePriceRange = dbo.DimBook.PriceRange;
go


-- TODO
--	- doda� krotk� UNKNOWN do ka�dego wymiaru i przypiywa� jej klucz w funkcji ISNULL()

MERGE INTO FBookSales as TT
	USING vETLFBookSales as ST
		ON 	
			TT.BookKey = ST.BookKey
		AND TT.SellDateKey = ST.SellDateKey
		AND TT.PayDateKey = ST.PayDateKey
		AND TT.SellerKey = ST.SellerKey
		AND TT.JunkKey = ST.JunkKey
		AND TT.TimeKey = ST.TimeKey
		AND TT.TransactionNo = ST.TransactionNo
			WHEN Not Matched
				THEN
					INSERT
					Values (
						  ST.Amount
						, ST.PurchasePrice
						, ST.Profit
						, ST.BookKey
						, ST.SellDateKey
						, ST.PayDateKey
						, ST.SellerKey
						, ST.JunkKey
						, ST.TimeKey
						, ST.TransactionNo
					)
			;

Drop view vETLFBookSales;

-- select * from FBookSales;