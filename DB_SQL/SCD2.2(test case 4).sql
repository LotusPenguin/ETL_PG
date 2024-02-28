USE SoftwareDB;

UPDATE Programy SET Aktualna_wersja = '1.1' WHERE Nazwa_handlowa = 'DocView PDF';

INSERT INTO Umowy_licencyjne (Numer_umowy, Data_zawarcia, Data_wygaśnięcia, Rodzaj_licencji, ID_Sprzedawcy, ID_Klienta, Nazwa_programu, Kwota_płatności_okresowych, Plan_płatności) VALUES
	('LIC/31/1', '2031-01-15', '2032-01-15', 'na osobe', 1, 1, 'DocView PDF', 100.00, 'miesiecznie');