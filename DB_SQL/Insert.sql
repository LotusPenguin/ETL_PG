USE SoftwareDB;

INSERT INTO Lokalizacje (Kraj) VALUES
	('Polska'),
	('Niemcy'),
	('Hiszpania'),
	('Niger'),
	('Wielka Brytania')

INSERT INTO Producenci_oprogramowania (Nazwa_handlowa, Lokalizacja, Sektor_działalności, Czy_aktywny) VALUES 
	('SoftSystem', 1, 'Oprogramowanie do zarządzania firmą', 'TAK'),
	('TechPol', 2, 'Oprogramowanie biurowe', 'TAK'),
	('Graphic Innovations', 3, 'Oprogramowanie do projektowania graficznego', 'TAK'),
	('ChmuraSoft', 4, 'Usługi chmurowe', 'NIE'),
	('DynamicData Solutions', 5, 'Oprogramowanie do analizy danych', 'TAK'),
	('CyfrowePrace', 1, 'Oprogramowanie do zarządzania projektami', 'TAK'),
	('IntelligenTech', 2, 'Oprogramowanie sztucznej inteligencji', 'TAK'),
	('PlanSoft', 3, 'Oprogramowanie do planowania zasobów przedsiębiorstwa', 'TAK'),
	('PR Solutions', 1, 'Oprogramowanie do zarządzania relacjami z klientami', 'TAK'),
	('Technologie Przyszłości', 2, 'Oprogramowanie do wirtualnej rzeczywistości', 'NIE');

INSERT INTO Sprzedawcy (Nazwa, Lokalizacja) VALUES
	('SoftShop Solutions', 1),
	('CodeCrafters', 2),
	('Programming Plaza', 3),
	('Software City', 4),
	('TechTrix', 5),
	('Digital Domain', 1),
	('Code Haven', 1),
	('The Software Store', 3),
	('Code Central', 4),
	('Software Superstore', 1),
	('Tech Zone', 1),
	('Software Avenue', 1);

INSERT INTO Klienci (os_fiz_or_firma, Suma_należności, Nazwa, Lokalizacja) VALUES
    ('Osoba_fizyczna', 0.00, 'Jan Kowalski',1),
    ('Osoba_fizyczna', 0.00, 'Anna Nowak',2),
    ('Firma', 0.00, 'Aviko Polska',3),
    ('Osoba_fizyczna', 0.00, 'Tomasz Lewandowski',4),
    ('Firma', 0.00, 'Telcza Sp. z o.o.',5),
    ('Osoba_fizyczna', 0.00, 'Katarzyna Wiśniewska',1),
    ('Firma', 0.00, 'Novotel Polska',1),
    ('Osoba_fizyczna', 0.00, 'Marcin Nowakowski',2),
    ('Firma', 0.00, 'Action',5),
    ('Firma', 0.00, 'EcoTechnologie Polska',1);

INSERT INTO Zlecenia (Numer_umowy, Data_złożenia, Termin_realizacji, Wytyczne_funkcjonalności, Rodzaj_licencji, Kwota_należności, Czy_zrealizowane, ID_Producenta, ID_Klienta) VALUES
	('22/12/1', '2022-12-16', '2022-12-30', 'Oprogramowanie powinno umożliwiać śledzenie zapasów i generowanie raportów', 'Komercyjna', 10000.00, 'NIE', 8, 9),
	('22/12/2', '2022-12-17', '2022-12-31', 'Oprogramowanie powinno umożliwiać zarządzanie rekordami pracowników i harmonogramami zmian', 'Komercyjna', 1500.00, 'NIE', 8, 9),
	('22/12/3', '2022-12-18', '2023-01-01', 'Oprogramowanie powinno umożliwiać przetwarzanie transakcji i śledzenie informacji o klientach', 'Wieczysta', 200000.00, 'NIE', 9, 9),
	('22/12/4', '2022-12-19', '2023-01-02', 'Oprogramowanie powinno umożliwiać tworzenie i edycję dokumentów, a także obsługiwanie analizy danych', 'Wieczysta', 25000.00, 'TAK', 5, 7),
	('22/12/5', '2022-12-20', '2023-01-03', 'Oprogramowanie powinno umożliwiać projektowanie i publikowanie stron internetowych', 'Wieczysta', 30000.00, 'TAK', 3, 8),
	('22/12/6', '2022-12-21', '2023-01-04', 'Oprogramowanie powinno umożliwiać edycję i ulepszanie zdjęć i filmów w oparciu o silnik sztucznej inteligencji', 'Komercyjna', 35000.00, 'NIE', 7, 8),
	('23/01/1', '2023-01-22', '2023-01-27', 'Oprogramowanie powinno umożliwiać zarządzanie zadaniami i zasobami projektów', 'Komercyjna', 40000.00, 'NIE', 6, 10);

