use DW_bookstore_test

INSERT INTO [dbo].[DimJunk] 
SELECT s, p 
FROM 
	  (
		VALUES 
			  ('wyj�cie')
			, ('g��wne')
			, ('lewe')
			, ('prawe')
			, ('�ciana')
			, ('okna')
			, ('info')
			, ('wyspa')
	  ) 
	AS Stand(s)
	
	, (
		VALUES 
			  ('czek')
			, ('karta')
			, ('got�wka')
	  ) 
	AS Payment(p);