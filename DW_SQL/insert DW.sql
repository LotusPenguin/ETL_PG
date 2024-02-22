INSERT INTO Sprzedawcy (Nazwa) VALUES
('SoftShop Solutions'),
('CodeCrafters'),
('Programming Plaza'),
('Software City');

INSERT INTO Klienci (os_fiz_or_firma, Nazwa) VALUES
(1, 'Tomasz Lewandowski'),
(0, 'EcoTechnologie Polska'),
(1, 'Jan Kowalski'),
(0, 'Telcza Sp. z o.o.'),
(1, 'Marcin Nowakowski');

INSERT INTO Junk (Plan_platnosci) VALUES
('Kwartalnie'),
('Miesiecznie'),
('Rocznie');


INSERT INTO Data (Rok, Miesiac, Dzien, Data) VALUES
(2023, 1, 31, '2023-01-31'),
(2023, 2, 28, '2023-02-28'),
(2023, 3, 31, '2023-03-31'),
(2023, 4, 30, '2023-04-30'),
(2023, 5, 31, '2023-05-31'),
(2023, 6, 30, '2023-06-30'),
(2023, 7, 31, '2023-07-31'),
(2023, 8, 31, '2023-08-31'),
(2023, 9, 30, '2023-09-30'),
(2023, 1, 15, '2023-01-15'),
(2023, 1, 16, '2023-01-16'),
(2023, 2, 16, '2023-02-16'),
(2023, 2, 28, '2023-02-28'),
(2023, 5, 28, '2023-05-28'),
(2023, 3, 10, '2023-03-10'),
(2023, 4, 10, '2023-04-10'),
(2023, 5, 10, '2023-05-10'),
(2023, 4, 5, '2023-04-05'),
(2023, 5, 20, '2023-05-20'),
(2023, 6, 12, '2023-06-12'),
(2023, 7, 8, '2023-07-08'),
(2023, 8, 25, '2023-08-25'),
(2023, 9, 17, '2023-09-17'),
(2023, 10, 3, '2023-10-03'),
(2025, 1, 15, '2025-01-15'),
(2025, 2, 28, '2025-02-28'),
(2025, 3, 10, '2025-03-10'),
(2024, 4, 05, '2024-04-05'),
(2028, 5, 20, '2028-05-20'),
(2025, 6, 12, '2025-06-12'),
(2028, 7, 8, '2028-07-08'),
(2025, 8, 25, '2025-08-25'),
(2028, 9, 17, '2028-09-17'),
(2026, 10, 3, '2026-10-03'),
(2024, 2, 28, '2024-02-28'),
(2024, 5, 10, '2024-05-10');

INSERT INTO Programy (Nazwa_handlowa, Aktualna_wersja, Platforma, Rodzaj, Czy_aktywny, Data_wydania, Data_zakonczenia_wsparcia) VALUES
('SuperFaktury', '4.0', 'Windows', 'Finanse', 1, 10, 25),
('Projektant 3D', '1.5', 'Windows, Mac', 'Multimedia', 1, 13, 26),
('Graficzny Edytor', '2.0', 'Windows, Mac', 'Multimedia', 1, 15, 27),
('Zarzadzanie Zasobami', '3.0', 'Windows', 'Zarzadzanie', 1, 18, 28),
('DocView PDF', '1.0', 'Windows, Mac', 'Biurowe', 1, 19, 28),
('Analiza Danych', '2.5', 'Windows, Mac', 'Analiza Danych', 1, 20, 30),
('Smart Slideshow', '1.0', 'Windows, Mac', 'Biurowe', 1, 21, 31),
('WWW Creator', '3.0', 'Windows, Mac', 'Kreator z GUI', 1, 23, 33),
('Logo Edytor', '2.5', 'Windows, Mac', 'Multimedia', 1, 24, 34),
('Katalogowanie Zasobow', '1.0', 'Windows', 'Zarzadzanie', 1, 22, 32);

UPDATE Programy SET Czy_aktywny = 0 WHERE Nazwa_handlowa = 'DocView PDF';

INSERT INTO Programy (Nazwa_handlowa, Aktualna_wersja, Platforma, Rodzaj, Czy_aktywny, Data_wydania, Data_zakonczenia_wsparcia) VALUES
('DocView PDF', '2.0', 'Windows, Mac', 'Biurowe', 1, 19, 29);

INSERT INTO Podpisanie_umowy_dystrybucyjnej (Numer_umowy, ID_sprzedawcy, ID_programu, Data_zawarcia, Data_wygasniecia) VALUES
('DTB/22/0001', 1, 1, 10, 25),
('DTB/22/0002', 2, 2, 13, 14),
('DTB/22/0003', 3, 2, 13, 14),
('DTB/22/0004', 3, 4, 15, 17),
('DTB/22/0005', 4, 4, 16, 36);

INSERT INTO Podpisanie_umowy_licencyjnej (Numer_umowy, ID_sprzedawcy, ID_klienta, ID_programu, Junk_id, Kwota_platnosci, Data_zawarcia, Data_wygasniecia) VALUES
('LIC/22/0001', 1, 1, 1, 2, 69.99, 11, 12),
('LIC/22/0002', 1, 2, 1, 2, 69.99, 11, 12),
('LIC/22/0003', 2, 3, 2, 1, 199.99, 13, 35),
('LIC/22/0004', 3, 4, 4, 1, 199.99, 18, 28),
('LIC/22/0005', 4, 5, 4, 3, 399.99, 19, 29);

INSERT INTO Zyski_miesieczne (ID_podpisania_umowy, Data_uzyskania_zysku, Zysk) VALUES
(1, 1, 69.99),
(2, 1, 69.99),
(3, 2, 199.99),
(3, 3, 199.99),
(3, 4, 199.99),
(3, 5, 199.99),
(3, 6, 199.99),
(3, 7, 199.99),
(3, 8, 199.99),
(3, 9, 199.99),
(4, 4, 199.99),
(4, 5, 199.99),
(4, 6, 199.99),
(4, 7, 199.99),
(4, 8, 199.99),
(4, 9, 199.99),
(5, 5, 399.99),
(5, 8, 399.99);