INSERT INTO Programy (Nazwa_handlowa, Aktualna_wersja, Platforma, Rodzaj, Opis, Czy_wspierany, Numer_zlecenia, Data_wydania, Data_zakończenia_wsparcia, ID_Producenta) VALUES
	('SuperFaktury', '4.0', 'Windows', 'Finanse', 'Program do fakturowania i zarządzania finansami małych firm', 'TAK', NULL,'2021-03-19','2026-03-19',1),
	('Projektant 3D', '1.5', 'Windows, Mac', 'Multimedia', 'Program do tworzenia projektów 3D', 'TAK', NULL,'2022-07-26','2027-07-26',2),
	('Graficzny Edytor', '2.0', 'Windows, Mac', 'Multimedia', 'Program do tworzenia i edytowania grafiki rastrowej i wektorowej', 'TAK', NULL,'2023-12-14','2028-12-14',3),
	('Zarządzanie Zasobami', '3.0', 'Windows', 'Zarządzanie', 'Program do zarządzania zasobami ludzkimi i finansowymi w firmie', 'TAK', NULL,'2023-12-14','2028-12-14',1),
	('DocView PDF', '1.0', 'Windows, Mac', 'Biurowe', 'Program do przeglądania i drukowania dokumentów PDF', 'TAK', NULL,'2023-02-14','2028-02-14',1),
	('Analiza Danych', '2.5', 'Windows, Mac', 'Analiza Danych', 'Program do analizy danych i tworzenia raportów', 'NIE', '22/12/4','2018-12-24','2023-12-24',4),
	('Smart Slideshow', '1.0', 'Windows, Mac', 'Biurowe', 'Program do tworzenia profesjonalnych prezentacji multimedialnych', 'TAK', NULL,'2019-10-04','2025-10-04',1),
	('WWW Creator', '3.0', 'Windows, Mac', 'Kreator z GUI', 'Program do tworzenia stron internetowych bez znajomości języków programowania', 'TAK', '22/12/5','2023-12-02','2028-12-02',5),
	('Logo Edytor', '2.5', 'Windows, Mac', 'Multimedia', 'Program do tworzenia i logotypów', 'TAK', NULL,'2023-12-14','2028-12-14',1),
	('Katalogowanie Zasobów', '1.0', 'Windows', 'Zarządzanie', 'Program do katalogowania i zarządzania zasobami w firmie', 'TAK', NULL,'2023-12-14','2028-12-14',5);

