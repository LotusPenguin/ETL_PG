use DW_bookstore_test

INSERT INTO [dbo].[DimJunk] 
SELECT s, p 
FROM 
	  (
		VALUES 
			  ('wyjœcie')
			, ('g³ówne')
			, ('lewe')
			, ('prawe')
			, ('œciana')
			, ('okna')
			, ('info')
			, ('wyspa')
	  ) 
	AS Stand(s)
	
	, (
		VALUES 
			  ('czek')
			, ('karta')
			, ('gotówka')
	  ) 
	AS Payment(p);