/*
INSERT INTO Umowy_dystrybucyjne (Nr_umowy, ID_Sprzedawcy, Data_zawarcia, Data_wygaśnięcia) VALUES
	('DTB/22/0001', 7, '2022-12-15', '2023-12-14'), 
    ('DTB/22/0002', 2, '2022-12-16', '2023-12-15'), 
    ('DTB/22/0003', 3, '2022-12-17', '2023-12-16'), 
    ('DTB/22/0004', 4, '2022-12-18', '2023-12-17'), 
    ('DTB/22/0005', 5, '2022-12-19', '2023-12-18'), 
    ('DTB/22/0006', 9, '2022-12-20', '2023-12-19'), 
    ('DTB/22/0007', 10, '2022-12-21', '2023-12-20'), 
    ('DTB/22/0008', 8, '2022-12-22', '2023-12-21'),
    ('DTB/22/0009', 9, '2022-12-23', '2023-12-22'),
    ('DTB/22/0010', 7, '2022-12-24', '2023-12-23'),
    ('DTB/22/0011', 11, '2022-12-25', '2023-12-24'),
    ('DTB/22/0012', 9, '2022-12-26', '2023-12-25'),
    ('DTB/22/0013', 10, '2022-12-27', '2023-12-26'),
    ('DTB/22/0014', 11, '2022-12-28', '2023-12-27'),
    ('DTB/22/0015', 12, '2022-12-29', '2023-12-28');
	
INSERT INTO Dystrybucja (Nr_umowy, Nazwa_handlowa) VALUES
	('DTB/22/0001', 'Projektant 3D'),
	('DTB/22/0001', 'Graficzny Edytor'),
	('DTB/22/0001', 'Logo Edytor'),
	('DTB/22/0002', 'DocView PDF'),
	('DTB/22/0002', 'Smart Slideshow'),
	('DTB/22/0003', 'DocView PDF'),
	('DTB/22/0004', 'DocView PDF'),
	('DTB/22/0005', 'DocView PDF'),
	('DTB/22/0006', 'Katalogowanie Zasobów'),
	('DTB/22/0006', 'Zarządzanie Zasobami'),
	('DTB/22/0007', 'Katalogowanie Zasobów'),
	('DTB/22/0007', 'Zarządzanie Zasobami'),
	('DTB/22/0008', 'DocView PDF'),
	('DTB/22/0009', 'DocView PDF'),
	('DTB/22/0010', 'SuperFaktury'),
	('DTB/22/0011', 'Katalogowanie Zasobów'),
	('DTB/22/0011', 'Zarządzanie Zasobami'),
	('DTB/22/0012', 'SuperFaktury'),
	('DTB/22/0013', 'SuperFaktury'),
	('DTB/22/0014', 'SuperFaktury'),
	('DTB/22/0015', 'SuperFaktury');
	
INSERT INTO Umowy_licencyjne (Numer_umowy, Data_zawarcia, Data_wygaśnięcia, Rodzaj_licencji, ID_Sprzedawcy, ID_Klienta, Nazwa_programu, Kwota_płatności_okresowych, Plan_płatności) VALUES
	('LIC/22/0001', '2022-12-15', '2023-12-14', 'Na osobę', 11, 1, 'SuperFaktury', 100.00, 'Miesięcznie'),
	('LIC/22/0002', '2022-12-16', '2024-12-15', 'Na osobę', 12, 2, 'SuperFaktury', 250.00, 'Kwartalnie'),
	('LIC/22/0003', '2022-12-17', '2024-12-16', 'Jednostanowiskowa', 7, 3, 'Projektant 3D', 1000.00, 'Rocznie'),
	('LIC/22/0004', '2022-12-18', '2023-12-17', 'Na osobę', 2, 4, 'WWW Creator', 200.00, 'Miesięcznie'),
	('LIC/22/0005', '2022-12-19', '2023-12-18', 'Na osobę', 10, 4, 'Graficzny Edytor', 250.00, 'Kwartalnie'),
	('LIC/22/0006', '2022-12-20', '2023-12-19', 'Na obszar', 10, 5, 'SuperFaktury', 2000.00, 'Rocznie'),
	('LIC/22/0007', '2022-12-21', '2024-12-20', 'Jednostanowiskowa', 7, 5, 'Logo Edytor', 70.00, 'Miesięcznie'),
	('LIC/22/0008', '2022-12-22', '2025-12-21', 'Na osobę', 10, 6, 'SuperFaktury', 200.00, 'Kwartalnie'),
	('LIC/22/0009', '2022-12-22', '2025-12-21', 'Na osobę', 10, 6, 'Smart Slideshow', 750.00, 'Rocznie'),
	('LIC/22/0010', '2022-12-22', '2023-12-21', 'Na osobę', 2, 6, 'Analiza Danych', 200.00, 'Miesięcznie');

INSERT INTO Faktury (Numer_faktury, Data_wystawienia, Termin_płatności, Status_opłacenia, Kwota_należności, Numer_umowy) VALUES
	('F/22/12/77', '2022-12-15', '2022-12-22', 'NIE', 100.00, 'LIC/22/0001'),
	('F1443', '2022-12-16', '2022-12-23', 'TAK', 250.00, 'LIC/22/0002'),
	('F-22-11233', '2022-12-17', '2022-12-24', 'NIE', 1000.00, 'LIC/22/0003'),
	('22/12/1775',  '2022-12-18', '2022-12-25', 'NIE', 200.00, 'LIC/22/0004'),
	('18889',  '2022-12-19', '2022-12-29', 'TAK', 250.00, 'LIC/22/0005'),
	('18892',  '2022-12-20', '2022-12-30', 'NIE', 2000.00, 'LIC/22/0006'),
	('F/22/12/18',  '2022-12-21', '2022-12-28', 'NIE', 70.00, 'LIC/22/0007'),
	('18898',  '2022-12-22', '2023-01-01', 'NIE', 200.00, 'LIC/22/0008'),
	('18901',  '2022-12-22', '2023-01-01', 'NIE', 750.00, 'LIC/22/0009'),
	('22/12/1929',  '2022-12-22', '2022-12-29', 'TAK', 200.00, 'LIC/22/0010');

INSERT Faktury (Numer_faktury, Data_wystawienia, Termin_płatności, Status_opłacenia, Kwota_należności, Numer_umowy) VALUES
	('23/01/1678', '2023-01-22', '2023-01-29', 'NIE', 200.00, 'LIC/22/0010');
*/